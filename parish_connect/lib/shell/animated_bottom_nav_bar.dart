// animated_bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:parish_connect/components/shell/animated_nav_item.dart';
import 'package:parish_connect/shell/nav_item.dart';
import 'package:parish_connect/theme/theme.dart';

class AnimatedBottomNavBar extends StatelessWidget {
  const AnimatedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });
  final int currentIndex;
  final List<NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Wrap the main Container in a Padding widget to lift it,
    // or add padding directly to the Container if it's placed at the bottom.
    // Assuming this widget is placed inside a Scaffold's bottomNavigationBar
    // or directly at the bottom of the body.

    // We will apply padding directly to the Container's parent (or the Container itself
    // if its parent is providing the necessary constraints).
    // The safest way is to wrap it in a Padding widget or use margins
    // if it's not the root of the bottom bar area.

    // Since this component is likely passed directly to a Scaffold's bottomNavigationBar property,
    // adding padding/margin *around* it may not work as expected because Scaffold
    // positions it strictly at the bottom.

    // Instead, we can add a margin *below* the Container by wrapping it in Padding.
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Adjust this value (e.g., 16.0) to set the lift height
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppShadows.soft(context),
          border: Border.all(color: cs.outline.withOpacity(0.15)),
        ),
        child: Row(
          // FIX: Reverting the 'Expanded' wrap to resolve the ParentData conflict.
          // Using spaceAround to distribute navigation items horizontally.
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            for (int i = 0; i < items.length; i++)
              // Removed Expanded wrapper
              AnimatedNavItem(
                index: i,
                selected: i == currentIndex,
                item: items[i],
                onTap: () => onTap(i),
              ),
          ],
        ),
      ),
    );
  }
}
