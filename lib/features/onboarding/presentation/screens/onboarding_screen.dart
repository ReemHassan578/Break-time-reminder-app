import 'package:break_time_reminder_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theming/styles.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20.h,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: ClipOval(
                child: SizedBox(
                  height: 300.h,
                  width: double.infinity,
                  child: Lottie.asset(
                    'assets/images/onboarding.json',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20.h,
                  children: [
                    Text(
                      'Take Smart Breaks!',
                      style: MyTextStyles.font25BlackBold,
                    ),
                    Text(
                      "Stay productive and healthy with scheduled break reminders.",
                      style: MyTextStyles.font20BlackRegular.copyWith(
                          height: 1.5.h,
                          letterSpacing: 0.1.w,
                          wordSpacing: 0.1.w),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: FilledButton(style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                backgroundColor: MyColors.defaultColor,
              ),
                onPressed: () {},
                child: Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
