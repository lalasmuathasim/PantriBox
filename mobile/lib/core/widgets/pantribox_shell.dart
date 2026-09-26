import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';

class PantriBoxShell extends StatelessWidget {
  const PantriBoxShell({
    required this.currentLocation,
    required this.child,
    super.key,
  });

  final String currentLocation;
  final Widget child;

  static const _items = <_NavItem>[
    _NavItem(label: 'Home', icon: Icons.home_outlined, route: '/home'),
    _NavItem(label: 'Lists', icon: Icons.checklist_rounded, route: '/lists'),
    _NavItem(
      label: 'Scan',
      icon: Icons.document_scanner_outlined,
      route: '/scan',
    ),
    _NavItem(
      label: 'Insights',
      icon: Icons.auto_graph_outlined,
      route: '/insights',
    ),
    _NavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            PantriBoxSpacing.md,
            0,
            PantriBoxSpacing.md,
            PantriBoxSpacing.md,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.surfaceElevated,
              borderRadius: BorderRadius.circular(PantriBoxRadius.xl),
              boxShadow: palette.floatingShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _items.map((item) {
                final selected = currentLocation == item.route;
                final isScan = item.route == '/scan';
                return Expanded(
                  child: Semantics(
                    button: true,
                    label: item.label,
                    selected: selected,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(PantriBoxRadius.lg),
                      onTap: () => context.go(item.route),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: PantriBoxSpacing.sm,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              padding: EdgeInsets.symmetric(
                                horizontal: isScan ? 14 : 10,
                                vertical: isScan ? 10 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? (isScan
                                          ? palette.primary
                                          : palette.primarySoft)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  isScan
                                      ? PantriBoxRadius.pill
                                      : PantriBoxRadius.md,
                                ),
                              ),
                              child: Icon(
                                item.icon,
                                size: isScan ? 22 : 21,
                                color: selected
                                    ? (isScan
                                          ? palette.onPrimary
                                          : palette.primary)
                                    : palette.textMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.label,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: selected
                                        ? palette.textPrimary
                                        : palette.textMuted,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
