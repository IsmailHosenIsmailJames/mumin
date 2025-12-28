import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:mumin/src/screens/daily_plan/data/day_30_data.dart";
import "package:mumin/src/screens/daily_plan/get_ramadan_number.dart";
import "package:mumin/src/screens/quran/resources/chapters.dart";
import "package:mumin/src/screens/quran/resources/model/quran_surah_info_model.dart";
import "package:mumin/src/screens/quran/resources/surah_meaning.dart";
import "package:mumin/src/screens/ramadan_calender/model/controller.dart";
import "package:mumin/src/screens/settings/controller/settings_controller.dart";
import "package:mumin/src/theme/shapes.dart";

class DailyRamadanPlan extends StatefulWidget {
  final int day;
  const DailyRamadanPlan({super.key, required this.day});

  @override
  State<DailyRamadanPlan> createState() => _DailyRamadanPlanState();
}

class _DailyRamadanPlanState extends State<DailyRamadanPlan> {
  final SettingsController settingsController = Get.put(SettingsController());
  RamadanTodayTimeController ramadanTodayTimeController = Get.find();
  late int day = widget.day;
  @override
  void initState() {
    load(day);
    super.initState();
  }

  List<Map<String, String?>> dua = [];
  List<Map<String, String?>> hadith = [];
  List<Map<String, String?>> quran = [];
  void load(int day) {
    dua = [];
    hadith = [];
    quran = [];

    quran = all30DayData[day]!["quran"]!;
    dua = all30DayData[day]!["dua"]!;
    hadith = all30DayData[day]!["hadith"]!;
    int firstSurahNumber = int.parse(quran.first["surahNumber"]!);
    int lastSurahNumber = int.parse(quran.last["surahNumber"]!);
    for (int i = firstSurahNumber + 1; i < lastSurahNumber - 1; i++) {
      quran.add(
        {
          "surahNumber": "$i",
          "start": "1",
          "end": null,
        },
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> myTabs = <Tab>[
      const Tab(text: "Dua"),
      const Tab(text: "Quran"),
      const Tab(text: "Hadith"),
    ];
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 5,
            title: Text(
              "Ramadan Day - ${widget.day}",
              style: const TextStyle(fontSize: 16),
            ),
            bottom: TabBar(
              tabs: myTabs,
            ),
            actions: [
              if (getRamadanNumber(ramadanTodayTimeController.ifter.value ??
                      const TimeOfDay(hour: 18, minute: 30)) >
                  1)
                SizedBox(
                  width: 90,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5, right: 5),
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 5, right: 2),
                      ),
                      initialValue: day,
                      items: List.generate(
                        getRamadanNumber(
                            ramadanTodayTimeController.ifter.value ??
                                const TimeOfDay(hour: 18, minute: 30)),
                        (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text("Day ${index + 1}"),
                          );
                        },
                      ),
                      onChanged: (value) {
                        day = value ?? 1;
                        load(day);
                      },
                    ),
                  ),
                ),
            ],
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: dua.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: SelectableText(
                              dua[index]["arabic"]!,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize:
                                    settingsController.arabicFontSize.value,
                                fontFamily: "IndopakNastaleeq",
                              ),
                            ),
                          ),
                          const Divider(),
                          SelectableText(
                            dua[index]["translation"]!,
                            style: TextStyle(
                              fontSize:
                                  settingsController.translationFontSize.value,
                            ),
                          )
                        ],
                      ),
                    );
                  });
                },
              ),
              ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: quran.length,
                itemBuilder: (context, index) {
                  int surahNumber = int.parse(quran[index]["surahNumber"]!);
                  if (surahNumber > allChaptersInfo.length) {
                    return const SizedBox();
                  }
                  final chapterModel = QuranSurahInfoModel.fromMap(
                    allChaptersInfo[surahNumber - 1],
                  );
                  int start = int.parse(quran[index]["start"]!);
                  int? end = quran[index]["end"] == null
                      ? null
                      : int.parse(quran[index]["end"]!);
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
                        int startAt = 0;
                        for (int i = 0; i < chapterModel.id - 1; i++) {
                          startAt +=
                              QuranSurahInfoModel.fromMap(allChaptersInfo[i])
                                  .versesCount;
                        }

                        context.push(
                          "/surah_view",
                          extra: {
                            "surahIndex": chapterModel.id - 1,
                            "surahName": chapterModel.nameSimple,
                            "quranInfoModel": chapterModel.toMap(),
                            "start": start,
                            "end": end,
                            "startAt": startAt,
                          },
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
                              child: Text((surahNumber).toString()),
                            ),
                            const Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${chapterModel.nameSimple} ($start - ${end ?? chapterModel.versesCount})",
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
                                Text("${chapterModel.versesCount} Ayahs"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: hadith.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(
                        alpha: 0.2,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: SelectableText(
                            hadith[index]["translation"]!,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
