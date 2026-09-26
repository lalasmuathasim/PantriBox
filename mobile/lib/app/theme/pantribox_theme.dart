import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_colors.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_shadows.dart';
import 'package:pantribox_mobile/app/theme/pantribox_theme_palette.dart';
import 'package:pantribox_mobile/app/theme/pantribox_typography.dart';

abstract final class PantriBoxTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    const palette = PantriBoxThemePalette(
      background: PantriBoxColors.background,
      surface: PantriBoxColors.surface,
      surfaceElevated: PantriBoxColors.surface,
      surfaceMuted: PantriBoxColors.surfaceMuted,
      primary: PantriBoxColors.accent,
      onPrimary: PantriBoxColors.onAccent,
      primarySoft: PantriBoxColors.accentSoft,
      textPrimary: PantriBoxColors.textPrimary,
      textSecondary: PantriBoxColors.textSecondary,
      textMuted: PantriBoxColors.textMuted,
      success: PantriBoxColors.success,
      warning: PantriBoxColors.warning,
      error: PantriBoxColors.error,
      info: PantriBoxColors.info,
      border: PantriBoxColors.border,
      divider: PantriBoxColors.divider,
      cardShadow: PantriBoxShadows.legacyCard,
      floatingShadow: PantriBoxShadows.legacyCard,
      heroGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [PantriBoxColors.surface, PantriBoxColors.accentSoft],
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: PantriBoxColors.canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PantriBoxColors.accent,
        brightness: Brightness.light,
        primary: PantriBoxColors.accent,
        surface: PantriBoxColors.surface,
        secondary: PantriBoxColors.warning,
      ),
      textTheme: PantriBoxTypography.textTheme(),
      extensions: const [palette],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: PantriBoxColors.textPrimary,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: PantriBoxColors.surface,
        shadowColor: PantriBoxColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PantriBoxColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          borderSide: const BorderSide(color: PantriBoxColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          borderSide: const BorderSide(color: PantriBoxColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          borderSide: const BorderSide(
            color: PantriBoxColors.accent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
