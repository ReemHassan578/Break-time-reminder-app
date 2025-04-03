import 'package:break_time_reminder_app/break_time_reminder_app.dart';
import 'package:break_time_reminder_app/core/helpers/hive_helper.dart';
import 'package:break_time_reminder_app/core/helpers/local_notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routing/app_router.dart';
import 'features/home/data/models/notification_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await LocalNotificationHelper.init();
  await HiveHelper.init();
  runApp(BreakTimeReminderApp(
    appRouter: AppRouter(),
  ));
}
