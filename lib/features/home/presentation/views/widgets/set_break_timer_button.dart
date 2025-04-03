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

class SetBreakTimeButton extends ConsumerWidget {
  const SetBreakTimeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var workingHoursRefValue = ref.watch(workingHoursProvider);
    var isTimerRunning = ref.watch(timerProvider).isRunning;
    var timeNow = TimeOfDay.now();
    return FilledButton(
        onPressed: isTimerRunning
            ? null
            : () async {
                var breakOccurrence = ref.watch(breakOccurrenceProvider);
                Duration remainingTime = Duration.zero;
                if (HiveHelper.hasScheduledNotification) {
                  remainingTime = getRemainingTime(
                      HiveHelper.notificationBox.values.first.scheduledTime);
                } else {
                  DateTime.now().add(Duration(minutes: breakOccurrence));
                  remainingTime = getRemainingTime(DateTime.now()
                      .add(Duration(minutes: breakOccurrence))
                      .toString());
                }

                if (workingHoursRefValue['from']! !=
                    workingHoursRefValue['to']!) {

                  HiveHelper.workSessionBox.put('session',WorkSessionModel(workFrom: workingHoursRefValue['from']!, workTo: workingHoursRefValue['to']!, breakDuration: ref.watch(breakDurationProvider),breakOccurrence: breakOccurrence));

                  ref.read(timerProvider.notifier).startTimer(remainingTime);
                  LocalNotificationHelper.scheduleBreakNotifications(
                      //  2,
                      ref.watch(breakOccurrenceProvider),
                      TimeOfDay(
                          hour: workingHoursRefValue['from']!,
                          minute: timeNow.minute),
                      TimeOfDay(
                          hour: workingHoursRefValue['to']!,
                          minute: timeNow.minute));
                //  ref.read(breakDurationProvider.notifier).setBreakDuration(ref.watch(breakDurationProvider));
                 // ref.read(workin.notifier).setBreakDuration(ref.watch(breakDurationProvider));

                }
              },
        child: Text('set'));
  }
}
