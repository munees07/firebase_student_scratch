import 'package:flutter/material.dart';

void errorMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(message, style: const TextStyle(color: Colors.white)),
    backgroundColor: Colors.redAccent,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void successMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.greenAccent,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
