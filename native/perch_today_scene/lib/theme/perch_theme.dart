import 'package:flutter/material.dart';

ThemeData buildPerchTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F6F49),
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 44,
        fontWeight: FontWeight.w600,
        letterSpacing: -2.0,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        height: 1.25,
      ),
    ),
  );
}
