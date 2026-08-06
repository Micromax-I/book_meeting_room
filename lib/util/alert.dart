import 'package:flutter/material.dart';

/// Reusable function to show an alert dialog with title, message, and buttons.
Future<void> showAlertDialog({
  required BuildContext context,
  required String message,
  VoidCallback? onOk,
}) async {
  // Save the parent context (screen context, not dialog context)
  final parentContext = context;

  await showDialog(
    context: parentContext,
    barrierDismissible: false, // user must tap OK
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Book Cab"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // close the dialog
              if (onOk != null) {
                // run after dialog closes safely
                Future.microtask(() => onOk());
              }
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

Future<void> showAlertDialogWithOkAndCancel({
  required BuildContext context,
  required String title,
  required String message,
  String okText = "Update App",
  String cancelText = "Cancel",
  VoidCallback? onOk,
  VoidCallback? onCancel,
}) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) onCancel();
              },
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (onOk != null) onOk();
              },
              child: Text(okText),
            ),
          ],
        ),
  );
}
