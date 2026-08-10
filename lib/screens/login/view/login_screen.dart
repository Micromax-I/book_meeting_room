import 'dart:ui';

import 'package:book_meeting_room/screens/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../util/alert.dart';
import '../../../util/update_manager.dart';
import '../../../widget/ui_helper.dart';
import '../viewmodel/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userName = TextEditingController();
  final password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool rememberMe = false;

  String versionName = '';
  String versionCode = '';

  @override
  void initState() {
    super.initState();

    _loadSavedData();
    _getVersion();
  }

  @override
  void dispose() {
    userName.dispose();
    password.dispose();

    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final vm = context.read<LoginViewModel>();

    final savedData = await vm.loadSavedData();

    if (!mounted) return;

    setState(() {
      rememberMe = savedData.rememberMe;

      if (savedData.rememberMe) {
        userName.text = savedData.userName;

        password.text = savedData.password;
      }
    });
  }

  Future<void> verifyUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final vm = context.read<LoginViewModel>();

    final success = await vm.authenticateUser(
      userName: userName.text.trim(),
      password: password.text.trim(),
      rememberMe: rememberMe,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      UiHelper.showErrorDialog(context, vm.errorMessage);
    }
  }

  Future<void> _getVersion() async {
    final versionCode = (await UiHelper.getVersion()).toString();

    final versionName = await UiHelper.getVersionName();

    if (!mounted) return;

    final vm = context.read<LoginViewModel>();

    await vm.checkVersion(versionCode, versionName);

    if (!mounted) return;

    final response = vm.versionResponse;

    if (response == null) {
      return;
    }

    if (response.Message == 'Failure') {
      if (response.ESSPath == null || response.ESSPath!.isEmpty) {
        showAlertDialog(
          context: context,
          message: 'App path not found. Unable to update app',
          onOk: () {
            SystemNavigator.pop();
          },
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,

          MaterialPageRoute(
            builder: (_) => UpdateDialog(apkUrl: response.ESSPath!),
          ),

          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffE3F2FD), Colors.white, Color(0xffF5F9FF)],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),

              child: Form(
                key: formKey,

                child: Column(
                  children: [
                    // ------------------------------------------------
                    // LOGO
                    // ------------------------------------------------
                    Hero(
                      tag: "logo",

                      child: Image.asset(
                        "assets/images/logo_bg.png",
                        height: 160,
                      ),
                    ),

                    const SizedBox(height: 10),

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

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Login to continue your booking",

                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),

                    const SizedBox(height: 30),

                    // ------------------------------------------------
                    // LOGIN CARD
                    // ------------------------------------------------
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                        child: Container(
                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.75),

                            borderRadius: BorderRadius.circular(25),

                            border: Border.all(color: Colors.white),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),

                          child: Column(
                            children: [
                              // --------------------------------------
                              // USERNAME
                              // --------------------------------------
                              TextFormField(
                                controller: userName,

                                decoration: InputDecoration(
                                  hintText: "Employee ID",

                                  prefixIcon: const Icon(Icons.person),

                                  filled: true,

                                  fillColor: Colors.white,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter Employee ID";
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // --------------------------------------
                              // PASSWORD
                              // --------------------------------------
                              TextFormField(
                                controller: password,

                                obscureText: !isPasswordVisible,

                                decoration: InputDecoration(
                                  hintText: "Password",

                                  prefixIcon: const Icon(Icons.lock),

                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),

                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                  ),

                                  filled: true,

                                  fillColor: Colors.white,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter Password";
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 10),

                              // --------------------------------------
                              // REMEMBER ME
                              // --------------------------------------
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: Colors.blue,

                                    value: rememberMe,

                                    onChanged: (value) {
                                      setState(() {
                                        rememberMe = value ?? false;
                                      });
                                    },
                                  ),

                                  const Text(
                                    "Remember Me",

                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const Spacer(),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // --------------------------------------
                              // LOGIN BUTTON
                              // --------------------------------------
                              vm.isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : _buildLoginButton(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // LOGIN BUTTON
  // ----------------------------------------------------------

  Widget _buildLoginButton() {
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

        onPressed: verifyUser,

        icon: const Icon(Icons.login, color: Colors.white),

        label: const Text(
          "LOGIN",

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
