import 'package:break_time_reminder_app/core/routing/app_router.dart';
import 'package:break_time_reminder_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theming/colors.dart';

class BreakTimeReminderApp extends StatelessWidget {
  final AppRouter appRouter;
  const BreakTimeReminderApp({super.key,required this.appRouter}) ;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:const ColorScheme.light(primary: MyColors.defaultColor),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
       
        initialRoute: Routes.onBoardingScreen,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
