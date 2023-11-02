import 'package:flutter/material.dart';

import '../theme/color_palette.dart';

class AuthButton extends StatelessWidget {
  String buttonText;
  void Function() buttonFunction;

  AuthButton({
    required this.buttonText,
    required this.buttonFunction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        onTap: buttonFunction,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white, width: 1.0)),
        tileColor: Palette.activeCardColor,
        title: Center(
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
