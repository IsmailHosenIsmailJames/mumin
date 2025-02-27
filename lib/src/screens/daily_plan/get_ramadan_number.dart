import 'package:flutter/material.dart';

int getRamadanNumber(TimeOfDay iftarTime) {
  DateTime ramadanStart = DateTime(2025, 3,
      1); //corrected: Changed to March 1st, as Ramadan days start from Maghrib
  DateTime now = DateTime.now();

  // Get today's date with the Iftar time.
  DateTime todayIftar =
      DateTime(now.year, now.month, now.day, iftarTime.hour, iftarTime.minute);

  // If the current time is BEFORE today's Iftar, we're still in the *previous* Islamic day.
  int dayOffset = (now.isBefore(todayIftar)) ? -1 : 0;

  // Calculate the difference in days, taking the offset into account.
  int ramadanDay = now.difference(ramadanStart).inDays + dayOffset;

  // Ensure the day is within the valid range (1-30 or 1-29, depending on the lunar calendar).
  if (ramadanDay < 1) {
    ramadanDay = 1; // It's not Ramadan yet.
  } else if (ramadanDay > 30) {
    // Assuming a maximum of 30 days.  Adjust if needed.
    ramadanDay = 30; // Ramadan is over (or the last day).
  }

  return ramadanDay;
}

DateTime getDateByRamadanNumber(int day) {
  DateTime ramadanStart = DateTime(2025, 3, 2);
  return ramadanStart.add(Duration(days: day));
}
