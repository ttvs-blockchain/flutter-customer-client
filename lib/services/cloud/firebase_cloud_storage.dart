import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import 'cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final certificates = FirebaseFirestore.instance.collection('certificates');

  // Future<CloudCertificate> createNewCertificate(
  //     {required String ownerUserID}) async {
  //   final document = await certificates.add({
  //     fieldNameOwnerUserID: ownerUserID,
  //     textFieldName: '',
  //   });
  //   final fetchedCertificate = await document.get();
  //   return CloudCertificate(
  //     documentID: fetchedCertificate.id,
  //     ownerUserID: ownerUserID,
  //     text: '',
  //   );
  // }

  Future<Iterable<CloudCertificate>> getCertificates(
      {required String userSystemID}) async {
    try {
      return await certificates
          .where(
            fieldNamePersonID,
            isEqualTo: userSystemID,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudCertificate.fromSnapshot(doc);
              },
            ),
          );
    } catch (_) {
      throw ExceptionCouldNotGetAllCertificates();
    }
  }

  Stream<Iterable<CloudCertificate>> allCertificates(
      {required String userSystemID}) {
    final allCertificates = certificates
        .where(fieldNamePersonID, isEqualTo: userSystemID)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudCertificate.fromSnapshot(doc)));
    return allCertificates;
  }

  // Future<Iterable<CloudCertificate>> getAllCertificates(
  //     {required String userSystemID}) async {
  //   final allCertificates = await certificates
  //       .where(fieldNamePersonID, isEqualTo: userSystemID)
  //       .snapshots()
  //       .map((event) =>
  //           event.docs.map((doc) => CloudCertificate.fromSnapshot(doc)));
  //   return allCertificates;
  // }

  // Future<void> updateCertificate({
  //   required String documentID,
  //   required String text,
  // }) async {
  //   try {
  //     await certificates.doc(documentID).update({textFieldName: text});
  //   } catch (_) {
  //     throw ExceptionCouldNotUpdateCertificate();
  //   }
  // }

  // Future<void> deleteCertificate({required String documentID}) async {
  //   try {
  //     await certificates.doc(documentID).delete();
  //   } catch (_) {
  //     throw ExceptionCouldNotDeleteCertificate();
  //   }
  // }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
