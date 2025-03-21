import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/styles.dart';

class TextQuotes extends StatelessWidget {
  const TextQuotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
              style: MyTextStyles.font20BlackRegular.copyWith(shadows: [
                Shadow(
                  blurRadius: 1,
                ),
              ], height: 1.5.h, letterSpacing: 0.1.w, wordSpacing: 0.1.w),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
