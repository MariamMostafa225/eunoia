import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static bool darkMode = true;

  static Color get background => darkMode ? Color(0xFF102D29) : Color(0xFFF4F1E9);
  static Color get rail => darkMode ? Color(0xFF0C2522) : Color(0xFFE7EEE6);
  static Color get surface => darkMode ? Color(0xFF173A35) : Color(0xFFFFFDF8);
  static Color get surface2 => darkMode ? Color(0xFF1C4640) : Color(0xFFEDF3ED);
  static Color get sand => darkMode ? Color(0xFF244C45) : Color(0xFFD9E7DA);
  static Color get border => darkMode ? Color(0xFF31564F) : Color(0xFFD9E2D9);
  static Color get gold => darkMode ? Color(0xFFF4CC78) : Color(0xFFB17C21);
  static Color get goldDark => darkMode ? Color(0xFFE8B85C) : Color(0xFFC4953D);
  static Color get cream => darkMode ? Color(0xFFF7F2E8) : Color(0xFF233E36);
  static Color get muted => darkMode ? Color(0xFFB5C7BE) : Color(0xFF65796E);
  static Color get coral => darkMode ? Color(0xFFF0A18E) : Color(0xFFB96E59);
  static const forest = Color(0xFF214740);
  static const forestDark = Color(0xFF193A34);
}

class AppTheme {
  static ThemeData get current {
    final brightness = AppColors.darkMode ? Brightness.dark : Brightness.light;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        brightness: brightness,
        primary: AppColors.gold,
        onPrimary: AppColors.forestDark,
        surface: AppColors.surface,
        onSurface: AppColors.cream,
        outline: AppColors.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.gold,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.muted),
        labelStyle: TextStyle(color: AppColors.gold),
        filled: true,
        fillColor: AppColors.rail,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
       textTheme: GoogleFonts.amiriTextTheme(ThemeData(brightness: brightness).textTheme).apply(bodyColor: AppColors.cream, displayColor: AppColors.cream),
      fontFamily: GoogleFonts.amiri().fontFamily,
    );
  }
}
