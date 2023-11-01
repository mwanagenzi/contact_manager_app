import 'package:contacts_manager/utils/app_routing.dart';
import 'package:contacts_manager/views/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'views/screens/welcome_screen.dart';

void main() {
  runApp(const ContactManagerApp());
}

class ContactManagerApp extends StatelessWidget {
  const ContactManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData(),
      home: const WelcomeScreen(),
      onGenerateRoute: generateAppRoutes,
    );
  }
}
