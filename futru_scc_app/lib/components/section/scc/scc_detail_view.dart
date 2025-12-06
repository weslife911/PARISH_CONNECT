import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futru_scc_app/models/scc/scc_record_model.dart';
import 'package:futru_scc_app/repositories/auth/check_auth_repository.dart';
import 'package:toastification/toastification.dart';
import '../../../widgets/helpers.dart'; // For showToast
import "package:futru_scc_app/widgets/builds/build_stat_card.dart";
import "package:futru_scc_app/widgets/builds/build_expansion_section.dart";

// PDF GENERATION IMPORTS
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
// path_provider is required for getApplicationDocumentsDirectory()
import 'package:path_provider/path_provider.dart'; 
import 'package:open_filex/open_filex.dart';

// =============================================================================
// DETAIL VIEW
// =============================================================================

class SCCDetailView extends ConsumerWidget {
  const SCCDetailView({super.key, required this.report}); 
  
  final SccReportModel report;

  // Helper function to create a table row for statistics
  pw.TableRow _buildStatRow(String label1, dynamic value1, String label2, dynamic value2, String label3, dynamic value3) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: '$label1: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.TextSpan(text: '$value1'),
              ],
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: '$label2: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.TextSpan(text: '$value2'),
              ],
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: '$label3: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.TextSpan(text: '$value3'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper function to build a narrative section
  // MODIFIED: Changed parameter type to List<String> to fix the type error
  pw.Widget _buildNarrativeSection(String title, List<String> contentList) {
    // If the list is empty or contains only empty strings, display 'N/A'
    if (contentList.isEmpty || contentList.every((item) => item.trim().isEmpty)) {
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
                pw.SizedBox(height: 10),
                pw.Text(
                    '$title:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                ),
                pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10, top: 4, bottom: 4),
                    child: pw.Text(
                        'N/A',
                        textAlign: pw.TextAlign.justify,
                        style: const pw.TextStyle(fontSize: 10),
                    ),
                ),
            ],
        );
    }
    
    // Convert the list of strings into a list of Text widgets for the PDF
    final pw.Widget contentWidget = pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: contentList.map((item) {
            // Filter out empty strings if any exist
            if (item.trim().isEmpty) return pw.SizedBox.shrink();

            return pw.Padding(
                padding: const pw.EdgeInsets.only(left: 10, top: 2, bottom: 2),
                child: pw.Text(
                    '• $item', // Use a bullet point for list items
                    textAlign: pw.TextAlign.justify,
                    style: const pw.TextStyle(fontSize: 10),
                ),
            );
        }).toList(),
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        pw.Text(
          '$title:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
        ),
        contentWidget,
      ],
    );
  }

  // =======================================================================
  // PERMISSION HANDLING LOGIC (REMOVED - Not needed for app-private directory)
  // =======================================================================
  // The _requestStoragePermission function has been removed to resolve permission denial.

  // =======================================================================
  // PDF GENERATION LOGIC (MODIFIED for Directory and Permission Check Removal)
  // =======================================================================
  Future<void> _generateReportPdf(BuildContext context, WidgetRef ref) async {
    
    // 1. Removed: Permission check removed as it's not required for getApplicationDocumentsDirectory()

    // 2. CONTINUE WITH PDF GENERATION
    final pdf = pw.Document();
    
    final period = 
      '${report.periodStart.toLocal().toString().split(' ')[0]} - ${report.periodEnd.toLocal().toString().split(' ')[0]}';
    final reportTitle = '${ref.watch(checkAuthRepositoryStateProvider)!.user!.parish} \n ${report.sccName} SMALL CHRISTIAN COMMUNITY (SCC) REPORT FORM';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // HEADER
              pw.Center(
                child: pw.Text(
                  reportTitle,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                ),
              ),
              pw.Divider(height: 15),

              // SCC NAME AND PERIOD
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Name of SCC: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: report.sccName),
                    ]
                  )),
                  pw.RichText(text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Period Covered: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: period),
                    ]
                  )),
                ],
              ),
              pw.SizedBox(height: 15),

              // STATISTICS TABLE (3 Columns)
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(),
                  1: const pw.FlexColumnWidth(),
                  2: const pw.FlexColumnWidth(),
                },
                children: [
                  // Row 1 (Families, Gospel Groups, Council Meetings)
                  _buildStatRow('Total of Families', report.totalFamilies, 
                               'Gospel Sharing Groups', report.gospelSharingGroups, 
                               'Council Meetings', report.councilMeetings),
                  // Row 2 (Children, GS Expected, General Meetings)
                  _buildStatRow('Children', report.children, 
                               'Gospel Sharing Sessions Expected', report.gospelSharingExpected, 
                               'General Meetings', report.generalMeetings),
                  // Row 3 (Youth, GS Done, No of Commissions)
                  _buildStatRow('Youth', report.youth, 
                               'Gospel Sharing Sessions Done', report.gospelSharingDone, 
                               'No of Commissions', report.noOfCommissions),
                  // Row 4 (Adults, Christians Attending, Active Commissions)
                  _buildStatRow('Adults', report.adults, 
                               'No of Christians attending Gospel Sharing', report.noChristiansAttendingGS, 
                               'Active Commissions', report.activeCommissions),
                  // Row 5 (Total Membership, % Attendance, Baptism)
                  _buildStatRow('Total Membership', report.totalMembership, 
                               '% Attendance of Gospel sharing', '${(report.gsAttendancePercentage * 100).toStringAsFixed(0)}%', 
                               'Baptism', report.baptism),
                  // Row 6 (Lapsed Christians, Irregular Marriages, Burials)
                  _buildStatRow('Lapsed Christians', report.lapsedChristians, 
                               'Irregular Marriages', report.irregularMarriages, 
                               'Burials', report.burials),
                ],
              ),
              pw.SizedBox(height: 15),

              // COMMISSION ACTIVITIES
              pw.Center(
                child: pw.Text(
                  'Activities carried out by Commissions in the SCC',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
                ),
              ),
              // Narrative sections (Mapping all available data fields)
              _buildNarrativeSection('Biblical Apostolate', report.biblicalApostolateActivities),
              _buildNarrativeSection('Liturgy', report.liturgyActivities),
              // You would add all other commission activities here, following the model fields.
              
              // PROBLEMS AND PLANS
              pw.SizedBox(height: 15),
              _buildNarrativeSection('Problems Encountered and Proposed Solutions', report.problemsEncountered),
              _buildNarrativeSection('Issues to be discussed in the Council', report.issuesForCouncil),
              pw.SizedBox(height: 5), // Added small break for separation
              _buildNarrativeSection('Plan for the next Month', report.nextMonthPlans),

              // SIGNATURES (Attempting to mimic the layout)
              pw.Spacer(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Sign: __________________________'),
                      pw.SizedBox(height: 5),
                      // Replace with actual signature names if available in model
                      pw.Text('Name: __________________________'), 
                      pw.Text('Secretary'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Sign: __________________________'),
                      pw.SizedBox(height: 5),
                      // Replace with actual signature names if available in model
                      pw.Text('Name: __________________________'),
                      pw.Text('SCC Chairperson'),
                    ],
                  ),
                ],
              )

            ],
          );
        },
      ),
    );

    // Save and Open the file
    // Get the application's private documents directory (e.g., Android/data/com.your_package_name/files)
    final directory = await getApplicationDocumentsDirectory(); 
    
    // Create the "scc" subdirectory
    final sccDir = Directory('${directory.path}/scc');
    if (!await sccDir.exists()) {
        await sccDir.create(recursive: true);
    }

    final fileName = 'SCC_Report_${report.sccName}_${report.periodStart.year}.pdf';
    final filePath = '${sccDir.path}/$fileName'; // Save to the new sccDir path
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    
    // Show toast notification
    showToast(context, 'Report saved as $fileName in the SCC folder', type: ToastificationType.success);
    
    // Open the file
    OpenFilex.open(filePath);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final title = report.sccName;
    final period = 
      '${report.periodStart.toLocal().toString().split(' ')[0]} - ${report.periodEnd.toLocal().toString().split(' ')[0]}';
    
    // Calculate the percentage for visualization
    final double attendancePercent = report.gsAttendancePercentage;
    final Color percentColor = attendancePercent >= 0.75 
        ? Colors.green 
        : (attendancePercent >= 0.5 ? Colors.orange : Colors.red);


    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // =====================================================================
          // STUNNING HEADER SECTION
          // =====================================================================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh, // Use a slightly higher surface color
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.church_rounded, size: 30, color: cs.onPrimaryContainer),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        'Report Period: $period',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Active Commissions: ${report.activeCommissions}/${report.noOfCommissions}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.secondary),
                      ),
                    ],
                  ),
                ),
                // =====================================================================
                // DOWNLOAD BUTTON 
                // =====================================================================
                IconButton(
                  onPressed: () => _generateReportPdf(context, ref), 
                  icon: Icon(Icons.download_for_offline_outlined, size: 28, color: cs.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // =====================================================================
          // KEY STATISTICS GRID
          // =====================================================================
          Text('Key Statistics', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5, // Make cards wider
            ),
            children: [
              buildStatCard(cs, 'Total Families', report.totalFamilies, Icons.family_restroom, cs.primary),
              buildStatCard(cs, 'Total Members', report.totalMembership, Icons.groups, cs.secondary),
              buildStatCard(cs, 'Council Meetings', report.councilMeetings, Icons.meeting_room, cs.tertiary),
              buildStatCard(cs, 'Gospel Groups', report.gospelSharingGroups, Icons.share, cs.error),
            ],
          ),
          const SizedBox(height: 20),

          // =====================================================================
          // ATTENDANCE VISUALIZATION
          // =====================================================================
          Text('Gospel Sharing Attendance', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: attendancePercent, // Use the actual percentage
                            strokeWidth: 8,
                            backgroundColor: cs.outlineVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(percentColor),
                          ),
                        ),
                        Text(
                          '${(attendancePercent * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: percentColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${report.noChristiansAttendingGS} Christians attended out of ${report.gospelSharingExpected} expected meetings.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // =====================================================================
          // COLLAPSIBLE REPORT SECTIONS
          // =====================================================================
          Text('Report Sections', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          
          // General Report Sections
          buildExpansionSection(context, 'Problems Encountered', report.problemsEncountered),
          buildExpansionSection(context, 'Proposed Solutions', report.proposedSolutions),
          buildExpansionSection(context, 'Issues for Council', report.issuesForCouncil),
          buildExpansionSection(context, 'Next Month Plans', report.nextMonthPlans),

          // Commission Activities (Example)
          buildExpansionSection(context, 'Biblical Apostolate Activities', report.biblicalApostolateActivities),
          buildExpansionSection(context, 'Liturgy Activities', report.liturgyActivities),
          
          // Sacramental Records
          buildExpansionSection(context, 'Sacramental Records', [
            'Baptisms: ${report.baptism}',
            'Burials: ${report.burials}',
            'Irregular Marriages: ${report.irregularMarriages}',
            'Lapsed Christians: ${report.lapsedChristians}',
          ]),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}