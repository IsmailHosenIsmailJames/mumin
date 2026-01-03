import "dart:convert";

import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:hive_ce/hive.dart";
import "package:http/http.dart";
import "package:mumin/src/apis/apis.dart";
import "package:mumin/src/core/utils/one_placemart_from_multi.dart";
import "package:mumin/src/screens/auth/controller/auth_controller.dart";
import "dart:developer";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:mumin/src/core/location/location_service.dart";
import "package:mumin/src/core/utils/lat_lon.dart";
import "package:mumin/src/screens/home/controller/model/user_location_data.dart";
import "package:mumin/src/screens/home/controller/user_location.dart";
import "package:mumin/src/screens/settings/controller/settings_controller.dart";

class QuranSettingsScreen extends StatefulWidget {
  const QuranSettingsScreen({super.key});

  @override
  State<QuranSettingsScreen> createState() => _QuranSettingsScreenState();
}

class _QuranSettingsScreenState extends State<QuranSettingsScreen> {
  final SettingsController settingsController = Get.put(SettingsController());
  bool isGuest = Hive.box("user_db").get("is_guest") ?? false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quran Settings"),
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              "Arabic Font Size",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              value: settingsController.arabicFontSize.value,
              min: 18.0,
              max: 50.0,
              onChanged: (value) {
                settingsController.arabicFontSize.value = value;
              },
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                style: TextStyle(
                  fontSize: settingsController.arabicFontSize.value,
                  fontFamily: "IndopakNastaleeq",
                  letterSpacing: 0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Bangla Translation Font Size",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              value: settingsController.translationFontSize.value,
              min: 12.0,
              max: 30.0,
              onChanged: (value) {
                settingsController.translationFontSize.value = value;
              },
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "পরম করুণাময়, পরম দয়ালু আল্লাহর নামে (শুরু করছি)",
                style: TextStyle(
                  fontSize: settingsController.translationFontSize.value,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "English Translation Font Size",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              value: settingsController.englishFontSize.value,
              min: 12.0,
              max: 30.0,
              onChanged: (value) {
                settingsController.englishFontSize.value = value;
              },
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "In the name of Allah, the Most Gracious, the Most Merciful.",
                style: TextStyle(
                  fontSize: settingsController.englishFontSize.value,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () async {
                  try {
                    UserLocationController userLocationController =
                        Get.put(UserLocationController());
                    LocationPermission locationPermission =
                        await Geolocator.checkPermission();

                    if (locationPermission == LocationPermission.denied ||
                        locationPermission ==
                            LocationPermission.deniedForever) {
                      locationPermission = await LocationService()
                          .requestAndGetLocationPermission();
                    }

                    if (locationPermission == LocationPermission.whileInUse ||
                        locationPermission == LocationPermission.always) {
                      Position? location =
                          await LocationService().getCurrentLocation();
                      if (location != null) {
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                location.latitude, location.longitude);
                        UserLocationData userLocationData = UserLocationData(
                            latitude: location.latitude,
                            longitude: location.longitude,
                            placemark: onePlacemarkFromMulti(placemarks));

                        await Hive.box("user_db").put(
                            "user_location_info", userLocationData.toJson());
                        userLocationController.locationData.value =
                            userLocationData;
                        Fluttertoast.showToast(
                            msg: "Location Updated Successfully");
                      } else {
                        // Fallback to manual
                        if (context.mounted) {
                          final result =
                              await context.push("/manual_location_selection");
                          _handleManualLocationResult(
                              result, userLocationController);
                        }
                      }
                    } else {
                      // Fallback to manual
                      if (context.mounted) {
                        final result =
                            await context.push("/manual_location_selection");
                        _handleManualLocationResult(
                            result, userLocationController);
                      }
                    }
                  } catch (e) {
                    log(e.toString());
                  }
                },
                leading: const Icon(FluentIcons.location_24_regular),
                title: const Text("Update User Location"),
              ),
            ),
            const Gap(24),
            if (!isGuest)
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Are you sure?"),
                          content: const Text(
                              "This action will delete all the data associated with your account. Are you sure you want to proceed?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel")),
                            TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  AuthController authController =
                                      Get.put(AuthController());

                                  final response = await post(
                                    Uri.parse(baseApi + deleteAccount),
                                    body: jsonEncode({
                                      "mobile_number": authController
                                          .user.value?.mobileNumber,
                                    }),
                                    headers: {
                                      "Content-Type": "application/json"
                                    },
                                  );
                                  if (response.statusCode == 200) {
                                    context.go("/login");
                                    authController.user.value = null;
                                    Fluttertoast.showToast(
                                        msg: "Account Deleted Successfully");
                                  }
                                },
                                child: const Text("Delete")),
                          ],
                        );
                      },
                    );
                  },
                  leading: const Icon(
                    FluentIcons.delete_24_filled,
                    color: Colors.red,
                  ),
                  title: const Text("Delete Account & Logout"),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _handleManualLocationResult(
      dynamic result, UserLocationController userLocationController) async {
    if (result is String) {
      try {
        Map<String, dynamic> data = jsonDecode(result);
        LatLon latLon = LatLon.fromMap(data);
        UserLocationData userLocationData = UserLocationData(
          latitude: latLon.latitude,
          longitude: latLon.longitude,
        );

        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(latLon.latitude, latLon.longitude);
          userLocationData.placemark = onePlacemarkFromMulti(placemarks);
        } catch (e) {
          log("Geocoding failed: $e");
        }

        await Hive.box("user_db")
            .put("user_location_info", userLocationData.toJson());
        userLocationController.locationData.value = userLocationData;
        Fluttertoast.showToast(msg: "Location Updated Successfully");
      } catch (e) {
        log("Geocoding failed: $e");
        Fluttertoast.showToast(msg: "Location Update Failed");
      }
    } else {
      log("Manual location selection failed: $result");
    }
  }

  Future<void> handleManualLocationResult(
      dynamic result, UserLocationController userLocationController) async {
    if (result is String) {
      try {
        Map<String, dynamic> data = jsonDecode(result);
        LatLon latLon = LatLon.fromMap(data);
        UserLocationData userLocationData = UserLocationData(
          latitude: latLon.latitude,
          longitude: latLon.longitude,
        );

        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(latLon.latitude, latLon.longitude);
          userLocationData.placemark = onePlacemarkFromMulti(placemarks);
        } catch (e) {
          log("Geocoding failed: $e");
        }

        await Hive.box("user_db")
            .put("user_location_info", userLocationData.toJson());
        userLocationController.locationData.value = userLocationData;
        Fluttertoast.showToast(msg: "Location Updated Successfully");
      } catch (e) {
        log("Manual location selection failed: $e");
      }
    }
  }
}
