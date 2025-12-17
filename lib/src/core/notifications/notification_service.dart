import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class NotificationService {
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'ramadan_notifications_group',
          channelKey: 'ramadan_notifications',
          channelName: 'Ramadan Notifications',
          channelDescription: 'Notifications for Ramadan daily reminders',
          defaultColor: Colors.teal,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'ramadan_notifications_group',
            channelGroupName: 'Ramadan Notifications')
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<void> scheduleDailyRamadanNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'ramadan_notifications',
        title: 'Today\'s Ramadan Plans are ready!',
        body: 'Open app to see today\'s Ramadan plan...',
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(key: 'OPEN_APP', label: 'Open App')
      ],
      schedule: NotificationCalendar(
        hour: 18,
        minute: 40,
        second: 0,
        millisecond: 0,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
