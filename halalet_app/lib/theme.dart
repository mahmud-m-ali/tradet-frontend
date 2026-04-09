import 'package:flutter/material.dart';

class HalalEtTheme {
  // Brand colors — rich green palette, easy on the eyes
  static const Color primary = Color(0xFF1B8A5A);
  static const Color primaryDark = Color(0xFF0F4C30);
  static const Color primaryLight = Color(0xFF27AE60);
  static const Color accent = Color(0xFFD4AF37); // Gold
  static const Color surface = Color(0xFF0D3B20); // Deep green bg
  static const Color surfaceLight = Color(0xFF134A2C);
  static const Color surfaceMedium = Color(0xFF1A5C38);
  static const Color cardBg = Color(0xFF164D30);
  static const Color cardBgLight = Color(0xFF1E5E3C);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA8D5BA);
  static const Color textMuted = Color(0xFF6DAF87);
  static const Color positive = Color(0xFF4ADE80);
  static const Color negative = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFBBF24);
  static const Color divider = Color(0xFF1F6B42);

  static LinearGradient get bgGradient => const LinearGradient(
        colors: [Color(0xFF0D3B20), Color(0xFF134A2C), Color(0xFF1A5C38)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient get cardGradient => const LinearGradient(
        colors: [Color(0xFF1A5C38), Color(0xFF22704A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get heroGradient => const LinearGradient(
        colors: [Color(0xFF27AE60), Color(0xFF1B8A5A), Color(0xFF0F6B3C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static BoxShadow get cardShadow => BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 12,
        offset: const Offset(0, 4),
      );

  // Light theme colors
  static const Color lightSurface = Color(0xFFF5F9F7);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF5A7268);
  static const Color lightTextMuted = Color(0xFF8A9E95);
  static const Color lightDivider = Color(0xFFDDE8E2);

  static LinearGradient get lightBgGradient => const LinearGradient(
        colors: [Color(0xFFEFF6F2), Color(0xFFF5F9F7), Color(0xFFFAFCFB)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient get lightCardGradient => const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFF8FBF9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: accent,
          surface: surface,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: surface,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryLight,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryLight, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: textSecondary),
          hintStyle: const TextStyle(color: textMuted),
          prefixIconColor: textMuted,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: primaryDark,
          elevation: 0,
          height: 72,
          indicatorColor: primaryLight.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: positive);
            }
            return const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500, color: textMuted);
          }),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: accent,
          surface: lightSurface,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: lightSurface,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: lightTextPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: lightTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          color: lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: lightDivider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: lightDivider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: lightTextSecondary),
          hintStyle: const TextStyle(color: lightTextMuted),
          prefixIconColor: lightTextMuted,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 2,
          height: 72,
          indicatorColor: primary.withValues(alpha: 0.15),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: primary);
            }
            return const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500, color: lightTextMuted);
          }),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  // For backward compatibility: alias to darkTheme
  // Previous code called `lightTheme` but it was actually dark-themed
}
