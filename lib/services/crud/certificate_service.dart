import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';
import 'package:vaxpass/services/crud/crud_exceptions.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import 'certificate_constants.dart';
import 'dummy_data.dart';

class DatabaseService {
  Database? _db;

  List<DatabaseCertificate> _certificates = [];

  DatabaseUser? _user;

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
      _certificateStreamController.stream;

  Future<void> cacheCertificates() async {
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
      await cacheCertificates();
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
      where: 'system_id = ? or email = ?',
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

  Future<void> deleteAllUsers() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    await db.delete(nameUserTable);
  }

  Future<bool> hasUser() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final users = await db.query(nameUserTable);
    return users.isNotEmpty;
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
      columnIsValidated: certificate.isValidated ? 1 : 0,
    });

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

  Future<Iterable<DatabaseCertificate>> getAllCertificates() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final certificates = await db.query(
      nameCertificateTable,
      orderBy: columnIssueTime + queryOrderByDESC,
    );
    log(certificates.toString());
    return certificates
        .map((certificateRow) => DatabaseCertificate.fromRow(certificateRow));
  }

  Future<Tuple2<DatabaseUser, Iterable<DatabaseCertificate>>>
      getUserAndCertificates() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final users = await db.query(
      nameUserTable,
    );
    if (users.isEmpty) {
      // throw ExceptionCouldNotFoundUser();
      // TODO: change this
      return const Tuple2(dummyDatabaseUser, []);
    }
    if (users.isEmpty) {
      return const Tuple2(dummyDatabaseUser, []);
    }
    if (users.length > 1) {
      throw ExceptionUserNotUnique();
    }
    final user = DatabaseUser.fromRow(users.first);
    final certificates = await db.query(
      nameCertificateTable,
      orderBy: columnIssueTime + queryOrderByDESC,
    );
    final iterableCertificates = certificates
        .map((certificateRow) => DatabaseCertificate.fromRow(certificateRow));
    return Tuple2<DatabaseUser, Iterable<DatabaseCertificate>>(
        user, iterableCertificates);
  }

  Future<void> insertDummyCertificates() async {
    log('Start inserting dummy certificates');
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
    cacheCertificates();
  }

  Future<void> insertDummyUser() async {
    log('Start to insert dummy user');
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
    _user = dummyDatabaseUser;
    log(_user.toString());
  }
}
