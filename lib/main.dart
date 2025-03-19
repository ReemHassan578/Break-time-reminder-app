import 'package:break_time_reminder_app/break_time_reminder_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await ScreenUtil.ensureScreenSize();
  runApp(BreakTimeReminderApp(
    appRouter: AppRouter(),
  ));
}
