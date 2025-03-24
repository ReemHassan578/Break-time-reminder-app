import 'dart:async';

import 'package:break_time_reminder_app/features/home/presentation/views/widgets/choosing_break_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/choosing_working_hours_box.dart';
import '../widgets/count_down_timer.dart';
import '../widgets/reset_break_timer_button.dart';
import '../widgets/set_break_time_button.dart';
import '../widgets/working_hours_wheel_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedHour = 9;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 40.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoosingWorkingHoursBox(),
            ChoosingBreakDuration(),
            CountDownTimer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SetBreakTimeButton(),
                ResetBreakTimerButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
