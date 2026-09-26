import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_theme_palette.dart';

extension PantriBoxThemeExtension on BuildContext {
  PantriBoxThemePalette get pantriBoxTheme {
    final palette = Theme.of(this).extension<PantriBoxThemePalette>();
    assert(
      palette != null,
      'PantriBoxThemePalette is missing from ThemeData.extensions',
    );
    return palette!;
  }
}
