import 'dart:convert';

class RamadanDayModel {
  final DateTime date;
  final String seharStart;
  final String seharEnd;
  final String ifter;

  RamadanDayModel({
    required this.date,
    required this.seharStart,
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
        seharStart: seharStart ?? this.seharStart,
        seharEnd: seharEnd ?? this.seharEnd,
        ifter: ifter ?? this.ifter,
      );

  factory RamadanDayModel.fromJson(String str) =>
      RamadanDayModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RamadanDayModel.fromMap(Map<String, dynamic> json) => RamadanDayModel(
        date: DateTime.parse(json["date"]),
        seharStart: json["sehar_start"],
        seharEnd: json["sehar_end"],
        ifter: json["ifter"],
      );

  Map<String, dynamic> toMap() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "sehar_start": seharStart,
        "sehar_end": seharEnd,
        "ifter": ifter,
      };
}
