import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import 'login_view.dart';
import 'main_view.dart';
import 'verify_email_view.dart';

class RouterPage extends StatelessWidget {
  const RouterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.fireBase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.fireBase().currentUser;
            log(user.toString());
            if (user == null) {
              return const LoginView();
            }
            if (user.isEmailVerified) {
              return const VerifyEmailView();
            }
            return MainView();
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
