import "package:flutter/material.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:just_audio_background/just_audio_background.dart";
import "package:mumin/src/core/audio/manage_audio.dart";
import "package:mumin/src/screens/auth/controller/auth_controller.dart";
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
  final AppThemeController appThemeController = Get.put(AppThemeController());
  appThemeController.initTheme();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Mumin",
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
    );
  }
}
