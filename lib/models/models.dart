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

  UserModel(this.systemID, this.name, this.countryCode, this.countryID,
      this.gender, this.dateOfBirth,
      {this.id = 0, this.payload});

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
    \tDateOfBirth: $dateOfBirth,
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
  int type;
  // String issuerID;
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
      this.systemID,
      this.name,
      this.issueDate,
      this.status,
      this.type,
      this.globalChainTxHash,
      this.globalChainBlockNum,
      this.globalChainTimeStamp,
      this.localChainID,
      this.localChainTxHash,
      this.localChainBlockNum,
      this.localChainTimeStamp,
      {this.id = 0,
      this.payload});

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
    \ttype: $type,
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
