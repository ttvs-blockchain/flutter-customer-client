import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart';
import '../enums/menu_action.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../utils/dialogs/logout_dialog.dart';
import 'certificate_view.dart';
import 'info.dart';
import 'qr_code.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const QRCodeScene(),
    const CertificateScene(),
    const ProfileScene(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('VaxPass'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateCertificateRoute);
            },
            icon: const Icon(Icons.add),
          ),
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
            onPressed: () {},
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
