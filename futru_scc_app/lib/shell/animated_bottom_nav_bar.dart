import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/shell/animated_nav_item.dart';
import 'package:futru_scc_app/shell/nav_item.dart';
import 'package:futru_scc_app/theme/theme.dart';

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
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.soft(context),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++)
            AnimatedNavItem(
              index: i,
              selected: i == currentIndex,
              item: items[i],
              onTap: () => onTap(i),
            ),
        ],
      ),
    );
  }
}