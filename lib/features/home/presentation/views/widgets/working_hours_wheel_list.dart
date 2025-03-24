import 'package:break_time_reminder_app/core/theming/colors.dart';
import 'package:break_time_reminder_app/core/theming/styles.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/working_hours_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkingHoursWheelList extends ConsumerWidget {
  final String type;
  const WorkingHoursWheelList({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 150.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type,
            style: MyTextStyles.font18BlackNormalPacificoFont,
          ),
          SizedBox(
            height: 100.h,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40.h,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                ref.read(workingHoursProvider.notifier).setWorkingHours(
                      type: type,
                      hour: index,
                    );
              },
              diameterRatio: 1.r,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Text(
                    "$index:00",
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: ref.watch(workingHoursProvider)[type] == index
                          ? MyColors.defaultColor
                          : Colors.black38,
                    ),
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
