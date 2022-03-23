import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'screens/main_view.dart';
import 'models/models.dart';
import 'screens/certificate.dart';
import 'screens/info.dart';
import 'screens/login_view.dart';
import 'screens/qr_code.dart';
import 'screens/register_view.dart';
import 'screens/router_page.dart';

class VaxPass extends StatefulWidget {
  const VaxPass({Key? key}) : super(key: key);

  @override
  _VaxPassState createState() => _VaxPassState();
}

class _VaxPassState extends State<VaxPass> {
  int _selectedIndex = 0;
  final listController = BehaviorSubject<List<CertificateModel>>(sync: true);
  final List<Widget> _widgetOptions = <Widget>[
    const QRCodeScene(),
    CertificateScene(),
    const ProfileScene(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VaxPass',
      // home: Scaffold(
      //   appBar: AppBar(
      //     centerTitle: true,
      //     title: const Text('VaxPass'),
      //     actions: <Widget>[
      //       IconButton(
      //         icon: const Icon(Icons.more_vert),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      //   body: Center(
      //     child: _widgetOptions.elementAt(_selectedIndex),
      //   ),
      //   bottomNavigationBar: BottomNavigationBar(
      //     items: const <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.qr_code_2_rounded),
      //         label: 'Code',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.library_books),
      //         label: 'Certificate',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.person),
      //         label: 'Info',
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     selectedItemColor: const Color.fromARGB(255, 5, 14, 136),
      //     onTap: _onItemTapped,
      //   ),
      // ),
      home: const RouterPage(),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/mainView/': (context) => MainView(),
      },
    );
  }
}
