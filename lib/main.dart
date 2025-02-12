import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mumin/src/screens/about/about_page.dart';
import 'package:mumin/src/screens/home/home_page.dart';
import 'package:mumin/src/theme/colors.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: MyAppColors.primaryColor),
      ),
      getPages: [
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/about', page: () => const AboutScreen()),
      ],
      initialRoute: '/home',
    );
  }
}
