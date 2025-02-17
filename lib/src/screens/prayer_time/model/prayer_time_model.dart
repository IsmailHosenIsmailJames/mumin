import 'dart:convert';

import 'package:flutter/material.dart';

class PrayerTimeModel {
  final String dateFor;
  final String fajr;
  final String shurooq;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimeModel({
    required this.dateFor,
    required this.fajr,
    required this.shurooq,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  PrayerTimeModel copyWith({
    String? dateFor,
    String? fajr,
    String? shurooq,
    String? dhuhr,
    String? asr,
    String? maghrib,
    String? isha,
  }) =>
      PrayerTimeModel(
        dateFor: dateFor ?? this.dateFor,
        fajr: fajr ?? this.fajr,
        shurooq: shurooq ?? this.shurooq,
        dhuhr: dhuhr ?? this.dhuhr,
        asr: asr ?? this.asr,
        maghrib: maghrib ?? this.maghrib,
        isha: isha ?? this.isha,
      );

  factory PrayerTimeModel.fromJson(String str) =>
      PrayerTimeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrayerTimeModel.fromMap(Map<String, dynamic> json) => PrayerTimeModel(
        dateFor: json['date_for'],
        fajr: json['fajr'],
        shurooq: json['shurooq'],
        dhuhr: json['dhuhr'],
        asr: json['asr'],
        maghrib: json['maghrib'],
        isha: json['isha'],
      );

  Map<String, dynamic> toMap() => {
        'date_for': dateFor,
        'fajr': fajr,
        'shurooq': shurooq,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };
}

class SinglePrayerTime {
  String name;
  TimeOfDay timeOfDay;
  SinglePrayerTime({
    required this.name,
    required this.timeOfDay,
  });
}
