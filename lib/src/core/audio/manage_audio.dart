import "dart:convert";

import "package:get/get.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
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

  // Store currently playing surah metadata for notification tap navigation
  String? currentSurahName;
  Map<String, dynamic>? currentQuranInfoModelMap;
  int? currentStartAt;
  bool? currentPracticeMode;

  /// Whether audio playback has been started at least once with surah metadata.
  bool get hasActivePlayback =>
      surahNumber.value >= 0 && currentQuranInfoModelMap != null;

  @override
  void onInit() {
    super.onInit();
    _restorePlaybackMetadata();
  }

  /// Persist playback metadata to Hive so it survives app restarts.
  void _savePlaybackMetadata() {
    final box = Hive.box("user_db");
    box.put("playback_surah_number", surahNumber.value);
    box.put("playback_surah_name", currentSurahName);
    box.put("playback_start_at", currentStartAt);
    box.put("playback_practice_mode", currentPracticeMode);
    if (currentQuranInfoModelMap != null) {
      box.put(
        "playback_quran_info_model",
        jsonEncode(currentQuranInfoModelMap),
      );
    }
  }

  /// Restore playback metadata from Hive after cold start.
  void _restorePlaybackMetadata() {
    final box = Hive.box("user_db");
    final savedSurahNumber = box.get("playback_surah_number");
    if (savedSurahNumber != null && savedSurahNumber is int) {
      surahNumber.value = savedSurahNumber;
      currentSurahName = box.get("playback_surah_name") as String?;
      currentStartAt = box.get("playback_start_at") as int?;
      currentPracticeMode = box.get("playback_practice_mode") as bool?;
      final modelJson = box.get("playback_quran_info_model") as String?;
      if (modelJson != null) {
        currentQuranInfoModelMap =
            Map<String, dynamic>.from(jsonDecode(modelJson));
      }
    }
  }

  /// Clear persisted playback metadata (call when playback ends).
  void clearPlaybackMetadata() {
    final box = Hive.box("user_db");
    box.delete("playback_surah_number");
    box.delete("playback_surah_name");
    box.delete("playback_start_at");
    box.delete("playback_practice_mode");
    box.delete("playback_quran_info_model");
  }

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
    int ayahIndex, {
    Map<String, dynamic>? quranInfoModelMap,
    int? startAt,
    bool? practiceMode,
  }) async {
    if (isStreamRegistered.value == false) {
      startListening();
    }
    surahNumber.value = surahIndex;

    // Store metadata for notification tap navigation
    currentSurahName = surahName;
    if (quranInfoModelMap != null) {
      currentQuranInfoModelMap = quranInfoModelMap;
    }
    if (startAt != null) {
      currentStartAt = startAt;
    }
    currentPracticeMode = practiceMode;

    // Persist to Hive for cold-start survival
    _savePlaybackMetadata();

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
