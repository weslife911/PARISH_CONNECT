import 'package:flutter/material.dart';

class StatChip extends StatelessWidget {
  const StatChip({super.key, required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: cs.tertiary.withValues(alpha: 0.15),
              child: Icon(icon, color: cs.tertiary),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(value,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ],
            )
          ],
        ),
      ),
    );
  }
}