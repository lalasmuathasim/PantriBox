import 'package:flutter/material.dart';

/// A minimal app bar for secondary pages that have a route to return to.
class PantriBoxPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PantriBoxPageAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final canPop = navigator.canPop();
    final platform = Theme.of(context).platform;
    final isApplePlatform =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: canPop
          ? IconButton(
              tooltip: 'Back',
              onPressed: navigator.pop,
              icon: Icon(
                isApplePlatform
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.arrow_back_rounded,
                size: isApplePlatform ? 18 : 22,
              ),
            )
          : null,
    );
  }
}
