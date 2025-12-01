import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../widgets/helpers.dart'; // For showToast

// =============================================================================
// DETAIL VIEW
// =============================================================================

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.folder, color: cs.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text('Status: Active • Location: North',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => showToast(context, 'PDF downloaded', type: ToastificationType.success),
                  icon: const Icon(Icons.download),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Details', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text('Description about this item goes here.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Documents', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...List.generate(
                    3,
                    (i) => ListTile(
                      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text('Attachment ${i + 1}.pdf'),
                      trailing:
                          Icon(Icons.download_outlined, color: cs.onSurfaceVariant),
                      onTap: () => showToast(context, 'PDF downloaded', type: ToastificationType.success),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity History',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...List.generate(
                    4,
                    (i) => ListTile(
                      leading: const Icon(Icons.history),
                      title: Text('Updated record ${i + 1}'),
                      subtitle: const Text('2d ago · by Admin'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}