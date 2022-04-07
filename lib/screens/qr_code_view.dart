import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:vaxpass/services/crud/certificate_service.dart';

import '../models/models.dart';

class QRCodeView extends StatefulWidget {
  const QRCodeView({Key? key}) : super(key: key);

  @override
  State<QRCodeView> createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> {
  late final DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = DatabaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseService.getUserAndCertificates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final userAndCerts = snapshot.data
                as Tuple2<DatabaseUser, Iterable<DatabaseCertificate>>;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QrImage(
                        data: getQRCodeInfoQRCodeView(
                            userAndCerts.item1, userAndCerts.item2)),
                  ),
                  const Text(
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
