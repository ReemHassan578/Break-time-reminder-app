
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
class LetsGoFilledButton extends StatelessWidget {
  const LetsGoFilledButton({
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
        onPressed: () {
          Navigator.pushNamed(context, Routes.homeScreen);
        },
        child: Text('Let’s Go!',style: MyTextStyles.font14WhiteBold,),
      ),  
    );
  }
}
