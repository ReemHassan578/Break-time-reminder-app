import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/hive_helper.dart';

class BreakDurationNotifier extends StateNotifier<int> {
  BreakDurationNotifier() : super(20) {
    _loadFromHive();
  }

  void setBreakDuration(int value) {
    state = value;
  }

  void _loadFromHive() {
    int? breakDuration =
        HiveHelper.workSessionBox.get('session')?.breakDuration;
    state = breakDuration ?? 20;

    HiveHelper.workSessionBox.watch(key: 'session').listen((event) {
      state = event.value == null ? 20 : breakDuration!;
    });
  }
}

final breakDurationProvider = StateNotifierProvider<BreakDurationNotifier, int>(
  (ref) {
    return BreakDurationNotifier();
  },
);
