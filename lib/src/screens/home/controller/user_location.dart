import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mumin/src/screens/home/controller/model/user_location_data.dart';

class UserLocationController extends GetxController {
  Rx<UserLocationData?> locationData = Rx<UserLocationData?>(null);
  @override
  void onInit() {
    final userLocation =
        Hive.box('user_db').get('user_location', defaultValue: null);
    if (userLocation != null) {
      locationData.value = UserLocationData.fromJson(userLocation);
    }
    super.onInit();
  }
}
