import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_colors.dart';

abstract final class PantriBoxTypography {
  static TextTheme textTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        height: 1.1,
        fontWeight: FontWeight.w700,
        color: PantriBoxColors.textPrimary,
        letterSpacing: -0.7,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: PantriBoxColors.textPrimary,
        letterSpacing: -0.4,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: PantriBoxColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: PantriBoxColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: PantriBoxColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: PantriBoxColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: PantriBoxColors.textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: PantriBoxColors.textPrimary,
      ),
    );
  }
}
