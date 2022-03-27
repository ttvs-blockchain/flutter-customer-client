import 'package:flutter/foundation.dart';
import 'cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class CloudCertificate {
  final String documentID;
  final String ownerUserID;
  final String text;

  const CloudCertificate({
    required this.documentID,
    required this.ownerUserID,
    required this.text,
  });

  CloudCertificate.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentID = snapshot.id,
        ownerUserID = snapshot.data()[ownerUserIDFieldName],
        text = snapshot.data()[textFieldName] as String;
}
