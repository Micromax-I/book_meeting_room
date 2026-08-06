import 'package:flutter/material.dart';

import 'custom_button.dart';

class BottomButton extends StatelessWidget {
  final bool displayText;
  final String text;
  final VoidCallback onTextTap;
  final VoidCallback onPreviousTap;
  final VoidCallback onNextTap;

  const BottomButton({
    super.key,
    required this.displayText,
    required this.text,
    required this.onTextTap,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 0, right: 20, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (displayText) TextButton(onPressed: onTextTap, child: Text(text)),
          CustomButton(text: 'Previous', onPressed: onPreviousTap),
          CustomButton(text: 'Next', onPressed: onNextTap),
        ],
      ),
    );
  }
}
