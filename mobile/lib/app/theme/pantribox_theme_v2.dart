import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_shadows.dart';
import 'package:pantribox_mobile/app/theme/pantribox_theme_palette.dart';

abstract final class PantriBoxThemeV2 {
  static const _background = Color(0xFFF8F4EE);
  static const _surface = Color(0xFFFFFFFF);
  static const _surfaceMuted = Color(0xFFF4EEE5);
  static const _surfaceElevated = Color(0xFFFFFCF8);
  static const _primary = Color(0xFFF26B2D);
  static const _primarySoft = Color(0xFFFFE5D7);
  static const _textPrimary = Color(0xFF16120F);
  static const _textSecondary = Color(0xFF6C655D);
  static const _textMuted = Color(0xFF9A9085);
  static const _border = Color(0xFFECE4D9);
  static const _divider = Color(0xFFF0E9DF);
  static const _success = Color(0xFF2B8A69);
  static const _warning = Color(0xFFBA7A2C);
  static const _error = Color(0xFFC24C39);
  static const _info = Color(0xFF4873D8);

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    const palette = PantriBoxThemePalette(
      background: _background,
      surface: _surface,
      surfaceElevated: _surfaceElevated,
      surfaceMuted: _surfaceMuted,
      primary: _primary,
      onPrimary: Colors.white,
      primarySoft: _primarySoft,
      textPrimary: _textPrimary,
      textSecondary: _textSecondary,
      textMuted: _textMuted,
      success: _success,
      warning: _warning,
      error: _error,
      info: _info,
      border: _border,
      divider: _divider,
      cardShadow: PantriBoxShadows.v2Card,
      floatingShadow: PantriBoxShadows.v2Floating,
      heroGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFF8F3), Color(0xFFFFE6D7)],
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: palette.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: _primary,
        onPrimary: Colors.white,
        secondary: _success,
        onSecondary: Colors.white,
        error: _error,
        onError: Colors.white,
        surface: _surface,
        onSurface: _textPrimary,
      ),
      textTheme: _textTheme(),
      extensions: const [palette],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _textPrimary,
        centerTitle: false,
      ),
      iconTheme: const IconThemeData(color: _textPrimary, size: 22),
      dividerColor: _divider,
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          color: _textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(
          color: _textMuted,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          borderSide: const BorderSide(color: _border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          borderSide: const BorderSide(color: _divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          borderSide: const BorderSide(color: _primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          borderSide: const BorderSide(color: _error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          borderSide: const BorderSide(color: _error, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          side: const BorderSide(color: _border),
          backgroundColor: _surface,
          foregroundColor: _textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primary,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.zero,
        iconColor: _textSecondary,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.pill),
        ),
        side: BorderSide.none,
      ),
    );
  }

  static TextTheme _textTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 44,
        height: 1.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.4,
        color: _textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        height: 1.05,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.1,
        color: _textPrimary,
      ),
      headlineLarge: TextStyle(
        fontSize: 30,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: _textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: _textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: _textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: _textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: _textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: _textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: _textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: _textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: _textSecondary,
      ),
    );
  }
}
