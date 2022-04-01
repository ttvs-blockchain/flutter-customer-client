import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';
import 'package:vaxpass/services/crud/crud_exceptions.dart';

import 'certificate_constants.dart';
import 'dummy_data.dart';

class CertificateService {
  Database? _db;

  List<DatabaseCertificate> _certificates = [];

  DatabaseUser? _user;

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
      columnGlobalChainTimestamp: certificate.globalChainTimeStamp,
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
        columnGlobalChainTimestamp: cert.globalChainTimeStamp,
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
}

@immutable
class DatabaseUser {
  final int? id;
  final String systemID;
  final String name;
  final String countryCode;
  final String countryID;
  final String gender;
  final String dateOfBirth;
  final String email;

  const DatabaseUser(
    this.id, {
    required this.systemID,
    required this.name,
    required this.countryCode,
    required this.countryID,
    required this.gender,
    required this.dateOfBirth,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[columnID] as int,
        systemID = map[columnSystemID] as String,
        name = map[columnName] as String,
        countryCode = map[columnCountryCode] as String,
        countryID = map[columnCountryID] as String,
        gender = _intToGenderString(map[columnGender] as int),
        dateOfBirth = map[columnDateOfBirth] as String,
        email = map[columnEmail] as String;

  @override
  String toString() => '''User($id, $systemID)[
      \tname: $name, 
      \tcountryCode: $countryCode,  
      \tcountryID: $countryID, 
      \tgender: $gender';
      \tdateOfBirth: $dateOfBirth,
      ]''';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseCertificate {
  final int? id;
  final String certID;
  final String personID;
  final String name;
  final String brand;
  final int numDose;
  final String issueTime;
  final String issuer;
  final String remark;
  final String globalChainTxHash;
  final int globalChainBlockNum;
  final String globalChainTimeStamp;
  final String localChainID;
  final String localChainTxHash;
  final int localChainBlockNum;
  final String localChainTimeStamp;
  final bool isValidated;

  DatabaseCertificate(
    this.id, {
    required this.certID,
    required this.personID,
    required this.name,
    required this.brand,
    required this.numDose,
    required this.issueTime,
    required this.issuer,
    required this.remark,
    required this.globalChainTxHash,
    required this.globalChainBlockNum,
    required this.globalChainTimeStamp,
    required this.localChainID,
    required this.localChainTxHash,
    required this.localChainBlockNum,
    required this.localChainTimeStamp,
    required this.isValidated,
  });

  DatabaseCertificate.fromRow(Map<String, Object?> map)
      : id = map[columnID] as int,
        certID = map[columnCertID] as String,
        personID = map[columnPersonID] as String,
        name = map[columnName] as String,
        brand = map[columnBrand] as String,
        numDose = map[columnNumDose] as int,
        issueTime = map[columnIssueTime] as String,
        issuer = map[columnIssuer] as String,
        remark = map[columnRemark] as String,
        globalChainTxHash = map[columnGlobalChainTxHash] as String,
        globalChainBlockNum = map[columnGlobalChainBlockNum] as int,
        globalChainTimeStamp = map[columnGlobalChainTimestamp] as String,
        localChainID = map[columnLocalChainID] as String,
        localChainTxHash = map[columnLocalChainTxHash] as String,
        localChainBlockNum = map[columnLocalChainBlockNum] as int,
        localChainTimeStamp = map[columnLocalChainTimestamp] as String,
        isValidated = (map[columnIsValidated] as int) == 1;

  @override
  String toString() => ''''Certificate($id, $certID)[
    \tperson ID: $personID,
    \tname: $name,
    \tbrand: $brand,
    \tnumDose: $numDose,
    \tissueTime: $issueTime,
    \tissuer: $issuer,
    \tremark: $remark,
    \tglobalChainTxHash: $globalChainTxHash,
    \tglobalChainBlockNum: $globalChainBlockNum,
    \tglobalChainTimeStamp: $globalChainTimeStamp,
    \tlocalChainID: $localChainID,
    \tlocalChainTxHash: $localChainTxHash,
    \tlocalChainBlockNum: $localChainBlockNum,
    \tlocalChainTimeStamp: $localChainTimeStamp,
    \tisValidated: $isValidated,
  ]''';

  @override
  bool operator ==(covariant DatabaseCertificate other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

String _intToGenderString(int intValue) {
  if (intValue == 0) {
    return "male";
  }
  if (intValue == 1) {
    return "female";
  }
  return "undefined";
}
