import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool isLoggedIn = false;
String quranScriptType = 'uthmani_tajweed';

class AppThemeController extends GetxController {
  RxString themeModeName = 'system'.obs;
  RxBool isDark = true.obs;

  void initTheme() async {
    final accountBox = Hive.box('user_db');

    isLoggedIn =
        accountBox.get('email') != '' && accountBox.get('email') != null;
    final infoBox = Hive.box('user_db');

    infoBox.get('fontSizeTranslation', defaultValue: 15.0);
    quranScriptType = infoBox.get(
      'quranScriptType',
      defaultValue: 'uthmani_tajweed',
    );

    final themePrefer = await Hive.openBox('user_db');
    final String? userTheme = themePrefer.get('theme_preference');
    if (userTheme != null) {
      if (userTheme == 'light') {
        isDark.value = false;
        Get.changeThemeMode(ThemeMode.light);
        themeModeName.value = 'light';
        await themePrefer.put('theme_preference', themeModeName.value);
      } else if (userTheme == 'dark') {
        isDark.value = true;

        Get.changeThemeMode(ThemeMode.dark);
        themeModeName.value = 'dark';
        await themePrefer.put('theme_preference', themeModeName.value);
      } else if (userTheme == 'system') {
        themeModeName.value = 'system';
        Get.changeThemeMode(ThemeMode.system);
        Future.delayed(const Duration(seconds: 1)).then((value) {
          isDark.value =
              MediaQuery.of(Get.context!).platformBrightness == Brightness.dark;
        });
      }
    } else {
      await themePrefer.put('theme_preference', 'system');
      isDark.value =
          MediaQuery.of(Get.context!).platformBrightness == Brightness.dark;
      themeModeName.value = 'system';
      initTheme();
    }
  }

  void setTheme(String themeToChange) async {
    final themePrefer = await Hive.openBox('user_db');
    if (themeToChange == 'light') {
      isDark.value = false;

      Get.changeThemeMode(ThemeMode.light);
      themeModeName.value = 'light';
      await themePrefer.put('theme_preference', themeModeName.value);
    } else if (themeToChange == 'dark') {
      isDark.value = true;

      themeModeName.value = 'dark';
      Get.changeThemeMode(ThemeMode.dark);
      await themePrefer.put('theme_preference', 'dark');
    } else if (themeToChange == 'system') {
      isDark.value =
          MediaQuery.of(Get.context!).platformBrightness == Brightness.dark;
      themeModeName.value = 'system';
      Get.changeThemeMode(ThemeMode.system);
      await themePrefer.put('theme_preference', 'system');
    }
  }
}
