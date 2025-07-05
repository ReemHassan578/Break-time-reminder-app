import 'package:break_time_reminder_app/core/routing/app_router.dart';
import 'package:break_time_reminder_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/helpers/shared_variables.dart';
import 'core/theming/colors.dart';

class BreakTimeReminderApp extends StatefulWidget {
  final AppRouter appRouter;
   static  final GlobalKey<NavigatorState> navigatorKey= GlobalKey<NavigatorState>() ;

  const BreakTimeReminderApp({super.key, required this.appRouter,});

  @override
  State<BreakTimeReminderApp> createState() => _BreakTimeReminderAppState();
}

class _BreakTimeReminderAppState extends State<BreakTimeReminderApp> with WidgetsBindingObserver {
   AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;
 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
     isAppInForeground=_appLifecycleState == AppLifecycleState.resumed;
    debugPrint('App lifecycle changed to: $_appLifecycleState');
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  


  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          builder: (context, child) {
            return Container(
              decoration:const BoxDecoration(
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
          navigatorKey:BreakTimeReminderApp.navigatorKey ,
          initialRoute: Routes.onBoardingScreen,
          onGenerateRoute: widget.appRouter.generateRoute,
        ),
      ),
    );
  }
}
