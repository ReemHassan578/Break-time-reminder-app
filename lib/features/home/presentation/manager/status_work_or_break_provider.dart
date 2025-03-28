import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StatusWorkOrBreak {
  working,
  breakTime,
}
class StatusWorkOrBreakNotifier extends StateNotifier<StatusWorkOrBreak> {
  StatusWorkOrBreakNotifier() : super(StatusWorkOrBreak.breakTime);

 void startWorking() {
    state = StatusWorkOrBreak.working;
  }

  void startBreakTime() {
    state = StatusWorkOrBreak.breakTime;
  }
}

final statusWorkOrBreakProvider =
    StateNotifierProvider<StatusWorkOrBreakNotifier,StatusWorkOrBreak>(
  (ref) {
    return StatusWorkOrBreakNotifier();
  },
);
