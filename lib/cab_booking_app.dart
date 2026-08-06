import 'package:book_meeting_room/screens/login_screen.dart';
import 'package:book_meeting_room/screens/splash_screen_new.dart';
import 'package:flutter/material.dart';



class CabBookingApp extends StatefulWidget {
  const CabBookingApp({super.key});

  @override
  State<CabBookingApp> createState() => _CabBookingAppState();
}

class _CabBookingAppState extends State<CabBookingApp> {
  void _onSplashCompleted() {
    setState(() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenNew();
  }
}
