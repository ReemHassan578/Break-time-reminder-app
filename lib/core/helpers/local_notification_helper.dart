import 'dart:developer';

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

  static Future<void> initializeNotifications() async {
    final initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings('app_icon'),
      iOS: const DarwinInitializationSettings(),
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _initializeTimeZone();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
   
  }

  /// Initializes the time zone for the local notifications plugin.
  static Future<void> _initializeTimeZone() async {
    tz.initializeTimeZones();
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  static void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }

    final isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime') ?? false;
    final workSession = HiveHelper.workSessionBox.values.first;
  
  
  final NotificationAppLaunchDetails? details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
   
 if (details?.didNotificationLaunchApp ?? false) {
      log('App launched from notification');
    }else{
      log('App launched normally');
    }
    if (isBreakTime) {
      HiveHelper.isBreakTimeBox.put('isBreakTime', false);
      
    } else {
      final breakDuration = workSession.breakDuration;
      final timeNow = TimeOfDay.now();
      final workTo = workSession.workTo;

     if (HiveHelper.notificationBox.isNotEmpty) {
      HiveHelper.notificationBox.deleteAt(0);
    }
      HiveHelper.isBreakTimeBox.put('isBreakTime', true);
      scheduleBreakNotifications(
        breakDuration,
        timeNow,
        TimeOfDay(hour: workTo, minute: 0),
        isForBreakEnd: true,
      );
         
    }

    BreakTimeReminderApp.navigatorKey.currentState?.pushReplacementNamed(
      Routes.notificationScreen,
      arguments: {
       'isFromNotification': details?.didNotificationLaunchApp
      }
    );

    
  }

  static Future<void> fetchAllNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
 
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (final notification in pendingNotifications) {

      
      // Process the notification details as needed
      print(
          " Title: ${notification.title}, Body: ${notification.body}, Payload: ${notification.payload}");
    }
  }

  /// Cancels all scheduled notifications and clears the notification box.
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    await HiveHelper.notificationBox.clear();
    await HiveHelper.isBreakTimeBox.clear();
  }

  static Future<void> scheduleBreakNotifications(
      int breakOccurrenceInMinutes, TimeOfDay startTime, TimeOfDay endTime,
      {int? breakDuration, bool? isForBreakEnd}) async {
    final now = tz.TZDateTime.now(tz.local);

    final startDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,

      //startTime.minute,
    );
    final endDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      endTime.hour,
      0,
    );
    List<tz.TZDateTime> scheduledTimes = [];
    tz.TZDateTime scheduleTime =
        startDateTime.add(Duration(minutes: breakOccurrenceInMinutes));
    // If the start time is in the past, move it to the next cycle
    if (isForBreakEnd == true ) {
      scheduleTime =
          startDateTime.add(Duration(minutes: breakOccurrenceInMinutes));
    } else {
      while (scheduleTime.isBefore(now) ) {
        scheduleTime = scheduleTime
            .add(Duration(minutes: breakOccurrenceInMinutes))
            .add(Duration(minutes: breakDuration!));
        log('scheduleTime inside first while: $scheduleTime');
      }
    }

    // tz.TZDateTime scheduleTime = startDateTime.isBefore(now)
    //     ? startDateTime.add(Duration(minutes: breakOccurrenceInMinutes))
    //     : startDateTime;
    // print(startDateTime);
    //   print(endDateTime);

    // isForBreakEnd == true
    //     ? print('breakDuration: $scheduleTime')
    //     : print('scheduleTime first time: $scheduleTime');
    // //   print(breakOccurrenceInMinutes);

    try {
      final String? alarmUri =
          await platform.invokeMethod<String>('getAlarmUri');

      if (alarmUri == null) {
        return;
      }

      final UriAndroidNotificationSound uriSound =
          UriAndroidNotificationSound(alarmUri);
      print('scheduleTime: $scheduleTime');
      print('endtime $endDateTime');
      print('bool value is Before ${scheduleTime.isBefore(endDateTime)}');
      print(isForBreakEnd);
      while (scheduleTime.isBefore(endDateTime)) {
        scheduledTimes.add(scheduleTime);

        await flutterLocalNotificationsPlugin.zonedSchedule(
            scheduleTime.millisecondsSinceEpoch
                .remainder(1 << 31), // Unique ID for each notification
            scheduleTime.toString(),
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
        print("isForBreakEnd $isForBreakEnd  ");
        if (isForBreakEnd == true) {
          await HiveHelper.breakEndNotificationTimeBox
              .put('breakEndNotification', scheduleTime.toString());
          print('scheduale in break scheds method $scheduleTime');
          return;
        }
        // Move to the next break time
        scheduleTime = scheduleTime
            .add(Duration(minutes: breakDuration!))
            .add(Duration(minutes: breakOccurrenceInMinutes));
        print('scheduleTime end while loooooooooooop: $scheduleTime');
      }
      // print('scheduleTime: $scheduleTime');
      HiveHelper.notificationBox.addAll(scheduledTimes
          .map((tz.TZDateTime e) => NotificationModel(
              id: e.millisecondsSinceEpoch.remainder(1 << 31).toString(),
              scheduledTime: e.toString()))
          .toList());
      print(scheduledTimes);
    } catch (e) {
      print('error in platform');
    }
  }
}
