import 'package:break_time_reminder_app/core/helpers/local_notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../manager/status_work_or_break_provider.dart';
import '../../manager/timer_provider.dart';

class ResetBreakTimerButton extends ConsumerWidget {
  const ResetBreakTimerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
        onPressed: () {
          ref.read(timerProvider.notifier).resetBreakTime();
          LocalNotificationHelper.cancelAllNotification();
                    ref.read(statusWorkOrBreakProvider.notifier).startWorking();

        },
        child: Text('reset'));
  }
}
