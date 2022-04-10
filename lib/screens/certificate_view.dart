import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/cloud/firebase_cloud_storage.dart';
import '../services/crud/certificate_service.dart';
import 'certificate_list_view.dart';

class CertificateView extends StatefulWidget {
  const CertificateView({Key? key}) : super(key: key);

  @override
  _CertificateViewState createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView> {
  late final DatabaseService _databaseService;
  late final FirebaseCloudStorage _firebaseService;

  @override
  void initState() {
    _databaseService = DatabaseService();
    _firebaseService = FirebaseCloudStorage();
    super.initState();
  }

  Future<void> _updateCertificatesFromCloud() async {
    final user = await _databaseService.getUser();

    final cloudCertificates =
        await _firebaseService.getCertificates(userSystemID: user.systemID);
    log(cloudCertificates.length.toString());
    _databaseService.deleteAllCertificates();

    for (final cert in cloudCertificates) {
      await _databaseService.createCertificate(
          certificate: cert.toDatabaseCertificate());
    }
    _databaseService.cacheCertificates();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseService.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final user = snapshot.data as DatabaseUser;
            return StreamBuilder(
              stream: _databaseService.allCertificates,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allCertificates =
                          snapshot.data as List<DatabaseCertificate>;
                      if (allCertificates.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'No certificates',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _updateCertificatesFromCloud();
                                },
                                child: const Text(
                                  'Refresh',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          await _updateCertificatesFromCloud();
                        },
                        child: CertificateListView(
                          certificates: allCertificates,
                          user: user,
                        ),
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
