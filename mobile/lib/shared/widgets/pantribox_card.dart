import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';

class PantriBoxCard extends StatelessWidget {
  const PantriBoxCard({
    required this.child,
    super.key,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(PantriBoxSpacing.lg),
    this.onTap,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.surface,
        borderRadius: BorderRadius.circular(PantriBoxRadius.lg),
        boxShadow: palette.cardShadow,
      ),
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(PantriBoxRadius.lg),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
