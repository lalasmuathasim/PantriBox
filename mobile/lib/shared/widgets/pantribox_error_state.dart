import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';

class PantriBoxErrorState extends StatelessWidget {
  const PantriBoxErrorState({
    required this.title,
    required this.message,
    this.primaryActionLabel,
    this.onPrimaryAction,
    super.key,
  });

  final String title;
  final String message;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Padding(
      padding: const EdgeInsets.all(PantriBoxSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 36, color: palette.error),
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
          if (primaryActionLabel != null && onPrimaryAction != null) ...[
            const SizedBox(height: PantriBoxSpacing.lg),
            PantriBoxPrimaryButton(
              label: primaryActionLabel!,
              onPressed: onPrimaryAction!,
            ),
          ],
        ],
      ),
    );
  }
}
