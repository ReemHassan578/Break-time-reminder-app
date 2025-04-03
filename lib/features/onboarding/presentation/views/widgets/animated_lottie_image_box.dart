
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AnimatedLottieImageBox extends StatelessWidget {
  const AnimatedLottieImageBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
