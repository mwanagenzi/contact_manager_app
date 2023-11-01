import 'package:flutter/material.dart';

import '../theme/color_palette.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_screen_svg.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController _newpassController, _confirmPassController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _newpassController = TextEditingController();
    _confirmPassController = TextEditingController();
    super.initState();
  }

  @override
  void deactivate() {
    _newpassController.dispose();
    _confirmPassController.dispose();
    super.deactivate();
  }

  bool isNewPassObscured = true;
  bool isConfirmPassObscured = true;
  IconData confirmPassVisibleIcon = Icons.visibility_off;
  IconData newPassVisibleIcon = Icons.visibility_off;

  IconData _changePasswordSuffixIcon(IconData visibleIcon) {
    if (visibleIcon == Icons.visibility) {
      return visibleIcon = Icons.visibility_off;
    } else {
      return visibleIcon = Icons.visibility;
    }
  }

  String? _fieldValidator(String? passFieldValue) {
    if (passFieldValue == null || passFieldValue.isEmpty) {
      return 'This field must contain a value';
    } else if (passFieldValue.length <= 8) {
      return 'Password must contain more than 8 characters';
    } else if (_newpassController.text != _confirmPassController.text) {
      return 'Passwords must be similar';
    } else {
      return null;
    }
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

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
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Text(
                            'Reset password',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _newpassController,
                          cursorColor: Colors.black,
                          autofocus: true,
                          obscureText: isNewPassObscured,
                          validator: _fieldValidator,
                          decoration: InputDecoration(
                            labelText: 'New password',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.black),
                            focusColor: Palette.highlightedTextColor,
                            hintText: 'New password',
                            // ignore: prefer_const_constructors
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: const Icon(
                              Icons.password_rounded,
                              color: Colors.black,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isNewPassObscured = !isNewPassObscured;
                                  newPassVisibleIcon =
                                      _changePasswordSuffixIcon(
                                          newPassVisibleIcon);
                                });
                              },
                              child: Icon(
                                newPassVisibleIcon,
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _confirmPassController,
                          cursorColor: Colors.black,
                          autofocus: true,
                          obscureText: isConfirmPassObscured,
                          validator: _fieldValidator,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.black),
                            focusColor: Palette.highlightedTextColor,
                            hintText: 'Confirm Password',
                            // ignore: prefer_const_constructors
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: const Icon(
                              Icons.password_rounded,
                              color: Colors.black,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isConfirmPassObscured =
                                      !isConfirmPassObscured;
                                  confirmPassVisibleIcon =
                                      _changePasswordSuffixIcon(
                                          confirmPassVisibleIcon);
                                });
                              },
                              child: Icon(
                                confirmPassVisibleIcon,
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AuthButton(
                          buttonText: 'Continue',
                          buttonFunction: () {
                            _handleSubmit(context);
                            //TODO: reset the password in laravel
                          },
                        ),
                      ],
                    ),
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
