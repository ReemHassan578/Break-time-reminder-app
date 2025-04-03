import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../core/helpers/hive_helper.dart';
import '../../../../core/helpers/time_helper.dart';

class TimerNotifier extends StateNotifier<StopWatchTimer> {
  TimerNotifier()
      : super(StopWatchTimer(
          mode: StopWatchMode.countDown,
          presetMillisecond: StopWatchTimer.getMilliSecFromSecond(0),
        )) {
    if (HiveHelper.hasScheduledNotification) {
      var remainingTime = getRemainingTime(
          HiveHelper.notificationBox.values.first.scheduledTime);
      print(remainingTime);
      startTimer(remainingTime);
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
