import 'package:flutter/material.dart';

class QRCodeScene extends StatelessWidget {
  const QRCodeScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Image(
            image: AssetImage('assets/sample_qr_code.png'),
            width: 300,
          ),
          Text(
            'Please present the QR Code to the verifier',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
