import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFAF9F6);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);
  
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color subtitleGray = Color(0xFF94A3B8);
  static const Color charcoalDark = Color(0xFF1E293B);

  static const Color accentBlue = Color(0xFF0284C7);
  static const Color accentPurple = Color(0xFF7C3AED);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentRed = Color(0xFFEF4444);

  static const Color chipBg = Color(0xFFF1F5F9);
  static const Color cardBgIceBlue = Color(0xFFEBF8FF);
  static const Color cardBgPeach = Color(0xFFFFF7ED);
  static const Color cardBgMint = Color(0xFFECFDF5);
  static const Color cardBgLavender = Color(0xFFF5F3FF);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.charcoalDark,
        background: AppColors.background,
        surface: AppColors.surfaceWhite,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
