import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:get/get.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
import "package:just_audio_background/just_audio_background.dart";
import "package:mumin/src/core/audio/manage_audio.dart";
import "package:mumin/src/screens/auth/controller/auth_controller.dart";
import "package:mumin/src/screens/manual_selection/cubit/manual_location_selection_cubit.dart";
import "package:mumin/src/theme/colors.dart";
import "package:mumin/src/theme/shapes.dart";
import "package:mumin/src/theme/theme_controller.dart";

import "package:mumin/src/routes/app_router.dart";

bool isUpdateChecked = false;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await JustAudioBackground.init(
    androidNotificationChannelId: "com.ryanheise.bg_demo.channel.audio",
    androidNotificationChannelName: "Audio playback",
    androidNotificationOngoing: true,
  );

  await Hive.initFlutter();
  await Hive.openBox("user_db");

  // Initialize Controllers
  Get.put(AuthController());
  Get.put(ManageAudioController());
  Get.put(AppThemeController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLifecycleState? _previousState;
  static const _notificationChannel =
      MethodChannel("com.impala.mumin/notification_tap");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FlutterNativeSplash.remove();

    // Listen for notification taps (in-app and cold-start)
    _notificationChannel.setMethodCallHandler((call) async {
      if (call.method == "onNotificationTap") {
        // For notification taps, navigate based on metadata alone
        // (on cold start, isPlaying may not yet be true)
        _navigateToSurahFromNotification();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only navigate when truly returning from background (paused → resumed).
    // This avoids triggering on notification shade pulls (inactive → resumed).
    if (state == AppLifecycleState.resumed &&
        _previousState == AppLifecycleState.paused) {
      _navigateToPlayingSurahIfNeeded();
    }
    _previousState = state;
  }

  /// Navigate from notification tap — uses metadata only (works on cold start).
  void _navigateToSurahFromNotification() {
    final audioController = Get.find<ManageAudioController>();
    if (!audioController.hasActivePlayback) return;

    final currentRoute =
        AppRouter.router.routerDelegate.currentConfiguration.uri.toString();
    if (currentRoute.startsWith("/surah_view/")) return;

    AppRouter.router.push("/surah_view/${audioController.surahNumber.value}");
  }

  /// Navigate from lifecycle resume — requires active playback.
  void _navigateToPlayingSurahIfNeeded() {
    final audioController = Get.find<ManageAudioController>();

    if (!audioController.hasActivePlayback ||
        !audioController.isPlaying.value) {
      return;
    }

    final currentRoute =
        AppRouter.router.routerDelegate.currentConfiguration.uri.toString();
    if (currentRoute.startsWith("/surah_view/")) return;

    AppRouter.router.push("/surah_view/${audioController.surahNumber.value}");
  }

  @override
  Widget build(BuildContext context) {
    return GetX<AppThemeController>(builder: (controller) {
      ThemeMode themeMode = ThemeMode.system;
      if (controller.themeModeName.value == "light") {
        themeMode = ThemeMode.light;
      } else if (controller.themeModeName.value == "dark") {
        themeMode = ThemeMode.dark;
      }
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ManualLocationSelectionCubit(),
          )
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "Mumin",
          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: MyAppColors.primaryColor,
              brightness: Brightness.light,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: MyAppShapes.borderRadius,
                ),
                backgroundColor: MyAppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: MyAppColors.primaryColor,
              brightness: Brightness.dark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: MyAppShapes.borderRadius,
                ),
                backgroundColor: MyAppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          routerConfig: AppRouter.router,
        ),
      );
    });
  }
}
