import 'dart:ui';

import 'package:book_meeting_room/core/widget/button_ui.dart';
import 'package:book_meeting_room/screens/home/view/home_page.dart';
import 'package:book_meeting_room/screens/login/widget/welcome_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/widget/logo_ui.dart';
import '../../../util/alert.dart';
import '../../../util/update_manager.dart';
import '../../../widget/ui_helper.dart';
import '../viewmodel/login_view_model.dart';
import '../widget/app_text_field.dart';
import '../widget/remember_me.dart';

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
                    LogoUi(),

                    const SizedBox(height: 10),

                    WelcomeText(),

                    const SizedBox(height: 30),

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
                              AppTextField(
                                controller: userName,
                                hintText: 'Employee ID',
                                prefixIcon: Icons.person,
                                validatorMessage: 'Enter Employee ID',
                              ),

                              const SizedBox(height: 20),

                              AppTextField(
                                controller: password,
                                hintText: 'Password',
                                prefixIcon: Icons.lock,
                                validatorMessage: 'Enter Password',
                                obscureText: !isPasswordVisible,
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
                              ),

                              const SizedBox(height: 10),

                              RememberMe(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 20),

                              vm.isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : ButtonUi(
                                    icon: Icons.login,
                                    title: 'LOGIN',
                                    onPressed: () {
                                      verifyUser();
                                    },
                                  ),
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
}
