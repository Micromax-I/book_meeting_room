import 'package:flutter/cupertino.dart';

class LogoUi extends StatelessWidget {
  const LogoUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "logo",
      child: Image.asset("assets/images/logo_bg.png", height: 160),
    );
  }
}
