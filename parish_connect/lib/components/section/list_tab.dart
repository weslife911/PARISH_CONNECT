import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:parish_connect/components/section/no_data_found_for_sections.dart';
import 'package:parish_connect/components/section/parish/parish_detail_view.dart';
import 'package:parish_connect/components/section/scc/scc_detail_view.dart';
import 'package:parish_connect/repositories/parish/parish_report_repository.dart';
import 'package:parish_connect/repositories/scc/scc_report_repository.dart';
import 'package:parish_connect/widgets/helpers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:parish_connect/utils/logger_util.dart';

class ListTab extends ConsumerWidget {
  final List<String> items;
  final String sectionTitle;

  const ListTab({super.key, required this.items, required this.sectionTitle});

  Widget _buildRecordList(
    BuildContext context,
    ColorScheme cs,
    List<dynamic> records,
  ) {
    logger.d(
      'ListTab: _buildRecordList called for section: $sectionTitle with ${records.length} records.',
    );
    if (records.isEmpty) {
      return NoDataFoundForSections(sectionTitle: sectionTitle);
    }

    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, i) {
        if (sectionTitle == "SCC") {
          final record = records[i];

          String title = record.sccName;
          String subtitle =
              'Period: ${record.periodStart.toLocal().toString().split(' ')[0]} - ${record.periodEnd.toLocal().toString().split(' ')[0]}';

          return Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              leading: CircleAvatar(
                backgroundColor: cs.primary.withOpacity(0.15),
                child: Icon(Icons.description, color: cs.primary),
              ),
              title: Text(
                title,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: theme.textTheme.bodySmall!.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: cs.primary,
              ),
              onTap: () => Navigator.of(
                context,
              ).push(animatedRoute(SCCDetailView(report: record))),
            ),
          );
        } else if (sectionTitle == "Parish") {
          final record = records[i];

          String title = record.commissionName;

          String subtitle =
              'Period Covered: ${record.periodCovered.toLocal().toString().split(' ')[0]}';

          final cs = Theme.of(context).colorScheme;
          final theme = Theme.of(context);

          return Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              leading: CircleAvatar(
                backgroundColor: cs.primary.withOpacity(0.15),
                child: Icon(Icons.description, color: cs.primary),
              ),
              title: Text(
                title,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: theme.textTheme.bodySmall!.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: cs.primary,
              ),
              onTap: () => Navigator.of(
                context,
              ).push(animatedRoute(ParishDetailView(report: record))),
            ),
          );
        } else {
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

  Widget _handleAsyncValue(
    BuildContext context,
    ColorScheme cs,
    AsyncValue<dynamic> asyncRecords,
  ) {
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
        logger.e(
          'ListTab: Status - Error loading $sectionTitle reports.',
          error: err,
          stackTrace: stack,
        );
        return Center(
          child: Text('Error loading $sectionTitle reports: ${err.toString()}'),
        );
      },

      data: (responseModel) {
        logger.d('ListTab: Status - Data received for $sectionTitle.');

        if (!responseModel.success) {
          logger.w(
            'ListTab: API response indicates failure for $sectionTitle: ${responseModel.message}',
          );
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Failed to load $sectionTitle records: ${responseModel.message}',
              ),
            ),
          );
        }

        List<dynamic> recordsList = [];

        if (sectionTitle.toLowerCase() == 'scc' ||
            sectionTitle.toLowerCase() == 'deanery') {
          recordsList = responseModel.records;
          logger.i(
            'ListTab: Extracted records using \'records\' field for $sectionTitle. Count: ${recordsList.length}',
          );
        } else if (sectionTitle.toLowerCase() == 'parish') {
          recordsList = responseModel.parishes;
          logger.i(
            'ListTab: Extracted records using \'parishes\' field for $sectionTitle. Count: ${recordsList.length}',
          );
        } else {
          logger.w(
            'ListTab: No specific record field extraction logic for section: $sectionTitle. Returning empty list.',
          );
        }

        return _buildRecordList(context, cs, recordsList);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('ListTab: Widget build started for section: $sectionTitle.');
    final cs = Theme.of(context).colorScheme;

    ProviderBase<AsyncValue<dynamic>>? provider;

    switch (sectionTitle.toLowerCase()) {
      case 'scc':
        provider = getSCCRecordsFutureProvider;
        logger.i(
          'ListTab: Selected getSCCRecordsFutureProvider for section: $sectionTitle.',
        );
        break;
      case 'parish':
        provider = getParishRecordsFutureProvider;
        logger.i(
          'ListTab: Selected getParishRecordsFutureProvider for section: $sectionTitle.',
        );
        break;
      case 'deanery':
        break;
      default:
        provider = null;
        logger.w('ListTab: No provider found for section: $sectionTitle.');
    }

    if (provider != null) {
      logger.d(
        'ListTab: Watching selected provider and calling _handleAsyncValue.',
      );
      final asyncRecords = ref.watch(
        provider as ProviderListenable<AsyncValue<dynamic>>,
      );
      return _handleAsyncValue(context, cs, asyncRecords);
    }

    logger.w(
      'ListTab: Rendering "No data provider" message for section: $sectionTitle.',
    );
    return Center(
      child: Text(
        'No data provider configured for "$sectionTitle" section.',
        textAlign: TextAlign.center,
        style: TextStyle(color: cs.error, fontSize: 16),
      ),
    );
  }
}
