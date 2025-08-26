import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_ai/app/data/app_constants.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF079DF5);
  static const Color secondaryColor = Color(0xFF0B4FD1);
  static const Color thirdColor = Color(0xFF282D31);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.arimo().fontFamily,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: const BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: thirdColor,
    ),
    scaffoldBackgroundColor: Color(0xFFf9f9f9),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
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
    fontFamily: GoogleFonts.lato().fontFamily,
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
      centerTitle: true,
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
