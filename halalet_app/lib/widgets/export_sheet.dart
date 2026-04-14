import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' as xl;
import '../theme.dart';
import '../widgets/responsive_layout.dart';
import '../utils/download_helper.dart';

// ─── Public entry point ──────────────────────────────────────────────────────

/// Shows the export modal (centered dialog on desktop, bottom sheet on mobile).
/// [title] — e.g. "Portfolio", "Transactions"
/// [rows]  — list of data rows (each row is a list of strings)
/// [headers] — column header strings
/// [pdfTitle] — heading shown in PDF document
void showExportSheet(
  BuildContext context, {
  required String title,
  required List<String> headers,
  required List<List<String>> rows,
  required String pdfTitle,
  String? subtitle,
}) {
  final wide = isWideScreen(context);
  if (wide) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: 420,
          child: _ExportContent(
            title: title,
            subtitle: subtitle,
            headers: headers,
            rows: rows,
            pdfTitle: pdfTitle,
          ),
        ),
      ),
    );
  } else {
    showModalBottomSheet(
      context: context,
      backgroundColor: TradEtTheme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ExportContent(
        title: title,
        subtitle: subtitle,
        headers: headers,
        rows: rows,
        pdfTitle: pdfTitle,
      ),
    );
  }
}

// ─── Internal content widget ─────────────────────────────────────────────────

class _ExportContent extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String> headers;
  final List<List<String>> rows;
  final String pdfTitle;

  const _ExportContent({
    required this.title,
    this.subtitle,
    required this.headers,
    required this.rows,
    required this.pdfTitle,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en');
    final now = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
    final baseName = title.toLowerCase().replaceAll(' ', '_');

    return Container(
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: TradEtTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.download_rounded,
                  color: TradEtTheme.primaryLight, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Export $title',
                        style: const TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w700, color: Colors.white)),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: const TextStyle(fontSize: 13,
                              color: TradEtTheme.textSecondary)),
                  ],
                ),
              ),
              // Close button (desktop dialog)
              if (isWideScreen(context))
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: TradEtTheme.textMuted, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // ── PDF ──
          _ExportOption(
            label: 'PDF',
            labelColor: Colors.white,
            badgeColor: const Color(0xFFE53935),
            badgeText: 'PDF',
            icon: Icons.picture_as_pdf_rounded,
            iconColor: Colors.white,
            title: 'PDF Document',
            subtitle: 'Formal statement, ready to print or share',
            onTap: () {
              Navigator.pop(context);
              _exportPdf(headers, rows, pdfTitle, now, baseName, fmt);
            },
          ),
          const SizedBox(height: 10),

          // ── Excel ──
          _ExportOption(
            label: 'XLS',
            labelColor: Colors.white,
            badgeColor: const Color(0xFF1D7044),
            badgeText: 'XLS',
            icon: Icons.grid_on_rounded,
            iconColor: Colors.white,
            title: 'Excel Spreadsheet (.xlsx)',
            subtitle: 'Open directly in Microsoft Excel',
            onTap: () {
              Navigator.pop(context);
              _exportExcel(headers, rows, title, baseName, now);
            },
          ),
          const SizedBox(height: 10),

          // ── CSV ──
          _ExportOption(
            label: 'CSV',
            labelColor: Colors.white,
            badgeColor: const Color(0xFF0277BD),
            badgeText: 'CSV',
            icon: Icons.table_rows_outlined,
            iconColor: Colors.white,
            title: 'CSV File',
            subtitle: 'Plain text, compatible with any spreadsheet',
            onTap: () {
              Navigator.pop(context);
              _exportCsv(headers, rows, baseName, now);
            },
          ),
        ],
      ),
    );
  }

  // ── PDF export ──
  Future<void> _exportPdf(
    List<String> headers,
    List<List<String>> rows,
    String pdfTitle,
    String now,
    String baseName,
    NumberFormat fmt,
  ) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TradEt — $pdfTitle',
                    style: pw.TextStyle(fontSize: 16,
                        fontWeight: pw.FontWeight.bold)),
                pw.Text('Generated: ${now.replaceAll('_', ' ')}',
                    style: const pw.TextStyle(fontSize: 9,
                        color: PdfColors.grey600)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 6),
          ],
        ),
        footer: (ctx) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text('Page ${ctx.pageNumber} of ${ctx.pagesCount}',
              style: const pw.TextStyle(fontSize: 9,
                  color: PdfColors.grey500)),
        ),
        build: (ctx) => [
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, fontSize: 9),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.grey200),
            cellStyle: const pw.TextStyle(fontSize: 8),
            headers: headers,
            data: rows,
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Sharia Board Compliance Certified — AAOIFI Standards Applied  |  '
            'ECX & NBE Compliant  |  No Riba (interest) instruments  |  '
            'INSA CSMS Guideline v1.0',
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    final bytes = await doc.save();
    // Use Printing.sharePdf for cross-platform support (web + mobile + desktop)
    await Printing.sharePdf(
        bytes: bytes, filename: 'tradet_${baseName}_$now.pdf');
  }

  // ── Excel export ──
  void _exportExcel(
    List<String> headers,
    List<List<String>> rows,
    String sheetName,
    String baseName,
    String now,
  ) {
    final excel = xl.Excel.createExcel();
    final sheet = excel[sheetName];

    // Header row
    sheet.appendRow(headers.map((h) => xl.TextCellValue(h)).toList());

    // Data rows
    for (final row in rows) {
      sheet.appendRow(row.map((v) => xl.TextCellValue(v)).toList());
    }

    // Remove default Sheet1
    if (excel.sheets.containsKey('Sheet1') && sheetName != 'Sheet1') {
      excel.delete('Sheet1');
    }

    final bytes = excel.save()!;
    downloadFile(bytes, 'tradet_${baseName}_$now.xlsx',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  }

  // ── CSV export ──
  void _exportCsv(
    List<String> headers,
    List<List<String>> rows,
    String baseName,
    String now,
  ) {
    final lines = <String>[
      headers.map(_csvEsc).join(','),
      ...rows.map((r) => r.map(_csvEsc).join(',')),
    ];
    final bytes = utf8.encode(lines.join('\r\n'));
    downloadFile(bytes, 'tradet_${baseName}_$now.csv', 'text/csv');
  }

  String _csvEsc(String s) {
    if (s.contains(',') || s.contains('"') || s.contains('\n')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }
}

// ─── Option tile ─────────────────────────────────────────────────────────────

class _ExportOption extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color badgeColor;
  final String badgeText;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExportOption({
    required this.label,
    required this.labelColor,
    required this.badgeColor,
    required this.badgeText,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: TradEtTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: TradEtTheme.divider.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              // File-type badge
              SizedBox(
                width: 44, height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Document shape
                    Container(
                      width: 36, height: 44,
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: badgeColor.withValues(alpha: 0.4),
                            width: 1.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 14, color: badgeColor),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                fontSize: 7,
                                fontWeight: FontWeight.w800,
                                color: labelColor,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12,
                            color: TradEtTheme.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: TradEtTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
