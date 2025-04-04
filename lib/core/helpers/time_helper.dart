import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

Duration getRemainingTime(String nextBreakTime) {
    DateTime parsedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(nextBreakTime);

    // Convert the DateTime to TZDateTime
    tz.TZDateTime tzDateTime = tz.TZDateTime.from(parsedDate, tz.local);
    return DateTime.now().difference(tzDateTime).abs();
  }