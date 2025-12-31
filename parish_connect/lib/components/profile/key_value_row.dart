import 'package:flutter/material.dart';

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({super.key, required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: cs.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ]),
    );
  }
}