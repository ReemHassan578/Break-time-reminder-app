import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

Duration getRemainingTime(String nextBreakTime) {
    DateTime parsedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(nextBreakTime);

    // Convert the DateTime to TZDateTime
    tz.TZDateTime tzDateTime = tz.TZDateTime.from(parsedDate, tz.local);
    return DateTime.now().difference(tzDateTime).abs();
  }


Map<String,tz.TZDateTime>  getStartAndEndTime(TimeOfDay startTime, TimeOfDay endTime,){
    final now = tz.TZDateTime.now(tz.local);
// Handle fromTime (possibly yesterday if time is now after midnight)
var startDateTime = tz.TZDateTime(
  tz.local,
  now.year,
  now.month,
  now.day,
  startTime.hour,
  startTime.minute,
);

// If the start time is *after* the end time → it means it crosses midnight
bool crossesMidnight = startTime.hour > endTime.hour && endTime.hour != 0;
// If we crossed midnight and current time is already *after* midnight but *before* end time
if (crossesMidnight && now.hour < endTime.hour) {
  startDateTime = startDateTime.subtract(Duration(days: 1));
}

// Adjust endDateTime (always relative to startDateTime)
var endDateTime = tz.TZDateTime(
  tz.local,
  startDateTime.year,
  startDateTime.month,
  startDateTime.day,
  endTime.hour,
  endTime.minute,
);
// If end time is before start time (crosses midnight) → add a day
if (endDateTime.isBefore(startDateTime)) {
  endDateTime = endDateTime.add(Duration(days: 1));
}
return {
    'start': startDateTime,
    'end': endDateTime,
  };

  }

 tz.TZDateTime getZeroTzDateTime(){
    var now= DateTime.now();
    return tz.TZDateTime(tz.local, now.year, now.month, now.day,);
  }