import 'package:break_time_reminder_app/core/theming/colors.dart';
import 'package:break_time_reminder_app/core/theming/styles.dart';
import 'package:break_time_reminder_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/hive_helper.dart';
import '../../../../core/routing/routes.dart';
import 'widgets/break_or_work_icon.dart';
import 'widgets/break_or_work_text.dart';
import 'widgets/ok_button.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime')!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 20.sp,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BreakOrWorkText(isBreakTime: isBreakTime),
           
            BreakOrWorkIcon(isBreakTime: isBreakTime),
           OkButton(),
          
          ],
        ),
      ),
    );
  }
}
