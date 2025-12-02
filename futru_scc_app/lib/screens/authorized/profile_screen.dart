import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futru_scc_app/components/profile/key_value_row.dart';
import 'package:futru_scc_app/repositories/auth/check_auth_repository.dart';
import '../../widgets/app_drawer.dart';

// =============================================================================
// PROFILE
// =============================================================================

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isAdmin = ref.read(checkAuthRepositoryStateProvider)!.user!.role;
    final user = ref.read(checkAuthRepositoryStateProvider)!.user;
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      drawer: AppDrawer(),
      body: ListView(
        // FIX: Added bottom padding to raise content above the custom bottom navigation bar.
        padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.person, size: 44, color: cs.onPrimaryContainer),
                ),
                SizedBox(height: 12),
                Text('Alex Johnson',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
                Text(isAdmin == "admin" ? 'Administrator · St. Mary’s Parish' : 'Member · St. Mary’s Parish',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Information',
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  KeyValueRow(icon: Icons.email, label: 'Email', value: user!.email),
                  KeyValueRow(icon: Icons.place, label: 'Parish', value: user!.parish),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Responsibilities', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8),
                  ...['Youth Ministry', 'Charity Committee', 'Music Team'].map(
                    (r) => ListTile(
                      leading: Icon(Icons.check_circle_outline, color: Colors.green),
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