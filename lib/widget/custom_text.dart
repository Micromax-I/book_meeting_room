import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final TextAlign textAlign;
  final Alignment alignment;
  final double left;
  final double right;
  final double top;
  final double bottom;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 10,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.alignment = Alignment.center,
    this.textDecoration = TextDecoration.none,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            decoration: textDecoration,
          ),
          textAlign: textAlign,
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }
}
