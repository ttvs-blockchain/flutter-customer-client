import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';

import '../models/models.dart';

// typedef CertificateCallBack = void Function(DatabaseCertificate certificate);
// typedef CertificateCallBack = void Function(CloudCertificate certificate);

class CertificateListView extends StatelessWidget {
  final List<DatabaseCertificate> certificates;
  // final Iterable<CloudCertificate> certificates;

  const CertificateListView({
    Key? key,
    required this.certificates,
  }) : super(key: key);

  void _createQRCodeView(
      BuildContext context, DatabaseCertificate certificate) {
    Navigator.of(context).pushNamed(
      certificateQRCodeViewRoute,
      arguments: certificate,
    );
  }

  void _onTap(BuildContext context, DatabaseCertificate certificate) {
    Navigator.of(context).pushNamed(
      certificateDetailViewRoute,
      arguments: certificate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final certificate = certificates[index];
        // final certificate = certificates.elementAt(index);
        return GestureDetector(
          onTap: () => _onTap(context, certificate),
          child: Card(
            color: certificates[index].isValidated
                ? const Color.fromARGB(139, 152, 255, 233)
                : const Color.fromARGB(138, 255, 56, 30),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
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
                              const SizedBox(width: 4),
                              _getStatusTag(certificate.isValidated),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _getIssueTimeTag(
                                    context, certificate.issueTime),
                                Text(
                                  'Number of Dose: ${certificate.numDose}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          _createQRCodeView(context, certificate);
                        },
                        icon: const Icon(
                          Icons.qr_code_rounded,
                          color: Colors.indigoAccent,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
