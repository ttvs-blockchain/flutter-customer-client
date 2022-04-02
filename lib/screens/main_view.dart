import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpass/services/cloud/firebase_cloud_storage.dart';
import 'package:vaxpass/services/crud/certificate_service.dart';

import '../enums/menu_action.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../utils/dialogs/logout_dialog.dart';
import 'certificate_view.dart';
import 'personal_info_view.dart';
import 'qr_code.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const QRCodeView(),
    const CertificateView(),
    const PersonalInfoView(),
  ];

  late final DatabaseService _databaseService;
  late final FirebaseCloudStorage _firebaseService;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _updateCertificatesFromCloud() async {
    final user = await _databaseService.getUser();

    final cloudCertificates = await _firebaseService
        .allCertificates(userSystemID: user.systemID)
        .first;

    _databaseService.deleteAllCertificates();

    for (final cert in cloudCertificates) {
      await _databaseService.createCertificate(
          certificate: cert.toDatabaseCertificate());
    }
  }

  @override
  void initState() {
    _databaseService = DatabaseService();
    _firebaseService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('VaxPass'),
        actions: <Widget>[
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                }
                break;
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Logout'),
              ),
            ];
          }),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2_rounded),
            label: 'Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Certificate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 5, 14, 136),
        onTap: _onItemTapped,
      ),
      floatingActionButton: Visibility(
        child: SizedBox(
          width: 50,
          height: 50,
          child: RawMaterialButton(
            onPressed: () {
              _updateCertificatesFromCloud();
              _databaseService.cacheCertificates();
            },
            fillColor: const Color.fromARGB(68, 63, 81, 181),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.refresh_outlined,
              size: 30,
            ),
          ),
        ),
        visible: _selectedIndex == 1,
      ),
    );
  }
}
