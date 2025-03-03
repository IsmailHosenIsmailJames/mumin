import 'dart:convert';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mumin/src/apis/apis.dart';
import 'package:mumin/src/core/algorithm/get_most_close_key.dart';
import 'package:mumin/src/core/location/location_service.dart';
import 'package:mumin/src/core/notifications/notification_service.dart';
import 'package:mumin/src/core/notifications/requiest_permission.dart';
import 'package:mumin/src/screens/auth/controller/auth_controller.dart';
import 'package:mumin/src/screens/daily_plan/daily_ramadan_plan.dart';
import 'package:mumin/src/screens/daily_plan/get_ramadan_number.dart';
import 'package:mumin/src/screens/home/controller/model/user_calander_day_model.dart';
import 'package:mumin/src/screens/home/controller/model/user_location_data.dart';
import 'package:mumin/src/screens/home/controller/user_location.dart';
import 'package:mumin/src/screens/home/controller/user_location_calender.dart';
import 'package:mumin/src/screens/home/count_down.dart';
import 'package:mumin/src/screens/quran/surah_list_screen.dart';
import 'package:mumin/src/screens/ramadan_calender/model/controller.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/shadows.dart';
import 'package:mumin/src/theme/shapes.dart';
import 'package:mumin/src/theme/theme_controller.dart';
import 'package:mumin/src/theme/theme_icon_button.dart';
import 'package:toastification/toastification.dart';

import '../../core/in_app_update/in_app_android_update/in_app_update_android.dart';

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
  AuthController authController = Get.put(AuthController());
  UserLocationController userLocationController =
      Get.put(UserLocationController());

  UserLocationCalender userLocationCalender = Get.put(UserLocationCalender());

  final userBox = Hive.box('user_db');
  @override
  void initState() {
    startupCalls();
    super.initState();
  }

  bool isLocationDeclined = false;

  Future<void> startupCalls() async {
    await getUserLocation();
    await inAppUpdateAndroid(context);

    if (await requestPermissionsAwesomeNotifications()) {
      await NotificationService.initializeNotifications();
      if (Hive.box('user_db').get('close_notification', defaultValue: null) ==
          null) {
        await AwesomeNotifications().cancelAll();
        await Hive.box('user_db').put('close_notification', true);
        log('AwesomeNotifications().cancelAll()');
      }
      await NotificationService.scheduleDailyRamadanNotification();
    }
    await requestPermissionsAwesomeNotifications();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userBox.get(
              'daily_plan_popup_${getRamadanNumber(
                ramadanTodayTimeController.ifter.value ??
                    const TimeOfDay(hour: 18, minute: 30),
              )}',
              defaultValue: null) ==
          null) {
        await showDailyPlanDialog();
        userBox.put(
            'daily_plan_popup_${getRamadanNumber(
              ramadanTodayTimeController.ifter.value ??
                  const TimeOfDay(hour: 18, minute: 30),
            )}',
            true);
      }
    });

    callApiAnalytics();
    setState(() {});
  }

  callApiAnalytics() async {
    log('$baseApi/api/activity?phone=${authController.user.value?.mobileNumber}',
        name: 'API hit');
    try {
      final res = await get(Uri.parse(
          '$baseApi/api/activity?phone=${authController.user.value?.mobileNumber}'));
      log(res.statusCode.toString(), name: 'statusCode');
      log(res.body, name: 'body');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> showDailyPlanDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Your daily Ramadan plans are ready!'),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
              label: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                routeTo30DayPlan(context, isPopUp: true);
              },
              label: const Text('See Plans'),
            )
          ],
        );
      },
    );
  }

  final RamadanTodayTimeController ramadanTodayTimeController =
      Get.put(RamadanTodayTimeController());

  Future<void> loadCalender(UserLocationData? userLocationData) async {
    String json = await rootBundle
        .loadString('assets/calender_data/ramadan_calendar2025.json');
    Map ramadanCalendar = jsonDecode(json);
    if (userLocationData != null) {
      String district =
          userLocationData.district.split(' ').first.toLowerCase();
      List<RamadanDayModel> ramadanDaysList = [];
      bool found = false;
      for (String key in ramadanCalendar.keys) {
        if (key.toString().toLowerCase() == district) {
          found = true;
          List temList = ramadanCalendar[key] as List;
          for (int i = 0; i < (temList).length; i++) {
            ramadanDaysList.add(
                RamadanDayModel.fromMap(Map<String, dynamic>.from(temList[i])));
          }
        }
      }
      if (!found) {
        String? key = FuzzyMatcher.findClosestKey(
            Map<String, dynamic>.from(ramadanCalendar), district);
        if (key != null) {
          List temList = ramadanCalendar[key] as List;
          for (int i = 0; i < (temList).length; i++) {
            ramadanDaysList.add(
                RamadanDayModel.fromMap(Map<String, dynamic>.from(temList[i])));
          }
        }
      }
      int ramadanDay = getRamadanNumber(
          ramadanTodayTimeController.ifter.value ??
              const TimeOfDay(hour: 18, minute: 30));
      RamadanDayModel todaysTime = ramadanDaysList[ramadanDay - 1];
      ramadanTodayTimeController.sehri.value = TimeOfDay.fromDateTime(
          DateFormat('h:mm a').parse(todaysTime.seharEnd));
      ramadanTodayTimeController.ifter.value =
          TimeOfDay.fromDateTime(DateFormat('h:mm a').parse(todaysTime.ifter));
      log(todaysTime.toJson());
      userLocationCalender.userLocationCalender.value = ramadanDaysList;
    }
  }

  Future<void> getUserLocation() async {
    // load Ramadan calender
    await loadCalender(userLocationController.locationData.value);
    try {
      LocationPermission locationPermission =
          await LocationService().requestAndGetLocationPermission();
      if (locationPermission == LocationPermission.deniedForever ||
          locationPermission == LocationPermission.denied) {
        setState(() {
          isLocationDeclined = true;
        });
      }
      Position? location = await LocationService().getCurrentLocation();
      if (location != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude, location.longitude);
        UserLocationData userLocationData = UserLocationData(
            latitude: location.latitude,
            longitude: location.longitude,
            division: 'division',
            district: 'district');
        for (Placemark placemark in placemarks) {
          if (placemark.administrativeArea != null) {
            userLocationData.division = placemark.administrativeArea!;
          }
          if (placemark.subAdministrativeArea != null) {
            userLocationData.district = placemark.subAdministrativeArea!;
          }
        }
        await Hive.box('user_db')
            .put('user_location', userLocationData.toJson());
        userLocationController.locationData.value = userLocationData;
        await loadCalender(userLocationController.locationData.value);
        setState(() {});
      } else {
        log('Location is null');
      }
    } catch (e) {
      log(e.toString());
    }
    setState(() {});
  }

  String formatSeconds(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int remainingSecondsAfterHours = totalSeconds % 3600;
    int minutes = remainingSecondsAfterHours ~/ 60;
    int seconds = remainingSecondsAfterHours % 60;

    String formattedTime =
        "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          SafeArea(
            child: isLocationDeclined
                ? SizedBox(
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
                              'Location permission denied!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Please give app location permission\nSo that you can enjoy more features.',
                              style: TextStyle(
                                fontSize: 12,
                                color: MyAppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            LocationPermission locationPermission =
                                await LocationService()
                                    .requestAndGetLocationPermission();
                            if (locationPermission ==
                                    LocationPermission.denied ||
                                locationPermission ==
                                    LocationPermission.deniedForever) {
                              Geolocator.openAppSettings();
                            }
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  )
                : userLocationController.locationData.value == null
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        height: 80,
                        width: double.infinity,
                      )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(
                          duration: 1200.ms,
                          color: const Color(0xFF80DDFF),
                        )
                    : SizedBox(
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
                                Text(
                                  userLocationController
                                      .locationData.value!.district,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${userLocationController.locationData.value!.division}, Bangladesh',
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
                      'Ramadan - ${getRamadanNumber(ramadanTodayTimeController.ifter.value ?? const TimeOfDay(hour: 18, minute: 30))}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMMEEEEd().format(getDateByRamadanNumber(
                          getRamadanNumber(
                                  ramadanTodayTimeController.ifter.value ??
                                      const TimeOfDay(hour: 18, minute: 30)) -
                              1)),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Gap(10),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sehri',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                ramadanTodayTimeController.sehri.value
                                        ?.format(context) ??
                                    '',
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
                                'Iftar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                ramadanTodayTimeController.ifter.value
                                        ?.format(context) ??
                                    '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: MyAppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 100,
                  child: Obx(() => RamadanCountdown(
                      iftarTime: ramadanTodayTimeController.ifter.value,
                      sehriTime: ramadanTodayTimeController.sehri.value)),
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
          GestureDetector(
            onTap: () async {
              await routeTo30DayPlan(context);
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: MyAppShapes.borderRadius,
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_month),
                  Gap(10),
                  Text(
                    'Ramadan Plan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward)
                ],
              ),
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

                    if (cards[index]['route'] == '/qibla_direction' ||
                        cards[index]['route'] == '/prayer_time' ||
                        cards[index]['route'] == '/mosque' ||
                        cards[index]['route'] == '/ramadan_calender') {
                      if (userLocationController.locationData.value == null) {
                        toastification.show(
                          context: context,
                          title: Text(
                            isLocationDeclined
                                ? 'Location permission denied!'
                                : 'Location Data is loading...',
                          ),
                          type: isLocationDeclined
                              ? ToastificationType.error
                              : null,
                          autoCloseDuration: const Duration(seconds: 4),
                        );
                      } else {
                        Get.toNamed(cards[index]['route']!);
                      }
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

  Future<void> routeTo30DayPlan(BuildContext context,
      {bool isPopUp = false}) async {
    if (isPopUp) Navigator.pop(context);
    Get.to(() => DailyRamadanPlan(
        day: getRamadanNumber(ramadanTodayTimeController.ifter.value ??
            const TimeOfDay(hour: 18, minute: 30))));
  }
}
