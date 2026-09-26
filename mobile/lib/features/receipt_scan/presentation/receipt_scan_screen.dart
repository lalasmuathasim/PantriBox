import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_empty_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_section_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_secondary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class ReceiptScanScreen extends StatelessWidget {
  const ReceiptScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            PantriBoxSpacing.lg,
            PantriBoxSpacing.md,
            PantriBoxSpacing.lg,
            PantriBoxSpacing.xxl,
          ),
          children: [
            const PantriBoxScreenHeader(
              eyebrow: 'Primary workflow',
              title: 'Scan receipt',
              subtitle:
                  'Receipt capture is central because it feeds purchase history and future price intelligence.',
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            PantriBoxCard(
              child: PantriBoxEmptyState(
                title: 'Turn receipts into price intelligence',
                message:
                    'Camera and gallery capture are routed through an abstraction so storage and OCR providers stay replaceable.',
                icon: Icons.receipt_long_outlined,
                action: Column(
                  children: [
                    PantriBoxPrimaryButton(
                      label: 'Scan receipt',
                      icon: Icons.photo_camera_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(height: PantriBoxSpacing.sm),
                    PantriBoxSecondaryButton(
                      label: 'Upload receipt',
                      icon: Icons.upload_file_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(height: PantriBoxSpacing.sm),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Use manual entry instead'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            const PantriBoxSectionHeader(
              title: 'Planned processing flow',
              subtitle: 'Deliberately modeled as replaceable steps.',
            ),
            const SizedBox(height: PantriBoxSpacing.sm),
            PantriBoxCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FlowStep('1', 'Receipt upload'),
                  _FlowStep('2', 'Object storage'),
                  _FlowStep('3', 'OCR extraction'),
                  _FlowStep('4', 'Receipt parser'),
                  _FlowStep('5', 'Product normalization'),
                  _FlowStep('6', 'User verification'),
                  const _FlowStep('7', 'Purchase and price observations'),
                  const SizedBox(height: PantriBoxSpacing.sm),
                  PantriBoxStatusChip(
                    label: 'Receipt text is never the canonical product identity',
                    tone: PantriBoxStatusTone.warning,
                    icon: Icons.info_outline_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowStep extends StatelessWidget {
  const _FlowStep(this.index, this.label);

  final String index;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: PantriBoxSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Text(index),
          ),
          const SizedBox(width: PantriBoxSpacing.sm),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
