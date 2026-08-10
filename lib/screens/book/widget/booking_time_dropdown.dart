import 'package:flutter/material.dart';

import '../../../core/widget/app_input_decoration.dart';

class BookingTimeDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final String validationMessage;
  final ValueChanged<String?> onChanged;

  const BookingTimeDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.validationMessage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: AppInputDecoration.dropdown(
        hintText: hint,
      ),
      items: items.map((time) {
        return DropdownMenuItem<String>(
          value: time,
          child: Text(time),
        );
      }).toList(),
      validator: (value) {
        return value == null
            ? validationMessage
            : null;
      },
      onChanged: onChanged,
    );
  }
}