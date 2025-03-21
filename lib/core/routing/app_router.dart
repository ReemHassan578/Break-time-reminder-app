
import 'package:flutter/material.dart';

import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
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

      default:
        return null;
    }
  }
}