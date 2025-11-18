import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:mumin/src/apis/apis.dart';
import 'package:mumin/src/screens/auth/controller/user_model.dart';
import 'package:toastification/toastification.dart';

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
    // final response = await post(
    //   Uri.parse(baseApi + loginApi),
    //   body: jsonEncode({
    //     'mobile_number': phone,
    //   }),
    //   headers: {'Content-Type': 'application/json'},
    // );
    // if (response.statusCode == 200) {
    //   log(response.body);
    //   if (jsonDecode(response.body)['success'] == true) {
    //     user.value = UserModel.fromMap(
    //         Map<String, dynamic>.from(jsonDecode(response.body)['result']));
    //     await Hive.box('user_db').put('user_data', user.value?.toJson());
    //     return true;
    //   } else {
    //     log('something went wrong');
    //     return false;
    //   }

    // else {
    // return false;
    // }
    final user = UserModel(
      id: 999,
      fullName: 'FullName',
      mobileNumber: '8801741095333',
      pinNumber: '9999',
      status: 'active',
    );
    await Hive.box('user_db').put('user_data', user.toJson());
    return true;
  }

  Future<bool> registration(
    BuildContext context,
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
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        log('Response : ${response.statusCode}');
        return await login(phone);
      } else {
        toastification.show(
          context: context,
          title: Text(jsonDecode(response.body)['message'] ?? ''),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 4),
        );
        return false;
      }
    } else {
      return false;
    }
  }
}
