import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // static ThemeData themeData() {
  //   return ThemeData(
  //     appBarTheme: const AppBarTheme(
  //       color: Palette.primaryColor,
  //       elevation: 2.0,
  //       shadowColor: Palette.activeCardColor,
  //       iconTheme: IconThemeData(color: Colors.white),
  //     ),
  //     scaffoldBackgroundColor: Palette.primaryColor,
  //     textTheme: AppTheme.textTheme,
  //
  //     // ignore: prefer_const_constructors
  //     bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //       selectedItemColor: Colors.black,
  //       backgroundColor: Colors.white,
  //       unselectedItemColor: Palette.inactiveCardColor,
  //     ),
  //   );
  // }
  //
  // static TextTheme textTheme = const TextTheme(
  //   displayLarge: TextStyle(
  //     color: Colors.white,
  //     fontSize: 30,
  //   ),
  //   displayMedium: TextStyle(
  //     fontSize: 20,
  //     color: Colors.white,
  //   ),
  //   displaySmall: TextStyle(
  //     color: Colors.white,
  //     fontSize: 18,
  //   ),
  //   headlineMedium: TextStyle(
  //     color: Colors.white,
  //     fontSize: 12,
  //   ),
  //   headlineSmall: TextStyle(
  //     color: Colors.white,
  //     fontSize: 22,
  //   ),
  //   titleLarge: TextStyle(
  //     color: Colors.white,
  //     fontSize: 13,
  //   ),
  //   bodyLarge: TextStyle(
  //     fontWeight: FontWeight.normal,
  //     fontSize: 20,
  //     color: Colors.white,
  //   ),
  //   bodyMedium: TextStyle(
  //     fontSize: 17,
  //     color: Colors.white,
  //   ),
  //   labelMedium: TextStyle(
  //     fontSize: 15,
  //     color: Colors.white,
  //   ),
  // );
  static ThemeData themeData() => ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Palette.primaryColor,
        secondary: Palette.secondaryColor,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: Palette.secondaryColor,
      focusColor: Palette.primaryColor,
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
        bodyText1: TextStyle(
          fontSize: 18,
        ),
        bodyText2: TextStyle(
          fontSize: 16,
        ),
        labelMedium: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ));
}
