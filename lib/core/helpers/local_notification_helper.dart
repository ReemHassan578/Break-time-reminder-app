import 'package:break_time_reminder_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../../break_time_reminder_app.dart';
import '../../features/home/data/models/notification_model.dart';
import 'hive_helper.dart';

class LocalNotificationHelper {
  static const platform = MethodChannel('alarm');
  static late final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin;

  static Future<void> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _initTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
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
      debugPrint('notification payload: $payload');
    }

    final bool? isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime');
    if (isBreakTime == true) {
      HiveHelper.isBreakTimeBox.put('isBreakTime', false);
    } else {
      var breakDuration = HiveHelper.workSessionBox.values.first.breakDuration;
      var workFrom = HiveHelper.workSessionBox.values.first.workFrom;
      var workTo = HiveHelper.workSessionBox.values.first.workTo;
      var timeNow = TimeOfDay.now();

      HiveHelper.isBreakTimeBox.put('isBreakTime', true);
      scheduleBreakNotifications(
          breakDuration,
          TimeOfDay(hour: workFrom, minute: timeNow.minute),
          TimeOfDay(hour: workTo, minute: timeNow.minute),
          isForBreakEnd: true);
    }

    BreakTimeReminderApp.navigatorKey.currentState?.pushReplacementNamed(
      Routes.notificationScreen,
    );

    // HiveHelper.notificationBox.values.first.removeAt(0);
  }

  static Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    HiveHelper.notificationBox.clear();
    HiveHelper.isBreakTimeBox.clear();
  }

  static void scheduleBreakNotifications(
      int breakOccurrenceInMinutes, TimeOfDay startTime, TimeOfDay endTime,
      {bool? isForBreakEnd}) async {
    final now = tz.TZDateTime.now(tz.local);

    final startDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );
    final endDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      endTime.hour,
      endTime.minute,
    );
    List<tz.TZDateTime> scheduledTimes = [];

    // If the start time is in the past, move it to the next cycle
    tz.TZDateTime scheduleTime = startDateTime.isBefore(now)
        ? startDateTime.add(Duration(minutes: breakOccurrenceInMinutes))
        : startDateTime;
    // print(startDateTime);
    //   print(endDateTime);
    //   print(scheduleTime);
    //   print(breakOccurrenceInMinutes);

    try {
      final String? alarmUri =
          await platform.invokeMethod<String>('getAlarmUri');

      if (alarmUri == null) {
        return;
      }

      final UriAndroidNotificationSound uriSound =
          UriAndroidNotificationSound(alarmUri);

      while (scheduleTime.isBefore(endDateTime)) {
        scheduledTimes.add(scheduleTime);

        await flutterLocalNotificationsPlugin.zonedSchedule(
            scheduleTime.millisecondsSinceEpoch
                .remainder(1 << 31), // Unique ID for each notification
            'Break Time Reminder',
            'Time for a break! Stay refreshed.',
            scheduleTime,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'break_channel_id',
                'Break Notifications',
                channelDescription:
                    'Notifies users to take breaks at scheduled intervals',
                audioAttributesUsage: AudioAttributesUsage.alarm,
                importance: Importance.high,
                sound: uriSound,
                visibility: NotificationVisibility.public,
                priority: Priority.high,
                fullScreenIntent: true,
              ),
            ),
            matchDateTimeComponents: DateTimeComponents.time,
            androidScheduleMode: AndroidScheduleMode.alarmClock);
        if (isForBreakEnd == true) {
          break;
        }
// save notification expected time

        // Move to the next break time
        scheduleTime =
            scheduleTime.add(Duration(minutes: breakOccurrenceInMinutes));
      }
      HiveHelper.notificationBox.addAll(scheduledTimes
          .map((tz.TZDateTime e) => NotificationModel(
              id: e.millisecondsSinceEpoch.remainder(1 << 31).toString(),
              scheduledTime: e.toString()))
          .toList());
    } catch (e) {
      print('error in platform');
    }
  }
}
