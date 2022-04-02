import 'package:flutter/material.dart';

class RegisterUserInfoView extends StatefulWidget {
  const RegisterUserInfoView({Key? key}) : super(key: key);

  @override
  State<RegisterUserInfoView> createState() => _RegisterUserInfoViewState();
}

class _RegisterUserInfoViewState extends State<RegisterUserInfoView> {
  late final TextEditingController _name;
  late final TextEditingController _systemID;
  late final TextEditingController _countryCode;
  late final TextEditingController _countryID;
  late final TextEditingController _gender;
  late final TextEditingController _dateOfBirth;
  late final TextEditingController _email;

  @override
  void initState() {
    _name = TextEditingController();
    _systemID = TextEditingController();
    _countryCode = TextEditingController();
    _countryID = TextEditingController();
    _gender = TextEditingController();
    _dateOfBirth = TextEditingController();
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _systemID.dispose();
    _countryCode.dispose();
    _countryID.dispose();
    _gender.dispose();
    _dateOfBirth.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
