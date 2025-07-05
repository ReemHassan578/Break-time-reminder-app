import 'dart:developer';

import 'package:break_time_reminder_app/features/home/data/models/work_session_model.dart';
import 'package:flutter/material.dart';
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
          onEnded: () {
         //   log('Timer ended!');
            //  HiveHelper.isBreakTimeBox.put('isBreakTime', false);
          },
        )) {
    _initTimer();
  }

  Future<void> _initTimer() async {
    final now = DateTime.now();
    final WorkSessionModel? workSession = HiveHelper.workSessionBox.isNotEmpty
        ? HiveHelper.workSessionBox.values.first
        : null;

    if (workSession == null || workSession.isIdle == true) {
   //   log('No work session available.');
      resetTimer();
      return;
    }

    bool isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime') ?? false;
    final startAndEndTime = getStartAndEndTime(
      TimeOfDay(hour: workSession.workFrom, minute: 0),
      TimeOfDay(hour: workSession.workTo, minute: 0),
    );
    final startTime = startAndEndTime['start']!;
    final endTime = startAndEndTime['end']!;

    final bool hasNotification = HiveHelper.hasScheduledNotification;
    final bool isWithinWorkHours =
        now.isAfter(startTime) && now.isBefore(endTime);
    final bool isBeforeWorkStart = now.isBefore(startTime);
    final bool isBeforeWorkEnd = now.isBefore(endTime);
    // log(HiveHelper.notificationBox.values.first.scheduledTime);
   // log('${now.isAfter(startTime)}&& ${now.isBefore(endTime)} ${!isBreakTime} && $isWithinWorkHours}');
    // has stored notification before , in working time , now passed the work from hour and not reached work to hour
    if (hasNotification && !isBreakTime && isWithinWorkHours) {
      await _handleScheduledNotificationDuringWorkHours(
          workSession.breakOccurrence);
    }

// if has stored notification but not passed the from hour
    else if (hasNotification && isBeforeWorkStart) {
      _handleScheduledBeforeStart(startTime);
    }

    // no coming notifications and not reached end time and not in ideal state
    else if (!hasNotification &&
        isBeforeWorkEnd &&
        workSession.isIdle == false) {
      _handleNoComingScheduledNotification(
        workSession.workTo,
      );
    }
    // if break Time and not reached the end time
    else if (isBreakTime && isBeforeWorkEnd) {
      _handleBreakTime();
      // set button not pressed
    } else {
     // log('set button not pressed');
      resetTimer();
    }
  }

  Future<void> _handleScheduledNotificationDuringWorkHours(
      int breakOccurrence) async {
 //   log(HiveHelper.notificationBox.values.first.scheduledTime);

    var remainingTime =
        getRemainingTime(HiveHelper.notificationBox.values.first.scheduledTime);

// if start with break time now
    if (remainingTime >= Duration(minutes: breakOccurrence)) {
      remainingTime = getRemainingTime(
          //////////
          HiveHelper.breakEndNotificationTimeBox.get('breakEndNotification')!);
     // log('start with breakTime');

      await HiveHelper.isBreakTimeBox.put('isBreakTime', true);
    }
    startTimer(remainingTime);
  }

  void _handleScheduledBeforeStart(tz.TZDateTime startDateTime) {
   // log('stored notification but no pass start hour');

    var remainingTime = startDateTime.difference(DateTime.now()).abs();
    HiveHelper.isBreakTimeBox.put('isBreakTime', true);
    startTimer(remainingTime);
  }

  void _handleNoComingScheduledNotification(int workTo) {
    var now = DateTime.now();
  //  log('no coming notificantio end hour');
    final endTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      workTo,
      0,
    );
    var remainingTime = getRemainingTime(endTime.toString());
    print(' no coming notifications $remainingTime');
    startTimer(remainingTime);
  }

  void _handleBreakTime() {
  //  log('break time and not reached end time');
    var remainingTime = getRemainingTime(
        /////
        HiveHelper.breakEndNotificationTimeBox.get('breakEndNotification')!);
    print(
        'remainingTime in breaaaaaaaaaaaaaaaaaaaak ${HiveHelper.breakEndNotificationTimeBox.get('breakEndNotification')!}');

    startTimer(remainingTime);
  }

  void startTimer(Duration time) {
    if (state.isRunning) {
      state.onStopTimer(); // Stop the timer before resetting
    }
    final updatedTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(time.inSeconds),
    );
    state = updatedTimer;
    state.onStartTimer();
  }

  void resetTimer() {
    final updatedTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      onEnded: () => state.onEnded!(),
    );
    state = updatedTimer;
    //state.onStopTimer();
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
