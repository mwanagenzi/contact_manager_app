import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData() => ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Palette.primaryColor,
        secondary: Palette.activeCardColor,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        color: Palette.primaryColor,
        elevation: 2.0,
        shadowColor: Palette.activeCardColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: Palette.secondaryColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Palette.activeCardColor,
        backgroundColor: Colors.white,
        unselectedItemColor: Palette.hintTextColor,
      ),
      focusColor: Palette.linkTextColor,
      textTheme: AppTheme.textTheme);
  static TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
    ),
    labelMedium: TextStyle(
      fontSize: 15,
      color: Colors.black,
    ),
  );
}
