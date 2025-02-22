import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:mumin/src/core/background/background_setup.dart';
import 'package:mumin/src/core/location/location_service.dart';
import 'package:mumin/src/core/notifications/requiest_permission.dart';
import 'package:mumin/src/screens/daily_plan/daily_ramadan_plan.dart';
import 'package:mumin/src/screens/daily_plan/get_ramadan_number.dart';
import 'package:mumin/src/screens/home/controller/model/user_calander_day_model.dart';
import 'package:mumin/src/screens/home/controller/model/user_location_data.dart';
import 'package:mumin/src/screens/home/controller/user_location.dart';
import 'package:mumin/src/screens/home/controller/user_location_calender.dart';
import 'package:mumin/src/screens/quran/surah_list_screen.dart';
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
    await inAppUpdateAndroid(context);
    await getUserLocation();
    await requestPermissionsAwesomeNotifications();
    FlutterForegroundTask.addTaskDataCallback(onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Request permissions and initialize the service.
      await requestPermissions().then((value) {
        initService().then((value) {
          startService();
        });
      });
      if (userBox.get(
              'daily_plan_popup${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
              defaultValue: null) ==
          null) {
        await showDailyPlanDialog();
        userBox.put(
            'daily_plan_popup${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
            true);
      }
    });
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

  Future<void> getUserLocation() async {
    // load Ramadan calender
    String json = await rootBundle
        .loadString('assets/calender_data/ramadan_calendar2024.json');
    Map ramadanCalendar = jsonDecode(json);
    if (userLocationController.locationData.value != null) {
      String district = userLocationController.locationData.value!.district
          .split(' ')
          .first
          .toLowerCase();
      List<RamadanDayModel> ramadanDaysList = [];
      for (String key in ramadanCalendar.keys) {
        if (key.toString().toLowerCase() == district) {
          List temList = ramadanCalendar[key] as List;
          for (int i = 0; i < (temList).length; i++) {
            ramadanDaysList.add(
                RamadanDayModel.fromMap(Map<String, dynamic>.from(temList[i])));
          }
        }
      }
      userLocationCalender.userLocationCalender.value = ramadanDaysList;
    }

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
        setState(() {});
      } else {
        log('Location is null');
      }
    } catch (e) {
      log(e.toString());
    }
    setState(() {});
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
                              'Sahari',
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
                              'Iftar',
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
                  onPressed: () async {
                    await routeTo30DayPlan(context);
                  },
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
    bool result = await InternetConnection().hasInternetAccess;
    if (result) {
      if (isPopUp) Navigator.pop(context);
      Get.to(() => DailyRamadanPlan(day: getRamadanNumber()));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            title: const Text(
              'No internet connection!',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            content: const Text(
                'To access 30 days Ramadan Plan, you will require internet connection.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
}
