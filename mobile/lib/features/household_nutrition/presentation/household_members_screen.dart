import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/features/household_nutrition/application/household_nutrition_models.dart';
import 'package:pantribox_mobile/features/household_nutrition/application/household_nutrition_repository.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_empty_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_loading_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_page_app_bar.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';

final householdMembersProvider = FutureProvider.autoDispose
    .family<List<HouseholdMember>, String>((ref, householdId) {
      return ref
          .watch(householdNutritionRepositoryProvider)
          .fetchMembers(householdId);
    });

class HouseholdMembersScreen extends ConsumerWidget {
  const HouseholdMembersScreen({super.key, this.householdId});

  final String? householdId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final householdId = this.householdId;
    return Scaffold(
      appBar: const PantriBoxPageAppBar(),
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
              eyebrow: 'Household profile',
              title: 'Household members',
              subtitle:
                  'Keep this profile lightweight. PantriBox does not collect medical details for grocery coverage insights.',
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            if (householdId == null)
              const PantriBoxCard(
                child: PantriBoxEmptyState(
                  title: 'Household setup needs an account',
                  message:
                      'Member management will connect to the active household once authentication is implemented.',
                  icon: Icons.groups_outlined,
                ),
              )
            else
              _MemberList(householdId: householdId),
          ],
        ),
      ),
    );
  }
}

class _MemberList extends ConsumerWidget {
  const _MemberList({required this.householdId});

  final String householdId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(householdMembersProvider(householdId));
    return members.when(
      loading: () => const PantriBoxCard(child: PantriBoxLoadingState()),
      error: (error, stackTrace) => const PantriBoxCard(
        child: PantriBoxEmptyState(
          title: 'Members are unavailable',
          message: 'Try again when the household connection is available.',
          icon: Icons.cloud_off_outlined,
        ),
      ),
      data: (data) => Column(
        children: [
          if (data.isEmpty)
            const PantriBoxCard(
              child: PantriBoxEmptyState(
                title: 'Add your first household member',
                message:
                    'A name is enough to start. Date of birth and sex remain optional until an approved methodology requires them.',
                icon: Icons.person_add_alt_1_outlined,
              ),
            ),
          ...data.map(
            (member) => Padding(
              padding: const EdgeInsets.only(bottom: PantriBoxSpacing.sm),
              child: PantriBoxCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(
                        member.displayName.isEmpty
                            ? '?'
                            : member.displayName.substring(0, 1),
                      ),
                    ),
                    const SizedBox(width: PantriBoxSpacing.md),
                    Expanded(
                      child: Text(
                        member.displayName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit ${member.displayName}',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () =>
                          _showMemberEditor(context, ref, householdId, member),
                    ),
                    IconButton(
                      tooltip: 'Deactivate ${member.displayName}',
                      icon: Icon(
                        Icons.person_remove_outlined,
                        color: context.pantriBoxTheme.error,
                      ),
                      onPressed: () async {
                        await ref
                            .read(householdNutritionRepositoryProvider)
                            .deactivateMember(
                              householdId: householdId,
                              memberId: member.id,
                            );
                        ref.invalidate(householdMembersProvider(householdId));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.md),
          PantriBoxPrimaryButton(
            label: 'Add household member',
            icon: Icons.person_add_alt_1_outlined,
            onPressed: () => _showMemberEditor(context, ref, householdId, null),
          ),
        ],
      ),
    );
  }
}

Future<void> _showMemberEditor(
  BuildContext context,
  WidgetRef ref,
  String householdId,
  HouseholdMember? member,
) async {
  final controller = TextEditingController(text: member?.displayName ?? '');
  var selectedDateOfBirth = member?.dateOfBirth;
  var selectedSex = member?.sex;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setSheetState) => Padding(
        padding: EdgeInsets.fromLTRB(
          PantriBoxSpacing.lg,
          PantriBoxSpacing.lg,
          PantriBoxSpacing.lg,
          MediaQuery.viewInsetsOf(sheetContext).bottom + PantriBoxSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              member == null ? 'Add member' : 'Edit member',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: PantriBoxSpacing.md),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: PantriBoxSpacing.md),
            OutlinedButton.icon(
              icon: const Icon(Icons.cake_outlined),
              label: Text(
                selectedDateOfBirth == null
                    ? 'Add date of birth (optional)'
                    : 'Date of birth: ${_formatDate(selectedDateOfBirth!)}',
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: sheetContext,
                  initialDate: selectedDateOfBirth ?? DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setSheetState(() => selectedDateOfBirth = date);
                }
              },
            ),
            const SizedBox(height: PantriBoxSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: selectedSex,
              decoration: const InputDecoration(labelText: 'Sex (optional)'),
              items: const [
                DropdownMenuItem(value: 'female', child: Text('Female')),
                DropdownMenuItem(value: 'male', child: Text('Male')),
                DropdownMenuItem(
                  value: 'unspecified',
                  child: Text('Prefer not to say'),
                ),
              ],
              onChanged: (value) => setSheetState(() => selectedSex = value),
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            PantriBoxPrimaryButton(
              label: member == null ? 'Add member' : 'Save changes',
              onPressed: () async {
                final repository = ref.read(
                  householdNutritionRepositoryProvider,
                );
                if (member == null) {
                  await repository.createMember(
                    householdId: householdId,
                    displayName: controller.text,
                    dateOfBirth: selectedDateOfBirth,
                    sex: selectedSex,
                  );
                } else {
                  await repository.updateMember(
                    householdId: householdId,
                    member: member,
                    displayName: controller.text,
                    dateOfBirth: selectedDateOfBirth,
                    sex: selectedSex,
                  );
                }
                ref.invalidate(householdMembersProvider(householdId));
                if (sheetContext.mounted) Navigator.of(sheetContext).pop();
              },
            ),
          ],
        ),
      ),
    ),
  );
  controller.dispose();
}

String _formatDate(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
