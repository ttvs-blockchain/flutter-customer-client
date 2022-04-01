import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpass/services/auth/bloc/auth_bloc.dart';
import 'package:vaxpass/services/auth/firebase_auth_provider.dart';

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
      ),
      debugShowCheckedModeBanner: false,
      // routes: {
      //   createOrUpdateCertificateRoute: (context) =>
      //       const CreateUpdateCertificateView(),
      // },
    );
  }
}
