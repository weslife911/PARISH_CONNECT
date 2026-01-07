import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/models/parish/parish_record_model.dart';
import 'package:parish_connect/repositories/auth/check_auth_repository.dart';
import 'package:parish_connect/utils/parish_pdf_generator.dart';
import "package:parish_connect/widgets/builds/build_expansion_section.dart";

class ParishDetailView extends ConsumerWidget {
  const ParishDetailView({super.key, required this.report});

  final ParishReportModel report;

  Widget _buildStatListItem(BuildContext context, String label, dynamic value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value.toString(),
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      dense: true,
    );
  }

  void _generatePdf(BuildContext context, WidgetRef ref) {
    ParishPdfGenerator.generateParishPdf(context, report, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = report.periodCovered
        .toLocal()
        .toIso8601String()
        .split('T')[0];
    // Watch the parish name for display in the UI
    final parishName =
        ref.watch(checkAuthRepositoryStateProvider)?.user?.parish ?? "Parish";

    return Scaffold(
      appBar: AppBar(
        title: Text('${report.commissionName} Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            tooltip: 'Save PDF to Device',
            onPressed: () => _generatePdf(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parishName,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 4),

            Text(
              report.commissionName,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Period Covered: $formattedDate',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
            ),
            const Divider(height: 30),

            Text(
              'Core Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildStatListItem(
                      context,
                      'Total Members',
                      report.totalMembers,
                    ),
                    _buildStatListItem(
                      context,
                      'Active Members',
                      report.activeMembers,
                    ),
                    _buildStatListItem(
                      context,
                      'Missions Represented',
                      report.missionsRepresented,
                    ),
                    _buildStatListItem(
                      context,
                      'General Meetings',
                      report.generalMeetings,
                    ),
                    _buildStatListItem(
                      context,
                      'EXCO Meetings',
                      report.excoMeetings,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Report Sections',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            buildExpansionSection(
              context,
              'Activities Carried Out',
              report.activities,
            ),
            buildExpansionSection(
              context,
              'Problems Encountered & Proposed Solutions',
              report.problemsAndSolutions,
            ),
            buildExpansionSection(
              context,
              'Issues for Council',
              report.issuesForCouncil,
            ),
            buildExpansionSection(context, 'Future Plans', report.futurePlans),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
