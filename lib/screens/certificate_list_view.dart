import 'package:flutter/material.dart';
import 'package:vaxpass/services/cloud/cloud_certificate.dart';

import '../utils/dialogs/delete_dialog.dart';

// typedef CertificateCallBack = void Function(DatabaseCertificate certificate);
typedef CertificateCallBack = void Function(CloudCertificate certificate);

class CertificateListView extends StatelessWidget {
  // final List<DatabaseCertificate> certificates;
  final Iterable<CloudCertificate> certificates;
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
        // final certificate = certificates[index];
        final certificate = certificates.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(certificate);
          },
          title: Text(
            certificate.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteCertificate(certificate);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
