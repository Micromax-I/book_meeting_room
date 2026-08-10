import 'package:book_meeting_room/widget/ui_helper.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../login/view/login_screen.dart';

class SplashScreenNew extends StatefulWidget {
  const SplashScreenNew({super.key});

  @override
  State<SplashScreenNew> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenNew>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5, // Start small
      end: 1.2, // End bigger
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Navigate only AFTER animation completes
    _controller.forward().whenComplete(() {
      gotoLoginScreen();
    });
  }

  void gotoLoginScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              // SizedBox(height: 100),
              Expanded(
                flex: 5,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: UiHelper.CustomImage(img: 'logo_bg.png'),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
