import "dart:io";
import "dart:developer" as dev;

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:just_audio/just_audio.dart";
import "package:just_audio_background/just_audio_background.dart";
import "package:mumin/src/core/audio/manage_audio.dart";
import "package:mumin/src/screens/quran/resources/chapters.dart";
import "package:mumin/src/screens/quran/resources/model/quran_surah_info_model.dart";
import "package:mumin/src/screens/quran/resources/surah_meaning.dart";
import "package:mumin/src/theme/colors.dart";
import "package:mumin/src/theme/shapes.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import "package:share_plus/share_plus.dart";

class SurahListScreen extends StatefulWidget {
  final bool? practiceMode;
  const SurahListScreen({super.key, this.practiceMode});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final audioController = Get.put(ManageAudioController());

  int selectedTab = 0;
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Holy Quran")),
      body: Column(
        children: [
          if (widget.practiceMode == true)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedTab == 0
                            ? MyAppColors.primaryColor
                            : Colors.black,
                        foregroundColor: selectedTab == 0
                            ? Colors.white
                            : MyAppColors.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTab = 0;
                        });
                      },
                      child: const Text("Practice"),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedTab == 1
                            ? MyAppColors.primaryColor
                            : Colors.black,
                        foregroundColor: selectedTab == 1
                            ? Colors.white
                            : MyAppColors.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTab = 1;
                        });
                      },
                      child: const Text("Records"),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: (!(widget.practiceMode == true && selectedTab == 1))
                ? ListView.builder(
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
                            int statAt = 0;
                            for (int i = 0; i < chapterModel.id - 1; i++) {
                              statAt += QuranSurahInfoModel.fromMap(
                                      allChaptersInfo[i])
                                  .versesCount;
                            }
                            context.push(
                              "/surah_view/${chapterModel.id - 1}",
                              extra: {
                                "surahIndex": chapterModel.id - 1,
                                "surahName": chapterModel.nameSimple,
                                "quranInfoModel": chapterModel.toMap(),
                                "practiceMode": widget.practiceMode,
                                "startAt": statAt,
                                "start": null,
                                "end": null,
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
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Stack(
                                    children: [
                                      SvgPicture.string(
                                        """<svg class="w-10 h-10 rounded-full flex items-center justify-center" fill="#b1901f" viewBox="0 0 24 24"><path class="opacity-15" d="M21.77,8.948a1.238,1.238,0,0,1-.7-1.7,3.239,3.239,0,0,0-4.315-4.316,1.239,1.239,0,0,1-1.7-.7,3.239,3.239,0,0,0-6.1,0,1.238,1.238,0,0,1-1.7.7A3.239,3.239,0,0,0,2.934,7.249a1.237,1.237,0,0,1-.7,1.7,3.24,3.24,0,0,0,0,6.1,1.238,1.238,0,0,1,.705,1.7A3.238,3.238,0,0,0,7.25,21.066a1.238,1.238,0,0,1,1.7.7,3.239,3.239,0,0,0,6.1,0,1.238,1.238,0,0,1,1.7-.7,3.239,3.239,0,0,0,4.316-4.315,1.239,1.239,0,0,1,.7-1.7,3.239,3.239,0,0,0,0-6.1Z"></path><text x="50%" y="53%" text-anchor="middle" stroke="#b1901f" stroke-width="0.5px" dy=".3em" class="text" style="font-size: 7px;">2</text></svg>""",
                                        height: 35,
                                        width: 35,
                                        colorFilter: ColorFilter.mode(
                                          MyAppColors.primaryColor
                                              .withValues(alpha: 0.3),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      Center(
                                        child: FittedBox(
                                            child:
                                                Text((index + 1).toString())),
                                      ),
                                    ],
                                  ),
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
                                      "surah${chapterModel.id.toString().padLeft(3, '0')}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: "surah-name-v1",
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
                  )
                : FutureBuilder(
                    future: getAudioList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data == null) {
                        return const Center(child: Text("No Record Found"));
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text("No Record Found"));
                      }
                      dev.log(snapshot.data!.length.toString());
                      return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final current = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    current.path.split("/").last,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const Gap(20),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      onPressed: () async {
                                        if (playingRecordIndex == index) {
                                          if (audioController.isPlaying.value) {
                                            audioController.audioPlayer.pause();
                                            setState(() {
                                              isPlaying = false;
                                            });
                                          } else {
                                            audioController.audioPlayer.play();
                                            setState(() {
                                              isPlaying = true;
                                            });
                                          }
                                          return;
                                        }
                                        setState(() {
                                          playingRecordIndex = index;
                                        });
                                        audioController.audioPlayer
                                            .setAudioSource(
                                          AudioSource.file(
                                            current.path,
                                            tag: MediaItem(
                                              id: index.toString(),
                                              title:
                                                  current.path.split("/").last,
                                            ),
                                          ),
                                        );
                                        await audioController.audioPlayer
                                            .play();
                                        setState(() {
                                          isPlaying = true;
                                        });
                                      },
                                      icon: Icon(
                                        (playingRecordIndex == index &&
                                                isPlaying)
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                    ),
                                  ),
                                  const Gap(5),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      onPressed: () {
                                        Share.shareXFiles([
                                          XFile(current.path),
                                        ]);
                                      },
                                      icon: const Icon(Icons.share),
                                    ),
                                  ),
                                  const Gap(5),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                              "Are you sure you want to delete this record?",
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text("No"),
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text("Yes"),
                                                onPressed: () async {
                                                  await File(
                                                    current.path,
                                                  ).delete();
                                                  Navigator.of(
                                                    context,
                                                  ).pop();
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  int playingRecordIndex = -1;

  Future<List<FileSystemEntity>> getAudioList() async {
    final directory = Directory(
      join((await getApplicationDocumentsDirectory()).path, "records"),
    );

    return directory.listSync();
  }
}
