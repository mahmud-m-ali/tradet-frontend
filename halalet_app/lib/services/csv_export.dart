import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

/// Generates CSV data and exports it (clipboard copy with download on web).
class CsvExport {
  static final _fmt = NumberFormat('#,##0.00', 'en');

  /// Generate CSV string from portfolio holdings.
  static String portfolioCsv(List<PortfolioHolding> holdings) {
    final buf = StringBuffer();
    buf.writeln('Symbol,Asset Name,Quantity,Unit,Avg Buy Price (ETB),Current Price (ETB),Current Value (ETB),P&L (ETB),P&L %,Sharia Compliant');
    for (final h in holdings) {
      buf.writeln(
        '${_esc(h.symbol)},${_esc(h.assetName)},${h.quantity},${h.unit},'
        '${_fmt.format(h.avgBuyPrice)},${_fmt.format(h.currentPrice)},'
        '${_fmt.format(h.currentValue)},${_fmt.format(h.pnl)},'
        '${h.pnlPercentage.toStringAsFixed(2)}%,${h.isShariaCompliant ? "Yes" : "No"}',
      );
    }
    return buf.toString();
  }

  /// Generate CSV string from orders.
  static String ordersCsv(List<Order> orders) {
    final buf = StringBuffer();
    buf.writeln('Date,Type,Symbol,Asset Name,Quantity,Price (ETB),Total (ETB),Fee (ETB),Status');
    for (final o in orders) {
      buf.writeln(
        '${_esc(o.createdAt)},${o.orderType.toUpperCase()},${_esc(o.symbol)},'
        '${_esc(o.assetName)},${o.quantity},${_fmt.format(o.price)},'
        '${_fmt.format(o.totalAmount)},${_fmt.format(o.feeAmount)},'
        '${o.orderStatus.toUpperCase()}',
      );
    }
    return buf.toString();
  }

  /// Export CSV — copies to clipboard and shows snackbar.
  static Future<void> export(BuildContext context, String csv, String filename) async {
    await Clipboard.setData(ClipboardData(text: csv));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('CSV data copied to clipboard')),
            ],
          ),
          backgroundColor: const Color(0xFF4ADE80),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Show preview dialog with copy and dismiss.
  static void showExportDialog(BuildContext context, String csv, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF164D30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.download_rounded, color: Color(0xFF4ADE80), size: 22),
            const SizedBox(width: 10),
            Text('Export $title', style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        content: SizedBox(
          width: 500,
          height: 300,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D3B20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                csv,
                style: const TextStyle(fontSize: 11, color: Color(0xFFA8D5BA),
                    fontFamily: 'monospace'),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close',
                style: TextStyle(color: Color(0xFF6DAF87))),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: csv));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('CSV copied to clipboard!'),
                  backgroundColor: const Color(0xFF4ADE80),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy CSV'),
          ),
        ],
      ),
    );
  }

  static String _esc(String s) => s.contains(',') ? '"$s"' : s;
}
