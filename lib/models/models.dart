import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class UserModel {
  // Annotate with @Id() if name isn't "id" (case insensitive).
  int id = 0;
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
  int id = 0;
  String systemID;
  String name;
  DateTime issueDate;
  Uint8List? payload;

  CertificateModel(this.id, this.systemID, this.name, this.issueDate,
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
    \tpayload: $payload,
    ''';
  }
}

class VaccineCertificateModel extends CertificateModel {
  int? dose;

  VaccineCertificateModel(id, systemID, name, issueDate, this.dose, {payload})
      : super(id, systemID, name, issueDate, payload: payload);

  @override
  String toString() {
    String vacCertificate = '''
    VaccineCertificateModel (
    \tdose: $dose
    ''';
    return vacCertificate + super.toString();
  }
}
