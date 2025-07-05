import 'package:flutter/services.dart';

class NativeHelper {
  static const platform = MethodChannel('alarm');
  static const cancelAlarm = 'cancelAlarm';
  static const getAlarmUri = 'getAlarmUri';
}
