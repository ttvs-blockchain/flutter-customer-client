import 'package:flutter/material.dart';

class CertificateScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            height: 220,
            width: double.maxFinite,
            child: Card(
              elevation: 5,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            height: 220,
            width: double.maxFinite,
            child: Card(
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
}
