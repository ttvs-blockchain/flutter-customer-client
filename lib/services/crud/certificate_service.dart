import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:tuple/tuple.dart';

import '../../constants/constants.dart';
import '../../models/models.dart';
import '../auth/firebase_auth_provider.dart';
import 'certificate_constants.dart';
import 'crud_exceptions.dart';

class DatabaseService {
  Database? _db;

  List<DatabaseCertificate> _certificates = [];

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

  final authProvider = FirebaseAuthProvider();

  Future<void> open() async {
    if (_db != null) {
      throw ExceptionDatabaseAlreadyOpen();
    }
    final user = authProvider.currentUser;
    // user not logged in
    if (user == null) {
      throw ExceptionUserNotLoggedIn();
    }
    String dbPath;
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      dbPath = join(docsPath.path, nameDB);
    } on MissingPlatformDirectoryException {
      throw ExceptionUnableToGetDocumentsDirectory();
    }
    try {
      final secureKey = 'pw:${user.email}:${user.id}';
      final pwHash = await const FlutterSecureStorage().read(key: secureKey);
      if (pwHash == null) {
        throw ExceptionCouldNotObtainDatabasePassword();
      }
      // use password and version to open sql_cipher
      final db = await openDatabase(
        dbPath,
        password: pwHash,
        version: dbVersion,
      );
      _db = db;
    } on DatabaseException {
      // if sql_cipher cannot be opened， try deleting the db path and create a new db
      // then open the db with new password
      Directory(dbPath).delete(recursive: true);
      final db = await openDatabase(
        dbPath,
        password: user.id,
        version: dbVersion,
      );
      _db = db;
    }

    _deleteDeprecatedTables(_db!);

    // create user table
    await _db!.execute(queryCreateUserTable);

    // create certificate table
    _db!.execute(queryCreateCertificateTable);
    await cacheCertificates();
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
      where: 'system_id = ?',
      whereArgs: [user.systemID],
    );
    if (results.isNotEmpty) {
      throw ExceptionUserAlreadyExists();
    }

    final userID = await db.insert(nameUserTable, {
      columnSystemID: user.systemID,
      columnName: user.name,
      columnCountryCode: user.countryCode,
      columnDocumentType: user.documentType,
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
    final userID = FirebaseAuthProvider().currentUser!.id;
    final results = await db.query(
      nameUserTable,
      where: 'system_id = ?',
      whereArgs: [userID],
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
      columnMerkleTreePath: certificate.merkleTreePath,
      columnMerkleTreeIndexes: certificate.merkleTreeIndexes,
      columnGlobalRootID: certificate.globalRootID,
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
    final userID = FirebaseAuthProvider().currentUser!.id;
    final certificates = await db.query(
      nameCertificateTable,
      where: "person_id = ?",
      whereArgs: [userID],
      orderBy: columnIssueTime + queryOrderByDESC,
    );
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
      throw ExceptionCouldNotFoundUser();
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

  Future<void> _deleteDeprecatedTables(Database db) async {
    final tables = await db.rawQuery(queryAllTableNames);
    // table['name'] refers to the table name
    final tableNames = tables.map((table) => table['name'] as String).toList();
    final deprecatedTableNames = tableNames
        .where((name) => !notRemoveTableNames.contains(name))
        .toList();
    for (final tableName in deprecatedTableNames) {
      await db.execute(queryDropTableByName + tableName);
    }
  }
}
