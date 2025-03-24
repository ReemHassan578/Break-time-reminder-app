import 'package:break_time_reminder_app/features/home/presentation/manager/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountDownTimer extends ConsumerStatefulWidget {
  const CountDownTimer({super.key});

  @override
  ConsumerState<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends ConsumerState<CountDownTimer> {

  @override
  Widget build(BuildContext context) {
    final timerRef = ref.watch(timerProvider);
    return  StreamBuilder<int>(
            stream: timerRef.rawTime,
            initialData: timerRef.rawTime.value,
            builder: (context, snap) {
              final value = snap.data!;
              final displayTime =
                  StopWatchTimer.getDisplayTime(value, milliSecond: false,);
                   final int hours = StopWatchTimer.getRawHours(value);
              final int minutes = StopWatchTimer.getRawMinute(value);
              final int seconds = StopWatchTimer.getRawSecond(value);
              return Column(children: [
                
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                  child: Text(
                    displayTime,
                    style:  TextStyle(
                      fontSize: 40.sp,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]);
            });
  }



  @override
  void dispose() async {
    super.dispose();
    await ref.read(timerProvider.notifier).disposeTimer(); // Need to call dispose function.
  }
}
