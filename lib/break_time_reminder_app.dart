import 'package:break_time_reminder_app/core/routing/app_router.dart';
import 'package:break_time_reminder_app/core/routing/routes.dart';
import 'package:flutter/material.dart';

class BreakTimeReminderApp extends StatelessWidget {
  final AppRouter appRouter;
  const BreakTimeReminderApp({super.key,required this.appRouter}) ;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Routes.onBoardingScreen,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
