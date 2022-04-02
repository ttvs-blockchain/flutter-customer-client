import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../models/models.dart';
import '../utils/generics/get_arguments.dart';

class CertificateQRCodeView extends StatelessWidget {
  const CertificateQRCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final certificate = context.getArgument<DatabaseCertificate>();
    if (certificate == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text(certificate.name), actions: [
        IconButton(
          onPressed: () {
            Share.share(certificate.toQRCodeInfo());
          },
          icon: const Icon(Icons.share),
        )
      ]),
      body: Column(
        children: [
          QrImage(data: certificate.toQRCodeInfo()),
          Text(
            'QR Code',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
