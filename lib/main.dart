import 'package:break_time_reminder_app/break_time_reminder_app.dart';
import 'package:break_time_reminder_app/core/helpers/hive_helper.dart';
import 'package:break_time_reminder_app/core/helpers/local_notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/routing/app_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
// Forces it to use cached fonts only
  GoogleFonts.config.allowRuntimeFetching = false; 

  await ScreenUtil.ensureScreenSize();
  await LocalNotificationHelper.preInitializeNotifications();
  await HiveHelper.init();
  
  runApp(BreakTimeReminderApp(
    appRouter: AppRouter(),
  ));
}
