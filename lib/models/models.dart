import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../constants/constants.dart';

@immutable
class DatabaseUser {
  final int? id;
  final String systemID;
  final String name;
  final String countryCode;
  final String countryID;
  final int gender;
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
        gender = map[columnGender] as int,
        dateOfBirth = map[columnDateOfBirth] as String,
        email = map[columnEmail] as String;

  @override
  String toString() => '''User($id, $systemID)[
      \tname: $name, 
      \tcountryCode: $countryCode,  
      \tcountryID: $countryID, 
      \tgender: $gender';
      \tdateOfBirth: $dateOfBirth,
      \temail: $email,
      ]''';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  String toQRCodeInfo() =>
      '"personalInfo":{"sysID":"$systemID","name":"$name","countryCode":"$countryCode","countryID":"$countryID","gender":"$gender","dateOfBirth":"$dateOfBirth"}';
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
  final String globalChainTimestamp;
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
    required this.globalChainTimestamp,
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
        globalChainTimestamp = map[columnGlobalChainTimestamp] as String,
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
    \tglobalChainTimeStamp: $globalChainTimestamp,
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

  String toQRCodeInfo() =>
      '"certificate":{"personID":"$personID","name":"$name","brand":"$brand","numDose":$numDose,"issueTime":"$issueTime","issuer":"$issuer","remark":"$remark","merklePath":["AIZca0LlTpd9yMCQpCji+hcqQoPBVvy10vQGJgLfopQ=","Nn7D3dsGNPI+4+Q4UqLy3Eo4VV+L6adyohnJTJiKzHY=","KBKMHj7Sl0xO8YTzxksqZSv4t1GmBLJ7/Gk2PbXThZw="]}';
}

@immutable
class CloudCertificate {
  final String documentID;
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
  final String globalChainTimestamp;
  final String localChainID;
  final String localChainTxHash;
  final int localChainBlockNum;
  final String localChainTimestamp;
  final bool isValidated;

  const CloudCertificate({
    required this.documentID,
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
    required this.globalChainTimestamp,
    required this.localChainID,
    required this.localChainTxHash,
    required this.localChainBlockNum,
    required this.localChainTimestamp,
    required this.isValidated,
  });

  CloudCertificate.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentID = snapshot.id,
        certID = snapshot.data()[fieldNameCertID],
        personID = snapshot.data()[fieldNamePersonID],
        name = snapshot.data()[fieldNameName],
        brand = snapshot.data()[fieldNameBrand],
        numDose = snapshot.data()[fieldNameNumDose],
        issueTime = snapshot.data()[fieldNameIssueTime],
        issuer = snapshot.data()[fieldNameIssuer],
        remark = snapshot.data()[fieldNameRemark],
        globalChainTxHash = snapshot.data()[fieldNameGlobalChainTxHash],
        globalChainBlockNum = snapshot.data()[fieldNameGlobalChainBlockNum],
        globalChainTimestamp = snapshot.data()[fieldNameGlobalChainTimestamp],
        localChainID = snapshot.data()[fieldNameLocalChainID],
        localChainTxHash = snapshot.data()[fieldNameLocalChainTxHash],
        localChainBlockNum = snapshot.data()[fieldNameLocalChainBlockNum],
        localChainTimestamp = snapshot.data()[fieldNameLocalChainTimestamp],
        isValidated = snapshot.data()[fieldNameIsValidated];

  DatabaseCertificate toDatabaseCertificate() => DatabaseCertificate(
        null,
        certID: certID,
        personID: personID,
        name: name,
        brand: brand,
        numDose: numDose,
        issueTime: issueTime,
        issuer: issuer,
        remark: remark,
        globalChainTxHash: globalChainTxHash,
        globalChainBlockNum: globalChainBlockNum,
        globalChainTimestamp: globalChainTimestamp,
        localChainID: localChainID,
        localChainTxHash: localChainTxHash,
        localChainBlockNum: localChainBlockNum,
        localChainTimeStamp: localChainTimestamp,
        isValidated: isValidated,
      );
}

String getCertificatePageQRCodeInfo(
    DatabaseCertificate certificate, DatabaseUser user) {
  final qrCodeInfo = '{${user.toQRCodeInfo()},${certificate.toQRCodeInfo()}}';
  log(qrCodeInfo);
  return qrCodeInfo;
}
