import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpass/extensions/buildcontext/loc.dart';

import '../enums/menu_action.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/crud/certificate_service.dart';
import '../utils/dialogs/logout_dialog.dart';
import 'certificate_view.dart';
import 'personal_info_view.dart';
import 'qr_code_view.dart';

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
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.clearData:
                await DatabaseService().deleteAllUsers();
                await DatabaseService().deleteAllCertificates();
                await DatabaseService().close();
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
                context.read<AuthBloc>().add(
                      const AuthEventInitialize(),
                    );
                break;
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
                value: MenuAction.clearData,
                child: Text('Clear Data'),
              ),
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
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code_2_rounded),
            label: context.loc.navigation_bar_qr_code,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_books),
            label: context.loc.navigation_bar_certificate,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: context.loc.navigation_bar_info,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 5, 14, 136),
        onTap: _onItemTapped,
      ),
    );
  }
}
