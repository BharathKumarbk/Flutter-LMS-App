import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterNotificationProvider extends ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future showNotification(int id, String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
        "channelId", "Merit Coaching", "App to learn",
        importance: Importance.max);
    var iosDetails = IOSNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }
}
