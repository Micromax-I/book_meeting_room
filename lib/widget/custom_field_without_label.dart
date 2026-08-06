import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';


class CustomFieldWithoutLabel extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final int? maxLength;
  final bool allCaps;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool isEnabled;

  const CustomFieldWithoutLabel({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines,
    this.minLines ,
    this.maxLength,
    this.readOnly = false,
    this.allCaps = false,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.isEnabled = true
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      minLines: minLines,
      maxLength: maxLength,
      enabled: isEnabled,
      inputFormatters: allCaps ? [UpperCaseTextFormatter()] : [],
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        prefixIconColor: AppColor.primary_color,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        suffixIconColor: AppColor.primary_color,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary_color),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary_color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary_color),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
