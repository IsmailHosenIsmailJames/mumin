import "dart:convert";
import "dart:developer";

import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:hive_flutter/adapters.dart";
import "package:http/http.dart";
import "package:mumin/src/apis/apis.dart";
import "package:mumin/src/screens/auth/controller/user_model.dart";

class AuthController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  onInit() {
    final userData = Hive.box("user_db").get("user_data", defaultValue: null);
    if (userData != null) {
      user.value = UserModel.fromJson(userData);
    }
    super.onInit();
  }

  Future<bool> login({required String phone, bool isGuest = false}) async {
    if (isGuest) {
      final user = UserModel(
        id: 999,
        fullName: "FullName",
        mobileNumber: "88017xxxxxxxx",
        pinNumber: "xxxxx",
        status: "active",
      );
      await Hive.box("user_db").put("user_data", user.toJson());
      await Hive.box("user_db").put("is_guest", true);
      return true;
    } else {
      String formattedPhone = phone.replaceAll('+', '');
      if (!formattedPhone.startsWith('88')) {
        formattedPhone = '88$formattedPhone';
      }

      final response = await post(
        Uri.parse(baseApi + loginApi),
        body: jsonEncode({
          "mobile_number": formattedPhone,
        }),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        log(response.body);
        final dynamic decodedResponse = jsonDecode(response.body);
        if (decodedResponse["success"] == true) {
          user.value = UserModel.fromMap(
              Map<String, dynamic>.from(decodedResponse["result"]));
          await Hive.box("user_db").put("user_data", user.value?.toJson());
          return true;
        } else {
          log("something went wrong: ${decodedResponse["message"]}");
          Fluttertoast.showToast(
            msg: decodedResponse["message"] ?? "Something went wrong",
            textColor: Colors.red,
          );
          return false;
        }
      } else {
        return false;
      }
    }
  }

  Future<bool> registration(
    BuildContext context,
    String fullName,
    String phone,
    String pinNumber,
  ) async {
    String formattedPhone = phone.replaceAll('+', '');
    if (!formattedPhone.startsWith('88')) {
      formattedPhone = '88$formattedPhone';
    }

    log(jsonEncode({
      "full_name": fullName,
      "mobile_number": formattedPhone,
      "pin_number": pinNumber,
    }));

    final response = await post(
      Uri.parse(baseApi + registrationApi),
      body: jsonEncode({
        "full_name": fullName,
        "mobile_number": formattedPhone,
        "pin_number": pinNumber,
      }),
      headers: {"Content-Type": "application/json"},
    );

    log(response.body);
    log(response.statusCode.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      final dynamic decodedResponse = jsonDecode(response.body);
      if (decodedResponse["success"] == true) {
        log("Registration success, logging in...");
        return await login(phone: formattedPhone);
      } else {
        Fluttertoast.showToast(
          msg: decodedResponse["message"] ?? "Registration failed",
          textColor: Colors.red,
        );
        return false;
      }
    } else {
      return false;
    }
  }
}
