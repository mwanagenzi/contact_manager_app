import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import '../theme/color_palette.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_screen_svg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void deactivate() {
    _passwordController.dispose();
    _emailController.dispose();
    super.deactivate();
  }

  bool isTextObscured = true;
  IconData visibilityIcon = Icons.visibility_off;

  IconData _changePasswordSuffixIcon(IconData visibleIcon) {
    if (visibleIcon == Icons.visibility) {
      return visibleIcon = Icons.visibility_off;
    } else {
      return visibleIcon = Icons.visibility;
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

  String? _fieldValidator(String? passFieldValue) {
    if (passFieldValue == null || passFieldValue.isEmpty) {
      return 'This field must contain a value';
    } else if (passFieldValue.length <= 8) {
      return 'Password must contain more than 8 characters';
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
          style: Theme.of(context).textTheme.bodyMedium,
        ));
  }

  void _userSignUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //   email: _emailController.text,
        //   password: _passwordController.text,
        // );
        Navigator.popAndPushNamed(context, AppRoutes.login);
      }
      // on FirebaseAuthException catch (e) {
      //   if (e.code == 'weak-password') {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         _showErrorSnackBar('The password provided is too weak.'));
      //   } else if (e.code == 'email-already-in-use') {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         _showErrorSnackBar('The account already exists for that email.'));
      //   }
      // }
      catch (e) {
        print(e);
      }
      Navigator.popAndPushNamed(context, AppRoutes.login);
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
                            'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.black,
                          autofocus: true,
                          validator: _emailValidator,
                          decoration: InputDecoration(
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
                          obscureText: isTextObscured,
                          validator: _fieldValidator,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
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
                                  isTextObscured = !isTextObscured;
                                  visibilityIcon =
                                      _changePasswordSuffixIcon(visibilityIcon);
                                });
                                // _changePasswordSuffixIcon(visibilityIcon);
                              },
                              child: Icon(
                                visibilityIcon,
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
                            _userSignUp(context);
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text('or',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text("Already have an account?"),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                Navigator.popAndPushNamed(
                                    context, AppRoutes.login);
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Palette.highlightedTextColor),
                              ),
                            ),
                          ],
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
