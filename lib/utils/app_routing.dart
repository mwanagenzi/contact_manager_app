import 'package:contacts_manager/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/providers/navbar_tab_manager.dart';
import '../views/screens/screens.dart';
import 'app_constants.dart';

Route<dynamic> generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.signUp:
      {
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      }
    case AppRoutes.contacts:
      {
        return MaterialPageRoute(builder: (context) => const ContactsScreen());
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
    case AppRoutes.groups:
      {
        return MaterialPageRoute(
            builder: (context) => const ContactGroupsScreen());
      }
    case AppRoutes.group:
      final contactArgs = settings.arguments as List<Contact>;
      {
        return MaterialPageRoute(
            builder: (context) => GroupScreen(
                  contacts: contactArgs,
                ));
      }
    case AppRoutes.profile:
      {
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      }
    case AppRoutes.contact:
      {
        final contactArgs = settings.arguments as Contact?;
        return MaterialPageRoute(
            builder: (context) => ContactScreen(
                  contact: contactArgs ??
                      Contact(
                          id: 0,
                          firstName: "",
                          phone: "",
                          email: "",
                          groupName: ""),
                ));
      }

    default:
      {
        return MaterialPageRoute(builder: ((context) => const ErrorScreen()));
      }
  }
}
