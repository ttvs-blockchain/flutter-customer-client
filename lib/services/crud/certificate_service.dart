import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';
import 'package:vaxpass/services/crud/crud_exceptions.dart';

class CertificateService {
  Database? _db;

  List<DatabaseCertificate> _certificates = [];

  static final CertificateService _shared =
      CertificateService._sharedInstance();
  CertificateService._sharedInstance() {
    _certificateStreamController =
        StreamController<List<DatabaseCertificate>>.broadcast(
      onListen: () {
        _certificateStreamController.sink.add(_certificates);
      },
    );
  }
  factory CertificateService() => _shared;

  late final StreamController<List<DatabaseCertificate>>
      _certificateStreamController;

  Stream<List<DatabaseCertificate>> get allCertificates =>
      _certificateStreamController.stream;

  Future<void> _cacheCertificates() async {
    final allCertificates = await getAllCertificates();
    _certificates = allCertificates.toList();
    _certificateStreamController.add(_certificates);
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      // create user table
      await db.execute(createUserTable);

      // create certificate table
      db.execute(createCertificateTable);
      await _cacheCertificates();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureIDIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    }
    return db;
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureIDIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTableName,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userID = await db.insert(userTableName, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userID,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureIDIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      userTableName,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleteCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureIDIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      userTableName,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) {
      throw CouldNotFoundUserException();
    }

    return DatabaseUser.fromRow(result.first);
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFoundUserException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (_) {
      rethrow;
    }
  }

  Future<DatabaseCertificate> createCertificate(
      {required DatabaseUser owner}) async {
    await _ensureIDIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure the owner exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFoundUserException();
    }

    const text = '';
    // create the certificate
    final certificateID = await db.insert(certificateTableName, {
      userIDColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final certificate = DatabaseCertificate(
      id: certificateID,
      userID: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    _certificates.add(certificate);
    _certificateStreamController.add(_certificates);

    return certificate;
  }

  Future<void> deleteCertificate({required int id}) async {
    await _ensureIDIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      certificateTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deleteCount == 0) {
      throw CouldNotDeleteCertificateException();
    }
    _certificates.removeWhere((c) => c.id == id);
    _certificateStreamController.add(_certificates);
  }

  Future<int> deleteAllCertificates() async {
    await _ensureIDIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(certificateTableName);
    _certificates = [];
    _certificateStreamController.add(_certificates);
    return deleteCount;
  }

  Future<DatabaseCertificate> getCertificate({required int id}) async {
    await _ensureIDIsOpen();
    final db = _getDatabaseOrThrow();
    final certificates = await db.query(
      certificateTableName,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (certificates.isEmpty) {
      throw CouldNotFoundCertificateException();
    }
    final certificate = DatabaseCertificate.fromRow(certificates.first);
    _certificates.removeWhere((c) => c.id == id);
    _certificates.add(certificate);
    _certificateStreamController.add(_certificates);
    return certificate;
  }

  Future<Iterable<DatabaseCertificate>> getAllCertificates() async {
    await _ensureIDIsOpen();
    final db = _getDatabaseOrThrow();
    final certificates = await db.query(certificateTableName);

    return certificates
        .map((certificateRow) => DatabaseCertificate.fromRow(certificateRow));
  }

  Future<DatabaseCertificate> updateCertificate({
    required DatabaseCertificate certificate,
    required String text,
  }) async {
    await _ensureIDIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure the certificate exists
    await getCertificate(id: certificate.id);

    final updateCount = await db.update(certificateTableName, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updateCount == 0) {
      throw CouldNotUpdateCertificateException();
    }

    final updatedCertificate = await getCertificate(id: certificate.id);
    _certificates.removeWhere((c) => c.id == updatedCertificate.id);
    _certificates.add(updatedCertificate);
    _certificateStreamController.add(_certificates);
    return updatedCertificate;
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'User, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseCertificate {
  final int id;
  final int userID;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseCertificate({
    required this.id,
    required this.userID,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseCertificate.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userID = map[userIDColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Certificate, ID = $id, userID = $userID, isSyncedWithCloud = $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseCertificate other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'vaxpass.db';
const userTableName = 'user';
const certificateTableName = 'certificate';
const idColumn = 'id';
const emailColumn = 'email';
const userIDColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const createCertificateTable = '''CREATE TABLE IF NOT EXISTS "certificate" (
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "text" TEXT,
        "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
