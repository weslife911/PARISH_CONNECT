import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/section/detail_view.dart';
import 'package:futru_scc_app/widgets/helpers.dart';

class ListTab extends StatelessWidget {
  final List<String> items;
  // New: Field to hold the context for filtering (e.g., 'SCC', 'Parish')
  final String sectionTitle;

  // New: Required parameters in the constructor
  const ListTab({super.key, required this.items, required this.sectionTitle});
  
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Filter the items: only include items whose name contains the sectionTitle.
    // .toLowerCase() is used for case-insensitive filtering.
    final filteredItems = items
        .where((item) => item.toLowerCase().contains(sectionTitle.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredItems.length,
      itemBuilder: (context, i) {
        final sectionName = filteredItems[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: cs.secondary.withOpacity(0.15),
              child: Icon(Icons.folder_open, color: cs.secondary),
            ),
            title: Text(sectionName),
            subtitle: const Text('Tap to view details'),
            trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            onTap: () => Navigator.of(context).push(AnimatedRoute(
              DetailView(title: sectionName),
            )),
          ),
        );
      },
    );
  }
}