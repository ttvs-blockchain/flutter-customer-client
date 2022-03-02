import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'package:vacpass/main.dart';
import 'package:vacpass/models/models.dart';
import 'package:vacpass/utils/route.dart';

class CertificateScene extends StatefulWidget {
  const CertificateScene({Key? key}) : super(key: key);

  @override
  _CertificateSceneState createState() => _CertificateSceneState();
}

class _CertificateSceneState extends State<CertificateScene> {
  // final StreamController<List<CertificateModel>> _listController =
  //     BehaviorSubject();
  final _listController = BehaviorSubject<List<CertificateModel>>();

  @override
  void initState() {
    super.initState();

    setState(() {});

    _listController
        .addStream(objectBox.certificateModelStream.map((q) => q.find()));
  }

  @override
  void dispose() {
    _listController.drain();
    _listController.close();
    super.dispose();
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
                          const Text(
                            "Label 0",
                            style: TextStyle(
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
                        "This is the summary of the certificate",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
          child: StreamBuilder<List<CertificateModel>>(
              stream: _listController.stream,
              builder: (context, snapshot) => ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: _itemBuilder(snapshot.data ?? []))))
    ]);
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
