import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:futru_scc_app/components/section/detail_view.dart';
// Assuming ParishRecordsResponseModel is imported implicitly via its provider file.
import 'package:futru_scc_app/repositories/parish/parish_report_repository.dart';
import 'package:futru_scc_app/repositories/scc/scc_report_repository.dart';
import 'package:futru_scc_app/widgets/helpers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// --------------------------------------------------------------------------------
// CRITICAL ASSUMPTION: All report models (SCC, Parish, Deanery) are structured
// such that the actual list of records is accessed via a property called 'records'
// (if it's RecordsResponseModel) or 'parishes' (if it's ParishRecordsResponseModel).
// And the items in the list (SccReportModel, ParishReportModel, etc.) all
// have properties 'sccName', 'periodStart', and 'periodEnd'.
// --------------------------------------------------------------------------------

class ListTab extends ConsumerWidget {
  final List<String> items;
  final String sectionTitle;

  const ListTab({super.key, required this.items, required this.sectionTitle});

  // Helper method to build the actual list from the records.
  // It now takes List<dynamic> and relies on dynamic access for properties.
  Widget _buildRecordList(BuildContext context, ColorScheme cs, List<dynamic> records) {
    if (records.isEmpty) {
      return Center(child: Text('No $sectionTitle reports found.'));
    }

    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, i) {
        // Use dynamic type for the report item.
        final record = records[i];

        // Access properties dynamically. This assumes all ReportModels
        // have these properties (sccName, periodStart, periodEnd).
        String title = record.sccName;
        String subtitle = 'Period: ${record.periodStart.toLocal().toString().split(' ')[0]} - ${record.periodEnd.toLocal().toString().split(' ')[0]}';

        return Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: CircleAvatar(
              backgroundColor: cs.primary.withOpacity(0.15),
              child: Icon(Icons.description, color: cs.primary),
            ),
            title: Text(
              title,
              style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              subtitle,
              style: theme.textTheme.bodySmall!.copyWith(color: cs.onSurfaceVariant),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded, color: cs.primary),
            onTap: () => Navigator.of(context).push(AnimatedRoute(
              // Pass the generic 'record' to DetailView.
              DetailView(report: record),
            )),
          ),
        );
      },
    );
  }

  // Helper method to handle the AsyncValue state.
  // We use dynamic for the AsyncValue's generic type since the type will be
  // different (RecordsResponseModel or ParishRecordsResponseModel).
  Widget _handleAsyncValue(BuildContext context, ColorScheme cs, AsyncValue<dynamic> asyncRecords) {
    return asyncRecords.when(
      loading: () => Center(
        child: LoadingAnimationWidget.inkDrop(
          color: cs.secondary,
          size: 50.0,
        ),
      ),
      error: (err, stack) => Center(child: Text('Error loading $sectionTitle reports: ${err.toString()}')),
      
      // The data received here will be either RecordsResponseModel or ParishRecordsResponseModel.
      data: (responseModel) {
        // Use dynamic to access the properties, which should be common (success, message)
        // and the records list, which will be named differently.
        if (!responseModel.success) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Failed to load $sectionTitle records: ${responseModel.message}'),
            ),
          );
        }

        List<dynamic> recordsList = [];
        
        // Use a conditional check to extract the list based on the expected model structure
        // This is the key change to handle the different report model structures.
        if (sectionTitle.toLowerCase() == 'scc' || sectionTitle.toLowerCase() == 'deanery') {
            // Assuming 'records' holds the list for SCC and Deanery
            recordsList = responseModel.records;
        } else if (sectionTitle.toLowerCase() == 'parish') {
            // Assuming 'parishes' holds the list for Parish
            recordsList = responseModel.parishes;
        }

        // Pass the dynamically extracted list of records to the helper method
        return _buildRecordList(context, cs, recordsList);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    // Use ProviderBase<AsyncValue<dynamic>> to hold the FutureProviders which
    // return different concrete types (RecordsResponseModel or ParishRecordsResponseModel).
    ProviderBase<AsyncValue<dynamic>>? provider;

    // Select the appropriate FutureProvider based on the sectionTitle
    switch (sectionTitle.toLowerCase()) {
      case 'scc':
        // getSCCRecordsFutureProvider returns Future<RecordsResponseModel>
        provider = getSCCRecordsFutureProvider;
        break;
      case 'parish':
        // getParishRecordsFutureProvider returns Future<ParishRecordsResponseModel>
        provider = getParishRecordsFutureProvider;
        break;
      case 'deanery':
        // Assuming Deanery returns RecordsResponseModel structure for now
        // provider = getDeaneryRecordsFutureProvider;
        break;
      default:
        provider = null;
    }

    if (provider != null) {
      // Watch the provider. We need to cast it to the common ProviderListenable type.
      final asyncRecords = ref.watch(provider as ProviderListenable<AsyncValue<dynamic>>);
      return _handleAsyncValue(context, cs, asyncRecords);
    }

    return Center(
      child: Text(
        'No data provider configured for "$sectionTitle" section.',
        textAlign: TextAlign.center,
        style: TextStyle(color: cs.error, fontSize: 16),
      ),
    );
  }
}