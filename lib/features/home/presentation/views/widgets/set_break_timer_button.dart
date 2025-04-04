//import 'dart:developer';

import 'package:break_time_reminder_app/core/helpers/hive_helper.dart';
import 'package:break_time_reminder_app/features/home/data/models/work_session_model.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/break_duration_provider.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/break_occurrence_provider.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/working_hours_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/helpers/local_notification_helper.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../manager/status_work_or_break_provider.dart';
import '../../manager/timer_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class SetBreakTimeButton extends ConsumerWidget {
  const SetBreakTimeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var workingHoursRefValue = ref.watch(workingHoursProvider);
    var isTimerRunning = ref.watch(timerProvider).isRunning;
    var workOrBreakStatus = ref.watch(statusWorkOrBreakProvider);
    final now = tz.TZDateTime.now(tz.local);
    var breakOccurrence = ref.watch(breakOccurrenceProvider);
    final startDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      workingHoursRefValue['from']!,
      0,

      //startTime.minute,
    );
    final endDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      workingHoursRefValue['to']!,
      0,
    );
    Duration remainingTime = Duration.zero;
    tz.TZDateTime scheduleTime =
        startDateTime.add(Duration(minutes: breakOccurrence));
    bool isReachEndTime = now.isAfter(endDateTime);
    print('isReachEndTime $isReachEndTime $now $endDateTime');
    if (!isReachEndTime) {
      scheduleTime = workOrBreakStatus == StatusWorkOrBreak.working
          ? startDateTime.add(Duration(minutes: breakOccurrence))
          : startDateTime
              .add(Duration(minutes: breakOccurrence))
              .add(Duration(minutes: ref.watch(breakDurationProvider)));
    } else {
      scheduleTime = startDateTime;
    }
    print('test   schedddudualed $scheduleTime');
 //   log('scheduleTime first time  before while widget set: $scheduleTime');
    while (scheduleTime.isBefore(now) && scheduleTime.isBefore(endDateTime)) {
      scheduleTime =
          //workOrBreakStatus==StatusWorkOrBreak.working?
          scheduleTime
              .add(Duration(minutes: breakOccurrence))
              .add(Duration(minutes: ref.watch(breakDurationProvider)));
      //: scheduleTime
      //.add(Duration(minutes: ref.watch(breakDurationProvider))) ;
   //   log('scheduleTime inside first while  widget set : $scheduleTime');
      if (HiveHelper.hasScheduledNotification) {
        print(
            'time  first schedule in hive ${HiveHelper.notificationBox.values.first.scheduledTime}');
      }
    }

    return FilledButton(
        onPressed: isTimerRunning || isReachEndTime
            ? null
            : () async {
                if (HiveHelper.hasScheduledNotification) {
                  remainingTime = getRemainingTime(
                      HiveHelper.notificationBox.values.first.scheduledTime);
                  print('remainingTime  first schedule in hive $remainingTime');
                } 
                else if(!HiveHelper.hasScheduledNotification){
 
  remainingTime = getRemainingTime(
          endDateTime.toString());
      print(' no coming notifications $remainingTime');
      ref.read(timerProvider.notifier).startTimer(remainingTime);
    }
                else {
                  //     DateTime.now().add(Duration(minutes: breakOccurrence));
                  remainingTime = scheduleTime.difference(DateTime.now());
                }

                if (workingHoursRefValue['from']! !=
                    workingHoursRefValue['to']!) {
                  HiveHelper.workSessionBox.put(
                      'session',
                      WorkSessionModel(
                          workFrom: workingHoursRefValue['from']!,
                          workTo: workingHoursRefValue['to']!,
                          breakDuration: ref.watch(breakDurationProvider),
                          breakOccurrence: breakOccurrence));

                  ref.read(timerProvider.notifier).startTimer(remainingTime
                      //  Duration(
                      //     hours: 0,
                      //     minutes: 2,
                      //   ),
                      );
                  LocalNotificationHelper.scheduleBreakNotifications(
                      //  4,
                      ref.read(breakOccurrenceProvider),
                      TimeOfDay(hour: workingHoursRefValue['from']!, minute: 0),
                      TimeOfDay(hour: workingHoursRefValue['to']!, minute: 0),
                      breakDuration:
                          //
                          //    1
                          ref.read(breakDurationProvider));
                  ref
                      .read(breakDurationProvider.notifier)
                      .setBreakDuration(ref.watch(breakDurationProvider));
                }
              },
        child: Text('set'));
  }
}
