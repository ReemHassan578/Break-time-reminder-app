import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/helpers/hive_helper.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../home/presentation/manager/break_duration_provider.dart';
import '../../../../home/presentation/manager/break_occurrence_provider.dart';
import '../../../../home/presentation/manager/timer_provider.dart';

class OkButton extends ConsumerWidget {
  final bool isFromNotification;
  const OkButton({
    super.key,
    required this.isFromNotification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomButton(
      text: "OK",
      onPressed: () {
        if (isFromNotification) {
        Navigator.pushReplacementNamed(context, Routes.homeScreen);
       
        } else {
          Navigator.of(context).popUntil((route) {
      return route.settings.name == Routes.homeScreen;
    });
              
        }
        final bool? isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime');
        if (isBreakTime == true) {
          ref.read(timerProvider.notifier).startTimer(
                Duration(minutes: ref.read(breakDurationProvider)),
              );
        } else {
          ref.read(timerProvider.notifier).startTimer(
                Duration(minutes: ref.read(breakOccurrenceProvider)),
              );
        }
        
      
      },
    );
  }
}
