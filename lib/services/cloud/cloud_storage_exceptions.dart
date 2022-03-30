import 'package:flutter/material.dart';

@immutable
class CloudStorageException implements Exception {
  const CloudStorageException();
}

class ExceptionCouldNotCreateCertificate implements Exception {}

class ExceptionCouldNotGetAllCertificates implements Exception {}

class ExceptionCouldNotUpdateCertificate implements Exception {}

class ExceptionCouldNotDeleteCertificate implements Exception {}
