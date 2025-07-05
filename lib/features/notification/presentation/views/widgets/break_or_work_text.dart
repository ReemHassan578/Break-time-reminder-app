
import 'package:flutter/material.dart';

import '../../../../../core/theming/styles.dart';

class BreakOrWorkText extends StatelessWidget {
  const BreakOrWorkText({
    super.key,
    required this.isBreakTime,
    required this.isEndHour,
  });

  final bool isBreakTime;
    final bool? isEndHour;


  @override
  Widget build(BuildContext context) {
    return Column(
  //    spacing: 20.sp,
    //      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          !isBreakTime && isEndHour!=true ? "Time to Work!" : (isEndHour==true? "Working Hours is over!":"Time for a Break!"),
          style: MyTextStyles.font25BlackBoldPacificoFont,
        ),
         Text(
              !isBreakTime
                  ? "Focus on your tasks and stay productive."
                  : "Relax and recharge for better efficiency.",
              textAlign: TextAlign.center,
              style: MyTextStyles.font20BlackRegularPlayFairFont,
            ),
      ],
    );
  }
}
