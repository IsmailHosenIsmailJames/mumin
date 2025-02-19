import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mumin/src/core/audio/manage_audio.dart';
import 'package:mumin/src/screens/about/about_page.dart';
import 'package:mumin/src/screens/auth/controller/auth_controller.dart';
import 'package:mumin/src/screens/auth/login_page.dart';
import 'package:mumin/src/screens/auth/registation_page.dart';
import 'package:mumin/src/screens/hadith/hadith_page.dart';
import 'package:mumin/src/screens/hajj/hajj_page.dart';
import 'package:mumin/src/screens/home/home_page.dart';
import 'package:mumin/src/screens/prayer_time/prayer_time.dart';
import 'package:mumin/src/screens/kalima/kalima_screen.dart';
import 'package:mumin/src/screens/qibla_direction/qibla_compass_screen.dart';
import 'package:mumin/src/screens/quran/surah_list_screen.dart';
import 'package:mumin/src/screens/ramadan_calender/ramadan_calender_page.dart';
import 'package:mumin/src/screens/tasbeeh/tasbeeh_screen.dart';
import 'package:mumin/src/screens/zakkat/zakkat_screen.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/shapes.dart';
import 'package:mumin/src/theme/theme_controller.dart';

import 'src/screens/mosque_view/mosque_view.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
    final AuthController authController = Get.put(AuthController());
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
        GetPage(name: '/hadith', page: () => const HadithPage()),
        GetPage(
            name: '/qibla_direction', page: () => const QiblaCompassScreen()),
        GetPage(name: '/prayer_time', page: () => const PrayerTime()),
        GetPage(
            name: '/ramadan_calender', page: () => const RamadanCalenderPage())
      ],
      initialRoute: authController.user.value == null ? '/login' : '/home',
      defaultTransition: Transition.leftToRight,
      onInit: () async {
        Get.put(ManageAudioController());

        final AppThemeController appThemeController = Get.put(
          AppThemeController(),
        );
        appThemeController.initTheme();

        FlutterNativeSplash.remove();
      },
    );
  }
}
