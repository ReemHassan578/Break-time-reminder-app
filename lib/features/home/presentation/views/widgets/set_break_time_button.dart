import 'package:break_time_reminder_app/features/home/presentation/manager/working_hours_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/helpers/local_notification_helper.dart';
import '../../manager/break_duration_provider.dart';
import '../../manager/status_work_or_break_provider.dart';
import '../../manager/timer_provider.dart';

class SetBreakTimeButton extends ConsumerWidget {
  const SetBreakTimeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
        onPressed: () {
          int breakDuration = ref.watch(breakDurationProvider);
          ref.read(timerProvider.notifier).setBreakTime(breakDuration);
        
          LocalNotificationHelper.scheduleBreakNotifications(
              ref.watch(breakDurationProvider),TimeOfDay(hour:ref.watch(workingHoursProvider)['from']!,minute: TimeOfDay.now().minute),TimeOfDay(hour:ref.watch(workingHoursProvider)['to']!,minute: TimeOfDay.now().minute));
          ref.read(statusWorkOrBreakProvider.notifier).startBreakTime();
        },
        child: Text('set break time'));
  }
}
