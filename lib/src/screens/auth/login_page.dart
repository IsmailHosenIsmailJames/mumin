import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mumin/src/screens/auth/controller/auth_controller.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/shapes.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String mobile = '';
  String code = '';

  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/Splash.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: MyAppShapes.borderRadius,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/mumin_logo.png',
                            width: MediaQuery.of(context).size.width * 0.5,
                            fit: BoxFit.contain,
                          ),
                          const Gap(10),
                          const Text(
                            'Just enter your phone number to log in your account',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(10),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: MyAppShapes.borderRadius,
                                borderSide: BorderSide(
                                  color: MyAppColors.backgroundDarkColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: MyAppShapes.borderRadius,
                                borderSide: BorderSide(
                                  color: MyAppColors.backgroundDarkColor,
                                ),
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {
                                mobile = text;
                              });
                            },
                          ),
                          const Gap(20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: MyAppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              minimumSize: const Size(double.infinity, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: MyAppShapes.borderRadius,
                              ),
                            ),
                            onPressed: () async {
                              if (mobile.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Validation'),
                                      content: const Text(
                                        'Please enter your mobile number',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                final bool isSuccessful =
                                    await authController.login(mobile);
                                if (isSuccessful) {
                                  Get.offNamed('/home');
                                } else {
                                  toastification.show(
                                    context: context,
                                    title: const Text('Unable to login'),
                                    type: ToastificationType.error,
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Login',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          const Gap(15),
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.offNamed('/registration');
                            },
                            child: Text(
                              'Register Now',
                              style: TextStyle(
                                fontSize: 16,
                                color: MyAppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
