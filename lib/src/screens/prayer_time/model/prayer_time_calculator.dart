import 'package:flutter/material.dart';
import 'package:mumin/src/screens/prayer_time/model/prayer_time_model.dart';

class PrayerTimeCalculator {
  // Encapsulate in a class for better organization

  List<SinglePrayerTime> getAllPrayerTime(PrayerTimeModel prayerTimeModel) {
    List<SinglePrayerTime> listOfSinglePrayerTime = [
      SinglePrayerTime(
          name: 'Fajr',
          timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.fajr)),
      SinglePrayerTime(
          name: 'Dhuhr',
          timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.dhuhr)),
      SinglePrayerTime(
          name: 'Asr',
          timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.asr)),
      SinglePrayerTime(
          name: 'Maghrib',
          timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.maghrib)),
      SinglePrayerTime(
          name: 'Isha',
          timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.isha)),
    ];
    return listOfSinglePrayerTime;
  }

  SinglePrayerTime getNextPrayerTime(PrayerTimeModel prayerTimeModel) {
    List<SinglePrayerTime> listOfSinglePrayerTime =
        getAllPrayerTime(prayerTimeModel);

    //log(listOfSinglePrayerTime[4].timeOfDay.hour.toString()); // Removed unnecessary log

    final now = TimeOfDay.now(); // Use the current time
    final nowInMinutes = now.hour * 60 + now.minute;

    for (int i = 0; i < listOfSinglePrayerTime.length; i++) {
      // Iterate through ALL prayer times
      SinglePrayerTime singlePrayerTime = listOfSinglePrayerTime[i];
      final prayerTimeInMinutes = singlePrayerTime.timeOfDay.hour * 60 +
          singlePrayerTime.timeOfDay.minute;

      if (prayerTimeInMinutes > nowInMinutes) {
        return listOfSinglePrayerTime[i]; // Return the *current* prayer time
      }
    }

    // If we get here, it means the current time is *after* all prayer times.
    // So, the next prayer time is Fajr of the *next* day.
    return listOfSinglePrayerTime[0];
  }

  TimeOfDay getTimeOfDayFormTimeString(String timeString) {
    List<String> parts = timeString.split(' ');
    int hour = int.parse(parts[0].split(':')[0]);
    int min = int.parse(parts[0].split(':')[1]);
    if (timeString.toLowerCase().endsWith('pm') && hour != 12) {
      // Convert to lowercase for robustness
      hour = hour + 12;
    } else if (timeString.toLowerCase().endsWith('am') && hour == 12) {
      hour = 0;
    }
    return TimeOfDay(hour: hour, minute: min);
  }
}
