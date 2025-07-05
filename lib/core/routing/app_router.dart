
import 'package:break_time_reminder_app/features/notification/presentation/views/notification_screen.dart';
import 'package:flutter/material.dart';

import '../../features/home/presentation/views/home_screen.dart';
import '../../features/onboarding/presentation/views/onboarding_screen.dart';
import 'routes.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const OnboardingScreen();
          },
        );
case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        );
        case Routes.notificationScreen:
        return MaterialPageRoute(
          builder: (context) {
            var args = settings.arguments as Map<String, dynamic>;
            return  NotificationScreen( isEndHour: args['isEndHour'],);
          },
        );

      default:
        return null;
    }
  }
}