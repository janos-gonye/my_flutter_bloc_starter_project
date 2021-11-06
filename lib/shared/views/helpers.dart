import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showSnackbar(BuildContext context, String text,
    {bool removeCurrent = true}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  if (removeCurrent) scaffoldMessenger.removeCurrentSnackBar();
  scaffoldMessenger.showSnackBar(SnackBar(content: Text(text)));
}
