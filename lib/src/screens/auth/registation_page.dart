import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _mobile = '';
  String _pin = '';

  Future<void> _save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Trigger onSaved for all fields
      final url = Uri.parse('YOUR_REGISTRATION_API_ENDPOINT');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': _name, 'mobile': _mobile, 'pin': _pin}),
        );

        final data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['success']) {
          await _save('userDetails', jsonEncode(data['result']));
          Get.offNamed('/home');
        } else {
          _showError(data['message'] ?? 'Registration failed');
        }
      } catch (e) {
        _showError('Network error');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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
                validator:
                    (value) => value!.isEmpty ? 'Please enter your name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                ),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your mobile' : null,
                onSaved: (value) => _mobile = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Territory Code',
                  hintText: 'Enter your code',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? 'Please enter your code' : null,
                onSaved: (value) => _pin = value!,
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
