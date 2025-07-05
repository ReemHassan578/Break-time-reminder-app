import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';
import '../theming/styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.r),
        ),
        backgroundColor: MyColors.defaultColor,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: MyTextStyles.font14WhiteBold,
      ),
    );
  }
}
