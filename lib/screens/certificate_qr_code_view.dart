import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

import '../models/models.dart';
import '../utils/generics/get_arguments.dart';

class CertificateQRCodeView extends StatelessWidget {
  const CertificateQRCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final certificateAndUser =
        context.getArgument<Tuple2<DatabaseCertificate, DatabaseUser>>();
    if (certificateAndUser == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final certificate = certificateAndUser.item1;
    final user = certificateAndUser.item2;
    final qrCodeInfo = getQRCodeInfoCertificateListView(certificate, user);
    return Scaffold(
      appBar: AppBar(title: Text(certificate.name), actions: [
        IconButton(
          onPressed: () {
            Share.share(qrCodeInfo);
          },
          icon: const Icon(Icons.share),
        )
      ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              'Certificate QR Code',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: QrImage(data: qrCodeInfo),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Please present this QR code while verifying',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
