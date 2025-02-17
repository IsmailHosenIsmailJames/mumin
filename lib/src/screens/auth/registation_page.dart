import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mumin/src/screens/auth/controller/auth_controller.dart';

import 'package:toastification/toastification.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _pin = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final res = await authController.registration(
          _name.text.trim(), _mobile.text.trim(), _pin.text.trim());
      if (res) {
        Get.offNamed('/home');
      } else {
        toastification.show(
          context: context,
          title: const Text('Unable to register'),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/images/mumin_logo.png'),
                ),
              ),
              const Center(child: Text('Sign up for new users')),
              const Gap(15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your name',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
                controller: _name,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your mobile' : null,
                controller: _mobile,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Territory Code',
                  hintText: 'Enter your code',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your code' : null,
                controller: _pin,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _register,
                  child: const Text('Sign Up'),
                ),
              ),
              const Gap(15),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.offNamed('/login');
                  },
                  child: const Text('Already Registered? Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
