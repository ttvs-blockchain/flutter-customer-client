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
          QrImage(data: qrCodeInfo),
          Text(
            'QR Code',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
