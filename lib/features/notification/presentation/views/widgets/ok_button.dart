import 'package:break_time_reminder_app/features/home/presentation/manager/break_duration_provider.dart';
import 'package:break_time_reminder_app/features/home/presentation/manager/timer_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/helpers/hive_helper.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/widgets/custom_button.dart';

class OkButton extends ConsumerWidget {
  const OkButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  CustomButton(text: "OK", onPressed:  () {
               Navigator.pushReplacementNamed(
                  context, Routes.homeScreen).then((value) {
ref.read(timerProvider.notifier).startTimer(Duration(minutes: ref.read(breakDurationProvider)));
// final bool? isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime');
    // HiveHelper.isBreakTimeBox
    //     .put('isBreakTime', isBreakTime == null ? false : !isBreakTime);

                  }  );
            },);
  }
}