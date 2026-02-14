import "package:get/get.dart";
import "package:mumin/src/screens/home/controller/model/user_calander_day_model.dart";

class UserLocationCalender extends GetxController {
  Rx<List<RamadanDayModel>?> userLocationCalender =
      Rx<List<RamadanDayModel>?>(null);

  Rx<List<RamadanDayModel>?> userLocationRamadanCalender =
      Rx<List<RamadanDayModel>?>(null);
}
