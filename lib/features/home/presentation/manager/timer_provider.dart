import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerNotifier extends StateNotifier<StopWatchTimer> {
  TimerNotifier()
      : super(StopWatchTimer(
          mode: StopWatchMode.countDown,
          presetMillisecond: StopWatchTimer.getMilliSecFromSecond(0),
          onChange: (value) => debugPrint('onChange $value'),
          onStopped: () {
            debugPrint('onStopped');
          },
          onEnded: () {
            debugPrint('onEnded');
          },
        ));

  void setBreakTime(int time) {
    state.setPresetTime(mSec: 0,add: false);
    state.onStartTimer();
    state.setPresetMinuteTime(time);
  }

  void resetBreakTime() {
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
