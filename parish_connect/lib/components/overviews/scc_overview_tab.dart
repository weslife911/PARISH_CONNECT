import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/components/section/stat_chip.dart';
import 'package:parish_connect/utils/logger_util.dart';
import 'package:parish_connect/widgets/helpers.dart';
import 'package:toastification/toastification.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SCCOverviewTab extends ConsumerStatefulWidget {
  const SCCOverviewTab({super.key, required this.title});
  final String title;

  @override
  ConsumerState<SCCOverviewTab> createState() => _SCCOverviewTabState();
}

class _SCCOverviewTabState extends ConsumerState<SCCOverviewTab> {
  List<File> _downloadedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadDownloadedFiles();
  }

  Future<void> _loadDownloadedFiles() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final sccDir = Directory('${directory.path}/SCC_Reports');
      if (await sccDir.exists()) {
        setState(() {
          _downloadedFiles = sccDir
              .listSync()
              .whereType<File>()
              .where((file) => file.path.endsWith('.pdf'))
              .toList();
        });
      }
    }
  }

  Future<void> _shareFile(File file) async {
    try {
      final XFile xFile = XFile(file.path);

      final params = ShareParams(
        files: [xFile],
        text: 'Sharing SCC Report: ${file.path.split('/').last}',
        title: 'SCC Report Share',
      );

      final result = await SharePlus.instance.share(params);

      if (result.status == ShareResultStatus.success) {
        if (mounted) {
          showToast(
            context,
            "File shared successfully!",
            type: ToastificationType.success,
          );
        }
      } else if (result.status == ShareResultStatus.dismissed) {
        logger.d("User closed the share sheet without sharing.");
      }
    } catch (e) {
      logger.e("Share Error", error: e);
      if (mounted) {
        showToast(
          context,
          "An error occurred while trying to share.",
          type: ToastificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.title} Snapshot',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: StatChip(
                        icon: Icons.people_outline,
                        label: 'Members',
                        value: '124',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatChip(
                        icon: Icons.description_outlined,
                        label: 'Docs',
                        value: _downloadedFiles.length.toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatChip(
                        icon: Icons.history,
                        label: 'Activities',
                        value: '12',
                      ),
                    ),
                  ],
                ),
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
                Text(
                  'Recent Reports',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _downloadedFiles.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text('No reports found in storage'),
                        ),
                      )
                    : Column(
                        children: _downloadedFiles.map((file) {
                          final fileName = file.path.split('/').last;
                          return ListTile(
                            leading: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                            title: Text(
                              fileName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.share, color: cs.primary),
                                  onPressed: () => _shareFile(file),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green[700],
                                  size: 20,
                                ),
                              ],
                            ),
                            onTap: () => showToast(
                              context,
                              'Opening $fileName',
                              type: ToastificationType.info,
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
