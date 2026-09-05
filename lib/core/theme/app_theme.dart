import 'package:flutter/material.dart';

/// Tema "High-Performance Dark" do IronLog.
///
/// Fundo grafite (nunca preto puro), tons de cinza para separar blocos por
/// contraste sutil, e UMA única cor de destaque (verde-limão elétrico) usada
/// com moderação — apenas em ações e progresso. Sem sombras borradas: os
/// blocos são delimitados por bordas finas e nítidas. Cantos retos (raio 4).
class AppTheme {
  AppTheme._();

  // Base grafite.
  static const Color bg = Color(0xFF121212);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceAlt = Color(0xFF202020);

  // Bordas nítidas (substituem sombras).
  static const Color border = Color(0xFF2A2A2A);
  static const Color borderStrong = Color(0xFF3A3A3A);

  // Destaque único (usar com extrema moderação).
  static const Color accent = Color(0xFFCCFF00);
  static const Color onAccent = Color(0xFF0A0A0A);

  // Tipografia.
  static const Color text = Color(0xFFF5F5F5);
  static const Color textDim = Color(0xFF9A9A9A);
  static const Color textFaint = Color(0xFF6A6A6A);

  /// Raio industrial: reto e agressivo.
  static const double radius = 4;

  /// Estilo de título de treino: pesado e condensado, para passar força.
  static const TextStyle heavyTitle = TextStyle(
    color: text,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    height: 1.05,
  );

  /// Eyebrow / rótulo em caixa alta.
  static const TextStyle label = TextStyle(
    color: textDim,
    fontWeight: FontWeight.w700,
    fontSize: 11,
    letterSpacing: 1.5,
  );

  /// Decoração padrão de um bloco: cinza sutil + borda nítida.
  static BoxDecoration panel({Color? color, Color? borderColor}) =>
      BoxDecoration(
        color: color ?? surface,
        border: Border.all(color: borderColor ?? border),
        borderRadius: BorderRadius.circular(radius),
      );

  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: accent,
      onPrimary: onAccent,
      secondary: accent,
      onSecondary: onAccent,
      surface: surface,
      onSurface: text,
      error: Color(0xFFFF4D4D),
      onError: Colors.white,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: heavyTitle,
        titleLarge: heavyTitle,
        titleMedium: const TextStyle(
          color: text,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        bodyMedium: const TextStyle(color: text),
        bodySmall: const TextStyle(color: textDim),
      ),
      // Mantido por segurança; a UI usa Container com borda (AppTheme.panel).
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: const BorderSide(color: borderStrong),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: accent,
        side: const BorderSide(color: border),
        labelStyle: const TextStyle(
          color: text,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        secondaryLabelStyle:
            const TextStyle(color: onAccent, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: textFaint),
        labelStyle: const TextStyle(color: textDim),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: accent),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bg,
        selectedItemColor: accent,
        unselectedItemColor: textFaint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11, letterSpacing: 0.5),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: surfaceAlt,
        contentTextStyle: TextStyle(color: text, fontWeight: FontWeight.w600),
      ),
    );
  }
}
