import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vaxpass/constants/routes.dart';
import 'package:vaxpass/models/models.dart';
import 'package:vaxpass/screens/certificate.dart';
import 'package:vaxpass/screens/info.dart';
import 'package:vaxpass/screens/login_view.dart';
import 'package:vaxpass/screens/main_view.dart';
import 'package:vaxpass/screens/create_update_certificate_view.dart';
import 'package:vaxpass/screens/qr_code.dart';
import 'package:vaxpass/screens/register_view.dart';
import 'package:vaxpass/screens/router_page.dart';
import 'package:vaxpass/screens/verify_email_view.dart';

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
