import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/helpers/hive_helper.dart';
import '../../../../core/helpers/time_helper.dart';

class TimerNotifier extends StateNotifier<StopWatchTimer> {
  TimerNotifier()
      : super(StopWatchTimer(
          mode: StopWatchMode.countDown,
          presetMillisecond: StopWatchTimer.getMilliSecFromSecond(0),
        )) {
    bool? isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime') ?? false;
var workSession = HiveHelper.workSessionBox.values.first;
var now=DateTime.now();
final endDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      workSession.workTo,
      0,
    );
    if (HiveHelper.hasScheduledNotification && !isBreakTime && (now.isBefore(endDateTime))){
      print(HiveHelper.notificationBox.values.first.scheduledTime);
      var remainingTime = getRemainingTime(
          HiveHelper.notificationBox.values.first.scheduledTime);
      print(remainingTime);
      startTimer(remainingTime);
    } else if (isBreakTime && (now.isBefore(endDateTime))) {
    
         var remainingTime = getRemainingTime(
//HiveHelper.notificationBox.values.first.scheduledTime
          HiveHelper.breakEndNotificationTimeBox.get('breakEndNotification')!
          );
          print('remainingTime in breaaaaaaaaaaaaaaaaaaaak ${ HiveHelper.breakEndNotificationTimeBox.get('breakEndNotification')!}');
    
        startTimer( remainingTime);
      
      // } else {
      //   startTimer(const Duration(minutes: 20)); // Default duration
      // }
    } else {
      StopWatchTimer(
        mode: StopWatchMode.countDown,
        presetMillisecond: StopWatchTimer.getMilliSecFromSecond(0),
      );
    }
  }

  void startTimer(Duration time) {
    if (state.isRunning) {
      state.onStopTimer(); // Stop the timer before resetting
    }
    final updatedTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(time.inSeconds),
      onChange: state.onChange,
      onStopped: state.onStopped,
      onEnded: state.onEnded,
    );
    state = updatedTimer;
    state.onStartTimer();
  }

  void resetTimer() {
    final updatedTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
    );
    state = updatedTimer;
    state.onResetTimer();
  }

  Future<void> disposeTimer() async {
    await state.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, StopWatchTimer>(
  (ref) {
    return TimerNotifier();
  },
);
