import 'package:intl/intl.dart';

import 'package:objectbox/objectbox.dart';

@Entity()
class UserData {
  // Annotate with @Id() if name isn't "id" (case insensitive).
  int id = 0;
  String? systemID;
  String? name;
  int? countryCode;
  String? countryID;
  bool? gender;
  DateTime dateOfBirth;
  String? otherInfo;

  UserData(this.id, this.name, this.countryCode, this.countryID, this.gender,
      this.dateOfBirth,
      {this.otherInfo});

  String get dateFormat => DateFormat('dd.MM.yyyy').format(dateOfBirth);

  @override
  String toString() {
    return 'UserData($id, $name, $countryCode, $countryID)';
  }
}

@Entity()
class CertificateData {
  int id = 0;
  String? systemID;
  String? title;
  String? info;
  DateTime issueDate;

  CertificateData(this.id, this.info, this.issueDate);

  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(issueDate);
}
