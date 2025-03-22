import 'package:break_time_reminder_app/core/routing/app_router.dart';
import 'package:break_time_reminder_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theming/colors.dart';

class BreakTimeReminderApp extends StatelessWidget {
  final AppRouter appRouter;
  const BreakTimeReminderApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                 MyColors.mint ,
                  Colors.white, 
                ],
              ),
            ),
            child: child, 
          );
        },

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.senTextTheme(),
          colorScheme: const ColorScheme.light(primary: MyColors.defaultColor),
           scaffoldBackgroundColor:
           // Set transparent to apply gradient manually
              Colors.transparent, 
          useMaterial3: true,
        ),
        initialRoute: Routes.onBoardingScreen,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
