enum PantriBoxThemeVariant {
  legacy,
  v2;

  static PantriBoxThemeVariant current() {
    const configured = String.fromEnvironment(
      'PANTRIBOX_THEME_VARIANT',
      defaultValue: 'v2',
    );

    return configured == 'legacy'
        ? PantriBoxThemeVariant.legacy
        : PantriBoxThemeVariant.v2;
  }
}
