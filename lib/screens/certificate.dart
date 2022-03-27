import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vaxpass/models/models.dart';
import 'package:vaxpass/objectbox.g.dart';
import 'package:vaxpass/utils/routes/routes.dart';

class CertificateScene extends StatefulWidget {
  const CertificateScene({Key? key}) : super(key: key);

  @override
  _CertificateSceneState createState() => _CertificateSceneState();
}

class _CertificateSceneState extends State<CertificateScene>
    with AutomaticKeepAliveClientMixin<CertificateScene> {
  Store? _store;
  Box<CertificateModel>? certificateBox;
  Stream? stream;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((dir) {
      openStore(directory: dir.path).then((Store store) {
        setState(() {
          _store = store;
        });

        certificateBox = store.box<CertificateModel>();
        stream = _store?.watch<CertificateModel>();

        // TODO: clearing all the previous records to be removed
        certificateBox?.removeAll();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _store?.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: StreamBuilder<void>(
          stream: stream,
          builder: (context, AsyncSnapshot<void> snapshot) {
            List<CertificateModel>? certificates =
                certificateBox?.getAll().reversed.toList() ?? [];

            if (certificates.isEmpty) {
              // TODO: dummy data to be removed
              _putDummyCertificateData();
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return ListView.separated(
              itemBuilder: _itemBuilder(certificates),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 5,
              ),
              itemCount: certificates.length,
            );
          }),
    );
  }

  GestureDetector Function(BuildContext, int) _itemBuilder(
          List<CertificateModel> certificates) =>
      (BuildContext context, int index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              HeroDialogRoute(
                builder: (context) => const CertificateDetailCard(),
              ),
            );
          },
          child: Card(
            color: certificates[index].status != 0
                ? const Color.fromARGB(138, 255, 56, 30)
                : const Color.fromARGB(139, 152, 255, 233),
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
                            certificates[index].name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            certificates[index].status != 0
                                ? 'Pending'
                                : 'Validated',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            DateFormat('HH:MM yyyy-MMM-dd')
                                .format(certificates[index].issueDate),
                            style: Theme.of(context).textTheme.bodyText2,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "This is the summary of the certificate ",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));

  void _putDummyCertificateData() {
    final certificates = [
      CertificateModel(
        "001",
        // systemID
        "Certificate 1",
        // name
        DateTime(2021, 6, 6, 10, 30),
        // issueDate
        0,
        // status
        0,
        // type
        "0x0001",
        // globalChainTxHash
        0,
        // globalChainBlockNum
        DateTime.now(),
        // globalChainTimeStamp
        "001",
        // localChainID
        "0x0001",
        // localChainTxHash
        0,
        // localChainBlockNum
        DateTime.now(), // localChainTimeStamp
      ),
      CertificateModel(
        "002",
        // systemID
        "Certificate 2",
        // name
        DateTime(2021, 6, 27, 13, 20),
        // issueDate
        0,
        // status
        0,
        // type
        "0x0002",
        // globalChainTxHash
        0,
        // globalChainBlockNum
        DateTime.now(),
        // globalChainTimeStamp
        "001",
        // localChainID
        "0x0002",
        // localChainTxHash
        0,
        // localChainBlockNum
        DateTime.now(), // localChainTimeStamp
      ),
      CertificateModel(
        "003",
        // systemID
        "Certificate 3",
        // name
        DateTime(2022, 2, 26, 14, 05),
        // issueDate
        0,
        // status
        0,
        // type
        "0x0003",
        // globalChainTxHash
        0,
        // globalChainBlockNum
        DateTime.now(),
        // globalChainTimeStamp
        "001",
        // localChainID
        "0x0003",
        // localChainTxHash
        0,
        // localChainBlockNum
        DateTime.now(), // localChainTimeStamp
      ),
      CertificateModel(
        "004",
        // systemID
        "Certificate 4",
        // name
        DateTime.now(),
        // issueDate
        1,
        // status
        0,
        // type
        "0x0004",
        // globalChainTxHash
        0,
        // globalChainBlockNum
        DateTime.now(),
        // globalChainTimeStamp
        "001",
        // localChainID
        "0x0004",
        // localChainTxHash
        0,
        // localChainBlockNum
        DateTime.now(), // localChainTimeStamp
      ),
    ];
    certificateBox?.putMany(certificates);
  }
}

class CertificateDetailCard extends StatelessWidget {
  const CertificateDetailCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
            child: Card(
                child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ))));
  }
}
