import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/repositories/auth/check_auth_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

// NOTE: Ensure these paths are correct for your project
import 'package:parish_connect/models/parish/parish_record_model.dart';
import 'package:parish_connect/utils/logger_util.dart';
import 'package:parish_connect/widgets/helpers.dart';
import 'package:toastification/toastification.dart'; // Assuming showToast is here


class ParishPdfGenerator {

  // ===========================================================================
  // 1. PDF HELPER WIDGETS (Uses built-in Helvetica fonts)
  // ===========================================================================

  static pw.TextStyle _textStyle(pw.Font font) => pw.TextStyle(
    font: font,
    fontSize: 10,
    color: PdfColors.black,
  );

  static pw.TextStyle _headerStyle(pw.Font font) => pw.TextStyle(
    font: font,
    fontSize: 14,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.blueGrey800,
  );

  static pw.TextStyle _titleStyle(pw.Font font) => pw.TextStyle(
    font: font,
    fontSize: 18,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.deepPurple,
  );

  static pw.Widget _buildListSection(
    String title,
    List<String> items,
    pw.Font font,
  ) {
    if (items.isEmpty) {
      return pw.Container();
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: _headerStyle(font)),
        pw.SizedBox(height: 8),
        pw.ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 10,
                    child: pw.Text('•', style: _textStyle(font).copyWith(fontSize: 12)),
                  ),
                  pw.Expanded(
                    child: pw.Text(items[index], style: _textStyle(font)),
                  ),
                ],
              ),
            );
          },
        ),
        pw.Divider(height: 16),
      ],
    );
  }

  static pw.Widget _buildParishStatTable(
    ParishReportModel report,
    pw.Font font,
  ) {
    final stats = {
      'Total Members': report.totalMembers.toString(),
      'Active Members': report.activeMembers.toString(),
      'Missions Represented': report.missionsRepresented.toString(),
      'General Meetings': report.generalMeetings.toString(),
      'EXCO Meetings': report.excoMeetings.toString(),
    };

    final List<pw.TableRow> rows = [];
    final statEntries = stats.entries.toList();

    for (var i = 0; i < statEntries.length; i += 2) {
      final stat1 = statEntries[i];
      final stat2 = i + 1 < statEntries.length ? statEntries[i + 1] : null;

      rows.add(
        pw.TableRow(
          decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
          children: [
            _buildStatCell(stat1.key, stat1.value, font),
            stat2 != null
              ? _buildStatCell(stat2.key, stat2.value, font)
              : pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('', style: _textStyle(font)),
                ),
          ],
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Commission Statistics', style: _headerStyle(font)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(1),
          },
          children: rows,
        ),
      ],
    );
  }

  static pw.Widget _buildStatCell(String label, String value, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: _textStyle(font).copyWith(fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
          pw.Text(value, style: _textStyle(font).copyWith(fontSize: 12, color: PdfColors.blue500)),
        ],
      ),
    );
  }


  // ===========================================================================
  // 2. MAIN GENERATOR FUNCTION (MODIFIED)
  // ===========================================================================

  /// Generates the Parish Report PDF and opens it.
  static Future<void> generateParishPdf(
    BuildContext context,
    ParishReportModel report,
    WidgetRef ref,
  ) async {
    if (context.mounted == false) return;

    showToast(context, 'Generating PDF...', type: ToastificationType.info);

    try {
      final pdf = pw.Document();
      final font = pw.Font.helvetica();
      final boldFont = pw.Font.helveticaBold();
      final parishName = ref.watch(checkAuthRepositoryStateProvider)!.user!.parish;

      String formattedDate = report.periodCovered.toLocal().toIso8601String().split('T')[0];

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              // 1. HEADER / METADATA
              pw.Center(
                child: pw.Column(
                  children: [
                    // MODIFIED: Use the dynamically passed parishName
                    pw.Text(parishName.toUpperCase(), style: _titleStyle(boldFont)),
                    pw.Text('PARISH COMMISSION REPORT', style: _titleStyle(boldFont).copyWith(fontSize: 16)),
                    pw.Divider(height: 16),
                  ],
                ),
              ),

              pw.Text('Name of Commission: ${report.commissionName}', style: _textStyle(font).copyWith(fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Text('Period Covered: $formattedDate', style: _textStyle(font).copyWith(fontSize: 12)),
              pw.Divider(height: 16),

              // 2. STATISTICS TABLE
              _buildParishStatTable(report, font),
              pw.SizedBox(height: 20),

              // 3. REPORT SECTIONS
              _buildListSection('ACTIVITIES CARRIED OUT', report.activities, font),

              _buildListSection('PROBLEMS ENCOUNTERED & PROPOSED SOLUTIONS', report.problemsAndSolutions, font),

              _buildListSection('ISSUES FOR COUNCIL', report.issuesForCouncil, font),

              _buildListSection('FUTURE PLANS', report.futurePlans, font),

              // 4. SIGNATURES
              pw.SizedBox(height: 40),
              pw.Text('SIGNATURES', style: _headerStyle(font)),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('____________________________________', style: _textStyle(font)),
                      pw.Text('CHAIRPERSON', style: _textStyle(font)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('____________________________________', style: _textStyle(font)),
                      pw.Text('SECRETARY', style: _textStyle(font)),
                    ],
                  ),
                ]
              ),

            ];
          },
        ),
      );

      // Save and open the PDF
      final directory = await getApplicationDocumentsDirectory();

      // 2. Define a clean subdirectory structure (optional but recommended)
      final outputDir = Directory('${directory.path}/Reports/Parish');

      // 3. Create the directory if it doesn't exist
      if (!await outputDir.exists()) {
        await outputDir.create(recursive: true);
      }

      // 4. Define the final file path
      final fileName = '${report.commissionName}_Parish_Report_$formattedDate.pdf';
      final file = File('${outputDir.path}/$fileName');

      // 5. Write the file
      await file.writeAsBytes(await pdf.save());

      // =====================================================================

      if (!context.mounted) return;
      showToast(context, 'PDF saved successfully to app data directory. Opening file...', type: ToastificationType.success);

      // Open the file using open_filex
      await OpenFilex.open(file.path);

    } catch (e, s) {
      if (!context.mounted) return;
      logger.e('Parish PDF Error', error: e, stackTrace: s);
      showToast(context, 'Failed to generate or open PDF: ${e.toString()}', type: ToastificationType.error);
    }
  }
}
