import 'package:flutter/material.dart';
import 'package:vaxpass/utils/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyCertDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty certificate!',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
