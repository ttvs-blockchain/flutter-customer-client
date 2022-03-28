import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'constants/routes.dart';
import 'models/models.dart';
import 'screens/certificate.dart';
import 'screens/create_update_certificate_view.dart';
import 'screens/info.dart';
import 'screens/login_view.dart';
import 'screens/main_view.dart';
import 'screens/qr_code.dart';
import 'screens/register_view.dart';
import 'screens/router_page.dart';
import 'screens/verify_email_view.dart';

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
      home: const RouterPage(),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        loginViewRoute: (context) => const LoginView(),
        registerViewRoute: (context) => const RegisterView(),
        mainViewRoute: (context) => MainView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateCertificateRoute: (context) =>
            const CreateUpdateCertificateView(),
      },
    );
  }
}
