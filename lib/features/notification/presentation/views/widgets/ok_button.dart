import 'dart:developer';

import 'package:break_time_reminder_app/core/helpers/local_notification_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../break_time_reminder_app.dart';
import '../../../../../core/helpers/native_helper.dart';
import '../../../../../core/helpers/shared_variables.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../home/presentation/manager/timer_provider.dart';

class OkButton extends ConsumerWidget {
  const OkButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomButton(
      text: "OK",
      onPressed: () async {
  final navigator = BreakTimeReminderApp.navigatorKey.currentState!;
        // final launchDetails = await LocalNotificationHelper
        //     .flutterLocalNotificationsPlugin
        //     .getNotificationAppLaunchDetails();
//ref.read(timerProvider.notifier).startTimer( Duration(minutes: 10));
        try {
          NativeHelper.platform.invokeMethod(NativeHelper.cancelAlarm);
      //    log('cancel alarm!');
        } catch (e) {}

        if (!isAppInForeground) {
    //      log('from notification background!');
          navigator.pushReplacementNamed(Routes.homeScreen);
        } else {
          navigator.pop(
  // (Route<dynamic> route) => route.settings.name == Routes.homeScreen,
);
        }
      },
    );
  }
}
