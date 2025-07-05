
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/hive_helper.dart';

class StatusIdleOrNotNotifier extends StateNotifier<bool> {
  StatusIdleOrNotNotifier() : super(true) {
    _loadFromHive();
  
  }

  void _loadFromHive() {
    bool? isIdle = HiveHelper.workSessionBox.get('session')?.isIdle;
     state = isIdle ?? true;
// log( 'isIdle: $isIdle');
    HiveHelper.workSessionBox.watch(key: 'session').listen((event) {
      state = event.value == null 
          ? true
          : event.value!.isIdle;
    });
  }

}

final statusIdleOrNotProvider =
    StateNotifierProvider<StatusIdleOrNotNotifier, bool>(
  (ref) {
    return StatusIdleOrNotNotifier();
  },
);
