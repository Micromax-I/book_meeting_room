import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Meeting Room Booking",

          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xff1565C0),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          "Welcome Back 👋",

          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        const Text(
          "Login to continue your booking",

          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ],
    );
  }
}
