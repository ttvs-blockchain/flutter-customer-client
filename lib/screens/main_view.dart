import 'package:flutter/material.dart';
import 'package:vaxpass/constants/routes.dart';
import 'package:vaxpass/enums/menu_action.dart';
import 'package:vaxpass/services/auth/auth_service.dart';
import 'package:vaxpass/services/crud/certificate_service.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final CertificateService _certificateService;

  String get userEmail => AuthService.fireBase().currentUser!.email!;

  @override
  void initState() {
    _certificateService = CertificateService();
    _certificateService.open();
    super.initState();
  }

  @override
  void dispose() {
    _certificateService.close();
    super.dispose();
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
              Navigator.of(context).pushNamed(newCertificateViewRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.fireBase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginViewRoute,
                    (_) => false,
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
      body: FutureBuilder(
          future: _certificateService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _certificateService.allCertificates,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text('Waiting for all certificates...');
                        default:
                          return const CircularProgressIndicator();
                      }
                    });
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
// class _MainViewState extends State<MainView> {
//   int _selectedIndex = 0;
//   final listController = BehaviorSubject<List<CertificateModel>>(sync: true);
//   final List<Widget> _widgetOptions = <Widget>[
//     const QRCodeScene(),
//     const CertificateScene(),
//     const ProfileScene(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('VaxPass'),
//         actions: <Widget>[
//           PopupMenuButton<MenuAction>(onSelected: (value) async {
//             switch (value) {
//               case MenuAction.logout:
//                 final shouldLogout = await showLogOutDialog(context);
//                 if (shouldLogout) {
//                   await AuthService.fireBase().logOut();
//                   Navigator.of(context).pushNamedAndRemoveUntil(
//                     loginViewRoute,
//                     (_) => false,
//                   );
//                 }
//                 break;
//             }
//           }, itemBuilder: (context) {
//             return const [
//               PopupMenuItem<MenuAction>(
//                 value: MenuAction.logout,
//                 child: Text('Logout'),
//               ),
//             ];
//           }),
//         ],
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.qr_code_2_rounded),
//             label: 'Code',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.library_books),
//             label: 'Certificate',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Info',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: const Color.fromARGB(255, 5, 14, 136),
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
