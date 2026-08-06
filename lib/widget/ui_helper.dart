import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UiHelper {
  static CustomImage({required String img}) {
    return Image.asset("assets/images/$img");
  }

  static CustomIcon({required String img}) {
    return ImageIcon(AssetImage("assets/icon/$img"));
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static void goToNextTab(TabController tabController) {
    if (tabController.index < tabController.length - 1) {
      tabController.animateTo(tabController.index + 1);
    }
  }

  static void goToPreviousTab(TabController tabController) {
    if (tabController.index > 0) {
      tabController.animateTo(tabController.index - 1);
    }
  }

  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static bool isValidIFSCCode(String ifsc) {
    return RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc);
  }

  static bool isValidUAN(String uan) {
    return RegExp(r'^\d{12}$').hasMatch(uan);
  }

  static bool isValidPassport(String passport) {
    return RegExp(r'^[A-Z][0-9]{7}$').hasMatch(passport);
  }

  static bool isValidPAN(String pan) {
    return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(pan);
  }

  static bool isValidPhoneNumber(String number) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(number);
  }

  static bool isValidPinCode(String pinCode) {
    return RegExp(r'^[1-9][0-9]{5}$').hasMatch(pinCode);
  }

  static bool isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

  static bool isValidAge(String dobString) {
    try {
      // Parse date exactly in yyyy-MM-dd format
      DateTime dob = DateTime.parse(dobString);

      // Get today's date (without time for strict comparison)
      DateTime today = DateTime.now();
      DateTime minDob = DateTime(today.year - 18, today.month, today.day);

      // Return true if dob is on or before minDob
      return dob.isBefore(minDob) || dob.isAtSameMomentAs(minDob);
    } catch (e) {
      return false;
    }
  }

   static Future<int> getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return int.parse(packageInfo.buildNumber);
  }

  static Future<String> getVersionName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    return packageInfo.version; // e.g. "1.0.0"
    // return packageInfo.buildNumber; // e.g. "1"
  }//
}
