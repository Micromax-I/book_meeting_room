import 'package:flutter/material.dart';

class RememberMe extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RememberMe({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: Colors.blue,
          value: value,
          onChanged: (value) {
            onChanged(value ?? false);
          },
        ),

        const Text(
          'Remember Me',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        const Spacer(),
      ],
    );
  }
}
