import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> requestPermissionsAwesomeNotifications() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
