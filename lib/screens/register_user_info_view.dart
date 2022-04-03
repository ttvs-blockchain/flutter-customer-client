import 'package:flutter/material.dart';
import 'package:vaxpass/services/auth/auth_service.dart';
import 'package:vaxpass/services/crud/certificate_service.dart';

import '../constants/constants.dart';
import '../models/models.dart';

class RegisterUserInfoView extends StatefulWidget {
  const RegisterUserInfoView({Key? key}) : super(key: key);

  @override
  State<RegisterUserInfoView> createState() => _RegisterUserInfoViewState();
}

class _RegisterUserInfoViewState extends State<RegisterUserInfoView> {
  late final TextEditingController _name;
  late final TextEditingController _countryCode;
  late final TextEditingController _countryID;
  late final TextEditingController _gender;
  late final TextEditingController _dateOfBirth;

  late final DatabaseService _databaseService;

  @override
  void initState() {
    _name = TextEditingController();
    _countryCode = TextEditingController();
    _countryID = TextEditingController();
    _gender = TextEditingController();
    _dateOfBirth = TextEditingController();
    _databaseService = DatabaseService();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _countryCode.dispose();
    _countryID.dispose();
    _gender.dispose();
    _dateOfBirth.dispose();
    super.dispose();
  }

  int _getGenderNum(String genderStr) {
    if (genderStr == 'Male') {
      return 0;
    }
    if (genderStr == 'Female') {
      return 1;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Text(
                'Please input your personal information below. You will be assigned a unique ID in the system.'),
            const SizedBox(height: 5),
            const Text(
                'Your personal information will be stored locally and not kept by our system.'),
            const SizedBox(height: 5),
            TextField(
              controller: _name,
              // obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Name',
                helperText: "Full name",
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _countryCode,
              // obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Country',
                helperText: 'In 3-character country code format',
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _countryID,
              // obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Identity Number',
                helperText: 'ID in your current country',
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _gender,
              // obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Gender',
                helperText: '"Male", "Female" or others',
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _dateOfBirth,
              // obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                helperText: 'Format: yyyy-mm-dd',
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  // TODO: to implement
                  final systemID = "001";
                  final name = _name.text;
                  final countryCode = _countryCode.text;
                  final countryID = _countryID.text;
                  final gender = _gender.text;
                  final dateOfBirth = _dateOfBirth.text;
                  await _databaseService.deleteAllUsers();
                  await _databaseService.createUser(
                      user: DatabaseUser(
                    null,
                    systemID: systemID,
                    name: name,
                    countryCode: countryCode,
                    countryID: countryID,
                    gender: _getGenderNum(gender),
                    dateOfBirth: dateOfBirth,
                    email: AuthService.fireBase().currentUser!.email!,
                  ));
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(mainViewRoute, (route) => true);
                },
                child: const Text('Next'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
