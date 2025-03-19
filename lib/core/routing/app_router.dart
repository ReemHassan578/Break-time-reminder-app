
import 'package:flutter/material.dart';

import 'routes.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold();
          },
        );

      default:
        return null;
    }
  }
}