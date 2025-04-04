
import 'package:break_time_reminder_app/features/home/presentation/views/widgets/choosing_break_duration_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/local_notification_helper.dart';
import 'widgets/work_or_break_lottie_image.dart';
import 'widgets/choosing_working_hours_box.dart';
import 'widgets/count_down_timer.dart';
import 'widgets/reset_break_timer_button.dart';
import 'widgets/set_break_timer_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocalNotificationHelper.fetchAllNotifications();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
            child: Column(
              //       spacing: 15.h,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CountDownTimer(),
                ChoosingWorkingHoursBox(),
                WorkOrBreakLottieImage(),
                ChoosingBreakDurationSlider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SetBreakTimeButton(),
                      ResetBreakTimerButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
