import 'dart:convert';

import 'package:intl/intl.dart';

class RamadanDayModel {
  final DateTime date;
  final String seharEnd;
  final String ifter;

  RamadanDayModel({
    required this.date,
    required this.seharEnd,
    required this.ifter,
  });

  RamadanDayModel copyWith({
    DateTime? date,
    String? seharStart,
    String? seharEnd,
    String? ifter,
  }) =>
      RamadanDayModel(
        date: date ?? this.date,
        seharEnd: seharEnd ?? this.seharEnd,
        ifter: ifter ?? this.ifter,
      );

  factory RamadanDayModel.fromJson(String str) =>
      RamadanDayModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RamadanDayModel.fromMap(Map<String, dynamic> json) => RamadanDayModel(
        date: DateFormat("yyyy/MM/dd").parse(json["date"]),
        seharEnd: json["sehar_end"],
        ifter: json["ifter"],
      );

  Map<String, dynamic> toMap() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "sehar_end": seharEnd,
        "ifter": ifter,
      };
}
