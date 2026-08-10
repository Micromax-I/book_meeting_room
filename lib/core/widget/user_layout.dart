import 'package:flutter/material.dart';

class UserLayout extends StatelessWidget {
  final String userName;

  const UserLayout({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              'Hello ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textScaler: TextScaler.noScaling,
            ),
            Text(
              userName,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              textScaler: TextScaler.noScaling,
            ),
          ],
        ),
      ),
    );
  }
}
