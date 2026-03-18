import 'package:flutter/material.dart';

class AppTheme {
  // Plum Focus palette
  static const Color primary = Color(0xFF5B2C6F);
  static const Color primaryLight = Color(0xFF7D3C98);
  static const Color secondary = Color(0xFF9B72CF);
  static const Color accent = Color(0xFF4ECDC4);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFE8A54B);
  static const Color danger = Color(0xFFE74C3C);

  static const Color surface = Color(0xFFF5F3FF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1035);
  static const Color textSecondary = Color(0xFF7C6F99);
  static const Color divider = Color(0xFFE8E0F0);

  static Color priorityColor(String priority) {
    switch (priority) {
      case 'high': return danger;
      case 'medium': return warning;
      case 'low': return accent;
      default: return textSecondary;
    }
  }

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
