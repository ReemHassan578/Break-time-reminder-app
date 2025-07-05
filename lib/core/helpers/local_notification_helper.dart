import 'dart:developer';

import 'package:break_time_reminder_app/core/routing/routes.dart';
import 'package:break_time_reminder_app/features/home/data/models/work_session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../../break_time_reminder_app.dart';
import '../../features/home/data/models/notification_model.dart';
import '../../features/home/presentation/manager/break_duration_provider.dart';
import '../../features/home/presentation/manager/break_occurrence_provider.dart';
import '../../features/home/presentation/manager/timer_provider.dart';
import 'hive_helper.dart';
import 'native_helper.dart';
import 'time_helper.dart';

class LocalNotificationHelper {
  static late final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin;

  static void Function(NotificationResponse)? onNotificationTap;

  static Future<void> preInitializeNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: DarwinInitializationSettings(),
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _initializeTimeZone();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) async {
        await _onDidReceiveNotificationResponse(notificationResponse);
        if (onNotificationTap != null) {
          onNotificationTap!(notificationResponse);
        }
      },
    );
  }

  static void initializeNotificationCallback(ref) {

    onNotificationTap = (notificationResponse) {
      //    log(' inside initializeNotificationCallback');

      final bool? isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime');
      if (isBreakTime == true && notificationResponse.payload != 'isEndHour') {
        ref.read(timerProvider.notifier).startTimer(
              Duration(minutes: ref.read(breakDurationProvider)),
            );
             //         log(' inside true');

      } else if(isBreakTime == false && notificationResponse.payload != 'isEndHour'){
        ref.read(timerProvider.notifier).startTimer(
              Duration(minutes: ref.read(breakOccurrenceProvider)),

            );
                         //           log(' inside else');

      }
    };
  }

  /// Initializes the time zone for the local notifications plugin.
  static Future<void> _initializeTimeZone() async {
    tz.initializeTimeZones();
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  static Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final notificationPayload = notificationResponse.payload;
  
    if (notificationPayload == 'isStartHour') {
    await  _handleStartHour();
    } else if (notificationPayload == 'isEndHour') {
     await _handleEndHour();
    } else {
     await _handleBreakTime();
    }

    BreakTimeReminderApp.navigatorKey.currentState
        ?.pushNamed(Routes.notificationScreen, arguments: {
      'isEndHour': notificationPayload == 'isEndHour'
          ? true
          : notificationPayload == 'isStartHour'
              ? false
              : null,
    });
  }

  static Future<void> _handleStartHour()async {
   await  _resetBreakTime();
  }

  static Future<void> _handleEndHour()async {
   await     HiveHelper.isBreakTimeBox.put('isBreakTime', true);

  }

  static Future<void> _handleBreakTime() async{
    final isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime') ?? false;

    if (isBreakTime) {
     await _resetBreakTime();
    } else {
      _setBreakTime();
    }
  }

  static Future<void> _resetBreakTime()async {
   await HiveHelper.isBreakTimeBox.put('isBreakTime', false);
  }

  static Future<void> _setBreakTime() async{
    final workSession = HiveHelper.workSessionBox.values.first;
    final breakDuration = workSession.breakDuration;
    final timeNow = TimeOfDay.now();
    final workTo = workSession.workTo;

    if (HiveHelper.notificationBox.isNotEmpty) {
      HiveHelper.notificationBox.deleteAt(0);
    }

   await HiveHelper.isBreakTimeBox.put('isBreakTime', true);
    scheduleBreakNotifications(
      breakDuration,
      timeNow,
      TimeOfDay(hour: workTo, minute: 0),
      isForBreakEnd: true,
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
  static Future<void> resetNotificationsState() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    await _clearHive();
    await _markCurrentWorkSessionAsIdeal();
  }

  static Future<void> _clearHive() async {
    await HiveHelper.notificationBox.clear();
    await HiveHelper.breakEndNotificationTimeBox.clear();
    await HiveHelper.isBreakTimeBox.clear();
  }

  static Future<void> _markCurrentWorkSessionAsIdeal() async {
    WorkSessionModel? workSession = HiveHelper.workSessionBox.get('session');
    workSession?.isIdle = true;
   await workSession?.save();
 //  log('work session is ideal ${workSession?.isIdle}');
  }


  static Future<void> scheduleBreakNotifications(
      int breakOccurrenceInMinutes, TimeOfDay startTime, TimeOfDay endTime,
      {int? breakDuration, bool? isForBreakEnd}) async {
    var startAndEndTime = getStartAndEndTime(startTime, endTime);
    var startDateTime = startAndEndTime['start']!;
    var endDateTime = startAndEndTime['end']!;

    List<tz.TZDateTime> scheduledTimes = [];
   if(isForBreakEnd==null && startDateTime.isAfter(DateTime.now())){ await scheduleLocalNotification(
      startDateTime,
      isStartHour: true,
    );}
    if(endDateTime.isAfter(DateTime.now()))
    {await scheduleLocalNotification(
      endDateTime,
      isStartHour: false,
    );}

    // Initial schedule time calculation
    tz.TZDateTime scheduleTime;
    scheduleTime = _getInitialValidScheduledTime(startDateTime,
        breakOccurrenceInMinutes, isForBreakEnd, endDateTime, breakDuration);

    while (scheduleTime.isBefore(endDateTime) ) {
      scheduledTimes.add(scheduleTime);

      await scheduleLocalNotification(scheduleTime,
          isForBreakEnd: isForBreakEnd);
      // print("isForBreakEnd $isForBreakEnd  ");
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
    }
    // print('scheduleTime: $scheduleTime');
    HiveHelper.notificationBox.addAll(scheduledTimes
        .map((tz.TZDateTime e) => NotificationModel(
            id: e.millisecondsSinceEpoch.remainder(1 << 31).toString(),
            scheduledTime: e.toString()))
        .toList());
    print(scheduledTimes);
  }

  static Future<void> scheduleLocalNotification(tz.TZDateTime scheduleTime,
      {bool? isForBreakEnd, bool? isStartHour}) async {
    try {
      final String? alarmUri =
          await NativeHelper.platform.invokeMethod<String>(NativeHelper.getAlarmUri);

      if (alarmUri == null) {
        return;
      }

      final UriAndroidNotificationSound uriSound =
          UriAndroidNotificationSound(alarmUri);
      await flutterLocalNotificationsPlugin.zonedSchedule(
          scheduleTime.millisecondsSinceEpoch
              .remainder(1 << 31), // Unique ID for each notification
          'Reminder',
            scheduleTime.toString(),
          // isForBreakEnd == true
          //     ? 'Time for a break! Stay refreshed.'
          //     : (isForBreakEnd == null && isStartHour == true
          //         ? 'Time to Work! Stay focused.'
          //         : (isStartHour == false?'working time has been over!':'Time for a break! Stay refreshed.')),
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
          payload: isStartHour == false
              ? 'isEndHour'
              : (isStartHour == true ? 'isStartHour' : null),
        //  matchDateTimeComponents: DateTimeComponents.time,
          androidScheduleMode: AndroidScheduleMode.alarmClock);
        //  log('log payload $scheduleTime isStartHour $isStartHour');
    } catch (e) {
      print('error in platform');
    }
  }

  static tz.TZDateTime _getInitialValidScheduledTime(
    tz.TZDateTime startDateTime,
    int breakOccurrenceInMinutes,
    bool? isForBreakEnd,
    tz.TZDateTime endDateTime,
    int? breakDuration,
  ) {
    var firstScheduledTime =
        startDateTime.add(Duration(minutes: breakOccurrenceInMinutes));
    tz.TZDateTime scheduleTime;
    if (isForBreakEnd == null) {
      while (firstScheduledTime.isBefore(DateTime.now()) &&
          firstScheduledTime.isBefore(endDateTime)) {
        firstScheduledTime = firstScheduledTime
            .add(Duration(minutes: breakOccurrenceInMinutes))
            .add(Duration(minutes: breakDuration!));
 }
      scheduleTime = firstScheduledTime;
    }
    // If the start time is in the past, move it to the next cycle

    else {
      scheduleTime =
          startDateTime.add(Duration(minutes: breakOccurrenceInMinutes));
    }

    return scheduleTime;
  }
}
