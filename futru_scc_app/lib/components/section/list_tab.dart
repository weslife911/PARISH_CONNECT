import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futru_scc_app/components/section/detail_view.dart';
import 'package:futru_scc_app/models/scc/records_response_model.dart'; 
import 'package:futru_scc_app/models/scc/scc_record_model.dart';
import 'package:futru_scc_app/repositories/scc/scc_report_repository.dart'; 
import 'package:futru_scc_app/widgets/helpers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; 

class ListTab extends ConsumerWidget {
  // This is kept, but ignored for the main sections (SCC, Parish, Deanery)
  final List<String> items; 
  final String sectionTitle;

  const ListTab({super.key, required this.items, required this.sectionTitle});

  // Helper method to build the actual list from the RecordsResponseModel
  Widget _buildRecordList(BuildContext context, ColorScheme cs, List<SccReportModel> sccRecords) {
    if (sccRecords.isEmpty) {
      return Center(child: Text('No $sectionTitle reports found.'));
    }
    
    final theme = Theme.of(context); // Get theme for text styles

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sccRecords.length,
      itemBuilder: (context, i) {
        final record = sccRecords[i];
        
        // Define title and subtitle dynamically
        String title = record.sccName;
        String subtitle = 'Period: ${record.periodStart.toLocal().toString().split(' ')[0]} - ${record.periodEnd.toLocal().toString().split(' ')[0]}';
        
        return Card(
          elevation: 4.0, // Stunning: Increased elevation
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Softer corners
          margin: const EdgeInsets.only(bottom: 12), // Add space between cards
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // More vertical padding
            leading: CircleAvatar(
              backgroundColor: cs.primary.withOpacity(0.15), // Use primary color for stronger visual
              child: Icon(Icons.description, color: cs.primary), // Use a different icon
            ),
            title: Text(
              title,
              style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold), // Stunning: Bold title
            ),
            subtitle: Text(
              subtitle,
              style: theme.textTheme.bodySmall!.copyWith(color: cs.onSurfaceVariant), // Subtle subtitle
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded, color: cs.primary), // Use a more modern icon
            onTap: () => Navigator.of(context).push(AnimatedRoute(
              // ADJUSTMENT 1: Pass the full 'record' (SccReportModel) instead of just the title
              DetailView(report: record), 
            )),
          ),
        );
      },
    );
  }

  // Helper method to handle the AsyncValue state
  Widget _handleAsyncValue(BuildContext context, ColorScheme cs, AsyncValue<RecordsResponseModel> asyncRecords) {
    return asyncRecords.when(
      // MODIFIED: Use LoadingAnimationWidget.inkDrop for a beautiful multi-color spinner
      loading: () => Center(
        child: LoadingAnimationWidget.inkDrop(
          // Note: In the previous step, this was updated to use a list of colors, 
          // but the uploaded file only shows a single color. Keeping the single
          // color here based on the provided file content.
          color: cs.secondary,
          size: 50.0,
        ),
      ),
      // END MODIFIED
      error: (err, stack) => Center(child: Text('Error loading $sectionTitle reports: ${err.toString()}')),
      data: (RecordsResponseModel responseModel) {
        if (!responseModel.success) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Failed to load $sectionTitle records: ${responseModel.message}'),
            ),
          );
        }
        
        // Pass the list of records to the helper method
        return _buildRecordList(context, cs, responseModel.records);
      },
    );
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    
    // Select the appropriate FutureProvider based on the sectionTitle
    FutureProvider<RecordsResponseModel>? provider;
    
    switch (sectionTitle.toLowerCase()) {
      case 'scc':
        provider = getSCCRecordsFutureProvider;
        break;
      case 'parish':
        // provider = getParishRecordsFutureProvider;
        break;
      case 'deanery':
        // provider = getDeaneryRecordsFutureProvider;
        break;
      default:
        // Set provider to null or handle sections without dedicated providers
        provider = null; 
    }
    
    if (provider != null) {
      // Watch and handle the AsyncValue from the selected provider
      final asyncRecords = ref.watch(provider);
      return _handleAsyncValue(context, cs, asyncRecords);
    }
    
    // If no provider is found (i.e., default case in the switch), show a message instead of the removed fallback list.
    return Center(
      child: Text(
        'No data provider configured for "$sectionTitle" section.',
        textAlign: TextAlign.center,
        style: TextStyle(color: cs.error, fontSize: 16),
      ),
    );
  }
}