import 'package:flutter/material.dart';

import '../constants/country_codes.dart';
import '../constants/document_types.dart';
import '../constants/genders.dart';
import '../models/models.dart';
import '../services/crud/certificate_service.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({Key? key}) : super(key: key);

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  late final DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = DatabaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseService.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final user = snapshot.data as DatabaseUser;
            return ListView(
              children: <Widget>[
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                ListTile(
                  title: const Text('Name'),
                  subtitle: Text(user.name),
                ),
                ListTile(
                  title: const Text('Country/Region'),
                  subtitle: Text(_countryCodeToEngName(user.countryCode)),
                ),
                ListTile(
                  title: const Text('Document Type'),
                  subtitle: Text(_intToDocumentType(user.documentType)),
                ),
                ListTile(
                  title: const Text('Identity Number'),
                  subtitle: Text(user.countryID),
                ),
                ListTile(
                  title: const Text('Gender'),
                  subtitle: Text(_intToGender(user.gender)),
                ),
                ListTile(
                  title: const Text('Date of Birth'),
                  subtitle: Text(user.dateOfBirth),
                ),
                ListTile(
                  title: const Text('Email'),
                  subtitle: Text(user.email),
                ),
              ],
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

String _intToGender(int value) {
  if (value >= genderList.length) {
    return 'Undefined';
  }
  return genderList[value];
}

String _intToDocumentType(int value) {
  if (value >= documentTypeList.length) {
    return 'Undefined';
  }
  return documentTypeList[value];
}

String _countryCodeToEngName(String countryCode) {
  if (countryCodeMap.containsKey(countryCode)) {
    return countryCodeMap[countryCode]!.engName;
  }
  return 'Undefined';
}
