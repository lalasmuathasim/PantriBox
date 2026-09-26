import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class PantriBoxMetricCard extends StatelessWidget {
  const PantriBoxMetricCard({
    required this.title,
    required this.value,
    super.key,
    this.subtitle,
    this.footnote,
    this.icon,
    this.badgeLabel,
    this.badgeTone = PantriBoxStatusTone.neutral,
    this.footer,
    this.emphasis = false,
  });

  final String title;
  final String value;
  final String? subtitle;
  final String? footnote;
  final IconData? icon;
  final String? badgeLabel;
  final PantriBoxStatusTone badgeTone;
  final Widget? footer;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: emphasis ? palette.heroGradient : null,
        borderRadius: BorderRadius.circular(PantriBoxRadius.lg),
      ),
      child: PantriBoxCard(
        backgroundColor: emphasis ? Colors.transparent : palette.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ),
                if (badgeLabel != null)
                  PantriBoxStatusChip(label: badgeLabel!, tone: badgeTone),
              ],
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            if (icon != null) ...[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.primarySoft,
                  borderRadius: BorderRadius.circular(PantriBoxRadius.md),
                ),
                child: Icon(icon, color: palette.primary),
              ),
              const SizedBox(height: PantriBoxSpacing.md),
            ],
            Text(value, style: Theme.of(context).textTheme.displayMedium),
            if (subtitle != null) ...[
              const SizedBox(height: PantriBoxSpacing.xs),
              Text(
                subtitle!,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: palette.textSecondary),
              ),
            ],
            if (footnote != null) ...[
              const SizedBox(height: PantriBoxSpacing.md),
              Text(
                footnote!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.textMuted),
              ),
            ],
            if (footer != null) ...[
              const SizedBox(height: PantriBoxSpacing.lg),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
