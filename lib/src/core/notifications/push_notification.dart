import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mumin/src/core/notifications/service.dart';

Future<void> pushNotifications({
  required int id,
  required String title,
  required String body,
}) async {
  await NotificationsService.initNotifications();
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id, // Must be unique for each notification
      channelKey: 'reminders', // The channel key you created
      title: title,
      body: body,
      actionType: ActionType.KeepOnTop,
    ),
  );
  log('Notification Shown');
}
