import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';

class PantriBoxLoadingState extends StatelessWidget {
  const PantriBoxLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(palette.primary),
          ),
        ),
        const SizedBox(width: PantriBoxSpacing.sm),
        Text(
          'Loading...',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}
