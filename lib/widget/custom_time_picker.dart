import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomTimePicker extends StatelessWidget {
  final String label;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final String? Function(String?)? validator;

  const CustomTimePicker({
    super.key,
    required this.label,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    required this.selectedTime,
    required this.onTimeSelected,
    this.validator,
  });

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: InkWell(
        onTap: () => _pickTime(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
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
          child: Text(
            selectedTime != null ? selectedTime!.format(context) : "",
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
