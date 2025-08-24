import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF079DF5);
  static const Color secondaryColor = Color(0xFF0B4FD1);
  static const Color thirdColor = Color(0xFF282D31);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: thirdColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: thirdColor, fontSize: 16),
      bodyMedium: TextStyle(color: thirdColor, fontSize: 14),
      titleLarge: TextStyle(
        color: thirdColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: thirdColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: thirdColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: thirdColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
