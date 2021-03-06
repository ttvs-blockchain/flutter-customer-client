import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'constants/constants.dart';
import 'screens/certificate_detail_view.dart';
import 'screens/certificate_qr_code_view.dart';
import 'screens/router_page.dart';
import 'services/auth/bloc/auth_bloc.dart';
import 'services/auth/firebase_auth_provider.dart';

class VaxPass extends StatefulWidget {
  const VaxPass({Key? key}) : super(key: key);

  @override
  _VaxPassState createState() => _VaxPassState();
}

class _VaxPassState extends State<VaxPass> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
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
