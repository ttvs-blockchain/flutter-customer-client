import 'package:flutter/material.dart';

@immutable
class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateCertificateException implements Exception {}

class CouldNotGetAllCertificatesException implements Exception {}

class CouldNotUpdateCertificateException implements Exception {}

class CouldNotDeleteCertificateException implements Exception {}
