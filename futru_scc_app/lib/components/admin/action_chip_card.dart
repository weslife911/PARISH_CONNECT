import 'package:flutter/material.dart';

class ActionChipCard extends StatelessWidget {
  const ActionChipCard({super.key, required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: cs.primaryContainer,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: cs.onPrimaryContainer),
          const SizedBox(width: 8),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}