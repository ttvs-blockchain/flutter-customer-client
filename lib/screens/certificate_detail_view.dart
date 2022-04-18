import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/models.dart';
import '../utils/generics/get_arguments.dart';

class CertificateDetailView extends StatelessWidget {
  const CertificateDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final certificate = context.getArgument<DatabaseCertificate>();
    if (certificate == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Certificate Details'), actions: [
        IconButton(
          onPressed: () {
            Share.share(certificate.toString());
          },
          icon: const Icon(Icons.share),
        ),
      ]),
      body: ListView(
        children: [
          listTile(
            'Name',
            certificate.name,
          ),
          listTile(
            'Certificate ID',
            certificate.certID,
          ),
          listTile(
            'Person ID',
            certificate.personID,
          ),
          listTile(
            'Brand',
            certificate.brand,
          ),
          listTile(
            'Number of Dose',
            certificate.numDose.toString(),
          ),
          listTile(
            'Issue Time',
            certificate.issueTime,
          ),
          listTile(
            'Issuer',
            certificate.issuer,
          ),
          listTile(
            'Remark',
            certificate.remark,
          ),
          listTile(
            'Status',
            certificate.isValidated ? 'Validated' : 'Pending',
          ),
          listTile(
            'Global Chain Transaction Hash',
            certificate.globalChainTxHash,
          ),
          listTile(
            'Global Chain Block Number',
            certificate.globalChainBlockNum.toString(),
          ),
          listTile(
            'Global Chain Timestamp',
            certificate.globalChainTimestamp,
          ),
          listTile(
            'Local Chain ID',
            certificate.localChainID,
          ),
          listTile(
            'Local Chain Transaction Hash',
            certificate.localChainTxHash,
          ),
          listTile(
            'Local Chain Block Number',
            certificate.localChainBlockNum.toString(),
          ),
          listTile(
            'Local Chain Timestamp',
            certificate.localChainTimeStamp,
          ),
          listTile(
            'Global Root ID',
            certificate.globalRootID,
          ),
          listTile(
            'Merkle Tree Path',
            certificate.merkleTreePath,
          ),
          listTile(
            'Merkle Tree Path Indexes',
            certificate.merkleTreeIndexes,
          )
        ],
      ),
    );
  }
}

Widget listTile(String title, String subtitle) {
  return ListTile(
    title: Text(title),
    subtitle: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(subtitle),
    ),
  );
}
