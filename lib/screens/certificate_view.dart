import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/crud/certificate_service.dart';
import 'certificate_list_view.dart';

class CertificateView extends StatefulWidget {
  const CertificateView({Key? key}) : super(key: key);

  @override
  _CertificateViewState createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView> {
  late final DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = DatabaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseService.allCertificates,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allCertificates =
                  snapshot.data as List<DatabaseCertificate>;
              return allCertificates.isEmpty
                  ? const Center(
                      child: Text(
                        'No certificates',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : CertificateListView(
                      certificates: allCertificates,
                    );
            }
            return const Center(child: CircularProgressIndicator());
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
