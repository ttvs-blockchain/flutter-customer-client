import 'package:flutter/material.dart';
import '../constants/country_codes.dart';

import '../models/models.dart';
import '../services/crud/certificate_service.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({Key? key}) : super(key: key);

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView>
    with AutomaticKeepAliveClientMixin<PersonalInfoView> {
  late final DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = DatabaseService();
    _databaseService.insertDummyUser();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _databaseService.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final user = snapshot.data as DatabaseUser;
            return Column(
              children: <Widget>[
                const SizedBox(height: 4),
                Text('Personal Information',
                    style: Theme.of(context).textTheme.headline6),
                ListTile(
                  title: const Text('Name'),
                  subtitle: Text(user.name),
                ),
                ListTile(
                  title: const Text('System ID'),
                  subtitle: Text(user.systemID),
                ),
                ListTile(
                  title: const Text('Country/Region'),
                  subtitle: Text(countryCodeMap[user.countryCode]!),
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

String _intToGender(int intValue) {
  if (intValue == 0) {
    return 'Male';
  }
  if (intValue == 1) {
    return 'Female';
  }
  return 'Undefined';
}
