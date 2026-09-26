import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';

class PantriBoxQuickAction extends StatelessWidget {
  const PantriBoxQuickAction({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return PantriBoxCard(
      onTap: onTap,
      padding: const EdgeInsets.all(PantriBoxSpacing.md),
      child: SizedBox(
        width: 156,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: palette.primarySoft,
                borderRadius: BorderRadius.circular(PantriBoxRadius.md),
              ),
              child: Icon(icon, color: palette.primary),
            ),
            const SizedBox(height: PantriBoxSpacing.md),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: PantriBoxSpacing.xs),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
