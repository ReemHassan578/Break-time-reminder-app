import 'package:break_time_reminder_app/features/home/presentation/manager/status_work_or_break_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class WorkOrBreakLottieImage extends ConsumerWidget {
  const WorkOrBreakLottieImage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      child: SizedBox(
        height: 240.h,
        width: 240.w,
        child: Lottie.asset(
          ref.watch(
            statusWorkOrBreakProvider)==StatusWorkOrBreak.working?'assets/images/work.json'
          :'assets/images/coffee.json',
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      ),
    );
  }
}
