import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaxpass/constants/constants.dart';

import '../services/crud/certificate_service.dart';

typedef CertificateCallBack = void Function(DatabaseCertificate certificate);
// typedef CertificateCallBack = void Function(CloudCertificate certificate);

class CertificateListView extends StatelessWidget {
  final List<DatabaseCertificate> certificates;
  // final Iterable<CloudCertificate> certificates;
  final CertificateCallBack onDeleteCertificate;
  final CertificateCallBack onTap;

  const CertificateListView({
    Key? key,
    required this.certificates,
    required this.onDeleteCertificate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final certificate = certificates[index];
        // final certificate = certificates.elementAt(index);
        return Card(
          color: certificates[index].isValidated
              ? const Color.fromARGB(139, 152, 255, 233)
              : const Color.fromARGB(138, 255, 56, 30),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              certificate.name,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            const SizedBox(width: 5),
                            _getStatusTag(certificate.isValidated),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _getIssueTimeTag(context, certificate.issueTime),
                              Text(
                                'Number of Dose: ${certificate.numDose}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.qr_code_rounded,
                      color: Colors.indigoAccent,
                      size: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getStatusTag(bool isValidated) {
    final statusTag = isValidated ? 'Validated' : 'Pending';
    final decorateBoxColor = isValidated
        ? const Color.fromARGB(255, 83, 109, 254)
        : const Color.fromARGB(134, 158, 158, 158);
    return Container(
      alignment: Alignment.center,
      width: 62,
      height: 22,
      child: Text(
        statusTag,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      decoration: BoxDecoration(
        color: decorateBoxColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

Widget _getIssueTimeTag(BuildContext context, String issueTime) {
  return Text(
    DateFormat(formatDateTime)
        .format(DateFormat(formatDatabaseDateTime).parse(issueTime)),
    style: Theme.of(context).textTheme.bodyText1,
  );
}
