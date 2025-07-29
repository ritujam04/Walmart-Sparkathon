import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message, {
  bool success = false,
}) {
  final color = success ? Colors.green : Colors.red;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
