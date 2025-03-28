import 'package:break_time_reminder_app/core/theming/colors.dart';
import 'package:break_time_reminder_app/core/theming/styles.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/break_occurrence_provider.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/working_hours_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../manager/break_duration_provider.dart';

class BreakOccurrenceWheel extends ConsumerWidget {
  const BreakOccurrenceWheel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "every",
            style: MyTextStyles.font18BlackNormalPacificoFont,
          ),
          SizedBox(
            height: 100.h,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40.h,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                ref
                    .read(breakOccurrenceProvider.notifier)
                    .setBreakOccurrence((30 * (index + 1)));
              },
              diameterRatio: 1.r,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  var breakOccurrence = (30 * (index + 1));
                  return Text(
                    breakOccurrence % 60 == 0
                        ? "${breakOccurrence ~/ 60}h"
                        : (breakOccurrence == 30
                            ? '30 min'
                            : "${breakOccurrence ~/ 60}h ${breakOccurrence % 60}m"),
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: ref.watch(breakOccurrenceProvider) == (30 * (index + 1))
                          ? MyColors.defaultColor
                          : Colors.black38,
                    ),

                    // color: ref.watch(workingHoursProvider)[type] == index
                    //     ? MyColors.defaultColor
                    //     : Colors.black38,
                  );
                },
                childCount: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
