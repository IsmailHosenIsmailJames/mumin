import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mumin/src/theme/colors.dart';

class NotificationsService {
  static Future<void> initNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'reminders',
          channelName: 'Used for Reminders',
          channelDescription: 'This channel is used for Reminders.',
          defaultColor: MyAppColors.primaryColor,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'take_medicine') {
      await Hive.initFlutter();
      await Hive.close();
      final actionsBox = await Hive.openBox('actions');
      await actionsBox.put('redirect', {DateTime.now().millisecondsSinceEpoch});
    }
    log('onActionReceivedMethod');
  }

  static Future<void> onNotificationCreatedMethod(receivedNotification) async {
    log('onNotificationCreatedMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
      receivedNotification) async {
    log('onNotificationDisplayedMethod');
  }

  static Future<void> onDismissActionReceivedMethod(receivedAction) async {
    log('onDismissActionReceivedMethod');
  }
}
