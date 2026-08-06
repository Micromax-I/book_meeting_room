import 'package:flutter/material.dart';

class LineSeperator extends StatelessWidget {
  const LineSeperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey.shade800, // line color
    );
  }
}
