import 'dart:convert';
import 'dart:io';

import 'package:contacts_manager/utils/app_constants.dart';
import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:contacts_manager/views/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/auth_screen_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void deactivate() {
    _emailController.dispose();
    _passwordController.dispose();
    super.deactivate();
  }

  bool _isTextObscured = true;
  IconData _visibilityIcon = Icons.visibility_off;

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
    } else if (passFieldValue.length <= 7) {
      return 'Password must contain more than 8 characters';
    } else {
      return null;
    }
  }

  String? _emailValidator(String? textFieldValue) {
    if (textFieldValue == null || textFieldValue.isEmpty) {
      return 'This value is required';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(textFieldValue)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  SnackBar _showErrorSnackBar(String errorMessage) {
    return SnackBar(
        backgroundColor: Palette.tileDividerColor,
        elevation: 5.0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        content: Text(
          errorMessage,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ));
  }

  SnackBar _showSuccessSnackBar(String errorMessage) {
    return SnackBar(
        backgroundColor: Palette.activeCardColor,
        elevation: 5.0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        content: Text(
          errorMessage,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ));
  }

  Future<void> storeUserCredentials(
      String token, String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.TOKEN, token);
    prefs.setString(AppConstants.USER_NAME, username);
    prefs.setString(AppConstants.EMAIL, email);
  }

  void _userLogin(BuildContext context, String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        http.Response response = await http.get(Uri.parse(
            '${AppConstants.BASE_URL}/login?email=$email&password=$password&device_name=contact_phone'));
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);

          if (jsonMap['success']) {
            ScaffoldMessenger.of(context)
                .showSnackBar(//todo: sort lint context rule later
                    _showSuccessSnackBar('Login success!!!'));
            await storeUserCredentials(jsonMap['token'],
                jsonMap['datum']['name'], jsonMap['datum']['email']);
            Navigator.popAndPushNamed(context, AppRoutes.home);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(//todo: sort lint context rule later
                    _showSuccessSnackBar('Login failed!!!'));
          }
        } else {
          var errorResponse = response.body;
          debugPrint("response error code : ${response.statusCode} /n"
              "response body : $errorResponse");
          ScaffoldMessenger.of(context)
              .showSnackBar(//todo: sort lint context rule later
                  _showErrorSnackBar('Login failed. Try again later'));
        }
      } on SocketException {
        ScaffoldMessenger.of(context).showSnackBar(
            //todo: sort lint context rule later
            _showErrorSnackBar(
                'Check your internet connection then try again'));
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
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
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Text(
                            'Login',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.black,
                          autofocus: true,
                          validator: _emailValidator,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                            hintText: 'Email Address',
                            // ignore: prefer_const_constructors
                            hintStyle: TextStyle(
                              color: Colors.black,
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
                        TextFormField(
                          controller: _passwordController,
                          cursorColor: Colors.black,
                          autofocus: true,
                          obscureText: _isTextObscured,
                          validator: _fieldValidator,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                            hintText: 'Password',
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
                                  _isTextObscured = !_isTextObscured;
                                  _visibilityIcon = _changePasswordSuffixIcon(
                                      _visibilityIcon);
                                });
                                // _changePasswordSuffixIcon(_visibilityIcon);
                              },
                              child: Icon(
                                _visibilityIcon,
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
                            _userLogin(context, _emailController.text,
                                _passwordController.text);
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text("Don't have an account?"),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                Navigator.popAndPushNamed(
                                    context, AppRoutes.signUp);
                                //TODO navigate to the registration page
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Palette.highlightedTextColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.popAndPushNamed(
                                context, AppRoutes.resetPassword);
                            //TODO: password reset functionality
                          },
                          child: Text(
                            'Forgot your password?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Palette.highlightedTextColor),
                            //
                          ),
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
