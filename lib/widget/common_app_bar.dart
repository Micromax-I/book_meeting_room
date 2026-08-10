import 'package:flutter/material.dart';

import '../screens/login/view/login_screen.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final String? profileImageUrl;
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.showBack,
    this.profileImageUrl,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1565C0),
      child: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading:
            showBack
                ? IconButton(
                  icon: const Icon(Icons.arrow_back,color: Colors.white,),
                  onPressed: () => Navigator.pop(context),
                )
                : null,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: const Icon(Icons.power_settings_new, color: Colors.white),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
