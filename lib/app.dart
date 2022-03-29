import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vaxpass/services/auth/bloc/auth_bloc.dart';
import 'package:vaxpass/services/auth/firebase_auth_provider.dart';

import 'constants/routes.dart';
import 'models/models.dart';
import 'screens/certificate.dart';
import 'screens/create_update_certificate_view.dart';
import 'screens/info.dart';
import 'screens/qr_code.dart';
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const RouterPage(),
      ),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        createOrUpdateCertificateRoute: (context) =>
            const CreateUpdateCertificateView(),
      },
    );
  }
}
