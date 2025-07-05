import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/hive_helper.dart';
import 'widgets/break_or_work_icon.dart';
import 'widgets/break_or_work_text.dart';
import 'widgets/ok_button.dart';

class NotificationScreen extends StatelessWidget {
  final bool? isEndHour;
  const NotificationScreen({
    super.key,
   required this.isEndHour
  });

  @override
  Widget build(BuildContext context) {

    final bool isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime')!;
    print('isBreakTime: $isBreakTime');
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 20.sp,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BreakOrWorkText(isBreakTime: isBreakTime,isEndHour: isEndHour,),
            BreakOrWorkIcon(isBreakTime: isBreakTime),
            OkButton(
              
            ),
          ],
        ),
      ),
    );
  }
}
