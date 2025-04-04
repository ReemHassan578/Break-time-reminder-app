
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theming/colors.dart';

class BreakOrWorkIcon extends StatelessWidget {
  const BreakOrWorkIcon({
    super.key,
    required this.isBreakTime,
  });

  final bool isBreakTime;

  @override
  Widget build(BuildContext context) {
    return Icon(
      !isBreakTime ? Icons.work : Icons.coffee,
      size: 100.sp,
      color: MyColors.defaultColor.withAlpha(180),
    );
  }
}
