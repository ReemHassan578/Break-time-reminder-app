import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/widgets/custom_button.dart';

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
        Navigator.pushReplacementNamed(context, Routes.homeScreen)
            .then((value) {
//ref.read(timerProvider.notifier).startTimer(Duration(minutes: ref.read(breakDurationProvider)));
// final bool? isBreakTime = HiveHelper.isBreakTimeBox.get('isBreakTime');
          // HiveHelper.isBreakTimeBox
          //     .put('isBreakTime', isBreakTime == null ? false : !isBreakTime);
        });
        } else {
          Navigator.of(context).popUntil((route) {
      return route.settings.name == Routes.homeScreen;
    });
              
        }
      
      },
    );
  }
}
