//import 'dart:developer';

import 'dart:developer';

import 'package:break_time_reminder_app/core/helpers/hive_helper.dart';
import 'package:break_time_reminder_app/features/home/data/models/work_session_model.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/break_duration_provider.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/break_occurrence_provider.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/status_idle_or_not_provider.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/working_hours_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/helpers/local_notification_helper.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/widgets/custom_button.dart';
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
    var timerRef = ref.watch(timerProvider);
    final now = tz.TZDateTime.now(tz.local);
    var startAndEndTime = getStartAndEndTime(
        TimeOfDay(hour: workingHoursRefValue['from'] ?? 0, minute: 0),
        TimeOfDay(hour: workingHoursRefValue['to'] ?? 0, minute: 0));
    var startDateTime = startAndEndTime['start']!;
    var endDateTime = startAndEndTime['end']!;
    bool isReachEndTime = now.isAfter(endDateTime);
    tz.TZDateTime scheduleTime;
    //startDateTime.add(Duration(minutes: breakOccurrence));

    final isSessionIdle = ref.watch(statusIdleOrNotProvider);

    return CustomButton(
        text: 'set',
        onPressed: ((timerRef.isRunning || isReachEndTime) && !isSessionIdle)
            ? null
            : () async {
                  var workingHoursRefValue = ref.read(workingHoursProvider);

                var breakOccurrence = ref.read(breakOccurrenceProvider);

                scheduleTime = await _getInitialScheduledTime(
                  ref: ref,
                  breakOccurrence: breakOccurrence,
                  startDateTime: startDateTime,
                  endDateTime: endDateTime,
                );
 log('set testttt $endDateTime $startDateTime');

               log('message in set button $scheduleTime');

                Duration remainingTime = await _getRemainigTime(
                  scheduleTime: scheduleTime,
                  breakOccurrence: breakOccurrence,
                  startDateTime: startDateTime,
                  endDateTime: endDateTime,
                );

               log('remaining time $remainingTime');

                HiveHelper.workSessionBox.put(
                  'session',
                  WorkSessionModel(
                      workFrom: workingHoursRefValue['from']!,
                      workTo: workingHoursRefValue['to']!,
                      breakDuration: ref.read(breakDurationProvider),
                      breakOccurrence: breakOccurrence,
                      isIdle: false),
                );

                ref.read(timerProvider.notifier).startTimer(remainingTime);

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
                    .setBreakDuration(ref.read(breakDurationProvider));
                    
              });
  }

  Future<tz.TZDateTime> _getInitialScheduledTime({
    required WidgetRef ref,
    required int breakOccurrence,
    required tz.TZDateTime startDateTime,
    required tz.TZDateTime endDateTime,
  }) async {
    var breakDuration = ref.read(breakDurationProvider);

    bool isReachEndTime = DateTime.now().isAfter(endDateTime);

    var firstScheduledTime =
        startDateTime.add(Duration(minutes: breakOccurrence));
    var breakScheduledEndTime =
        firstScheduledTime.add(Duration(minutes: breakDuration));

 //   log('scheduleTime in set button $firstScheduledTime  $breakScheduledEndTime     break enddddddddd ');
    if (isReachEndTime || firstScheduledTime.isAfter(endDateTime)) {
      return getZeroTzDateTime();
    }

    while (firstScheduledTime.isBefore(DateTime.now()) &&
        firstScheduledTime.isBefore(endDateTime)) {
      firstScheduledTime = firstScheduledTime
          .add(Duration(minutes: breakOccurrence))
          .add(Duration(minutes: breakDuration));
    //  log('scheduleTime in set button $firstScheduledTime      first whileeeeeeeeeeeeee ');
    }
    //  log(' set button $breakScheduledEndTime ${DateTime.now() } befoooore    breaaak  ');

    while (breakScheduledEndTime.isBefore(DateTime.now()) &&
        breakScheduledEndTime.isBefore(endDateTime)) {
      breakScheduledEndTime =
          breakScheduledEndTime.add(Duration(minutes: breakDuration)).add(Duration(
              minutes: breakOccurrence));
  //    log(' set button $breakScheduledEndTime      breaaak  ');
    }

    var remainingTime = getRemainingTime(firstScheduledTime.toString());

// if start with break time now
    if (remainingTime >= Duration(minutes: breakOccurrence)) {
await      HiveHelper.isBreakTimeBox.put('isBreakTime', true);
      await LocalNotificationHelper.scheduleBreakNotifications(
        breakDuration,
        TimeOfDay.fromDateTime(
          breakScheduledEndTime.subtract(
            Duration(minutes: breakDuration),
          ),
        ),
        TimeOfDay.fromDateTime(endDateTime),
        isForBreakEnd: true,
      );
   //   log('heeeeeeeeeeeeeeeeeeeeeeeer $firstScheduledTime');

      return breakScheduledEndTime;
    }
   // log(' set button $firstScheduledTime      firstScheduledTime frominitialScheduled method  ');

    return firstScheduledTime;
    //log(' set button $breakScheduledEndTime      break  ');

    // if (workOrBreakStatus == StatusWorkOrBreak.working) {
    //   scheduleTime = startDateTime.add(Duration(minutes: breakOccurrence));
    // } else {
    //   scheduleTime = startDateTime
    //       .add(Duration(minutes: breakOccurrence))
    //       .add(Duration(minutes: ref.watch(breakDurationProvider)));
    // }

    // if (isReachEndTime) {
    //   scheduleTime = startDateTime;
    // } else {
    //   scheduleTime = workOrBreakStatus == StatusWorkOrBreak.working
    //       ? startDateTime.add(Duration(minutes: breakOccurrence))
    //       : startDateTime
    //           .add(Duration(minutes: breakOccurrence))
    //           .add(Duration(minutes: ref.watch(breakDurationProvider)));
    // }
    //   if (!isReachEndTime) {
    //     scheduleTime = workOrBreakStatus == StatusWorkOrBreak.working
    //         ? startDateTime.add(Duration(minutes: breakOccurrence))
    //         : startDateTime
    //             .add(Duration(minutes: breakOccurrence))
    //             .add(Duration(minutes: ref.watch(breakDurationProvider)));
    //   } else {
    //     scheduleTime = startDateTime;
    //   }

    //   while (scheduleTime.isBefore(DateTime.now()) &&
    //       scheduleTime.isBefore(endDateTime)) {
    //     scheduleTime =
    //         //workOrBreakStatus==StatusWorkOrBreak.working?
    //         scheduleTime
    //             .add(Duration(minutes: breakOccurrence))
    //             .add(Duration(minutes: ref.watch(breakDurationProvider)));
    //   }
    //  if(){ HiveHelper.breakEndNotificationTimeBox
    //       .put('breakEndNotification', scheduleTime.toString());
    //   LocalNotificationHelper.scheduleBreakNotifications(
    //     breakDuration,
    //     TimeOfDay.fromDateTime(
    //         scheduleTime.subtract(Duration(minutes: breakDuration))),
    //     TimeOfDay.fromDateTime(endDateTime),
    //     isForBreakEnd: true,
    //   );}
    //   log('scheduleTime in set button $scheduleTime      break enddddddddd ');
  }

  Future<Duration> _getRemainigTime({
    required tz.TZDateTime scheduleTime,
    required int breakOccurrence,
    required tz.TZDateTime startDateTime,
    required tz.TZDateTime endDateTime,
  }) async {
    final now = DateTime.now();

    final bool isWithinWorkHours =
        now.isAfter(startDateTime) && now.isBefore(endDateTime);
    final bool isBeforeWorkStart = now.isBefore(startDateTime);
    final bool isBeforeWorkEnd = now.isBefore(endDateTime);

log("isBeforeWorkStart $isBeforeWorkStart $startDateTime");
    log("isBeforeWorkEnd $isBeforeWorkEnd $endDateTime");
    // Duration test = scheduleTime.difference(DateTime.now());
    // print(
    //     '${test >= Duration(minutes: breakOccurrence) && DateTime.now().isBefore(startDateTime)}');

    // before selected work from hour
    if (isBeforeWorkStart) {
log("before start");
      return now.difference(startDateTime).abs();
      // //  print('remainingTime  first schedule in hive $remainingTime');
    }
    // after selected work to hour
    else if (!isBeforeWorkEnd) {
      log("after end");

      return Duration.zero;
      //  print(' no coming notifications $remainingTime');
      //////   ref.read(timerProvider.notifier).startTimer(remainingTime);
    }

    // within work hours but now it for break time
    else if (scheduleTime.difference(DateTime.now()).abs() >=
        Duration(minutes: breakOccurrence)) {
      //  print('remainingTyyyiyiyiyiy $remainingTime');

      await HiveHelper.isBreakTimeBox.put('isBreakTime', true);
      log("within work hours but now it for break time");
      return scheduleTime.difference(DateTime.now()).abs();
    } else {
      log("else ");

      //     DateTime.now().add(Duration(minutes: breakOccurrence));
      return scheduleTime.difference(DateTime.now()).abs();
    }
  } // case display remaining of endTime
}
