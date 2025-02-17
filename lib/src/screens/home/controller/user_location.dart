import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

class UserLocationData {
  double latitude;
  double longitude;
  String division;
  String district;

  UserLocationData({
    required this.latitude,
    required this.longitude,
    required this.division,
    required this.district,
  });

  UserLocationData copyWith({
    double? latitude,
    double? longitude,
    String? division,
    String? district,
  }) =>
      UserLocationData(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        division: division ?? this.division,
        district: district ?? this.district,
      );

  factory UserLocationData.fromJson(String str) =>
      UserLocationData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserLocationData.fromMap(Map<String, dynamic> json) =>
      UserLocationData(
        latitude: json['latitude'],
        longitude: json['longitude'],
        division: json['division'],
        district: json['district'],
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'division': division,
        'district': district,
      };
}
