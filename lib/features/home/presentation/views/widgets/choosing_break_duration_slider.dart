import 'package:break_time_reminder_app/features/home/presentation/manager/break_duration_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theming/styles.dart';
import '../../manager/status_idle_or_not_provider.dart';
import '../../manager/timer_provider.dart';

class ChoosingBreakDurationSlider extends ConsumerWidget{
  const ChoosingBreakDurationSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int breakDuration = ref.watch(breakDurationProvider);
            var timerRef = ref.watch(timerProvider);
         bool   isSessionIdeal = ref.watch(statusIdleOrNotProvider);

    return Column(
      children: [
        Text(
          'select your break duration',
          style: TextStyle(
              fontSize: 19.sp,
              letterSpacing: -2.w,
              fontWeight: FontWeight.w500),
        ),
        Slider(
          value:  breakDuration.toDouble(),
          min: 0,
          max: 120,
          divisions: 24, 
 label: breakDuration >= 60
      ? "${breakDuration ~/ 60} hr ${breakDuration % 60} min"
      : "$breakDuration min",
                onChanged: timerRef.isRunning || !isSessionIdeal?null:(value) {
            ref.read(breakDurationProvider.notifier).setBreakDuration(value.toInt());
          },
        ),
        Text(
           breakDuration >= 60
      ? "${breakDuration ~/ 60} hr ${breakDuration % 60} min"
      : "$breakDuration min",
          style: MyTextStyles.font18BlackNormalPacificoFont,
        ),
      ],
    );
  }
}
