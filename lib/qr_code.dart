import 'package:flutter/material.dart';

class QRCodeScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
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
    ));
  }
}
