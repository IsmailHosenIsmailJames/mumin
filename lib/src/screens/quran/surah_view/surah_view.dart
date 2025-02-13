import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mumin/src/screens/quran/resources/chapters_ayah_count.dart';
import 'package:mumin/src/screens/quran/resources/model/quran_surah_info_model.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/shapes.dart';

class SurahView extends StatefulWidget {
  final int surahIndex;
  final String surahName;
  final QuranSurahInfoModel quranInfoModel;
  const SurahView({
    super.key,
    required this.surahIndex,
    required this.surahName,
    required this.quranInfoModel,
  });

  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  List<Map<String, String>> ayahsWithMeaning = [];
  @override
  void initState() {
    int startAyahIndex = 0;
    for (int i = 0; i < widget.surahIndex; i++) {
      startAyahIndex += ayahCount[i];
    }
    int endAyahIndex = startAyahIndex + ayahCount[widget.surahIndex];
    getAllAyahsMap(startAyahIndex, endAyahIndex);
    super.initState();
  }

  void getAllAyahsMap(int stat, int end) async {
    final String jsonBengali = await rootBundle.loadString(
      'assets/quran/bengali.json',
    );
    final List<String> mapBengali = List<String>.from(jsonDecode(jsonBengali));
    final String jsonEnglish = await rootBundle.loadString(
      'assets/quran/english.json',
    );
    final List<String> mapEnglish = List<String>.from(jsonDecode(jsonEnglish));
    final String jsonindopak = await rootBundle.loadString(
      'assets/quran/indopak.json',
    );
    final List<String> mapIndopak = List<String>.from(jsonDecode(jsonindopak));

    for (int i = stat; i < end; i++) {
      ayahsWithMeaning.add({
        'quran': mapIndopak.elementAt(i),
        'bn': mapBengali.elementAt(i),
        'en': mapEnglish.elementAt(i),
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.surahName)),
      body:
          ayahsWithMeaning.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: ayahsWithMeaning.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: MyAppShapes.borderRadius,
                      color: Colors.grey.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ayah: ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.play_arrow_rounded),
                          ],
                        ),
                        const Gap(5),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            ayahsWithMeaning[index]['quran']!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MyAppColors.primaryColor,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        const Divider(),
                        Text(
                          ayahsWithMeaning[index]['bn']!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                        const Divider(),
                        Text(
                          ayahsWithMeaning[index]['en']!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
