import 'dart:developer';

import 'package:break_time_reminder_app/core/theming/colors.dart';
import 'package:break_time_reminder_app/core/theming/styles.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/break_occurrence_provider.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/status_idle_or_not_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/local_notification_helper.dart';
import '../../manager/timer_provider.dart';

class BreakOccurrenceWheel extends ConsumerStatefulWidget {
  const BreakOccurrenceWheel({
    super.key,
  });

  @override
 ConsumerState<BreakOccurrenceWheel>   createState() => _BreakOccurrenceWheelState();
}

class _BreakOccurrenceWheelState extends ConsumerState<BreakOccurrenceWheel> {
  late FixedExtentScrollController _scrollController;

 
  
@override
  void initState() {

    super.initState();
       LocalNotificationHelper.initializeNotificationCallback(ref);

    _scrollController = FixedExtentScrollController(
        initialItem:( ref.read(breakOccurrenceProvider)-1) ~/ 30);
  


  }
  @override
  Widget build(BuildContext context, ) {
   var timerRef = ref.watch(timerProvider);
       final isSessionIdeal = ref.watch(statusIdleOrNotProvider);
//log( 'isIdeal: ${timerRef.isRunning && !isSessionIdeal}');

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
              controller: _scrollController,
              itemExtent: 40.h,
              physics: timerRef.isRunning || !isSessionIdeal?const NeverScrollableScrollPhysics():const FixedExtentScrollPhysics(),
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
