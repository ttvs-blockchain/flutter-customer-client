import 'package:flutter/material.dart';

class QRCodeScene extends StatelessWidget {
  const QRCodeScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      const Image(
          image: AssetImage('assets/sample_qr_code.png'), width: 300),
      const Text('Please present the QR Code to the verifier'),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: const Text('Scan QR Code'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ],
      ),
    );
  }
}
