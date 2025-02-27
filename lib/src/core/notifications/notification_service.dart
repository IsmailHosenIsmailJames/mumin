import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mumin/src/screens/daily_plan/get_ramadan_number.dart';

// ... (Your other code, including getRamadanNumber and _nextInstanceOfTimeOfDay)

class NotificationService {
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelGroupKey: 'ramadan_notifications_group',
          channelKey: 'ramadan_notifications',
          channelName: 'Ramadan Notifications',
          channelDescription: 'Notifications for Ramadan daily reminders',
          defaultColor: Colors.teal,
          ledColor: Colors.white,
          importance: NotificationImportance.High, // Show as popup
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'ramadan_notifications_group',
            channelGroupName: 'Ramadan Notifications')
      ],
      debug: true, // Set to false in production
    );

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. You'll need to handle
        // user interaction and gracefully handle the case where permissions
        // are denied.
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<void> scheduleDailyRamadanNotification(
      TimeOfDay iftarTime) async {
    int ramadanDay = getRamadanNumber(iftarTime);
    if (ramadanDay > 0 && ramadanDay <= 30) {
      // Ramadan is active
      DateTime notificationTime =
          _nextInstanceOfTimeOfDay(const TimeOfDay(hour: 18, minute: 40));

      // Debugging: Print the scheduled time
      print("Scheduling notification for: $notificationTime");

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: ramadanDay, // Unique ID for each day, allows for replacing, good practice.
          channelKey: 'ramadan_notifications',
          title: 'Ramadan Day $ramadanDay',
          body:
              "It's almost Iftar time!  Prepare for your meal.", // Customize your message
          notificationLayout:
              NotificationLayout.Default, // Or BigPicture, BigText, etc.
        ),
        actionButtons: [
          // optional actions, like snooze, open app, etc.
          NotificationActionButton(
              key: "OPEN_APP", label: "Open App") //Simple action button
        ],
        schedule: NotificationCalendar.fromDate(date: notificationTime),
      );
      print("Notification is scheduled at time $notificationTime");
    } else {
      //Cancel the notification, if the ramadan time is not ok.
      await AwesomeNotifications().cancelAll();
      print("Ramadan is not active. No notification scheduled.");
    }
  }

  // Helper function to get the next instance of a TimeOfDay (same as before)
  static DateTime _nextInstanceOfTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    DateTime nextInstance = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (nextInstance.isBefore(now)) {
      nextInstance = nextInstance.add(const Duration(days: 1));
    }
    return nextInstance;
  }

  // Function to cancel all scheduled notifications, use this, When ramadan end.
  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  // You can add more methods for other notification types (Sehri, etc.)
}
