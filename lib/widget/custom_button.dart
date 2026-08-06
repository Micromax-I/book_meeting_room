import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final String? fontFamily;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.fontSize = 10,
    this.textColor = AppColor.primary_color,
    this.fontWeight = FontWeight.normal,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    this.borderRadius = 10.0,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          side: const BorderSide(color: AppColor.primary_color, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }
}
