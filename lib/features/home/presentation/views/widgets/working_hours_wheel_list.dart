import 'package:break_time_reminder_app/core/theming/colors.dart';
import 'package:break_time_reminder_app/core/theming/styles.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/working_hours_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkingHoursWheelList extends ConsumerStatefulWidget {
  
  final String type;
  const WorkingHoursWheelList({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<WorkingHoursWheelList> createState() => _WorkingHoursWheelListState();
}

class _WorkingHoursWheelListState extends ConsumerState<WorkingHoursWheelList>{
    late FixedExtentScrollController _scrollController;

@override
  void initState() {
    super.initState();
        _scrollController = FixedExtentScrollController(initialItem: ref.read(workingHoursProvider)[widget.type]!);

  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.type,
            style: MyTextStyles.font18BlackNormalPacificoFont,
          ),
 
          SizedBox(
            height: 100.h,
            child: ListWheelScrollView.useDelegate(
              controller: _scrollController,
              itemExtent: 40.h,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                ref.read(workingHoursProvider.notifier).setWorkingHours(
                      type: widget.type,
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
                      color: ref.watch(workingHoursProvider)[widget.type] == index
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
