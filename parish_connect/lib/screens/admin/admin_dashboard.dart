import 'package:flutter/material.dart';
import "package:parish_connect/components/admin/action_chip_card.dart";
import 'package:parish_connect/components/admin/metric_card.dart';
// =============================================================================
// ADMIN DASHBOARD
// =============================================================================

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 110,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            children: const [
              MetricCard(icon: Icons.groups, label: 'SCCs', count: 18),
              MetricCard(icon: Icons.church, label: 'Parishes', count: 6),
              MetricCard(icon: Icons.location_city, label: 'Missions', count: 9),
              MetricCard(icon: Icons.account_balance, label: 'Deaneries', count: 3),
              MetricCard(icon: Icons.person, label: 'Users', count: 142),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
            ),
            alignment: Alignment.center,
            child: Text('Chart: Activities over time',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 16),
          Text('Recent Activities', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
            5,
            (i) => ListTile(
              leading: const Icon(Icons.notifications_none),
              title: Text('Updated Mission ${i + 1}'),
              subtitle: const Text('Today · by Admin'),
              trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 12),
          Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChipCard(icon: Icons.group_add, label: 'Create SCC', onTap: () {}),
              ActionChipCard(icon: Icons.add_business, label: 'Create Parish', onTap: () {}),
              ActionChipCard(icon: Icons.picture_as_pdf, label: 'Upload PDF template', onTap: () {}),
              ActionChipCard(icon: Icons.manage_accounts, label: 'Manage Users', onTap: () {}),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
