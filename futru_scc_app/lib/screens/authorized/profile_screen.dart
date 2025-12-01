import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/profile/key_value_row.dart';
import '../../main.dart';
import '../../widgets/app_drawer.dart';

// =============================================================================
// PROFILE
// =============================================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAdmin = appState.isAdmin;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.person, size: 44, color: cs.onPrimaryContainer),
                ),
                const SizedBox(height: 12),
                Text('Alex Johnson',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
                Text(isAdmin ? 'Administrator · St. Mary’s Parish' : 'Member · St. Mary’s Parish',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Information',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const KeyValueRow(icon: Icons.email, label: 'Email', value: 'alex@example.com'),
                  const KeyValueRow(icon: Icons.phone, label: 'Phone', value: '+1 555 0101'),
                  const KeyValueRow(icon: Icons.place, label: 'Parish', value: 'St. Mary’s'),
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
                  Text('Responsibilities', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...['Youth Ministry', 'Charity Committee', 'Music Team'].map(
                    (r) => ListTile(
                      leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                      title: Text(r),
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

