import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:mumin/src/screens/quran/resources/chapters.dart';
import 'package:mumin/src/screens/quran/resources/model/quran_surah_info_model.dart';
import 'package:mumin/src/screens/quran/resources/surah_meaning.dart';
import 'package:mumin/src/screens/quran/surah_view/surah_view.dart';
import 'package:mumin/src/theme/shapes.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Holy Quran')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: allChaptersInfo.length,
        itemBuilder: (context, index) {
          final chapterModel = QuranSurahInfoModel.fromMap(
            allChaptersInfo[index],
          );
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: MyAppShapes.borderRadius,
                ),
              ),
              onPressed: () {
                Get.to(
                  () => SurahView(
                    surahIndex: chapterModel.id - 1,
                    surahName: chapterModel.nameSimple,
                    quranInfoModel: chapterModel,
                  ),
                );
              },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: MyAppShapes.borderRadius,
                ),

                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: Text((index + 1).toString()),
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chapterModel.nameSimple,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(surahMeaningsInEnglish[index]),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chapterModel.nameArabic,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(chapterModel.versesCount.toString() + ' Ayahs'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
