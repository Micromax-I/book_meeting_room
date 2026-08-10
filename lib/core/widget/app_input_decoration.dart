import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class AppInputDecoration {
  static InputDecoration dropdown({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _errorBorder(),
      focusedErrorBorder: _errorBorder(),
    );
  }

  static OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColor.primary_color),
    );
  }

  static OutlineInputBorder _errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    );
  }
}
