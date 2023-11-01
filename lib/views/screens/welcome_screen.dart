import 'package:contacts_manager/utils/app_constants.dart';
import 'package:contacts_manager/views/widgets/auth_button.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_screen_svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthScreenSvg(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Text(
                          'Hi!',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        buttonText: 'Sign Up',
                        buttonFunction: () {
                          Navigator.pushNamed(context, AppRoutes.signUp);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthButton(
                        buttonText: 'Login',
                        buttonFunction: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
