import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:mumin/src/apis/apis.dart';
import 'package:mumin/src/screens/auth/controller/user_model.dart';

class AuthController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);
  @override
  onInit() {
    final userData = Hive.box('user_db').get('user_data', defaultValue: null);
    if (userData != null) {
      user.value = UserModel.fromJson(userData);
    }
    super.onInit();
  }

  Future<bool> login(String phone) async {
    if (!phone.startsWith('+88') || !phone.startsWith('88')) {
      phone = '88${phone.replaceAll('+', '')}';
    }
    final response = await post(
      Uri.parse(baseApi + loginApi),
      body: jsonEncode({
        'mobile_number': phone,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      log(response.body);
      if (jsonDecode(response.body)['success'] == true) {
        user.value = UserModel.fromMap(
            Map<String, dynamic>.from(jsonDecode(response.body)['result']));
        await Hive.box('user_db').put('user_data', user.value?.toJson());
        return true;
      } else {
        log('something went wrong');
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> registration(
    String fullName,
    String phone,
    String pinNumber,
  ) async {
    log(jsonEncode({
      'full_name': fullName,
      'mobile_number': phone,
      'pin_number': pinNumber,
    }));
    final response = await post(
      Uri.parse(baseApi + registrationApi),
      body: jsonEncode({
        'full_name': fullName,
        'mobile_number': phone,
        'pin_number': pinNumber,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    log(response.body);
    if (response.statusCode == 200) {
      log('Response : ${response.statusCode}');
      return await login(phone);
    } else {
      return false;
    }
  }
}
