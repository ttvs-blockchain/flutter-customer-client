import 'package:flutter/material.dart';
import 'package:vaxpass/services/crud/certificate_service.dart';

class NewCertificateView extends StatefulWidget {
  const NewCertificateView({Key? key}) : super(key: key);

  @override
  _NewCertificateViewState createState() => _NewCertificateViewState();
}

class _NewCertificateViewState extends State<NewCertificateView> {
  DatabaseCertificate? _certificate;
  late final CertificateService _certificateService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Certificate'),
      ),
      body: const Text('Generate your new certificate here'),
    );
  }
}
