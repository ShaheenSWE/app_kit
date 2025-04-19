import 'package:flutter/material.dart';

abstract final class AppTheme {
  // Default theme configuration
  static Color _primaryColor = Colors.blue;
  static Color _scaffoldBackgroundColor = Colors.white;
  static Color _appBarColor = Colors.blue;
  static Color _appBarTextColor = Colors.white;

  /// Configure theme in main.dart
  static void config({
    Color? primaryColor,
    Color? scaffoldBackgroundColor,
    Color? appBarColor,
    Color? appBarTextColor,
  }) {
    _primaryColor = primaryColor ?? _primaryColor;
    _scaffoldBackgroundColor = scaffoldBackgroundColor ?? _scaffoldBackgroundColor;
    _appBarColor = appBarColor ?? _primaryColor;
    _appBarTextColor = appBarTextColor ?? Colors.white;
  }

  /// Get the light theme
  static ThemeData get lightTheme => ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      secondary: _primaryColor,
    ),
    scaffoldBackgroundColor: _scaffoldBackgroundColor,
    appBarTheme: AppBarTheme(
      color: _appBarColor,
      titleTextStyle: TextStyle(
        color: _appBarTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: _appBarTextColor),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
    ),
  );
}