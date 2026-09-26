import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';

class PantriBoxEmptyState extends StatelessWidget {
  const PantriBoxEmptyState({
    required this.title,
    required this.message,
    super.key,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: palette.primarySoft,
            borderRadius: BorderRadius.circular(PantriBoxRadius.md),
          ),
          child: Icon(icon, size: 30, color: palette.primary),
        ),
        const SizedBox(height: PantriBoxSpacing.md),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: PantriBoxSpacing.xs),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: palette.textSecondary),
        ),
        if (action != null) ...[
          const SizedBox(height: PantriBoxSpacing.lg),
          action!,
        ],
      ],
    );
  }
}
