import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryColor = Color(0xFFFFB6C1); // Light pink
  static const Color primaryLight = Color(0xFFFFE4E1); // Misty rose
  static const Color primaryDark = Color(0xFFFF69B4); // Hot pink
  static const Color accentColor = Color(0xFFFF85A2); // Pink sherbet
  static const Color backgroundColor = Color(
    0xFFFFFAFA,
  ); // Snow white with pink tint
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Color(0xFF333333);
  static const Color onSurface = Color(0xFF333333);
  static const Color onError = Colors.white;

  // Text Theme
  static TextTheme lightTextTheme = const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: onBackground,
    ),
    displayMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: onBackground,
    ),
    bodyLarge: TextStyle(fontSize: 16.0, color: onBackground),
    bodyMedium: TextStyle(fontSize: 14.0, color: onBackground),
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: onPrimary,
    ),
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryLight,
      secondary: accentColor,
      surface: backgroundColor,
      error: errorColor,
      onPrimary: onPrimary,
      onSurface: onSurface,
      onError: onError,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: onBackground,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
      iconTheme: IconThemeData(color: onBackground),
    ),
    textTheme: lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        textStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: errorColor),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    cardTheme: const CardThemeData(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      color: surfaceColor,
    ),
  );

  // Dark Theme (optional, can be implemented later)
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    // We can implement dark theme later if needed
  );
}
