import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatChip extends ConsumerWidget {
  const StatChip({super.key, required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    // NOTE: Removing the Expanded wrapper here, as it's already wrapped
    // by the parent SCCOverviewTab.dart. While harmless, it's redundant.
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: cs.tertiary.withOpacity(0.15),
            child: Icon(icon, color: cs.tertiary),
          ),
          const SizedBox(width: 10),
          // FIX: Wrap the Column in Expanded to constrain the text content
          // and prevent overflow inside this inner Row.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              // To handle potential text overflow within the Column, the children 
              // will inherit the constraints of the Expanded widget.
              children: [
                Text(
                  label, 
                  style: Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis, // Added for safety
                ),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis, // Added for safety
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}