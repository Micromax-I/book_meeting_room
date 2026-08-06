import 'dart:convert';
import 'dart:ui';

import 'package:book_meeting_room/screens/login/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/employee_response.dart';
import '../model/version_response.dart';
import '../network/api_service_new.dart';
import '../util/alert.dart';
import '../util/preference_helper.dart';
import '../util/update_manager.dart';
import '../widget/ui_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userName = TextEditingController();
  var password = TextEditingController();
  bool isLoading = false;
  var versionName = "";
  var versionCode = "";

  final formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool isPasswordVisible = false;

  bool rememberMe = false;
  final prefs = PreferenceHelper();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _getVersion();
  }

  Future<void> _loadSavedData() async {
    final remember = await prefs.getBool('rememberMe') ?? false;
    final uN = await prefs.getString('userName') ?? '';
    final pass = await prefs.getString('password') ?? '';
    setState(() {
      if (remember) {
        userName.text = uN;
        password.text = pass;
        rememberMe = remember;
      }
    });
  }

  void verifyUser() {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // hide keyboard
      setState(() => isLoading = true);
      var userId = base64Encode(utf8.encode(userName.text.trim()));
      var pass = base64Encode(utf8.encode(password.text.trim()));

      final body = {'UserName': userId, 'Password': pass};
      print('Body-->$body');

      ApiServiceNew.get(
        endpoint:
            '/Employee/GetEmpDetail?userid=$userId&pass=$pass&IMEI1=&IMEI2=',
        fromJson: (json) => EmployeeResponse.fromJson(json),
        onSuccess: (response) {
          setState(() => isLoading = false);

          if (response.Ecode == null || response.Ecode == "") {
            UiHelper.showErrorDialog(context, 'User id or password invalid');
          } else {
            prefs.setString('password_check', password.text);
            if (rememberMe) {
              prefs.setBool('rememberMe', true);
              prefs.setString('userName', userName.text);
              prefs.setString('password', password.text);
            } else {
              prefs.remove('rememberMe');
              prefs.remove('userName');
              prefs.remove('password');
              // await prefs.clear(); // or remove specific keys
            }
            // if (response.Data == null) {
            //   UiHelper.showErrorDialog(context, 'User Data is null.');
            // } else {
            prefs.setString('userName', userName.text);
            prefs.setString('userId', userName.text);
            prefs.setString('name', response.Name!);
            prefs.setInt('CabAccess', response.Cabaccess!);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(isAdmin: response.Cabaccess!),
              ),
              (route) => false,
            );
            // }
          }
        },
        onError: (error) {
          setState(() => isLoading = false);
          UiHelper.showErrorDialog(context, error);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  if (value!.isEmpty) {
                                    return "Enter Employee ID";
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

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
                                  if (value!.isEmpty) {
                                    return "Enter Password";
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: Colors.blue,

                                    value: rememberMe,

                                    onChanged: (v) {
                                      setState(() {
                                        rememberMe = v!;
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

                                  /*  TextButton(
                                    onPressed: () {},

                                    child: const Text("Forgot Password?"),
                                  ),*/
                                ],
                              ),

                              const SizedBox(height: 20),

                              isLoading
                                  ? const CircularProgressIndicator()
                                  : Container(
                                    width: double.infinity,

                                    height: 55,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),

                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff1565C0),

                                          Color(0xff42A5F5),
                                        ],
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
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                      ),

                                      onPressed: verifyUser,

                                      icon: const Icon(
                                        Icons.login,

                                        color: Colors.white,
                                      ),

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
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                 /*   const Icon(
                      Icons.local_taxi,

                      color: Color(0xff1565C0),

                      size: 35,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Safe • Fast • Reliable",

                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getVersion() async {
    versionCode = (await UiHelper.getVersion()) as String;
    versionName = await UiHelper.getVersionName();
    setState(() {
      checkVersion(versionCode, versionName);
    });
  }

  void checkVersion(String versionCode, String versionName) {
    FocusScope.of(context).unfocus(); // hide keyboard
    setState(() => isLoading = true);

    // print('versionCode-->$versionCode-->versionName-->$versionName');

    ApiServiceNew.get(
      endpoint:
          '/Account/GetAppVersion?VC=$versionCode&VN=$versionName&AppID=Contract',
      fromJson: (json) => VersionResponse.fromJson(json),
      onSuccess: (response) {
        setState(() => isLoading = false);

        if (response.Message != null && response.Message == 'Failure') {
          if (response.ESSPath == null || response.ESSPath!.isEmpty) {
            showAlertDialog(
              context: context,
              message: 'app path not found.Unable to update app',
              onOk: () {
                SystemNavigator.pop();
              },
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateDialog(apkUrl: response.ESSPath!),
              ),
              (route) => false,
            );
          }
        }
      },
      onError: (error) {
        setState(() => isLoading = false);
        showAlertDialog(
          context: context,
          message: error,
          onOk: () {
            SystemNavigator.pop();
          },
        );
      },
    );
  }
}
