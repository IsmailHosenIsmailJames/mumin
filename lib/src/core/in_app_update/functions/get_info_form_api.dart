import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import '../model/latest_app_info.dart';

Future<LatestAppInfoAPIModel> getInfoFormAPI() async {
  final response = await get(
    Uri.parse('http://128.199.87.251:2025/mumin_app/info'),
  );
  log(response.body.toString());
  log(response.statusCode.toString());
  if (response.statusCode == 200) {
    try {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(jsonDecode(response.body));
      LatestAppInfoAPIModel latestAppInfoAPIModel =
          LatestAppInfoAPIModel.fromMap(data['result']);
      return latestAppInfoAPIModel;
    } catch (e) {
      throw Exception('Failed to get latest app info');
    }
  } else {
    throw Exception('Failed to get latest app info');
  }
}
