import 'package:flutter/material.dart';
import 'package:vaxpass/services/auth/auth_service.dart';
import 'package:vaxpass/services/cloud/firebase_cloud_storage.dart';

import '../constants/constants.dart';
import '../services/cloud/cloud_certificate.dart';
import 'certificate_list_view.dart';

class CertificateScene extends StatefulWidget {
  const CertificateScene({Key? key}) : super(key: key);

  @override
  _CertificateSceneState createState() => _CertificateSceneState();
}

class _CertificateSceneState extends State<CertificateScene>
    with AutomaticKeepAliveClientMixin<CertificateScene> {
  // late final CertificateService _certificateService;
  late final FirebaseCloudStorage _certificateService;

  // String get userEmail => AuthService.fireBase().currentUser!.email!;
  String get userID => AuthService.fireBase().currentUser!.id;

  @override
  void initState() {
    // _certificateService = CertificateService();
    _certificateService = FirebaseCloudStorage();
    // _certificateService.open();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _certificateService.close();
  //   super.dispose();
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      // stream: _certificateService.allCertificates,
      stream: _certificateService.allCertificates(ownerUserID: userID),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allCertificates =
                  // snapshot.data as List<DatabaseCertificate>;
                  snapshot.data as Iterable<CloudCertificate>;
              return CertificateListView(
                certificates: allCertificates,
                onDeleteCertificate: (certificate) async {
                  // await _certificateService.deleteCertificate(
                  //     id: certificate.id);
                  await _certificateService.deleteCertificate(
                    documentID: certificate.documentID,
                  );
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
