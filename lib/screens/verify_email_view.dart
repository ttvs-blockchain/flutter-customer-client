import 'package:flutter/material.dart';
import 'package:vaxpass/services/auth/auth_service.dart';

import '../constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Verify Email'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text(
                'Verification email sent, please open it to verify your account'),
            const Text(
                "If you haven't received an email, press the button to send again"),
            TextButton(
              child: const Text('Send email verification'),
              onPressed: () async {
                await AuthService.fireBase().sendEmailVerification();
              },
            ),
            TextButton(
              onPressed: () async {
                await AuthService.fireBase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerViewRoute,
                  (route) => false,
                );
              },
              child: const Text('Go back to registration'),
            )
          ],
        ),
      ),
    );
  }
}
