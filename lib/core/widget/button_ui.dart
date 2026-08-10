import 'package:flutter/material.dart';

class ButtonUi extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onPressed;

  const ButtonUi({
    super.key,
    required this.icon,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: const LinearGradient(
          colors: [Color(0xff1565C0), Color(0xff42A5F5)],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(.35),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,

          shadowColor: Colors.transparent,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        onPressed: onPressed,

        icon: Icon(icon, color: Colors.white),

        label: Text(
          title,

          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
