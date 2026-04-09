import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final _fmt = NumberFormat('#,##0.00');
  List<PriceAlert> _alerts = [];
  List<PriceAlert> _triggered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _loading = true);
    try {
      final api = context.read<AppProvider>().api;
      final results = await Future.wait([
        api.getAlerts(),
        api.getTriggeredAlerts(),
      ]);
      _alerts = results[0];
      _triggered = results[1];
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _deleteAlert(int id) async {
    try {
      await context.read<AppProvider>().api.deleteAlert(id);
      _loadAlerts();
    } catch (_) {}
  }

  void _showCreateDialog() {
    final provider = context.read<AppProvider>();
    final assets = provider.assets;
    if (assets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Load market data first'),
            backgroundColor: HalalEtTheme.warning),
      );
      return;
    }

    Asset? selectedAsset = assets.first;
    final priceCtrl = TextEditingController();
    String condition = 'above';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: HalalEtTheme.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Create Price Alert',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('የዋጋ ማንቂያ ይፍጠሩ',
                    style: TextStyle(fontSize: 12, color: HalalEtTheme.textSecondary)),
                const SizedBox(height: 16),
                DropdownButtonFormField<Asset>(
                  initialValue: selectedAsset,
                  dropdownColor: HalalEtTheme.cardBgLight,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Asset'),
                  items: assets.map((a) => DropdownMenuItem(
                    value: a,
                    child: Text('${a.symbol} — ${a.name}',
                        overflow: TextOverflow.ellipsis),
                  )).toList(),
                  onChanged: (v) => setDialogState(() {
                    selectedAsset = v;
                    if (v?.price != null) {
                      priceCtrl.text = v!.price!.toStringAsFixed(2);
                    }
                  }),
                ),
                const SizedBox(height: 12),
                if (selectedAsset?.price != null)
                  Text('Current: ${_fmt.format(selectedAsset!.price)} ETB',
                      style: const TextStyle(fontSize: 12, color: HalalEtTheme.textSecondary)),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Target Price (ETB)',
                    suffixText: 'ETB',
                  ),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setDialogState(() => condition = 'above'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: condition == 'above'
                              ? HalalEtTheme.positive.withValues(alpha: 0.2)
                              : HalalEtTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: condition == 'above'
                                ? HalalEtTheme.positive : HalalEtTheme.divider,
                          ),
                        ),
                        child: Center(child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.trending_up, size: 16,
                                color: condition == 'above'
                                    ? HalalEtTheme.positive : HalalEtTheme.textMuted),
                            const SizedBox(width: 6),
                            Text('Above', style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: condition == 'above'
                                  ? HalalEtTheme.positive : HalalEtTheme.textMuted,
                            )),
                          ],
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setDialogState(() => condition = 'below'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: condition == 'below'
                              ? HalalEtTheme.negative.withValues(alpha: 0.2)
                              : HalalEtTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: condition == 'below'
                                ? HalalEtTheme.negative : HalalEtTheme.divider,
                          ),
                        ),
                        child: Center(child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.trending_down, size: 16,
                                color: condition == 'below'
                                    ? HalalEtTheme.negative : HalalEtTheme.textMuted),
                            const SizedBox(width: 6),
                            Text('Below', style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: condition == 'below'
                                  ? HalalEtTheme.negative : HalalEtTheme.textMuted,
                            )),
                          ],
                        )),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: HalalEtTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                final price = double.tryParse(priceCtrl.text);
                if (price == null || selectedAsset == null) return;
                Navigator.pop(ctx);
                try {
                  await provider.api.createAlert(
                    assetId: selectedAsset!.id,
                    targetPrice: price,
                    condition: condition,
                  );
                } catch (_) {}
                _loadAlerts();
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);

    final content = Container(
      decoration: BoxDecoration(gradient: HalalEtTheme.bgGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 0),
              child: Row(
                children: [
                  const Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price Alerts', style: TextStyle(fontSize: 28,
                          fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
                      Text('የዋጋ ማንቂያ • Get notified on price changes',
                          style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
                    ],
                  )),
                  FloatingActionButton.small(
                    onPressed: _showCreateDialog,
                    backgroundColor: HalalEtTheme.positive,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: HalalEtTheme.positive))
                  : RefreshIndicator(
                      onRefresh: _loadAlerts,
                      color: HalalEtTheme.positive,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 16),
                        children: [
                          // Triggered alerts
                          if (_triggered.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text('Triggered', style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700,
                                  color: HalalEtTheme.accent)),
                            ),
                            ..._triggered.map(_buildTriggeredAlert),
                            const SizedBox(height: 20),
                          ],

                          // Active alerts
                          if (_alerts.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text('Active Alerts', style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700,
                                  color: HalalEtTheme.positive)),
                            ),
                            ..._alerts.map(_buildAlertCard),
                          ],

                          if (_alerts.isEmpty && _triggered.isEmpty)
                            _buildEmptyState(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );

    if (wide) return WebContentWrapper(maxWidth: 800, child: content);
    return content;
  }

  Widget _buildAlertCard(PriceAlert alert) {
    final isAbove = alert.condition == 'above';
    final color = isAbove ? HalalEtTheme.positive : HalalEtTheme.negative;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(isAbove ? Icons.trending_up : Icons.trending_down,
                color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(alert.symbol, style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
              const SizedBox(height: 2),
              Text('${isAbove ? "Above" : "Below"} ${_fmt.format(alert.targetPrice)} ETB',
                  style: TextStyle(fontSize: 12, color: color)),
              if (alert.currentPrice != null)
                Text('Current: ${_fmt.format(alert.currentPrice)} ETB',
                    style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted)),
            ],
          )),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: HalalEtTheme.negative, size: 20),
            onPressed: () => _deleteAlert(alert.id),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggeredAlert(PriceAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HalalEtTheme.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HalalEtTheme.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: HalalEtTheme.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_active, color: HalalEtTheme.accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${alert.symbol} hit target!',
                  style: const TextStyle(fontWeight: FontWeight.w700,
                      fontSize: 14, color: Colors.white)),
              Text('${alert.condition == "above" ? "Went above" : "Dropped below"} '
                  '${_fmt.format(alert.targetPrice)} ETB',
                  style: const TextStyle(fontSize: 12, color: HalalEtTheme.accent)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(Icons.notifications_none, size: 64, color: HalalEtTheme.textMuted.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text('No alerts yet', style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w600, color: HalalEtTheme.textMuted)),
          const SizedBox(height: 8),
          const Text('Tap + to create a price alert',
              style: TextStyle(fontSize: 13, color: HalalEtTheme.textMuted)),
        ],
      ),
    );
  }
}
