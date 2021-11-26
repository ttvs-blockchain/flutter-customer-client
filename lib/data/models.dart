import 'package:intl/intl.dart';

import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  // Annotate with @Id() if name isn't "id" (case insensitive).
  int id = 0;
  String? name;
  int? countryCode;
  String? countryID;
  bool? gender;
  DateTime dateOfBirth;
  String? otherInfo;

  User(this.id, this.name, this.countryCode, this.countryID, this.gender,
      this.dateOfBirth,
      {this.otherInfo});

  String get dateFormat => DateFormat('dd.MM.yyyy').format(dateOfBirth);
}

@Entity()
class Certificate {
  int id = 0;
  String? info;
  DateTime issueDate;

  Certificate(this.id, this.info, this.issueDate);

  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(issueDate);
}
