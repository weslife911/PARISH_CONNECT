import 'package:flutter/material.dart';

Widget buildExpansionSection(BuildContext context, String title, List<String> items) {
    final cs = Theme.of(context).colorScheme;
    if (items.isEmpty) {
      return const SizedBox.shrink(); // Hide if empty
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        iconColor: cs.primary,
        collapsedIconColor: cs.onSurfaceVariant,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(Icons.check_circle_outline, size: 16, color: cs.secondary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(item, style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }