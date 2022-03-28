import 'package:flutter/material.dart';
import 'package:vaxpass/services/cloud/cloud_certificate.dart';
import 'package:vaxpass/services/cloud/firebase_cloud_storage.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';
import '../services/auth/auth_service.dart';
import '../utils/dialogs/logout_dialog.dart';
import 'certificate_list_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // late final CertificateService _certificateService;
  late final FirebaseCloudStorage _certificateService;

  // String get userEmail => AuthService.fireBase().currentUser!.email!;
  String get userID => AuthService.fireBase().currentUser!.id;

  @override
  void initState() {
    // _certificateService = CertificateService();
    _certificateService = FirebaseCloudStorage();
    // _certificateService.open();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _certificateService.close();
  //   super.dispose();
  // }

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
      body: StreamBuilder(
          // stream: _certificateService.allCertificates,
          stream: _certificateService.allCertificates(ownerUserID: userID),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allCertificates =
                      // snapshot.data as List<DatabaseCertificate>;
                      snapshot.data as Iterable<CloudCertificate>;
                  return CertificateListView(
                    certificates: allCertificates,
                    onDeleteCertificate: (certificate) async {
                      // await _certificateService.deleteCertificate(
                      //     id: certificate.id);
                      await _certificateService.deleteCertificate(
                        documentID: certificate.documentID,
                      );
                    },
                    onTap: (certificate) async {
                      Navigator.of(context).pushNamed(
                        createOrUpdateCertificateRoute,
                        arguments: certificate,
                      );
                    },
                  );
                }
                return const CircularProgressIndicator();
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
//       body: FutureBuilder(
//           future: _certificateService.getOrCreateUser(email: userEmail),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.done:
//                 return StreamBuilder(
//                     stream: _certificateService.allCertificates,
//                     builder: (context, snapshot) {
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.waiting:
//                         case ConnectionState.active:
//                           if (snapshot.hasData) {
//                             final allCertificates =
//                                 snapshot.data as List<DatabaseCertificate>;
//                             return CertificateListView(
//                               certificates: allCertificates,
//                               onDeleteCertificate: (certificate) async {
//                                 await _certificateService.deleteCertificate(
//                                     id: certificate.id);
//                               },
//                               onTap: (certificate) async {
//                                 Navigator.of(context).pushNamed(
//                                   createOrUpdateCertificateRoute,
//                                   arguments: certificate,
//                                 );
//                               },
//                             );
//                           }
//                           return const CircularProgressIndicator();
//                         default:
//                           return const CircularProgressIndicator();
//                       }
//                     });
//               default:
//                 return const CircularProgressIndicator();
//             }
//           }),
//     );
//   }
// }
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
