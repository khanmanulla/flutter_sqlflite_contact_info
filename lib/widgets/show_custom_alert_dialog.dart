import 'package:flutter/material.dart';

Future<bool?> showCustomAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmButtonText,
  String? cancelButtonText,
  Color? confirmButtonColor,
  Color? cancelButtonColor,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          if (cancelButtonText != null)
            TextButton(
              style: TextButton.styleFrom(backgroundColor: cancelButtonColor ?? Colors.grey),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelButtonText, style: const TextStyle(color: Colors.white)),
            ),
          if (confirmButtonText != null)
            TextButton(
              style: TextButton.styleFrom(backgroundColor: confirmButtonColor ?? Colors.blue),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmButtonText, style: const TextStyle(color: Colors.white)),
            ),
        ],
      );
    },
  );
}
