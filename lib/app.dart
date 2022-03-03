import 'package:flutter/material.dart';

class VacPass extends StatefulWidget {
  @override
  _VacPassState createState() => _VacPassState();
}

class _VacPassState extends State<VacPass> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('VaxPass'),
      ),
      body: const Center(
        child: Text('Main Page'),
      ),
    ));
  }
}
