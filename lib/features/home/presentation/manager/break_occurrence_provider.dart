import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/hive_helper.dart';

class BreakOccurrenceNotifier extends StateNotifier<int> {
  BreakOccurrenceNotifier() : super(30) {
    _loadFromHive();
  }

  void _loadFromHive() {
    int? breakOccurrence =
        HiveHelper.workSessionBox.get('session')?.breakOccurrence;
    state = breakOccurrence ?? 30;

    HiveHelper.workSessionBox.watch(key: 'session').listen((event) {
      state = event.value == null ? 30 : breakOccurrence!;
    });
  }

  void setBreakOccurrence(int value) {
    state = value;
  }
}

final breakOccurrenceProvider =
    StateNotifierProvider<BreakOccurrenceNotifier, int>(
  (ref) {
    return BreakOccurrenceNotifier();
  },
);
