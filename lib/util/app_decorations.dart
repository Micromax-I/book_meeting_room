import 'package:flutter/material.dart';

class AppDecorations {
  static final BoxDecoration shadowGradientBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFFFFF), // startColor
        Color(0xFFE1E1E1), // centerColor
        Color(0xFFC9C9C9), // endColor
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x50A6A6A6), // shadow 1
        offset: Offset(0, 2),
        blurRadius: 3,
      ),
      BoxShadow(
        color: Color(0x60A6A6A6), // shadow 2
        offset: Offset(1, 3),
        blurRadius: 4,
      ),
      BoxShadow(
        color: Color(0x70A6A6A6), // shadow 3
        offset: Offset(2, 4),
        blurRadius: 5,
      ),
    ],
    borderRadius: BorderRadius.circular(8),
  );
}
