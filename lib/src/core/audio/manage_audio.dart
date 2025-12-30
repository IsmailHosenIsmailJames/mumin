import "package:get/get.dart";
import "package:just_audio/just_audio.dart";
import "package:just_audio_background/just_audio_background.dart"
    show MediaItem;
import "package:mumin/src/core/audio/api/base_api.dart";

import "../../screens/quran/resources/chapters_ayah_count.dart";

class ManageAudioController extends GetxController {
  RxBool isPlaying = false.obs;
  RxInt indexOfAyah = (-1).obs;
  RxInt surahNumber = (-1).obs;
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isStreamRegistered = false.obs;

  void startListening() {
    isStreamRegistered.value = true;
    audioPlayer.playerStateStream.listen((event) {
      isPlaying.value = event.playing;
    });
    audioPlayer.currentIndexStream.listen((event) {
      if (event != null) {
        indexOfAyah.value = event;
      }
    });
  }

  void playSurahAsPlaylist(
    String surahName,
    int surahIndex,
    int ayahIndex,
  ) async {
    if (isStreamRegistered.value == false) {
      startListening();
    }
    surahNumber.value = surahIndex;

    await audioPlayer.stop();
    List<LockCachingAudioSource> audioSources = [];
    int ayahNumber = ayahCount[surahIndex];
    for (var i = 0; i < ayahNumber; i++) {
      String id = surahIDFromNumber(
        surahNumber: surahIndex + 1,
        ayahNumber: i + 1,
      );
      String audioURL = makeAudioUrl(audioBase, id);
      audioSources.add(
        LockCachingAudioSource(
          Uri.parse(audioURL),
          tag: MediaItem(
            id: id,
            album: "Abdul Baset",
            title: "$surahName ($id)",
          ),
        ),
      );
    }
    await audioPlayer.setAudioSources(
      audioSources,
      initialIndex: ayahIndex,
      initialPosition: Duration.zero,
    );
    await audioPlayer.play();
  }

  String makeAudioUrl(String link, String surahID) {
    return "$link/$surahID.mp3";
  }

  static String surahIDFromNumber({required int surahNumber, int? ayahNumber}) {
    return "${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}";
  }
}
