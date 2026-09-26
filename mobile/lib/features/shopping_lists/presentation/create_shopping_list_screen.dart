import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class CreateShoppingListScreen extends StatelessWidget {
  const CreateShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PantriBoxSpacing.lg),
          children: [
            const PantriBoxScreenHeader(
              eyebrow: 'List foundation',
              title: 'Create shopping list',
              subtitle:
                  'Start with a clean structured list so price comparison and future optimization remain deterministic.',
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            const PantriBoxStatusChip(
              label: 'Structure first',
              tone: PantriBoxStatusTone.primary,
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            PantriBoxCard(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'List name'),
                  ),
                  SizedBox(height: PantriBoxSpacing.md),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'First item',
                      hintText: 'Milk, eggs, rice...',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            PantriBoxPrimaryButton(
              label: 'Save placeholder',
              icon: Icons.check_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
