import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/hive_helper.dart';

enum StatusWorkOrBreak {
  working,
  breakTime,
}

class StatusWorkOrBreakNotifier extends StateNotifier<StatusWorkOrBreak> {
  StatusWorkOrBreakNotifier() : super(StatusWorkOrBreak.breakTime) {
    _loadFromHive();
  
  }

  void _loadFromHive() {
    bool? isBreak = HiveHelper.isBreakTimeBox.get('isBreakTime');
     state = isBreak == null || isBreak == false
        ? StatusWorkOrBreak.working
        : StatusWorkOrBreak.breakTime;

    HiveHelper.isBreakTimeBox.watch(key: 'isBreakTime').listen((event) {
      state = event.value == null || event.value == false
          ? StatusWorkOrBreak.working
          : StatusWorkOrBreak.breakTime;
    });
  }

  void startWorking() {
    state = StatusWorkOrBreak.working;
  }

  void startBreakTime() {
    state = StatusWorkOrBreak.breakTime;
  }
}

final statusWorkOrBreakProvider =
    StateNotifierProvider<StatusWorkOrBreakNotifier, StatusWorkOrBreak>(
  (ref) {
    return StatusWorkOrBreakNotifier();
  },
);
