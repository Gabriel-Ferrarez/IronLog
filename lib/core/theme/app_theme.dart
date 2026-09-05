import 'package:flutter/material.dart';

/// Tema visual do IronLog: fundo escuro com acento verde-limão neon,
/// transmitindo energia e foco — a "cara" de academia.
class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF0E0F13);
  static const Color surface = Color(0xFF171A21);
  static const Color surfaceHigh = Color(0xFF20242E);
  static const Color lime = Color(0xFFC8FF3D);
  static const Color orange = Color(0xFFFF6B3D);
  static const Color textMuted = Color(0xFF9AA0AD);

  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: lime,
      onPrimary: Color(0xFF10130A),
      secondary: orange,
      onSecondary: Color(0xFF2A0E05),
      surface: surface,
      onSurface: Color(0xFFEDEFF3),
      error: Color(0xFFFF5A5A),
      onError: Colors.white,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Color(0xFFEDEFF3),
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surfaceHigh,
        selectedColor: lime,
        side: BorderSide.none,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: const StadiumBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lime,
          foregroundColor: const Color(0xFF10130A),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: surfaceHigh,
          foregroundColor: const Color(0xFFEDEFF3),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: lime,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF262A34),
        thickness: 1,
      ),
    );
  }
}
