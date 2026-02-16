import "dart:convert";

import "package:intl/intl.dart";

class RamadanDayModel {
  final DateTime date;
  final String seharEnd;
  final String ifter;
  final double lat;
  final double long;

  RamadanDayModel({
    required this.date,
    required this.seharEnd,
    required this.ifter,
    required this.lat,
    required this.long,
  });

  RamadanDayModel copyWith({
    DateTime? date,
    String? seharStart,
    String? seharEnd,
    String? ifter,
    double? lat,
    double? long,
  }) =>
      RamadanDayModel(
        date: date ?? this.date,
        seharEnd: seharEnd ?? this.seharEnd,
        ifter: ifter ?? this.ifter,
        lat: lat ?? this.lat,
        long: long ?? this.long,
      );

  factory RamadanDayModel.fromJson(String str) =>
      RamadanDayModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RamadanDayModel.fromMap(Map<String, dynamic> json) => RamadanDayModel(
        date: DateFormat("dd-MM-yyyy").parse(json["date"]),
        seharEnd: json["sehar_end"],
        ifter: json["ifter"],
        lat: double.tryParse(json["lat"].toString()) ?? 0.0,
        long: double.tryParse(json["long"].toString()) ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "sehar_end": seharEnd,
        "ifter": ifter,
        "lat": lat,
        "long": long,
      };
}
