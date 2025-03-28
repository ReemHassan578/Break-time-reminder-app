import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'break_occurrence_wheel.dart';
import 'working_hours_wheel_list.dart';

class ChoosingWorkingHoursBox extends StatelessWidget {
  const ChoosingWorkingHoursBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'determine  your  working  hours',
          style: TextStyle(
              fontSize: 19.sp,
              letterSpacing: -2.w,
              fontWeight: FontWeight.w500),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WorkingHoursWheelList(type: 'from'),
            WorkingHoursWheelList(type: 'to'),
            BreakOccurrenceWheel(),
          ],
        ),
      ],
    );
  }
}
