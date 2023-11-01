import 'package:contacts_manager/utils/app_constants.dart';
import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:contacts_manager/views/widgets/auth_button.dart';
import 'package:flutter/material.dart';

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
    } else if (passFieldValue.length <= 8) {
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
        backgroundColor: Palette.inactiveCardColor,
        elevation: 2.0,
        content: Text(
          errorMessage,
          style: Theme.of(context).textTheme.bodyText2,
        ));
  }

  void _userLogin(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        print("Trying to sign in before firebase auth");
        // await FirebaseAuth.instance.signInWithEmailAndPassword(
        //     email: _emailController.text, password: _passwordController.text);
        // print("Trying to sign in after firebase auth");
        Navigator.popAndPushNamed(context, AppRoutes.home);
      }
    }
    // on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(_showErrorSnackBar('No user found for that email.'));
    //   } else if (e.code == 'wrong-pasword') {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         _showErrorSnackBar('Wrong password provided for that user.'));
    //   }
    // }
    catch (e) {
      print(e);
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
                                .headline5!
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
                                .bodyText2!
                                .copyWith(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                            focusColor: Palette.highlightedTextColor,
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
                                .bodyText2!
                                .copyWith(color: Colors.black),
                            focusColor: Palette.highlightedTextColor,
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
                            _userLogin(context);
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
