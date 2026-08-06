import 'package:flutter/material.dart';

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(child: CircularProgressIndicator()),
  );
}

void hideLoader(BuildContext context) {
  Navigator.pop(context);
}