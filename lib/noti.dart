/*
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = AndroidInitializationSettings(
        'mipmap/ic_launcher'); // Replace with your icon
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      'channel_id 6',
      'channelName',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, not);
  }
}
*/
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/logo'); // Replace with your icon
    // var initializationSettingsIOS = IOSFlutterLocalNotificationsPlugin(); // Add iOS settings if needed
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS; // Add iOS settings if needed
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id6', // Change channel_id to avoid spaces
      'channelName',
      playSound: true,
      // Replace with your notification sound
      importance: Importance.max,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await fln.show(id, title, body, notificationDetails, payload: payload);

  }
}
