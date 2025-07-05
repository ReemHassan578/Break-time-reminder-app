import 'dart:developer';

import 'package:break_time_reminder_app/core/helpers/local_notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/helpers/hive_helper.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../manager/status_idle_or_not_provider.dart';
import '../../manager/timer_provider.dart';
import '../../manager/working_hours_provider.dart';

class ResetBreakTimerButton extends ConsumerWidget {
  const ResetBreakTimerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var workingHoursRefValue = ref.watch(workingHoursProvider);
    var timerRef = ref.watch(timerProvider);
    var startAndEndTime = getStartAndEndTime(
        TimeOfDay(hour: workingHoursRefValue['from'] ?? 0, minute: 0),
        TimeOfDay(hour: workingHoursRefValue['to'] ?? 0, minute: 0));
    var endDateTime = startAndEndTime['end']!;
    bool isReachEndTime = DateTime.now().isAfter(endDateTime);
           final isSessionIdeal=ref.watch(statusIdleOrNotProvider);

// log('set testttt $endDateTime $startDateTime');
    //startDateTime.add(Duration(minutes: breakOccurrence));

    
    return CustomButton(
      text: 'reset',
      onPressed: () async{
        
     //   log('${ref.read(workingHoursProvider)['to']}');
        ref.read(timerProvider.notifier).resetTimer();
       await LocalNotificationHelper.resetNotificationsState();      //  final isSessionActive = HiveHelper.workSessionBox.get('session') != null &&
      //   HiveHelper.workSessionBox.get('session')!.isIdeal == false;
         //       log('${timerRef.isRunning} $isReachEndTime && ${!isSessionIdeal}');

      },
    );
  }
}
