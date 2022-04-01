import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../services/crud/certificate_service.dart';
import 'certificate_list_view.dart';

class CertificateView extends StatefulWidget {
  const CertificateView({Key? key}) : super(key: key);

  @override
  _CertificateViewState createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView>
    with AutomaticKeepAliveClientMixin<CertificateView> {
  late final DatabaseService _databaseService;
  // late final FirebaseCloudStorage _certificateService;

  // String get userEmail => AuthService.fireBase().currentUser!.email!;
  // String get userID => AuthService.fireBase().currentUser!.id;

  @override
  void initState() {
    _databaseService = DatabaseService();
    // _certificateService = FirebaseCloudStorage();
    _databaseService.insertDummyCertificates();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _databaseService.allCertificates,
      // stream: _certificateService.allCertificates(ownerUserID: userID),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allCertificates =
                  snapshot.data as List<DatabaseCertificate>;
              // snapshot.data as Iterable<CloudCertificate>;
              return CertificateListView(
                certificates: allCertificates,
                onDeleteCertificate: (certificate) async {
                  await _databaseService.deleteCertificate(id: certificate.id!);
                  // await _certificateService.deleteCertificate(
                  //   documentID: certificate.documentID,
                  // );
                },
                onTap: (certificate) async {
                  Navigator.of(context).pushNamed(
                    createOrUpdateCertificateRoute,
                    arguments: certificate,
                  );
                },
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
