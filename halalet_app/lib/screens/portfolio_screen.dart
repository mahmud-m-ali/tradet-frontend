import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../services/csv_export.dart';
import '../theme.dart';
import '../widgets/sharia_badge.dart';
import '../widgets/price_change.dart';
import '../widgets/responsive_layout.dart';
import 'trade_screen.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en');
    final wide = isWideScreen(context);
    final desktop = isDesktop(context);

    return Container(
      decoration: BoxDecoration(gradient: HalalEtTheme.bgGradient),
      child: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.holdings.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: HalalEtTheme.positive),
              );
            }

            final summary = provider.portfolioSummary;

            return RefreshIndicator(
              color: HalalEtTheme.positive,
              backgroundColor: HalalEtTheme.cardBg,
              onRefresh: () => provider.loadPortfolio(),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 20),
                children: [
                  // Header
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Portfolio',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5)),
                            Text('ፖርትፎሊዮ • Your holdings',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: HalalEtTheme.textSecondary)),
                          ],
                        ),
                      ),
                      if (provider.holdings.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            final csv = CsvExport.portfolioCsv(provider.holdings);
                            CsvExport.showExportDialog(context, csv, 'Portfolio');
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: HalalEtTheme.cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: HalalEtTheme.divider),
                              ),
                              child: const Icon(Icons.download_rounded,
                                  size: 20, color: HalalEtTheme.positive),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => provider.loadPortfolio(),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: HalalEtTheme.cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: HalalEtTheme.divider),
                            ),
                            child: const Icon(Icons.refresh_rounded,
                                size: 20, color: HalalEtTheme.textSecondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Balance card
                  if (desktop)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 3, child: _balanceCard(context, summary, fmt)),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: _quickStats(summary, fmt),
                          ),
                        ],
                      ),
                    )
                  else
                    _balanceCard(context, summary, fmt),
                  const SizedBox(height: 24),

                  // Holdings header
                  const Text('Holdings / ይዞታዎች',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const SizedBox(height: 12),

                  if (provider.holdings.isEmpty)
                    _emptyHoldings()
                  else if (wide)
                    _webHoldingsTable(context, provider, fmt)
                  else
                    ...provider.holdings.map((h) {
                      final asset = provider.assets.where((a) => a.id == h.assetId).firstOrNull;
                      return GestureDetector(
                        onTap: asset != null
                            ? () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => TradeScreen(asset: asset)))
                            : null,
                        child: _mobileHoldingCard(h, fmt),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _balanceCard(BuildContext context, dynamic summary, NumberFormat fmt) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: HalalEtTheme.heroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: HalalEtTheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Total Value',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('ETB',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            fmt.format(summary?.totalPortfolioValue ?? 0),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: -1),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _balanceItem('Holdings', fmt.format(summary?.totalHoldingsValue ?? 0)),
                Container(width: 1, height: 30, color: Colors.white24),
                _balanceItem('Cash', fmt.format(summary?.cashBalance ?? 0)),
                Container(width: 1, height: 30, color: Colors.white24),
                _balanceItem(
                  'P&L',
                  '${(summary?.totalPnl ?? 0) >= 0 ? '+' : ''}${fmt.format(summary?.totalPnl ?? 0)}',
                  color: (summary?.totalPnl ?? 0) >= 0
                      ? HalalEtTheme.positive
                      : HalalEtTheme.negative,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showDepositSheet(context),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline, color: Colors.white, size: 17),
                          const SizedBox(width: 6),
                          Text(l.deposit,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showWithdrawSheet(context),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.remove_circle_outline, color: Colors.white, size: 17),
                          const SizedBox(width: 6),
                          Text(l.withdraw,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickStats(dynamic summary, NumberFormat fmt) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Quick Stats',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HalalEtTheme.textSecondary)),
          const SizedBox(height: 14),
          _quickStatRow('Total Invested', '${fmt.format(summary?.totalInvested ?? 0)} ETB'),
          const SizedBox(height: 8),
          _quickStatRow('Holdings Value', '${fmt.format(summary?.totalHoldingsValue ?? 0)} ETB'),
          const SizedBox(height: 8),
          _quickStatRow(
            'Return',
            '${(summary?.totalPnl ?? 0) >= 0 ? '+' : ''}${fmt.format(summary?.totalPnl ?? 0)} ETB',
            color: (summary?.totalPnl ?? 0) >= 0 ? HalalEtTheme.positive : HalalEtTheme.negative,
          ),
        ],
      ),
    );
  }

  Widget _quickStatRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: HalalEtTheme.textMuted)),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color ?? Colors.white)),
      ],
    );
  }

  // ─── Web: Holdings as table ───
  Widget _webHoldingsTable(BuildContext context, AppProvider provider, NumberFormat fmt) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: HalalEtTheme.primaryDark.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Asset', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: HalalEtTheme.textMuted))),
                Expanded(flex: 1, child: Text('Quantity', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: HalalEtTheme.textMuted))),
                Expanded(flex: 1, child: Text('Avg Price', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: HalalEtTheme.textMuted))),
                Expanded(flex: 1, child: Text('Current', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: HalalEtTheme.textMuted))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text('Value', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: HalalEtTheme.textMuted)))),
                SizedBox(width: 100, child: Align(alignment: Alignment.centerRight, child: Text('P&L', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: HalalEtTheme.textMuted)))),
              ],
            ),
          ),
          // Rows
          ...provider.holdings.asMap().entries.map((entry) {
            final i = entry.key;
            final h = entry.value;
            final asset = provider.assets.where((a) => a.id == h.assetId).firstOrNull;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: asset != null
                    ? () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TradeScreen(asset: asset)))
                    : null,
              child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: i.isEven ? HalalEtTheme.cardBg.withValues(alpha: 0.3) : Colors.transparent,
                border: Border(
                  bottom: BorderSide(color: HalalEtTheme.divider.withValues(alpha: 0.15)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Text(h.symbol,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
                        const SizedBox(width: 6),
                        ShariaBadge(isCompliant: h.isShariaCompliant, compact: true),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(h.assetName,
                              style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('${h.quantity} ${h.unit}',
                        style: const TextStyle(fontSize: 13, color: Colors.white)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('${fmt.format(h.avgBuyPrice)} ETB',
                        style: const TextStyle(fontSize: 13, color: Colors.white)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('${fmt.format(h.currentPrice)} ETB',
                        style: const TextStyle(fontSize: 13, color: Colors.white)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('${fmt.format(h.currentValue)} ETB',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                        textAlign: TextAlign.right),
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${h.pnl >= 0 ? "+" : ""}${fmt.format(h.pnl)} ETB',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: h.pnl >= 0 ? HalalEtTheme.positive : HalalEtTheme.negative,
                          ),
                        ),
                        PriceChange(change: h.pnlPercentage, fontSize: 10),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            );
          }),
        ],
      ),
    );
  }

  // ─── Mobile: holding card (unchanged) ───
  Widget _mobileHoldingCard(dynamic h, NumberFormat fmt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(h.symbol,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                        const SizedBox(width: 6),
                        ShariaBadge(isCompliant: h.isShariaCompliant, compact: true),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      h.nameAm != null ? '${h.assetName} / ${h.nameAm}' : h.assetName,
                      style: const TextStyle(fontSize: 12, color: HalalEtTheme.textMuted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${fmt.format(h.currentValue)} ETB',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 2),
                  PriceChange(change: h.pnlPercentage, fontSize: 11),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: HalalEtTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _holdingDetail('Qty', '${h.quantity} ${h.unit}'),
                _holdingDetail('Avg', fmt.format(h.avgBuyPrice)),
                _holdingDetail('Current', fmt.format(h.currentPrice)),
                _holdingDetail('P&L', '${fmt.format(h.pnl)} ETB',
                    color: h.pnl >= 0 ? HalalEtTheme.positive : HalalEtTheme.negative),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyHoldings() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: HalalEtTheme.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pie_chart_outline_rounded,
                size: 40, color: HalalEtTheme.textMuted),
          ),
          const SizedBox(height: 16),
          const Text('No holdings yet',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white)),
          const SizedBox(height: 4),
          const Text('Start trading to build your portfolio',
              style: TextStyle(color: HalalEtTheme.textMuted, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _balanceItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: color ?? Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  Widget _holdingDetail(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: HalalEtTheme.textMuted)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 12, color: color ?? Colors.white)),
      ],
    );
  }

  void _showDepositSheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: HalalEtTheme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: HalalEtTheme.divider,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Deposit ETB',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 4),
            const Text('ገንዘብ አስገባ • Funds via secure channel (no interest)',
                style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
              decoration: const InputDecoration(
                prefixText: 'ETB  ',
                prefixStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: HalalEtTheme.textSecondary),
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(controller.text);
                if (amount != null && amount > 0) {
                  Navigator.pop(ctx);
                  final result = await context.read<AppProvider>().deposit(amount);
                  if (context.mounted) {
                    await context.read<AppProvider>().loadPortfolio();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'Deposit complete'),
                        backgroundColor: HalalEtTheme.positive,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                }
              },
              child: const Text('Deposit'),
            ),
          ],
        ),
      ),
    );
  }

  static const _ethiopianBanks = [
    'Commercial Bank of Ethiopia (CBE)',
    'Awash Bank',
    'Dashen Bank',
    'Bank of Abyssinia',
    'Wegagen Bank',
    'United Bank',
    'Nib International Bank',
    'Cooperative Bank of Oromia',
    'Lion International Bank',
    'Oromia Bank',
    'Bunna Bank',
    'Berhan Bank',
    'Abay Bank',
    'Addis International Bank',
    'Debub Global Bank',
    'Enat Bank',
    'ZamZam Bank',
    'Hijra Bank',
    'Siinqee Bank',
    'Amhara Bank',
    'Gadaa Bank',
    'Goh Betoch Bank',
    'Tsedey Bank',
    'Tsehay Bank',
  ];

  void _showWithdrawSheet(BuildContext context) {
    final amountCtrl = TextEditingController();
    final accountCtrl = TextEditingController();
    String? selectedBank;

    showModalBottomSheet(
      context: context,
      backgroundColor: HalalEtTheme.cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: HalalEtTheme.divider,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Withdraw ETB',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 4),
              const Text('ገንዘብ አውጣ • Withdraw to your bank account (Riba-free)',
                  style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
              const SizedBox(height: 12),
              Consumer<AppProvider>(
                builder: (_, provider, __) {
                  final available = provider.availableCashBalance;
                  final reserved = provider.reservedForOrders;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available: ${available.toStringAsFixed(2)} ETB',
                        style: const TextStyle(fontSize: 13, color: HalalEtTheme.positive, fontWeight: FontWeight.w600),
                      ),
                      if (reserved > 0)
                        Text(
                          'Reserved in open orders: ${reserved.toStringAsFixed(2)} ETB',
                          style: const TextStyle(fontSize: 11, color: HalalEtTheme.warning),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 14),

              // Bank selector
              DropdownButtonFormField<String>(
                value: selectedBank,
                dropdownColor: HalalEtTheme.surfaceLight,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  labelText: 'Select Bank / ባንክ ይምረጡ',
                  prefixIcon: Icon(Icons.account_balance, size: 20),
                ),
                items: _ethiopianBanks.map((bank) => DropdownMenuItem(
                  value: bank,
                  child: Text(bank, style: const TextStyle(fontSize: 13)),
                )).toList(),
                onChanged: (v) => setSheetState(() => selectedBank = v),
              ),
              const SizedBox(height: 14),

              // Account number
              TextField(
                controller: accountCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Account Number / የሒሳብ ቁጥር',
                  prefixIcon: Icon(Icons.credit_card, size: 20),
                ),
              ),
              const SizedBox(height: 14),

              // Amount
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                decoration: const InputDecoration(
                  prefixText: 'ETB  ',
                  prefixStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: HalalEtTheme.textSecondary),
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HalalEtTheme.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final amount = double.tryParse(amountCtrl.text);
                  if (amount == null || amount <= 0) return;
                  if (selectedBank == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please select a bank'),
                        backgroundColor: HalalEtTheme.warning,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    return;
                  }
                  if (accountCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please enter account number'),
                        backgroundColor: HalalEtTheme.warning,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    return;
                  }
                  final available = context.read<AppProvider>().availableCashBalance;
                  if (amount > available) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Insufficient available balance. Available: ${available.toStringAsFixed(2)} ETB'),
                        backgroundColor: HalalEtTheme.negative,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(ctx);
                  final result = await context.read<AppProvider>().withdraw(
                    amount: amount,
                    bankName: selectedBank!,
                    accountNumber: accountCtrl.text.trim(),
                  );
                  if (context.mounted) {
                    await context.read<AppProvider>().loadPortfolio();
                    final isError = result.containsKey('error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isError
                            ? (result['error'] ?? 'Withdrawal failed')
                            : (result['message'] ?? 'Withdrawal complete')),
                        backgroundColor: isError ? HalalEtTheme.negative : HalalEtTheme.positive,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context).withdraw,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
