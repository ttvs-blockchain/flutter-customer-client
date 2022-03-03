import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  final String errorMessage;
  final FlutterErrorDetails errorDetails;

  const ErrorPage(this.errorMessage, this.errorDetails, {Key? key})
      : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'An error occurred',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.errorMessage,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              widget.errorDetails.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
