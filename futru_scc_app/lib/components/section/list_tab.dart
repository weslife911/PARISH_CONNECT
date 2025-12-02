import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/section/detail_view.dart';
import 'package:futru_scc_app/widgets/helpers.dart';

class ListTab extends StatelessWidget {
  const ListTab({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, i) => Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: cs.secondary.withValues(alpha: 0.15),
            child: Icon(Icons.folder_open, color: cs.secondary),
          ),
          title: Text('Record ${i + 1}'),
          subtitle: const Text('Tap to view, edit or download PDF'),
          trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
          onTap: () => Navigator.of(context).push(AnimatedRoute(
            DetailView(title: 'Record ${i + 1}'),
          )),
        ),
      ),
    );
  }
}