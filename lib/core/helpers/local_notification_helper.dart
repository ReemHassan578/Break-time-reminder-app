import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class LocalNotificationHelper {
  static late final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin;

  static Future<void> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await  _initTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
       );
  }

 static Future<void> _initTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timeZoneName));
   // print(tz.TZDateTime.now(tz.local));
  }

  static void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
    //  debugPrint('notification payload: $payload');
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      ' channel id',
      'channel name',
      channelDescription: ' channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

static void scheduleBreakNotifications(int breakDurationInMinutes, TimeOfDay startTime, TimeOfDay endTime) async {
  final now = tz.TZDateTime.now(tz.local);
  final startDateTime = tz.TZDateTime(
    tz.local, now.year, now.month, now.day, startTime.hour, startTime.minute,
  );
  final endDateTime = tz.TZDateTime(
    tz.local, now.year, now.month, now.day, endTime.hour, endTime.minute,
  );

  // If the start time is in the past, move it to the next cycle
  var scheduleTime = startDateTime.isBefore(now) ? startDateTime.add(Duration(minutes: breakDurationInMinutes)) : startDateTime;

  while (scheduleTime.isBefore(endDateTime)) {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      scheduleTime.millisecondsSinceEpoch, // Unique ID for each notification
      'Break Time Reminder',
      'Time for a break! Stay refreshed.',
      scheduleTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'break_channel_id',
          'Break Notifications',
          channelDescription: 'Notifies users to take breaks at scheduled intervals',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
       matchDateTimeComponents: DateTimeComponents.time, 
       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );

    // Move to the next break time
    scheduleTime = scheduleTime.add(Duration(minutes: breakDurationInMinutes));
  }
}



  // static Future<void> cancelAllNotifications() async {
  //   await _flutterLocalNotificationsPlugin.cancelAll();
  // }

  // static Future<void> onSelectNotification(String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  // }

  // static Future<void> onDidReceiveLocalNotification(
  //     int id, String title, String body, String payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     context: Get.context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title),
  //       content: Text(body),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () {
  //             // Navigator.of(context, rootNavigator: true).pop();
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
}
