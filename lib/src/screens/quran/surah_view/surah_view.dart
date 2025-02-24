import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mumin/src/core/audio/manage_audio.dart';
import 'package:mumin/src/screens/quran/resources/chapters_ayah_count.dart';
import 'package:mumin/src/screens/quran/resources/model/quran_surah_info_model.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/shapes.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;
import 'package:toastification/toastification.dart';

class SurahView extends StatefulWidget {
  final bool? practiceMode;

  final int surahIndex;
  final String surahName;
  final QuranSurahInfoModel quranInfoModel;
  final int? start;
  final int? end;
  final int startAt;
  const SurahView({
    super.key,
    required this.surahIndex,
    required this.surahName,
    required this.quranInfoModel,
    this.practiceMode,
    this.start,
    this.end,
    required this.startAt,
  });

  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  List<Map<String, String>> ayahsWithMeaning = [];
  List<GlobalKey> scrollKeys = [];
  ManageAudioController audioController = Get.find();
  @override
  void initState() {
    int startAyahIndex = 0;
    for (int i = 0; i < widget.surahIndex; i++) {
      startAyahIndex += ayahCount[i];
    }
    int endAyahIndex = startAyahIndex + ayahCount[widget.surahIndex];
    getAllAyahsMap(startAyahIndex, endAyahIndex);
    super.initState();
    record.onStateChanged().listen((state) {
      setState(() {
        recordingState = state;
      });
    });
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
      if (widget.start != null) {
        if (((widget.start! + widget.startAt) - 1) > i) {
          continue;
        }
      }
      if (widget.end != null) {
        if (((widget.end! + widget.startAt) - 1) < i) {
          continue;
        }
      }
      log(i.toString());
      scrollKeys.add(GlobalKey());
      ayahsWithMeaning.add({
        'quran': mapIndopak.elementAt(i),
        'bn': mapBengali.elementAt(i),
        'en': mapEnglish.elementAt(i),
      });
    }

    setState(() {});
  }

  startListingForScroll() {
    audioController.audioPlayer.currentIndexStream.listen((event) async {
      if (event != null &&
          ayahCount[widget.surahIndex] > event &&
          audioController.surahNumber.value == widget.surahIndex &&
          scrollKeys.isNotEmpty) {
        if (scrollKeys[event].currentContext != null) {
          Scrollable.ensureVisible(
            scrollKeys[event].currentContext!,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 200),
            alignment: 0.5,
          );
        }
      }
    });
  }

  final record = AudioRecorder();
  bool isRecording = false;
  RecordState recordingState = RecordState.stop;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.surahName)),
      body: ayahsWithMeaning.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Scrollbar(
                  controller: scrollController,
                  interactive: true,
                  radius: Radius.circular(10),
                  thickness: 7,
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 100,
                      left: 5,
                      right: 5,
                    ),
                    itemCount: ayahsWithMeaning.length,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        bool isPlayingCurrent = (widget.surahIndex ==
                                audioController.surahNumber.value) &&
                            (index == audioController.indexOfAyah.value);

                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            key: scrollKeys[index],
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: MyAppShapes.borderRadius,
                              ),
                            ),
                            onPressed: () async {
                              if (widget.surahIndex ==
                                  audioController.surahNumber.value) {
                                if (index !=
                                    audioController.indexOfAyah.value) {
                                  audioController.audioPlayer.seek(
                                    const Duration(seconds: 0),
                                    index: index,
                                  );
                                  audioController.audioPlayer.play();
                                } else {
                                  if (audioController.isPlaying.value) {
                                    audioController.audioPlayer.pause();
                                  } else {
                                    audioController.audioPlayer.play();
                                  }
                                }
                              } else {
                                audioController.playSurahAsPlaylist(
                                  widget.quranInfoModel.nameSimple,
                                  widget.surahIndex,
                                  index,
                                );
                                startListingForScroll();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                borderRadius: MyAppShapes.borderRadius,
                                color: Colors.grey.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: isPlayingCurrent
                                      ? MyAppColors.primaryColor
                                      : Colors.grey.withValues(alpha: 0.5),
                                  width: isPlayingCurrent ? 2.0 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Ayah: ${(widget.start ?? 1) + index}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        (audioController.isPlaying.value &&
                                                audioController
                                                        .surahNumber.value ==
                                                    widget.surahIndex &&
                                                audioController
                                                        .indexOfAyah.value ==
                                                    index)
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                      ),
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
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                if (widget.practiceMode == true)
                  SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () async {
                          log((await record.isRecording()).toString());
                          if (await record.isRecording()) {
                            setState(() {
                              isRecording = true;
                            });
                            return;
                          } else {
                            // Get the app documents directory
                            final Directory appDocumentsDir = Directory(
                              join(
                                (await getApplicationDocumentsDirectory()).path,
                                'records',
                              ),
                            );

                            if (!(await appDocumentsDir.exists())) {
                              appDocumentsDir.create();
                            }

                            // Check and request permission if needed
                            if (await record.hasPermission()) {
                              // Start recording to file
                              await record.start(
                                const RecordConfig(encoder: AudioEncoder.wav),
                                path: path.join(
                                  appDocumentsDir.path,
                                  '${widget.surahName}-${DateTime.now().toIso8601String().split('.')[0]}.wav',
                                ),
                              );
                              setState(() {
                                isRecording = true;
                              });
                            }
                          }
                        },
                        child: isRecording
                            ? Container(
                                decoration: BoxDecoration(
                                  color: MyAppColors.primaryColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/recording.gif',
                                    ),
                                    const Gap(10),
                                    IconButton(
                                      onPressed: () {
                                        if (recordingState ==
                                            RecordState.pause) {
                                          record.resume();
                                        } else {
                                          record.pause();
                                        }
                                      },
                                      icon: recordingState == RecordState.pause
                                          ? const Icon(Icons.play_arrow)
                                          : const Icon(Icons.stop),
                                    ),
                                    const Gap(10),
                                    TextButton(
                                      onPressed: () {
                                        record.cancel();
                                        setState(() {
                                          isRecording = false;
                                        });
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    const Gap(10),
                                    TextButton(
                                      onPressed: () async {
                                        final dir = await record.stop();

                                        toastification.show(
                                          context: context,
                                          title: Text('Saved to $dir'),
                                          autoCloseDuration: const Duration(
                                            seconds: 3,
                                          ),
                                          alignment: Alignment.topRight,
                                          type: ToastificationType.success,
                                        );

                                        setState(() {
                                          isRecording = false;
                                        });
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: MyAppColors.primaryColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                height: 80,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.mic,
                                        size: 40,
                                        color: MyAppColors.backgroundLightColor,
                                      ),
                                      const Text('Record your recitation'),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
