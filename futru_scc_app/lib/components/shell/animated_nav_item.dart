import 'package:flutter/material.dart';
import 'package:futru_scc_app/shell/nav_item.dart';

class AnimatedNavItem extends StatelessWidget {
  const AnimatedNavItem({
    super.key,
    required this.index,
    required this.selected,
    required this.item,
    required this.onTap,
  });
  final int index;
  final bool selected;
  final NavItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? cs.primaryContainer.withValues(alpha: 0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon,
                  color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: SizedBox(width: selected ? 8 : 0),
              ),
              // FIX: Wrap AnimatedOpacity with Expanded to constrain the Text widget.
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: selected ? 1 : 0,
                  child: Text(
                    selected ? item.label : '',
                    overflow: TextOverflow.ellipsis, // Use ellipsis for clear constraint
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}