import "dart:developer";

import "package:flutter/material.dart";

int getRamadanNumber(TimeOfDay iftarTime) {
  DateTime ramadanStart = DateTime(2026, 2, 19);
  DateTime now = DateTime.now();

  DateTime todayIftar =
      DateTime(now.year, now.month, now.day, iftarTime.hour, iftarTime.minute);

  if (now.isBefore(ramadanStart)) {
    return 1;
  }

  int ramadanDay = now.difference(ramadanStart).inDays;

  if (now.isBefore(todayIftar)) {
  } else {
    ramadanDay++;
  }

  if (ramadanDay < 1) {
    ramadanDay = 0;
  } else if (ramadanDay > 30) {
    ramadanDay = 29;
  }
  log(ramadanDay.toString(), name: "Day");
  return ramadanDay + 1;
}

DateTime getDateByRamadanNumber(int day) {
  DateTime ramadanStart = DateTime(2026, 2, 19);
  return ramadanStart.add(Duration(days: day));
}
