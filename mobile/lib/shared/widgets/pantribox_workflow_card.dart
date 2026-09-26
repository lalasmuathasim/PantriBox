import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';

enum PantriBoxWorkflowCardEmphasis { primary, secondary }

/// A tappable action card for an important, user-facing workflow.
class PantriBoxWorkflowCard extends StatelessWidget {
  const PantriBoxWorkflowCard({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.visual,
    required this.onTap,
    super.key,
    this.emphasis = PantriBoxWorkflowCardEmphasis.secondary,
    this.footer,
  });

  final String title;
  final String description;
  final String actionLabel;
  final Widget visual;
  final VoidCallback onTap;
  final PantriBoxWorkflowCardEmphasis emphasis;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;
    final isPrimary = emphasis == PantriBoxWorkflowCardEmphasis.primary;

    return Semantics(
      button: true,
      label: title,
      child: PantriBoxCard(
        backgroundColor: isPrimary ? palette.surfaceElevated : palette.surface,
        onTap: onTap,
        child: isPrimary
            ? _PrimaryWorkflowContent(
                title: title,
                description: description,
                actionLabel: actionLabel,
                visual: visual,
                footer: footer,
              )
            : _SecondaryWorkflowContent(
                title: title,
                description: description,
                actionLabel: actionLabel,
                visual: visual,
              ),
      ),
    );
  }
}

class _PrimaryWorkflowContent extends StatelessWidget {
  const _PrimaryWorkflowContent({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.visual,
    this.footer,
  });

  final String title;
  final String description;
  final String actionLabel;
  final Widget visual;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: visual),
            const SizedBox(width: PantriBoxSpacing.md),
            Icon(Icons.arrow_forward_rounded, color: palette.primary),
          ],
        ),
        const SizedBox(height: PantriBoxSpacing.lg),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: PantriBoxSpacing.xs),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: palette.textSecondary),
        ),
        const SizedBox(height: PantriBoxSpacing.md),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: PantriBoxSpacing.xs,
          children: [
            Text(
              actionLabel,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: palette.primary),
            ),
            Icon(Icons.arrow_forward_rounded, color: palette.primary, size: 18),
          ],
        ),
        if (footer != null) ...[
          const SizedBox(height: PantriBoxSpacing.xs),
          footer!,
        ],
      ],
    );
  }
}

class _SecondaryWorkflowContent extends StatelessWidget {
  const _SecondaryWorkflowContent({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.visual,
  });

  final String title;
  final String description;
  final String actionLabel;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        visual,
        const SizedBox(height: PantriBoxSpacing.md),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: PantriBoxSpacing.xs),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: palette.textSecondary),
        ),
        const SizedBox(height: PantriBoxSpacing.md),
        Icon(Icons.arrow_forward_rounded, color: palette.primary, size: 20),
      ],
    );
  }
}
