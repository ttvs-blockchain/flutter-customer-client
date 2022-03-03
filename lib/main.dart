import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:vacpass/database/objectbox.dart';
import 'package:vacpass/screens/info.dart';
import 'package:vacpass/screens/certificate.dart';
import 'package:vacpass/screens/qr_code.dart';
import 'package:vacpass/screens/error_page.dart';
import 'package:vacpass/app.dart';

// provides access to the ObjectBox Store throughout the app
late ObjectBox objectBox;

Future<void> main() async {
  // this is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();

  GestureBinding.instance?.resamplingEnabled = true;
  // runApp(const MyApp());
  runZonedGuarded(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
      return ErrorPage(
          details.exception.toString() + "\n " + details.stack.toString(),
          details);
    };
    runApp(VacPass());
  }, (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
}

// main application widget
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   static const String _title = 'VacPass';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: const MyStatefulWidget(),
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: const Color.fromARGB(255, 23, 159, 238),
//         // fontFamily: 'Georgia',
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // stateful widget that the main application instantiates
// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);

//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }

// // private State class that goes with MyStatefulWidget
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   int _selectedIndex = 0;
//   final List<Widget> _widgetOptions = <Widget>[
//     new QRCodeScene(),
//     new CertificateScene(),
//     new ProfilePage(),
//     SettingsList(
//       sections: [
//         SettingsSection(
//           title: 'Section',
//           tiles: [
//             SettingsTile(
//               title: 'Language',
//               subtitle: 'English',
//               leading: const Icon(Icons.language),
//               onPressed: (BuildContext context) {},
//             ),
//             SettingsTile.switchTile(
//               title: 'Use fingerprint',
//               leading: const Icon(Icons.fingerprint),
//               switchValue: true,
//               onToggle: (bool value) {},
//             ),
//           ],
//         ),
//       ],
//     ),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('VacPass'),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.qr_code_2_rounded),
//             label: 'Code',
//             backgroundColor: Colors.blue,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.library_books),
//             label: 'Certificate',
//             backgroundColor: Colors.blue,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Info',
//             backgroundColor: Colors.blue,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//             backgroundColor: Colors.blue,
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: const Color.fromARGB(255, 2, 80, 133),
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
