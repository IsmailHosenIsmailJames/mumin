import 'dart:convert';

class QuranSurahInfoModel {
  final int id;
  final String revelationPlace;
  final int revelationOrder;
  final bool bismillahPre;
  final String nameSimple;
  final String nameArabic;
  final int versesCount;
  final List<int> pages;

  QuranSurahInfoModel({
    required this.id,
    required this.revelationPlace,
    required this.revelationOrder,
    required this.bismillahPre,
    required this.nameSimple,
    required this.nameArabic,
    required this.versesCount,
    required this.pages,
  });

  QuranSurahInfoModel copyWith({
    int? id,
    String? revelationPlace,
    int? revelationOrder,
    bool? bismillahPre,
    String? nameSimple,
    String? nameArabic,
    int? versesCount,
    List<int>? pages,
  }) => QuranSurahInfoModel(
    id: id ?? this.id,
    revelationPlace: revelationPlace ?? this.revelationPlace,
    revelationOrder: revelationOrder ?? this.revelationOrder,
    bismillahPre: bismillahPre ?? this.bismillahPre,
    nameSimple: nameSimple ?? this.nameSimple,
    nameArabic: nameArabic ?? this.nameArabic,
    versesCount: versesCount ?? this.versesCount,
    pages: pages ?? this.pages,
  );

  factory QuranSurahInfoModel.fromJson(String str) =>
      QuranSurahInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuranSurahInfoModel.fromMap(Map<String, dynamic> json) =>
      QuranSurahInfoModel(
        id: json['id'],
        revelationPlace: json['revelation_place'],
        revelationOrder: json['revelation_order'],
        bismillahPre: json['bismillah_pre'],
        nameSimple: json['name_simple'],
        nameArabic: json['name_arabic'],
        versesCount: json['verses_count'],
        pages: List<int>.from(json['pages'].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'revelation_place': revelationPlace,
    'revelation_order': revelationOrder,
    'bismillah_pre': bismillahPre,
    'name_simple': nameSimple,
    'name_arabic': nameArabic,
    'verses_count': versesCount,
    'pages': List<dynamic>.from(pages.map((x) => x)),
  };
}
