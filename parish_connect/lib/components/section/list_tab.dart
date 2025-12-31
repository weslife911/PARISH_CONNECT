import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:parish_connect/components/section/parish/parish_detail_view.dart';
import 'package:parish_connect/components/section/scc/scc_detail_view.dart';
import 'package:parish_connect/repositories/parish/parish_report_repository.dart';
import 'package:parish_connect/repositories/scc/scc_report_repository.dart';
import 'package:parish_connect/widgets/helpers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// IMPORT LOGGER UTILITY
import 'package:parish_connect/utils/logger_util.dart';

class ListTab extends ConsumerWidget {
  final List<String> items;
  final String sectionTitle;

  const ListTab({super.key, required this.items, required this.sectionTitle});

  // Helper method to build the actual list from the records.
  // MODIFIED: Accepts List<dynamic> for flexibility.
  Widget _buildRecordList(BuildContext context, ColorScheme cs, List<dynamic> records) {
    logger.d('ListTab: _buildRecordList called for section: $sectionTitle with ${records.length} records.');
    if (records.isEmpty) {
      return Center(child: Text('No $sectionTitle reports found.'));
    }

    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, i) {

        if(sectionTitle == "SCC") {
          final record = records[i];

          // Access properties dynamically (assuming all Report Models have them)
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
                SCCDetailView(report: record),
              )),
            ),
          );
        } else if(sectionTitle == "Parish") {
          final record = records[i];

          // --- Access Parish data fields ---
          String title = record.commissionName; // Uses commissionName for the title.

          // MODIFIED: Uses the single 'periodCovered' field to generate the subtitle.
          // It maintains the original date formatting style by splitting the string.
          String subtitle = 'Period Covered: ${record.periodCovered.toLocal().toString().split(' ')[0]}';

          // Get Theme/ColorScheme for styling (Assuming cs and theme are defined)
          final cs = Theme.of(context).colorScheme;
          final theme = Theme.of(context);


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
                // Pass the generic 'record' (ParishReportModel) to DetailView.
                ParishDetailView(report: record),
              )),
            ),
          );
        }
         else {
          return Center(
          child: LoadingAnimationWidget.inkDrop(
            color: cs.secondary,
            size: 50.0,
          ),
        );
        }
      },
    );
  }

  // Helper method to handle the AsyncValue state.
  // MODIFIED: Accepts AsyncValue<dynamic> as the inner type can be RecordsResponseModel or ParishRecordsResponseModel.
  Widget _handleAsyncValue(BuildContext context, ColorScheme cs, AsyncValue<dynamic> asyncRecords) {
    logger.d('ListTab: _handleAsyncValue started for section: $sectionTitle.');
    return asyncRecords.when(
      loading: () {
        logger.d('ListTab: Status - Loading $sectionTitle reports.');
        return Center(
          child: LoadingAnimationWidget.inkDrop(
            color: cs.secondary,
            size: 50.0,
          ),
        );
      },
      error: (err, stack) {
        logger.e('ListTab: Status - Error loading $sectionTitle reports.', error: err, stackTrace: stack);
        return Center(child: Text('Error loading $sectionTitle reports: ${err.toString()}'));
      },

      data: (responseModel) {
        logger.d('ListTab: Status - Data received for $sectionTitle.');

        // Check for API success status using dynamic property access
        if (!responseModel.success) {
          logger.w('ListTab: API response indicates failure for $sectionTitle: ${responseModel.message}');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Failed to load $sectionTitle records: ${responseModel.message}'),
            ),
          );
        }

        List<dynamic> recordsList = [];

        // Use a conditional check to extract the correct list property
        if (sectionTitle.toLowerCase() == 'scc' || sectionTitle.toLowerCase() == 'deanery') {
            // Assumes SCC and Deanery response models use the 'records' property
            recordsList = responseModel.records;
            logger.i('ListTab: Extracted records using \'records\' field for $sectionTitle. Count: ${recordsList.length}');
        } else if (sectionTitle.toLowerCase() == 'parish') {
            // Assumes Parish response model uses the 'parishes' property
            recordsList = responseModel.parishes;
            logger.i('ListTab: Extracted records using \'parishes\' field for $sectionTitle. Count: ${recordsList.length}');
        } else {
             logger.w('ListTab: No specific record field extraction logic for section: $sectionTitle. Returning empty list.');
        }


        // Pass the dynamically extracted list of records to the helper method
        return _buildRecordList(context, cs, recordsList);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('ListTab: Widget build started for section: $sectionTitle.');
    final cs = Theme.of(context).colorScheme;

    // Use a generic type for the provider to allow it to hold FutureProviders
    // that return different concrete response models.
    ProviderBase<AsyncValue<dynamic>>? provider;

    // Select the appropriate FutureProvider based on the sectionTitle
    switch (sectionTitle.toLowerCase()) {
      case 'scc':
        provider = getSCCRecordsFutureProvider;
        logger.i('ListTab: Selected getSCCRecordsFutureProvider for section: $sectionTitle.');
        break;
      case 'parish':
        provider = getParishRecordsFutureProvider;
        logger.i('ListTab: Selected getParishRecordsFutureProvider for section: $sectionTitle.');
        break;
      case 'deanery':
        // provider = getDeaneryRecordsFutureProvider;
        // logger.i('ListTab: Selected getDeaneryRecordsFutureProvider for section: $sectionTitle.');
        break;
      default:
        provider = null;
        logger.w('ListTab: No provider found for section: $sectionTitle.');
    }

    if (provider != null) {
      logger.d('ListTab: Watching selected provider and calling _handleAsyncValue.');
      // Watch the provider, casting it to the common ProviderListenable type.
      final asyncRecords = ref.watch(provider as ProviderListenable<AsyncValue<dynamic>>);
      return _handleAsyncValue(context, cs, asyncRecords);
    }

    logger.w('ListTab: Rendering "No data provider" message for section: $sectionTitle.');
    return Center(
      child: Text(
        'No data provider configured for "$sectionTitle" section.',
        textAlign: TextAlign.center,
        style: TextStyle(color: cs.error, fontSize: 16),
      ),
    );
  }
}
