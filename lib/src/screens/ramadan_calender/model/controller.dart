import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RamadanTodayTimeController extends GetxController {
  Rx<TimeOfDay?> sehri = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> ifter = Rx<TimeOfDay?>(null);
}
