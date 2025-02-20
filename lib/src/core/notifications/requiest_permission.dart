import 'package:awesome_notifications/awesome_notifications.dart';

void requestPermissionsAwesomeNotifications() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
