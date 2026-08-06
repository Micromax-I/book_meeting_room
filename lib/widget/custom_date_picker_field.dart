import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomDatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  const CustomDatePickerField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
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
        hintText: hintText,
        suffixIcon: const Icon(Icons.calendar_month),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
      ),
    );
  }
}
