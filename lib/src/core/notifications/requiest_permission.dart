import "package:awesome_notifications/awesome_notifications.dart";

Future<bool> requestPermissionsAwesomeNotifications() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  return isAllowed;
}
