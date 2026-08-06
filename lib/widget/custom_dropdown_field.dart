import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String hintText;
  final T? selectedValue;
  final List<T> itemList;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String Function(T) itemLabelBuilder;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.selectedValue,
    required this.itemList,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary_color),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: DropdownButtonFormField<T>(
        hint: Text(hintText),
        iconEnabledColor:AppColor.primary_color,
        validator: validator,
        style: const TextStyle(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
        dropdownColor: Colors.white,
        isExpanded: true,
        value:
            (selectedValue != null && itemList.contains(selectedValue))
                ? selectedValue
                : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        items:
            itemList
                .map(
                  (T value) => DropdownMenuItem<T>(
                    value: value,
                    child: Text(itemLabelBuilder(value)),
                  ),
                )
                .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
