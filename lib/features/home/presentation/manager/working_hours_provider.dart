import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkingHoursNotifier extends StateNotifier<Map<String, int>> {
  WorkingHoursNotifier() : super({'from': 0, 'to': 0});

 void setWorkingHours({required String type, required int hour}) {
    state = {...state, type: hour};
  }
}

final workingHoursProvider =
    StateNotifierProvider<WorkingHoursNotifier, Map<String, int>>(
  (ref) {
    return WorkingHoursNotifier();
  },
);
