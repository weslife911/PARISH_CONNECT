// futru_scc_app/views/parish_detail_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// NOTE: Ensure these paths are correct
import 'package:futru_scc_app/models/parish/parish_record_model.dart';
import 'package:futru_scc_app/repositories/auth/check_auth_repository.dart'; 
import 'package:futru_scc_app/utils/parish_pdf_generator.dart';
import "package:futru_scc_app/widgets/builds/build_expansion_section.dart";


// =============================================================================
// DETAIL VIEW (MODIFIED)
// =============================================================================

class ParishDetailView extends ConsumerWidget {
  const ParishDetailView({
    super.key, 
    required this.report,
  }); 
  
  final ParishReportModel report;

  Widget _buildStatListItem(BuildContext context, String label, dynamic value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value.toString(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      dense: true,
    );
  }

  // PDF Generation Logic Call
  void _generatePdf(BuildContext context, WidgetRef ref) {
    // MODIFIED: Pass the parishName to the generator
    ParishPdfGenerator.generateParishPdf(
      context, 
      report,
      ref
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = report.periodCovered.toLocal().toIso8601String().split('T')[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('${report.commissionName} Report'), 
        actions: [
          // PDF Generation Button
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            tooltip: 'Generate PDF Report',
            onPressed: () => _generatePdf(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================================
            // REPORT METADATA & HEADER
            // =====================================================================
            // ADDED: Display the parish name clearly at the top
            Text(
              ref.watch(checkAuthRepositoryStateProvider)!.user!.parish,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 4),

            Text(
              report.commissionName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Period Covered: $formattedDate',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
            ),
            const Divider(height: 30),

            // =====================================================================
            // CORE STATISTICS
            // =====================================================================
            Text('Core Statistics', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildStatListItem(context, 'Total Members', report.totalMembers),
                    _buildStatListItem(context, 'Active Members', report.activeMembers),
                    _buildStatListItem(context, 'Missions Represented', report.missionsRepresented),
                    _buildStatListItem(context, 'General Meetings', report.generalMeetings),
                    _buildStatListItem(context, 'EXCO Meetings', report.excoMeetings),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // =====================================================================
            // REPORT SECTIONS
            // =====================================================================
            Text('Report Sections', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            
            buildExpansionSection(context, 'Activities Carried Out', report.activities),
            buildExpansionSection(context, 'Problems Encountered & Proposed Solutions', report.problemsAndSolutions),
            buildExpansionSection(context, 'Issues for Council', report.issuesForCouncil),
            buildExpansionSection(context, 'Future Plans', report.futurePlans),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}