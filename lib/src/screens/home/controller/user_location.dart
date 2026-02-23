import "package:get/get.dart";
import "package:hive_ce/hive.dart";
import "package:mumin/src/screens/home/controller/model/user_location_data.dart";

class UserLocationController extends GetxController {
  Rx<UserLocationData?> locationData = Rx<UserLocationData?>(null);
  RxBool dontShowAgain = RxBool(false);
  @override
  void onInit() {
    final box = Hive.box("user_db");
    var userLocation = box.get("user_location_info", defaultValue: null);

    // Migration for old users who have data under "user_location"
    if (userLocation == null) {
      userLocation = box.get("user_location", defaultValue: null);
      if (userLocation != null) {
        box.put("user_location_info", userLocation);
      }
    }

    if (userLocation != null) {
      try {
        locationData.value = UserLocationData.fromJson(userLocation);
      } catch (e) {
        // ignore errors
      }
    }
    super.onInit();
  }
}
