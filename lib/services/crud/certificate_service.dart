import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';
import 'package:vaxpass/services/crud/crud_exceptions.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import 'certificate_constants.dart';
import 'dummy_data.dart';

class DatabaseService {
  Database? _db;

  List<DatabaseCertificate> _certificates = [];

  DatabaseUser? user;

  static final DatabaseService _shared = DatabaseService._sharedInstance();
  DatabaseService._sharedInstance() {
    _certificateStreamController =
        StreamController<List<DatabaseCertificate>>.broadcast(
      onListen: () {
        _certificateStreamController.sink.add(_certificates);
      },
    );
  }
  factory DatabaseService() => _shared;

  late final StreamController<List<DatabaseCertificate>>
      _certificateStreamController;

  Stream<List<DatabaseCertificate>> get allCertificates =>
      _certificateStreamController.stream; //.filter((certificate) {
  //   final currentUser = _user;
  //   if (currentUser != null) {
  //     return certificate.personID == currentUser.systemID;
  //   } else {
  //     throw ExceptionUserShouldBeSetBeforeAccessingAllCertificates();
  //   }
  // });

  Future<void> _cacheCertificates() async {
    final allCertificates = await getAllCertificates();
    _certificates = allCertificates.toList();
    _certificateStreamController.add(_certificates);
  }

  Future<void> open() async {
    if (_db != null) {
      throw ExceptionDatabaseAlreadyOpen();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, nameDB);
      final db = await openDatabase(dbPath);
      _db = db;

      // create user table
      await db.execute(queryCreateUserTable);

      // create certificate table
      db.execute(queryCreateCertificateTable);
      await _cacheCertificates();
    } on MissingPlatformDirectoryException {
      throw ExceptionUnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw ExceptionDatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDBIsOpen() async {
    try {
      await open();
    } on ExceptionDatabaseAlreadyOpen {
      // empty
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw ExceptionDatabaseIsNotOpen();
    }
    return db;
  }

  Future<int> createUser({required DatabaseUser user}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      nameUserTable,
      limit: 1,
      where: 'sys_id = ? or email = ?',
      whereArgs: [user.systemID, user.email],
    );
    if (results.isNotEmpty) {
      throw ExceptionUserAlreadyExists();
    }

    final userID = await db.insert(nameUserTable, {
      columnSystemID: user.systemID,
      columnName: user.name,
      columnCountryCode: user.countryCode,
      columnCountryID: user.countryID,
      columnGender: user.gender,
      columnDateOfBirth: user.dateOfBirth,
      columnEmail: user.email,
    });
    return userID;
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      nameUserTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleteCount != 1) {
      throw ExceptionCouldNotDeleteUser();
    }
  }

  Future<DatabaseUser> getUser() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      nameUserTable,
    );
    if (results.isEmpty) {
      throw ExceptionCouldNotFoundUser();
    }
    if (results.length > 1) {
      throw ExceptionUserNotUnique();
    }
    final user = DatabaseUser.fromRow(results.first);
    return user;
  }

  Future<int> createCertificate(
      {required DatabaseCertificate certificate}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure the owner exists in the database with the correct id
    // final dbUser = await getUser(email: owner.email);
    // if (dbUser != owner) {
    //   throw ExceptionCouldNotFoundUser();
    // }

    // const text = '';
    // create the certificate
    final certificateID = await db.insert(nameCertificateTable, {
      columnCertID: certificate.certID,
      columnPersonID: certificate.personID,
      columnName: certificate.name,
      columnBrand: certificate.brand,
      columnNumDose: certificate.numDose,
      columnIssueTime: certificate.issueTime,
      columnIssuer: certificate.issuer,
      columnRemark: certificate.remark,
      columnGlobalChainTxHash: certificate.globalChainTxHash,
      columnGlobalChainBlockNum: certificate.globalChainBlockNum,
      columnGlobalChainTimestamp: certificate.globalChainTimestamp,
      columnLocalChainID: certificate.localChainID,
      columnLocalChainTxHash: certificate.localChainTxHash,
      columnLocalChainBlockNum: certificate.localChainBlockNum,
      columnLocalChainTimestamp: certificate.localChainTimeStamp,
    });

    // final certificate = DatabaseCertificate(
    //   id: certificateID,
    //   userID: owner.id,
    //   text: text,
    //   isSyncedWithCloud: true,
    // );

    _certificates.add(certificate);
    _certificateStreamController.add(_certificates);

    return certificateID;
  }

  Future<void> deleteCertificate({required int id}) async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      nameCertificateTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deleteCount == 0) {
      throw ExceptionCouldNotDeleteCertificate();
    }
    _certificates.removeWhere((c) => c.id == id);
    _certificateStreamController.add(_certificates);
  }

  Future<int> deleteAllCertificates() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(nameCertificateTable);
    _certificates = [];
    _certificateStreamController.add(_certificates);
    return deleteCount;
  }

  // Future<DatabaseCertificate> getCertificate({required int id}) async {
  //   await _ensureDBIsOpen();
  //   final db = _getDatabaseOrThrow();
  //   final certificates = await db.query(
  //     nameCertificateTable,
  //     limit: 1,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );

  //   if (certificates.isEmpty) {
  //     throw ExceptionCouldNotFoundCertificate();
  //   }
  //   final certificate = DatabaseCertificate.fromRow(certificates.first);
  //   _certificates.removeWhere((c) => c.id == id);
  //   _certificates.add(certificate);
  //   _certificateStreamController.add(_certificates);
  //   return certificate;
  // }

  Future<Iterable<DatabaseCertificate>> getAllCertificates() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final certificates = await db.query(
      nameCertificateTable,
      orderBy: columnIssueTime + queryOrderByDESC,
    );

    return certificates
        .map((certificateRow) => DatabaseCertificate.fromRow(certificateRow));
  }

  Future<void> insertDummyCertificates() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final certificates = await db.query(nameCertificateTable);
    if (certificates.isNotEmpty) {
      return;
    }
    final certIDs = <int>[];
    for (var cert in dummyDatabaseCertificates) {
      final certID = await db.insert(nameCertificateTable, {
        columnCertID: cert.certID,
        columnPersonID: cert.personID,
        columnName: cert.name,
        columnBrand: cert.brand,
        columnNumDose: cert.numDose,
        columnIssueTime: cert.issueTime,
        columnIssuer: cert.issuer,
        columnRemark: cert.remark,
        columnGlobalChainTxHash: cert.globalChainTxHash,
        columnGlobalChainBlockNum: cert.globalChainBlockNum,
        columnGlobalChainTimestamp: cert.globalChainTimestamp,
        columnLocalChainID: cert.localChainID,
        columnLocalChainTxHash: cert.localChainTxHash,
        columnLocalChainBlockNum: cert.localChainBlockNum,
        columnLocalChainTimestamp: cert.localChainTimeStamp,
        columnIsValidated: cert.isValidated,
      });
      certIDs.add(certID);
      log(cert.toString());
    }
  }

  Future<void> insertDummyUser() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final users = await db.query(nameUserTable);
    if (users.length > 1) {
      throw ExceptionUserNotUnique();
    }
    if (users.isNotEmpty) {
      return;
    }
    await db.insert(nameUserTable, {
      columnSystemID: dummyDatabaseUser.systemID,
      columnName: dummyDatabaseUser.name,
      columnCountryCode: dummyDatabaseUser.countryCode,
      columnCountryID: dummyDatabaseUser.countryID,
      columnGender: dummyDatabaseUser.gender,
      columnDateOfBirth: dummyDatabaseUser.dateOfBirth,
      columnEmail: dummyDatabaseUser.email,
    });
  }
}
