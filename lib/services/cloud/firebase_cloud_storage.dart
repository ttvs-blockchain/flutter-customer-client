import 'package:cloud_firestore/cloud_firestore.dart';

import 'cloud_certificate.dart';
import 'cloud_storage_constants.dart';
import 'cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final certificates = FirebaseFirestore.instance.collection('certificates');

  Future<CloudCertificate> createNewCertificate(
      {required String ownerUserID}) async {
    final document = await certificates.add({
      ownerUserIDFieldName: ownerUserID,
      textFieldName: '',
    });
    final fetchedCertificate = await document.get();
    return CloudCertificate(
      documentID: fetchedCertificate.id,
      ownerUserID: ownerUserID,
      text: '',
    );
  }

  // Future<Iterable<CloudCertificate>> getCertificates(
  //     {required String ownerUserID}) async {
  //   try {
  //     return await certificates
  //         .where(
  //           ownerUserIDFieldName,
  //           isEqualTo: ownerUserID,
  //         )
  //         .get()
  //         .then(
  //           (value) => value.docs.map(
  //             (doc) {
  //               return CloudCertificate(
  //                 documentID: doc.id,
  //                 ownerUserID: doc.data()[ownerUserIDFieldName] as String,
  //                 text: doc.data()[textFieldName] as String,
  //               );
  //             },
  //           ),
  //         );
  //   } catch (_) {
  //     throw CouldNotGetAllCertificatesException();
  //   }
  // }

  Stream<Iterable<CloudCertificate>> allCertificates(
      {required String ownerUserID}) {
    final allCertificates = certificates
        .where(ownerUserIDFieldName, isEqualTo: ownerUserID)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudCertificate.fromSnapshot(doc)));
    return allCertificates;
  }

  Future<void> updateCertificate({
    required String documentID,
    required String text,
  }) async {
    try {
      await certificates.doc(documentID).update({textFieldName: text});
    } catch (_) {
      throw CouldNotUpdateCertificateException();
    }
  }

  Future<void> deleteCertificate({required String documentID}) async {
    try {
      await certificates.doc(documentID).delete();
    } catch (_) {
      throw CouldNotDeleteCertificateException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
