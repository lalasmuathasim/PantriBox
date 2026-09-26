import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/core/api/system_api_repository.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_loading_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_section_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

final apiVersionProvider = FutureProvider((ref) {
  return ref.watch(systemApiRepositoryProvider).fetchVersion();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(apiVersionProvider);
    final palette = context.pantriBoxTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          PantriBoxSpacing.lg,
          PantriBoxSpacing.md,
          PantriBoxSpacing.lg,
          120,
        ),
        children: [
          const PantriBoxScreenHeader(
            eyebrow: 'Account and app setup',
            title: 'Profile',
            subtitle:
                'This bootstrap profile stays lightweight while the account and household specs mature.',
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          PantriBoxCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: palette.primarySoft,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: palette.primary,
                  ),
                ),
                const SizedBox(width: PantriBoxSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PantriBox Household',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: PantriBoxSpacing.xs),
                      Text(
                        'Identity, roles, and linked providers will expand in the authentication and household specs.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          const PantriBoxSectionHeader(
            title: 'Backend connectivity',
            subtitle:
                'Representative contract integration through the versioned REST API.',
          ),
          const SizedBox(height: PantriBoxSpacing.sm),
          version.when(
            loading: () => const PantriBoxCard(child: PantriBoxLoadingState()),
            error: (error, stackTrace) =>
                PantriBoxCard(child: Text('Unable to load API info: $error')),
            data: (data) => PantriBoxCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: PantriBoxSpacing.xs),
                  Text(
                    'Version ${data.version} · ${data.apiPrefix}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: PantriBoxSpacing.md),
                  Text(
                    data.mcpCapabilities.isEmpty
                        ? 'No MCP capabilities advertised yet.'
                        : 'MCP-ready capabilities: ${data.mcpCapabilities.map((capability) => capability.name).join(', ')}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: PantriBoxSpacing.md),
                  const PantriBoxStatusChip(
                    label: 'REST and MCP share the same service boundary',
                    tone: PantriBoxStatusTone.success,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
