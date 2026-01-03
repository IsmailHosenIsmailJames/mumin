import "dart:convert";

import "package:mumin/src/core/utils/one_placemart_from_multi.dart";

class UserLocationData {
  double latitude;
  double longitude;
  AppPlacemark? placemark;

  UserLocationData({
    required this.latitude,
    required this.longitude,
    this.placemark,
  });

  UserLocationData copyWith({
    double? latitude,
    double? longitude,
    AppPlacemark? placemark,
  }) =>
      UserLocationData(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        placemark: placemark ?? this.placemark,
      );

  factory UserLocationData.fromJson(String str) =>
      UserLocationData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserLocationData.fromMap(Map<String, dynamic> json) =>
      UserLocationData(
        latitude: json["latitude"],
        longitude: json["longitude"],
        placemark: json["placemark"] != null
            ? AppPlacemark.fromJson(json["placemark"])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "latitude": latitude,
        "longitude": longitude,
        "placemark": placemark?.toJson(),
      };
}
