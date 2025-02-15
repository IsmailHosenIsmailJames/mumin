import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mumin/src/core/audio/manage_audio.dart';
import 'package:mumin/src/screens/about/about_page.dart';
import 'package:mumin/src/screens/auth/login_page.dart';
import 'package:mumin/src/screens/auth/registation_page.dart';
import 'package:mumin/src/screens/hajj/hajj_page.dart';
import 'package:mumin/src/screens/home/home_page.dart';
import 'package:mumin/src/screens/kalima/kalima_screen.dart';
import 'package:mumin/src/screens/qibla_direction/qibla_compass_screen.dart';
import 'package:mumin/src/screens/quran/surah_list_screen.dart';
import 'package:mumin/src/screens/tasbeeh/tasbeeh_screen.dart';
import 'package:mumin/src/screens/zakkat/zakkat_screen.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/shapes.dart';
import 'package:mumin/src/theme/theme_controller.dart';

import 'src/screens/mosque_view/mosque_view.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await Hive.initFlutter();
  await Hive.openBox('user_db');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mumin',
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
        textTheme: GoogleFonts.notoSansTextTheme(),
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
        textTheme: GoogleFonts.notoSansTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
          decorationColor: Colors.white,
        ),
      ),
      getPages: [
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/about', page: () => const AboutScreen()),
        GetPage(name: '/hajj', page: () => const HajjPage()),
        GetPage(name: '/kalima', page: () => const KalimaScreen()),
        GetPage(name: '/mosque', page: () => const MosqueScreen()),
        GetPage(name: '/tasbeeh', page: () => const TasbeehScreen()),
        GetPage(name: '/zakat_screen', page: () => const ZakatScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/registration', page: () => const RegistrationScreen()),
        GetPage(name: '/quran', page: () => const SurahListScreen()),
        GetPage(
          name: '/qibla_direction',
          page: () => const QiblaCompassScreen(),
        ),
      ],
      initialRoute: '/home',
      defaultTransition: Transition.leftToRight,
      onInit: () async {
        Get.put(ManageAudioController());
        final AppThemeController appThemeController = Get.put(
          AppThemeController(),
        );
        appThemeController.initTheme();
      },
    );
  }
}
