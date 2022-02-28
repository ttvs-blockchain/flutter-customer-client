import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class UserModel {
  // ObjectBox required
  int id = 0;

  // user basic info
  String systemID;
  String name;
  int countryCode;
  String countryID;
  int gender;
  DateTime dateOfBirth;
  Uint8List? payload;

  UserModel(this.id, this.systemID, this.name, this.countryCode, this.countryID,
      this.gender, this.dateOfBirth,
      {this.payload});

  String get dateFormat => DateFormat('dd.MM.yyyy').format(dateOfBirth);

  @override
  String toString() {
    return '''
    UserModel (
    \tid: $id,
    \tsystemID: $systemID,
    \tname $name,
    \tcountryCode: $countryCode,
    \tcountryID: $countryID,
    \tgender: $gender,
    \tDateOfBirth: $dateOfBirth
    \tpayload: $payload,
    )
    ''';
  }
}

@Entity()
class CertificateModel {
  // ObjectBox required
  int id = 0;

  // certificate basic info
  String systemID;
  String name;
  DateTime issueDate;
  int status;
  Uint8List? payload;

  // global chain info
  String globalChainTxHash;
  int globalChainBlockNum;
  DateTime globalChainTimeStamp;

  // local chain info
  String localChainID;
  String localChainTxHash;
  int localChainBlockNum;
  DateTime localChainTimeStamp;

  CertificateModel(
      this.id,
      this.systemID,
      this.name,
      this.issueDate,
      this.status,
      this.globalChainTxHash,
      this.globalChainBlockNum,
      this.globalChainTimeStamp,
      this.localChainID,
      this.localChainTxHash,
      this.localChainBlockNum,
      this.localChainTimeStamp,
      {this.payload});

  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(issueDate);

  @override
  String toString() {
    return '''
    CertificateModel (
    \tid: $id,
    \tsystemID: $systemID,
    \tname: $name,
    \tissueDate: $issueDate,
    \tstatus: $status,
    \tpayload: $payload,
    \t***global_chain_info***
    \tglobalChainTxHash: $globalChainTxHash,
    \tglobalChainBlockNum: $globalChainBlockNum,
    \tglobalChainTimeStamp: $globalChainTimeStamp,
    \t***local_chain_info***
    \tlocalChainID: $localChainID,
    \tlocalChainTxHash: $localChainTxHash,
    \tlocalChainBlockNum: $localChainBlockNum,
    \tlocalChainTimeStamp: $localChainTimeStamp,
    )
    ''';
  }
}

class VaccineCertificateModel extends CertificateModel {
  int? dose;

  VaccineCertificateModel(
      id,
      systemID,
      name,
      issueDate,
      status,
      globalChainTxHash,
      globalChainBlockNum,
      globalChainTimeStamp,
      localChainID,
      localChainTxHash,
      localChainBlockNum,
      localChainTimeStamp,
      this.dose,
      {payload})
      : super(
            id,
            systemID,
            name,
            issueDate,
            status,
            globalChainTxHash,
            globalChainBlockNum,
            globalChainTimeStamp,
            localChainID,
            localChainTxHash,
            localChainBlockNum,
            localChainTimeStamp,
            payload: payload);

  @override
  String toString() {
    String vacCertificate = super.toString() +
        '''
        VaccineCertificateModel (
        \tdose: $dose
        ''';
    return vacCertificate + super.toString();
  }
}
