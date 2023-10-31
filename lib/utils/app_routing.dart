import 'package:contacts_manager/views/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/providers/navbar_tab_manager.dart';
import '../views/screens/screens.dart';
import 'app_constants.dart';

Route<dynamic> generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.welcome:
      {
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      }
    case AppRoutes.signUp:
      {
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      }
    case AppRoutes.login:
      {
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      }
    case AppRoutes.resetPassword:
      {
        return MaterialPageRoute(
            builder: (context) => const ResetPasswordScreen());
      }
    case AppRoutes.home:
      {
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<NavbarTabManager>(
            create: (context) => NavbarTabManager(),
            child: const HomeScreen(),
          ),
        );
      }
    // case AppRoutes.weeklyForecast:
    //   {
    //     return MaterialPageRoute(
    //         builder: (context) => const WeeklyForecastScreen());
    //   }
    // case AppRoutes.search:
    //   {
    //     return MaterialPageRoute(builder: (context) => SearchLocationScreen());
    //   }

    default:
      {
        return MaterialPageRoute(builder: ((context) => const ErrorScreen()));
      }
  }
}
