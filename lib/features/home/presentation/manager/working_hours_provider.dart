import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/hive_helper.dart';

class WorkingHoursNotifier extends StateNotifier<Map<String, int>> {
  WorkingHoursNotifier() : super({'from': 0, 'to': 0}){
    _loadFromHive();
  }


 void _loadFromHive() {
    int? workFrom =
        HiveHelper.workSessionBox.get('session')?.workFrom;
         int? workTo =
        HiveHelper.workSessionBox.get('session')?.workTo;
    state = {'from': workFrom ?? 0, 'to': workTo ?? 0};

    HiveHelper.workSessionBox.watch(key: 'session').listen((event) {
   //   log('event: ${event.value.workFrom}');
      state = event.value == null
          ? state
          : {'from': state['from']!, 'to': state['to']!};
    });

 
  }


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
