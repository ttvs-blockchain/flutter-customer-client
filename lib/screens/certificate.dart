import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CertificateItem extends StatelessWidget {
  CertificateItem({
    required this.id,
    required this.name,
    required this.label,
    required this.summary,
    required this.issueDate,
  }) : super(key: ObjectKey(id));

  final int id;
  final String name;
  final String label;
  final String summary;
  final DateTime issueDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat('HH:MM yyyy-MMM-dd').format(issueDate),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                const Icon(
                  Icons.qr_code_rounded,
                  color: Colors.blueAccent,
                  size: 40,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  summary,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateScene extends StatelessWidget {
  const CertificateScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return CertificateItem(
            id: index,
            name: 'Certificate $index',
            label: 'Vaccine Certificate',
            summary: 'This is a summary of the certificate',
            issueDate: DateTime.now(),
          );
        },
      ),
    );
  }
}
