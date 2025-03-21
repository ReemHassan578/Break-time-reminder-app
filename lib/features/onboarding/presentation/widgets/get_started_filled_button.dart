
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
class GetStartedFilledButton extends StatelessWidget {
  const GetStartedFilledButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding:
              EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          backgroundColor: MyColors.defaultColor,
        ),
        onPressed: () {},
        child: Text('Get Started'),
      ),
    );
  }
}
