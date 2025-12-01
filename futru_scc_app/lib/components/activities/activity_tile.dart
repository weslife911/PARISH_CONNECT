import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({super.key, required this.title, required this.subtitle, this.onTap});
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: CircleAvatar(
          backgroundColor: cs.tertiary.withValues(alpha: 0.18),
          child: Icon(Icons.event, color: cs.tertiary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}