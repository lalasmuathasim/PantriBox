import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';

enum PantriBoxStatusTone { primary, success, warning, neutral, info }

class PantriBoxStatusChip extends StatelessWidget {
  const PantriBoxStatusChip({
    required this.label,
    super.key,
    this.tone = PantriBoxStatusTone.neutral,
    this.icon,
  });

  final String label;
  final PantriBoxStatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    final (background, foreground) = switch (tone) {
      PantriBoxStatusTone.primary => (palette.primarySoft, palette.primary),
      PantriBoxStatusTone.success => (
        palette.success.withValues(alpha: 0.14),
        palette.success,
      ),
      PantriBoxStatusTone.warning => (
        palette.warning.withValues(alpha: 0.14),
        palette.warning,
      ),
      PantriBoxStatusTone.info => (
        palette.info.withValues(alpha: 0.14),
        palette.info,
      ),
      PantriBoxStatusTone.neutral => (
        palette.surfaceMuted,
        palette.textSecondary,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(PantriBoxRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: PantriBoxSpacing.xs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
