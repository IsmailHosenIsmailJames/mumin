import "dart:convert";
import "dart:developer";

import "package:awesome_notifications/awesome_notifications.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:go_router/go_router.dart";
import "package:get/get.dart";
import "package:hijri/hijri_calendar.dart";
import "package:hive_ce/hive.dart";
import "package:http/http.dart";
import "package:intl/intl.dart";
import "package:mumin/src/apis/apis.dart";
import "package:mumin/src/core/algorithm/get_most_close_key.dart";
import "package:mumin/src/core/location/location_service.dart";
import "package:mumin/src/core/notifications/notification_service.dart";
import "package:mumin/src/core/notifications/requiest_permission.dart";
import "package:mumin/src/core/utils/lat_lon.dart";
import "package:mumin/src/core/utils/one_placemart_from_multi.dart";
import "package:mumin/src/screens/auth/controller/auth_controller.dart";
import "package:mumin/src/screens/daily_plan/get_ramadan_number.dart";
import "package:mumin/src/screens/home/controller/model/user_calander_day_model.dart";
import "package:mumin/src/screens/home/controller/model/user_location_data.dart";
import "package:mumin/src/screens/home/controller/user_location.dart";
import "package:mumin/src/screens/home/controller/user_location_calender.dart";
import "package:mumin/src/screens/home/count_down.dart";
import "package:mumin/src/screens/ramadan_calender/model/controller.dart";
import "package:mumin/src/theme/colors.dart";
import "package:mumin/src/theme/shadows.dart";
import "package:mumin/src/theme/shapes.dart";
import "package:mumin/src/theme/theme_controller.dart";
import "package:mumin/src/theme/theme_icon_button.dart";
import "package:toastification/toastification.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> cards = [
    {"img": "assets/images/kalima.png", "name": "Kalima", "route": "/kalima"},
    {"img": "assets/images/quran.png", "name": "Quran", "route": "/quran"},
    {"img": "assets/images/hadith.png", "name": "Hadith", "route": "/hadith"},
    {
      "img": "assets/images/read_and_practice.png",
      "name": "Read & Practice",
      "route": "/read_practice",
    },
    {
      "img": "assets/images/ramadan.png",
      "name": "Ramadan Calender",
      "route": "/ramadan_calender",
    },
    {
      "img": "assets/images/prayer_time.png",
      "name": "Prayer Time",
      "route": "/prayer_time",
    },
    {"img": "assets/images/mosque2.png", "name": "Mosque", "route": "/mosque"},
    {
      "img": "assets/images/direction.png",
      "name": "Qibla Direction",
      "route": "/qibla_direction",
    },
    {
      "img": "assets/images/tasbeeh.png",
      "name": "Tasbeeh",
      "route": "/tasbeeh",
    },
    {
      "img": "assets/images/zakat.png",
      "name": "Zakat Calculator",
      "route": "/zakat_screen",
    },
    {"img": "assets/images/qaba.png", "name": "Hajj", "route": "/hajj"},
    {"img": "assets/images/about.png", "name": "About", "route": "/about"},
    {
      "img": "assets/images/settings-svgrepo-com.png",
      "name": "Settings",
      "route": "/settings"
    },
  ];

  AppThemeController appThemeController = Get.find();
  AuthController authController = Get.put(AuthController());
  UserLocationController userLocationController =
      Get.put(UserLocationController());

  UserLocationCalender userLocationCalender = Get.put(UserLocationCalender());

  final userBox = Hive.box("user_db");
  @override
  void initState() {
    startupCalls();
    super.initState();
  }

  bool isLocationDeclined = false;

  Future<void> startupCalls() async {
    await getUserLocation();

    bool dontShowAgain =
        Hive.box("user_db").get("dont_show_again", defaultValue: false);

    bool isNotificationAllowed =
        await AwesomeNotifications().isNotificationAllowed();
    if (!isNotificationAllowed && !dontShowAgain) {
      bool userAgreed = await _showPermissionRationale(
        icon: Icons.notifications_active_outlined,
        title: "Stay Notified!",
        description:
            "Enable notifications to receive daily Ramadan reminders, prayer times, and important updates directly on your device.",
        color: MyAppColors.primaryColor,
      );

      if (userAgreed) {
        if (await requestPermissionsAwesomeNotifications()) {
          await NotificationService.initializeNotifications();
          if (Hive.box("user_db")
                  .get("close_notification", defaultValue: null) ==
              null) {
            await AwesomeNotifications().cancelAll();
            await Hive.box("user_db").put("close_notification", true);
            log("AwesomeNotifications().cancelAll()");
          }
          await NotificationService.scheduleDailyRamadanNotification();
        }
      }
    } else if (!dontShowAgain) {
      await NotificationService.initializeNotifications();
      await NotificationService.scheduleDailyRamadanNotification();
    }
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userBox.get(
              "daily_plan_popup_${getRamadanNumber(
                ramadanTodayTimeController.ifter.value ??
                    const TimeOfDay(hour: 18, minute: 30),
              )}",
              defaultValue: null) ==
          null) {
        await showDailyPlanDialog();
        userBox.put(
            "daily_plan_popup_${getRamadanNumber(
              ramadanTodayTimeController.ifter.value ??
                  const TimeOfDay(hour: 18, minute: 30),
            )}",
            true);
      }
    });

    callApiAnalytics();
    setState(() {});
  }

  Future<void> callApiAnalytics() async {
    log("$baseApi/api/activity?phone=${authController.user.value?.mobileNumber}",
        name: "API hit");
    try {
      final res = await get(Uri.parse(
          "$baseApi/api/activity?phone=${authController.user.value?.mobileNumber}"));
      log(res.statusCode.toString(), name: "statusCode");
      log(res.body, name: "body");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> showDailyPlanDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Your daily Ramadan plans are ready!"),
          actions: [
            TextButton.icon(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.close),
              label: const Text("Close"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                routeTo30DayPlan(context, isPopUp: true);
              },
              label: const Text("See Plans"),
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
        .loadString("assets/calender_data/ramadan_calendar2025.json");
    Map ramadanCalendar = jsonDecode(json);
    if (userLocationData != null) {
      log(userLocationData.placemark?.subAdministrativeArea ??
          userLocationData.placemark?.administrativeArea ??
          "Empty");
      String district = userLocationData.placemark?.subAdministrativeArea ??
          userLocationData.placemark?.administrativeArea ??
          "Dhaka";
      district = district.replaceAll(" ", "");
      List<RamadanDayModel> ramadanDaysList = [];
      log(district);
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
      RamadanDayModel? todaysTime;
      try {
        todaysTime = ramadanDaysList[ramadanDay - 1];
      } catch (e) {
        log(e.toString());
      }
      if (todaysTime != null) {
        ramadanTodayTimeController.sehri.value = TimeOfDay.fromDateTime(
            DateFormat("h:mm a").parse(todaysTime.seharEnd));
        ramadanTodayTimeController.ifter.value = TimeOfDay.fromDateTime(
            DateFormat("h:mm a").parse(todaysTime.ifter));
        log(todaysTime.toJson());
      }
      userLocationCalender.userLocationCalender.value = ramadanDaysList;
      setState(() {});
    }
  }

  Future<void> getUserLocation() async {
    // load Ramadan calender
    await loadCalender(userLocationController.locationData.value);
    try {
      LocationPermission locationPermission =
          await Geolocator.checkPermission();

      bool dontShowAgain = Hive.box("user_db")
          .get("dont_show_location_permission", defaultValue: false);

      if (locationPermission == LocationPermission.denied && !dontShowAgain) {
        bool userAgreed = await _showPermissionRationale(
          icon: Icons.location_on_outlined,
          title: "Enable Location",
          description:
              "We need your location to provide accurate prayer times, Qibla direction, and nearby mosques based on your current city.",
          color: Colors.redAccent,
        );

        if (userAgreed) {
          locationPermission =
              await LocationService().requestAndGetLocationPermission();
        }
      }

      if (locationPermission == LocationPermission.deniedForever ||
          locationPermission == LocationPermission.denied) {
        setState(() {
          isLocationDeclined = true;
        });
        return;
      }
      Position? location = await LocationService().getCurrentLocation();
      if (location != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude, location.longitude);
        UserLocationData userLocationData = UserLocationData(
          latitude: location.latitude,
          longitude: location.longitude,
        );
        userLocationData.placemark = onePlacemarkFromMulti(placemarks);
        await Hive.box("user_db")
            .put("user_location", userLocationData.toJson());
        userLocationController.locationData.value = userLocationData;
        await loadCalender(userLocationController.locationData.value);
        setState(() {});
      } else {
        log("Location is null");
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
            child: isLocationDeclined &&
                    userLocationController.locationData.value == null
                ? Row(
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
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Location permission denied!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              "Please give app location permission or choose city manually, So that you can enjoy more features.",
                              style: TextStyle(
                                fontSize: 12,
                                color: MyAppColors.secondaryColor,
                              ),
                            ),
                            const Gap(5),
                            SizedBox(
                              height: 30,
                              width: 200,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          MyAppColors.secondaryColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      padding: EdgeInsets.zero),
                                  onPressed: () async {
                                    final result = await context
                                        .push("/manual_location_selection");
                                    if (result is String) {
                                      try {
                                        Map<String, dynamic> data =
                                            jsonDecode(result);
                                        LatLon latLon = LatLon.fromMap(data);
                                        UserLocationData userLocationData =
                                            UserLocationData(
                                          latitude: latLon.latitude,
                                          longitude: latLon.longitude,
                                        );

                                        try {
                                          List<Placemark> placemarks =
                                              await placemarkFromCoordinates(
                                                  latLon.latitude,
                                                  latLon.longitude);
                                          userLocationData.placemark =
                                              onePlacemarkFromMulti(placemarks);
                                        } catch (e) {
                                          log("Geocoding failed: $e");
                                        }

                                        await Hive.box("user_db").put(
                                            "user_location_info",
                                            userLocationData.toJson());
                                        userLocationController.locationData
                                            .value = userLocationData;
                                        await loadCalender(
                                            userLocationController
                                                .locationData.value);
                                        setState(() {
                                          isLocationDeclined = false;
                                        });
                                      } catch (e) {
                                        log("Manual location selection failed: $e");
                                      }
                                    }
                                  },
                                  child: const Text("Choose City Manually")),
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      IconButton(
                        onPressed: () async {
                          LocationPermission locationPermission =
                              await LocationService()
                                  .requestAndGetLocationPermission();
                          if (locationPermission == LocationPermission.denied ||
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
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (userLocationController
                                      .locationData.value?.placemark ==
                                  null)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    borderRadius: MyAppShapes.borderRadius,
                                  ),
                                  height: 25,
                                )
                                    .animate(
                                        onPlay: (controller) =>
                                            controller.repeat())
                                    .shimmer(
                                      duration: 1200.ms,
                                      color: const Color(0xFF80DDFF),
                                    ),
                              if (userLocationController
                                      .locationData.value?.placemark !=
                                  null)
                                const Text("Location"),
                              if (userLocationController
                                      .locationData.value?.placemark !=
                                  null)
                                Text(
                                  userLocationController
                                          .locationData.value?.placemark
                                          ?.toAddressString() ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Gap(8),
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
                      HijriCalendar.now().toFormat("dd MMMM yyyy"),
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
                                "Sehri",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              ramadanTodayTimeController.sehri.value == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.grey.withValues(alpha: 0.2),
                                        borderRadius: MyAppShapes.borderRadius,
                                      ),
                                      height: 20,
                                      width: 50,
                                    )
                                      .animate(
                                          onPlay: (controller) =>
                                              controller.repeat())
                                      .shimmer(
                                        duration: 1200.ms,
                                        color: const Color(0xFF80DDFF),
                                      )
                                  : Text(
                                      ramadanTodayTimeController.sehri.value
                                              ?.format(context) ??
                                          "",
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
                              ramadanTodayTimeController.ifter.value == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.grey.withValues(alpha: 0.2),
                                        borderRadius: MyAppShapes.borderRadius,
                                      ),
                                      height: 20,
                                      width: 50,
                                    )
                                      .animate(
                                          onPlay: (controller) =>
                                              controller.repeat())
                                      .shimmer(
                                        duration: 1200.ms,
                                        color: const Color(0xFF80DDFF),
                                      )
                                  : Text(
                                      ramadanTodayTimeController.ifter.value
                                              ?.format(context) ??
                                          "",
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
                color: isDark(appThemeController.themeModeName.value)
                    ? MyAppColors.backgroundDarkColor.withValues(alpha: 0.5)
                    : MyAppColors.backgroundLightColor,
                borderRadius: MyAppShapes.borderRadius,
              ),
              child: Image.asset("assets/images/banner.gif"),
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
                    "Ramadan Plan",
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
          const Gap(10),
          GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: List.generate(cards.length, (index) {
              return InkWell(
                borderRadius: MyAppShapes.borderRadius,
                onTap: () {
                  if (cards[index]["route"] == "/read_practice") {
                    context.push("/read_practice");
                    return;
                  }

                  if (cards[index]["route"] == "/qibla_direction" ||
                      cards[index]["route"] == "/prayer_time" ||
                      cards[index]["route"] == "/mosque" ||
                      cards[index]["route"] == "/ramadan_calender") {
                    if (userLocationController.locationData.value == null) {
                      toastification.show(
                        context: context,
                        title: Text(
                          isLocationDeclined
                              ? "Location permission denied!"
                              : "Location Data is loading...",
                        ),
                        type: isLocationDeclined
                            ? ToastificationType.error
                            : null,
                        autoCloseDuration: const Duration(seconds: 4),
                      );
                    } else {
                      context.push(cards[index]["route"]!);
                    }
                    return;
                  }
                  context.push(cards[index]["route"]!);
                },
                child: Obx(
                  () => Container(
                    height: 105,
                    width: 95,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isDark(appThemeController.themeModeName.value)
                          ? MyAppColors.backgroundDarkColor
                          : MyAppColors.backgroundLightColor,
                      borderRadius: MyAppShapes.borderRadius,
                      boxShadow: [
                        isDark(appThemeController.themeModeName.value)
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
                            cards[index]["img"]!,
                            fit: BoxFit.fill,
                            color: cards[index]["name"] == "Settings"
                                ? isDark(appThemeController.themeModeName.value)
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700
                                : null,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          cards[index]["name"]!,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const Gap(10),
          const Gap(50),
        ],
      ),
    );
  }

  bool isDark(String mood) {
    if (mood == "dark") {
      return true;
    } else if (mood == "light") {
      return false;
    } else {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  Future<bool> _showPermissionRationale({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) async {
    bool? result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark(appThemeController.themeModeName.value)
              ? MyAppColors.backgroundDarkColor
              : MyAppColors.backgroundLightColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
            const Gap(24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: MyAppColors.secondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            GetX<UserLocationController>(
              builder: (controller) => CheckboxListTile(
                value: controller.dontShowAgain.value,
                title: const Text("Don't show again"),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  controller.dontShowAgain.value = value!;
                  Hive.box("user_db").put("dont_show_again", value);
                },
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Not Now",
                      style: TextStyle(color: MyAppColors.secondaryColor),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Allow",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16),
          ],
        ),
      ),
    );
    return result ?? false;
  }

  Future<void> routeTo30DayPlan(BuildContext context,
      {bool isPopUp = false}) async {
    if (isPopUp) context.pop();
    context.push(
      "/daily_ramadan_plan",
      extra: {
        "day": getRamadanNumber(ramadanTodayTimeController.ifter.value ??
            const TimeOfDay(hour: 18, minute: 30))
      },
    );
  }
}
