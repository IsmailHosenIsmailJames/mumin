import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mumin/src/screens/about/about_page.dart';
import 'package:mumin/src/screens/auth/login_page.dart';
import 'package:mumin/src/screens/hajj/hajj_page.dart';
import 'package:mumin/src/screens/home/home_page.dart';
import 'package:mumin/src/screens/kalima/kalima_screen.dart';
import 'package:mumin/src/screens/quran/surah_list_screen.dart';
import 'package:mumin/src/screens/tasbeeh/tasbeeh_screen.dart';
import 'package:mumin/src/screens/zakkat/zakkat_screen.dart';
import 'package:mumin/src/theme/colors.dart';

import 'src/screens/mosque_view/mosque_view.dart';

void main() {
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
        GetPage(name: '/quran', page: () => const SurahListScreen()),
      ],
      initialRoute: '/home',
      defaultTransition: Transition.leftToRight,
    );
  }
}
