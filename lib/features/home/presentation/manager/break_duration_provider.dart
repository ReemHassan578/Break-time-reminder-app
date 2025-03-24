import 'package:flutter_riverpod/flutter_riverpod.dart';

class BreakDurationNotifier extends StateNotifier<int> {
  BreakDurationNotifier() : super(0);

  void setBreakDuration(int value) {
    state = value;
  }
}


final breakDurationProvider = StateNotifierProvider<BreakDurationNotifier, int>(
  (ref) {
    return BreakDurationNotifier();
  },
);
