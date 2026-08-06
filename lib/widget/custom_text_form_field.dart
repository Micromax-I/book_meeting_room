import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';


class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final int minLines;
  final bool readOnly;
  final int? maxLength;
  final bool allCaps;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.allCaps = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
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
      inputFormatters: allCaps ? [UpperCaseTextFormatter()] : [],
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        prefixIconColor: AppColor.primary_color,
        suffixIcon: suffixIcon != null ? IconButton(
          icon: Icon(suffixIcon),
          color: AppColor.primary_color,
          onPressed: onSuffixIconPressed, // Pass the callback here
        ) : null,
        suffixIconColor: AppColor.primary_color,
        labelText: hintText,
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
