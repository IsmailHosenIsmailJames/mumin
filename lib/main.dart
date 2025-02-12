import 'package:flutter/material.dart';
import 'package:mumin/src/screens/home/home_page.dart';
import 'package:mumin/src/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mumin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MyAppColors.primaryColor),
      ),
      home: const HomePage(),
    );
  }
}
