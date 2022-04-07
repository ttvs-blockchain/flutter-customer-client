import 'package:country_code_picker/country_code_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpass/constants/country_codes.dart';
import 'package:vaxpass/constants/document_types.dart';
import 'package:vaxpass/constants/genders.dart';
import 'package:vaxpass/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';

class RegisterUserInfoView extends StatefulWidget {
  const RegisterUserInfoView({Key? key}) : super(key: key);

  @override
  State<RegisterUserInfoView> createState() => _RegisterUserInfoViewState();
}

class _RegisterUserInfoViewState extends State<RegisterUserInfoView> {
  late final TextEditingController _name;
  late final TextEditingController _countryID;

  String countryCode = countryCodeMap['HK']!.code;
  String documentType = documentTypeList[0];
  String gender = genderList[0];
  String dateOfBirth = '2000-01-01';

  @override
  void initState() {
    _name = TextEditingController();
    _countryID = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _countryID.dispose();
    super.dispose();
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
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Full Name'),
                TextField(
                  controller: _name,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      hintText: 'Identical to your official ID document'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Country/Region:'),
                CountryCodePicker(
                  onChanged: (cc) {
                    countryCode = cc.code!;
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'HK',
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: true,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Select Document Type:'),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: documentType,
                  elevation: 16,
                  onChanged: (String? newValue) {
                    setState(() {
                      documentType = newValue!;
                    });
                  },
                  items: documentTypeList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Identity Number'),
                TextField(
                  controller: _countryID,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      hintText: 'Identical to your ID on the passport'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Select Gender:'),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: gender,
                  elevation: 16,
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue!;
                    });
                  },
                  items:
                      genderList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Date of Birth'),
                DateTimePicker(
                  initialValue: '',
                  firstDate: DateTime(1800),
                  lastDate: DateTime(DateTime.now().year + 1),
                  onChanged: (val) {
                    dateOfBirth = val;
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final name = _name.text;
                  final countryID = _countryID.text;
                  context.read<AuthBloc>().add(
                        AuthEventRegisterUserInfo(
                          name,
                          countryCode,
                          documentType,
                          countryID,
                          gender,
                          dateOfBirth,
                        ),
                      );
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
