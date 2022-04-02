import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/constants.dart';
import 'screens/certificate_detail_view.dart';
import 'screens/certificate_qr_code_view.dart';
import 'services/auth/bloc/auth_bloc.dart';
import 'services/auth/firebase_auth_provider.dart';

import 'screens/router_page.dart';

class VaxPass extends StatefulWidget {
  const VaxPass({Key? key}) : super(key: key);

  @override
  _VaxPassState createState() => _VaxPassState();
}

class _VaxPassState extends State<VaxPass> {
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
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyText1: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        certificateQRCodeViewRoute: (context) => const CertificateQRCodeView(),
        certificateDetailViewRoute: (context) => const CertificateDetailView(),
      },
    );
  }
}
