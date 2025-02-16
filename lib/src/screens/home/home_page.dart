import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:mumin/src/screens/quran/surah_list_screen.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/shadows.dart';
import 'package:mumin/src/theme/shapes.dart';
import 'package:mumin/src/theme/theme_controller.dart';
import 'package:mumin/src/theme/theme_icon_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> cards = [
    {'img': 'assets/images/kalima.png', 'name': 'Kalima', 'route': '/kalima'},
    {'img': 'assets/images/quran.png', 'name': 'Quran', 'route': '/quran'},
    {'img': 'assets/images/hadith.png', 'name': 'Hadith', 'route': '/hadith'},
    {
      'img': 'assets/images/read_and_practice.png',
      'name': 'Read & Practice',
      'route': '/read_practice',
    },
    {
      'img': 'assets/images/ramadan.png',
      'name': 'Ramadan Calender',
      'route': '/ramadan_calender',
    },
    {
      'img': 'assets/images/prayer_time.png',
      'name': 'Prayer Time',
      'route': '/prayer_time',
    },
    {'img': 'assets/images/mosque2.png', 'name': 'Mosque', 'route': '/mosque'},
    {
      'img': 'assets/images/direction.png',
      'name': 'Qibla Direction',
      'route': '/qibla_direction',
    },
    {
      'img': 'assets/images/tasbeeh.png',
      'name': 'Tasbeeh',
      'route': '/tasbeeh',
    },
    {
      'img': 'assets/images/zakat.png',
      'name': 'Zakat Calculator',
      'route': '/zakat_screen',
    },
    {'img': 'assets/images/qaba.png', 'name': 'Hajj', 'route': '/hajj'},
    {'img': 'assets/images/about.png', 'name': 'About', 'route': '/about'},
  ];

  AppThemeController appThemeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          SafeArea(
            child: SizedBox(
              height: 80,
              child: Row(
                children: [
                  const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  const Gap(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tangail',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Dhaka, Bangaladesh',
                        style: TextStyle(
                          fontSize: 16,
                          color: MyAppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  themeIconButton,
                ],
              ),
            ),
          ),
          const Gap(10),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 3, 29, 51),
              borderRadius: MyAppShapes.borderRadius,
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMEEEEd().format(DateTime.now()),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Sahari",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              const TimeOfDay(
                                hour: 3,
                                minute: 30,
                              ).format(context),
                              style: TextStyle(
                                fontSize: 16,
                                color: MyAppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const Gap(25),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Iftar",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              const TimeOfDay(
                                hour: 18,
                                minute: 12,
                              ).format(context),
                              style: TextStyle(
                                fontSize: 16,
                                color: MyAppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('assets/images/mosque.png'),
                ),
              ],
            ),
          ),
          const Gap(10),
          Obx(
            () => Container(
              height: 70,
              decoration: BoxDecoration(
                color: appThemeController.isDark.value
                    ? MyAppColors.backgroundDarkColor.withValues(alpha: 0.5)
                    : MyAppColors.backgroundLightColor,
                borderRadius: MyAppShapes.borderRadius,
              ),
              child: Image.asset('assets/images/banner.gif'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 3, 29, 51),
              borderRadius: MyAppShapes.borderRadius,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.white),
                const Gap(10),
                const Text(
                  '30 Day Plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: MyAppShapes.borderRadius,
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 16,
                      color: MyAppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.spaceBetween,
            children: List.generate(cards.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: MyAppShapes.borderRadius,
                    ),
                  ),
                  onPressed: () {
                    if (cards[index]['route'] == '/read_practice') {
                      Get.to(
                        () => const SurahListScreen(practiceMode: true),
                        routeName: '/read_practice',
                      );
                      return;
                    }
                    Get.toNamed(cards[index]['route']!);
                  },
                  child: Obx(
                    () => Container(
                      height: 105,
                      width: 95,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: appThemeController.isDark.value
                            ? MyAppColors.backgroundDarkColor
                            : MyAppColors.backgroundLightColor,
                        borderRadius: MyAppShapes.borderRadius,
                        boxShadow: [
                          appThemeController.isDark.value
                              ? MyAppShadows.commonShadowDark
                              : MyAppShadows.commonShadowLight,
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: Image.asset(
                              cards[index]['img']!,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            cards[index]['name']!,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const Gap(50),
        ],
      ),
    );
  }
}
