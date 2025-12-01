import 'package:flutter/material.dart';

class BackendNote extends StatelessWidget {
  const BackendNote({super.key, required this.cs});
  final ColorScheme cs;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        const Icon(Icons.info_outline),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'No backend connected. To enable real auth, open the Firebase or Supabase panel in Dreamflow and complete setup.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
      ]),
    );
  }
}