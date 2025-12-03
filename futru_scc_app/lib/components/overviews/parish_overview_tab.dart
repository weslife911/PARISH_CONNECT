import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/section/stat_chip.dart';
import 'package:futru_scc_app/widgets/helpers.dart';
import 'package:toastification/toastification.dart';

class ParishOverviewTab extends StatelessWidget {
  const ParishOverviewTab({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$title Snapshot',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(
                      child: StatChip(icon: Icons.people_outline, label: 'Members', value: '124'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatChip(icon: Icons.description_outlined, label: 'Docs', value: '37'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatChip(icon: Icons.history, label: 'Activities', value: '12'),
                    ),
                  ],
                ),
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
                Text('Recent Documents', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...List.generate(
                  3,
                  (i) => ListTile(
                    leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text('Document ${i + 1}.pdf'),
                    trailing:
                        Icon(Icons.download_outlined, color: cs.onSurfaceVariant),
                    onTap: () => showToast(context, 'Download started', type: ToastificationType.success),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}