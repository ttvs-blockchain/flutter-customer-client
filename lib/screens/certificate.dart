import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CertificateItem extends StatelessWidget {
  CertificateItem({
    required this.id,
    required this.title,
    required this.info,
    required this.issueDate,
  }) : super(key: ObjectKey(id));

  final int id;
  final String title;
  final String info;
  final DateTime issueDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  info,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  DateFormat('yyyy MMM.dd')
                      .format(issueDate), //issueDate.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            const Icon(Icons.qr_code_outlined),
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
            title: 'Certificate $index',
            info: 'This is the info for certificate $index',
            issueDate: DateTime.now(),
          );
        },
      ),
    );
  }
}
