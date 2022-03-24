import 'dart:async';
import 'dart:developer';
import 'dart:developer' show log;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'screens/error_page.dart';

Future<void> main() async {
  GestureBinding.instance?.resamplingEnabled = true;
  runZonedGuarded(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
      return ErrorPage(
          details.exception.toString() + "\n " + details.stack.toString(),
          details);
    };
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const VaxPass());
  }, (Object obj, StackTrace stack) {
    log(obj.toString() + "\n" + stack.toString());
  });
}
