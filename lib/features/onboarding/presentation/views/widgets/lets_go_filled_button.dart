
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../core/widgets/custom_button.dart';
class LetsGoFilledButton extends StatelessWidget {
  const LetsGoFilledButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(text: 'Let’s Go!',onPressed:() {
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } ,);
  }
}