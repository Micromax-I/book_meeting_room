import 'package:book_meeting_room/screens/login/view/login_screen.dart';
import 'package:book_meeting_room/screens/splash/splash_screen_new.dart';
import 'package:flutter/material.dart';

class RoomBookingApp extends StatefulWidget {
  const RoomBookingApp({super.key});

  @override
  State<RoomBookingApp> createState() => _CabBookingAppState();
}

class _CabBookingAppState extends State<RoomBookingApp> {
  void _onSplashCompleted() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenNew();
  }
}
