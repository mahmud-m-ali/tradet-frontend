import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/export_sheet.dart';
import '../theme.dart';
import '../widgets/sharia_badge.dart';
import '../widgets/price_change.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/disclaimer_footer.dart';
import 'trade_screen.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fmt = NumberFormat('#,##0.00', 'en');
    final wide = isWideScreen(context);
    final desktop = isDesktop(context);

    return Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.holdings.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: TradEtTheme.positive),
              );
            }

            final summary = provider.portfolioSummary;

            return RefreshIndicator(
              color: TradEtTheme.positive,
              backgroundColor: TradEtTheme.cardBg,
              onRefresh: () => provider.loadPortfolio(),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  wide ? 32 : 20,
                  wide ? 24 : 16,
                  wide ? 32 : 20,
                  20,
                ),
                children: [
                  // Header
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Portfolio',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'ፖርትፎሊዮ • Your holdings',
                              style: TextStyle(
                                fontSize: 13,
                                color: TradEtTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (provider.holdings.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            final fmt = NumberFormat('#,##0.00', 'en');
                            showExportSheet(
                              context,
                              title: 'Portfolio',
                              subtitle: '${provider.holdings.length} holdings',
                              pdfTitle: 'Portfolio Holdings Statement',
                              headers: [
                                'Symbol',
                                'Asset',
                                'Qty',
                                'Unit',
                                'Avg Buy (ETB)',
                                'Current (ETB)',
                                'Value (ETB)',
                                'P&L (ETB)',
                                'P&L %',
                                'Sharia',
                              ],
                              rows: provider.holdings
                                  .map(
                                    (h) => [
                                      h.symbol,
                                      h.assetName,
                                      h.quantity.toString(),
                                      h.unit,
                                      fmt.format(h.avgBuyPrice),
                                      fmt.format(h.currentPrice),
                                      fmt.format(h.currentValue),
                                      fmt.format(h.pnl),
                                      '${h.pnlPercentage.toStringAsFixed(2)}%',
                                      h.isShariaCompliant ? 'Yes' : 'No',
                                    ],
                                  )
                                  .toList(),
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: TradEtTheme.cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: TradEtTheme.divider),
                              ),
                              child: const Icon(
                                Icons.download_rounded,
                                size: 20,
                                color: TradEtTheme.positive,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => provider.loadPortfolio(),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: TradEtTheme.cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: TradEtTheme.divider),
                            ),
                            child: provider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: TradEtTheme.textSecondary,
                                    ),
                                  )
                                : const Icon(
                                    Icons.refresh_rounded,
                                    size: 20,
                                    color: TradEtTheme.textSecondary,
                                  ),
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
                          Expanded(
                            flex: 3,
                            child: _balanceCard(context, summary, fmt),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _quickStats(summary, fmt),
                                const SizedBox(height: 14),
                                _returnRateCard(summary, fmt),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    _balanceCard(context, summary, fmt),
                  const SizedBox(height: 14),
                  _PortfolioSplitCard(summary: summary),
                  const SizedBox(height: 14),
                  _ShariaScoreCard(holdings: provider.holdings),
                  const SizedBox(height: 24),

                  // Holdings header
                  Text(
                    l.holdings,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (provider.holdings.isEmpty)
                    _emptyHoldings()
                  else if (wide)
                    _webHoldingsTable(context, provider, fmt)
                  else
                    ...provider.holdings.map((h) {
                      final asset = provider.assets
                          .where((a) => a.id == h.assetId)
                          .firstOrNull;
                      return GestureDetector(
                        onTap: asset != null
                            ? () => Navigator.of(context).push(
                                appRoute(context, TradeScreen(asset: asset)),
                              )
                            : null,
                        child: _mobileHoldingCard(context, h, fmt),
                      );
                    }),
                  const SizedBox(height: 16),
                  const DisclaimerFooter(),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<double> _fetchUsdRate(AppProvider provider) async {
    try {
      final rates = await provider.api.getExchangeRates();
      return rates['USD']?.selling ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  Widget _balanceCard(BuildContext context, dynamic summary, NumberFormat fmt) {
    final l = AppLocalizations.of(context);
    final provider = context.read<AppProvider>();
    final totalEtb = (summary?.totalPortfolioValue ?? 0) as double;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: TradEtTheme.heroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TradEtTheme.primary.withValues(alpha: 0.3),
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
              Text(
                'Total Value',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'ETB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            fmt.format(totalEtb),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          // USD equivalent using NBE selling rate
          FutureBuilder<double>(
            future: _fetchUsdRate(provider),
            builder: (_, snap) {
              final selling = snap.data ?? 0.0;
              if (selling <= 0) return const SizedBox.shrink();
              final usd = totalEtb / selling;
              final usdFmt = NumberFormat('#,##0.00', 'en');
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      '≈ USD ${usdFmt.format(usd)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '@ ${usdFmt.format(selling)} ETB/USD (NBE)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            },
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
                _balanceItem(
                  'Holdings',
                  fmt.format(summary?.totalHoldingsValue ?? 0),
                ),
                Container(width: 1, height: 30, color: Colors.white24),
                _balanceItem('Cash', fmt.format(summary?.cashBalance ?? 0)),
                Container(width: 1, height: 30, color: Colors.white24),
                _balanceItem(
                  'P&L',
                  '${(summary?.totalPnl ?? 0) >= 0 ? '+' : ''}${fmt.format(summary?.totalPnl ?? 0)}',
                  color: (summary?.totalPnl ?? 0) >= 0
                      ? TradEtTheme.positive
                      : TradEtTheme.negative,
                ),
              ],
            ),
          ),
          const Spacer(),
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
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 17,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l.deposit,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
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
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.white,
                            size: 17,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l.withdraw,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
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
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TradEtTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          _quickStatRow(
            'Total Invested',
            '${fmt.format(summary?.totalInvested ?? 0)} ETB',
          ),
          const SizedBox(height: 8),
          _quickStatRow(
            'Holdings Value',
            '${fmt.format(summary?.totalHoldingsValue ?? 0)} ETB',
          ),
          const SizedBox(height: 8),
          _quickStatRow(
            'Return',
            '${(summary?.totalPnl ?? 0) >= 0 ? '+' : ''}${fmt.format(summary?.totalPnl ?? 0)} ETB',
            color: (summary?.totalPnl ?? 0) >= 0
                ? TradEtTheme.positive
                : TradEtTheme.negative,
          ),
        ],
      ),
    );
  }

  Widget _returnRateCard(dynamic summary, NumberFormat fmt) {
    final invested = summary?.totalInvested ?? 0;
    final pnl = summary?.totalPnl ?? 0;
    final pnlPct = invested > 0 ? (pnl / invested * 100) : 0.0;
    final isPositive = pnl >= 0;
    final color = isPositive ? TradEtTheme.positive : TradEtTheme.negative;
    final barValue = (pnlPct.abs() / 50).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Return Rate',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TradEtTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${isPositive ? "+" : ""}${pnlPct.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: barValue,
              minHeight: 7,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invested',
                    style: TextStyle(
                      fontSize: 10,
                      color: TradEtTheme.textMuted,
                    ),
                  ),
                  Text(
                    '${fmt.format(invested)} ETB',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Return',
                    style: TextStyle(
                      fontSize: 10,
                      color: TradEtTheme.textMuted,
                    ),
                  ),
                  Text(
                    '${isPositive ? "+" : ""}${fmt.format(pnl)} ETB',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickStatRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }

  // ─── Web: Holdings as table ───
  Widget _webHoldingsTable(
    BuildContext context,
    AppProvider provider,
    NumberFormat fmt,
  ) {
    return FutureBuilder<double>(
      future: _fetchUsdRate(provider),
      builder: (_, snap) =>
          _webHoldingsTableInner(context, provider, fmt, snap.data ?? 0.0),
    );
  }

  Widget _webHoldingsTableInner(
    BuildContext context,
    AppProvider provider,
    NumberFormat fmt,
    double usdRate,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: TradEtTheme.primaryDark.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Asset',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: TradEtTheme.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: TradEtTheme.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Avg Price',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: TradEtTheme.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Current',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: TradEtTheme.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Value',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: TradEtTheme.textMuted,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'P&L',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: TradEtTheme.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...provider.holdings.asMap().entries.map((entry) {
            final i = entry.key;
            final h = entry.value;
            final asset = provider.assets
                .where((a) => a.id == h.assetId)
                .firstOrNull;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: asset != null
                    ? () => Navigator.of(
                        context,
                      ).push(appRoute(context, TradeScreen(asset: asset)))
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: i.isEven
                        ? TradEtTheme.cardBg.withValues(alpha: 0.3)
                        : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: TradEtTheme.divider.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              h.symbol,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            ShariaBadge(
                              isCompliant: h.isShariaCompliant,
                              complianceLevel: h.complianceLevel,
                              compact: true,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                h.assetName,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: TradEtTheme.textMuted,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${h.quantity} ${h.unit}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${fmt.format(h.avgBuyPrice)} ETB',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${fmt.format(h.currentPrice)} ETB',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${fmt.format(h.currentValue)} ETB',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            if (usdRate > 0)
                              Text(
                                'USD ${fmt.format(h.currentValue / usdRate)}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: TradEtTheme.textMuted,
                                ),
                                textAlign: TextAlign.right,
                              ),
                          ],
                        ),
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
                                color: h.pnl >= 0
                                    ? TradEtTheme.positive
                                    : TradEtTheme.negative,
                              ),
                            ),
                            PriceChange(change: h.pnlPercentage, fontSize: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Mobile: holding card (unchanged) ───
  Widget _mobileHoldingCard(BuildContext context, dynamic h, NumberFormat fmt) {
    final langCode = AppLocalizations.of(context).langCode;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
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
                        Text(
                          h.symbol,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        ShariaBadge(
                          isCompliant: h.isShariaCompliant,
                          compact: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (langCode == 'am' || langCode == 'ti') && h.nameAm != null
                          ? h.nameAm!
                          : h.assetName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: TradEtTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${fmt.format(h.currentValue)} ETB',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
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
              color: TradEtTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _holdingDetail('Qty', '${h.quantity} ${h.unit}'),
                _holdingDetail('Avg', fmt.format(h.avgBuyPrice)),
                _holdingDetail('Current', fmt.format(h.currentPrice)),
                _holdingDetail(
                  'P&L',
                  '${fmt.format(h.pnl)} ETB',
                  color: h.pnl >= 0
                      ? TradEtTheme.positive
                      : TradEtTheme.negative,
                ),
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
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TradEtTheme.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pie_chart_outline_rounded,
              size: 40,
              color: TradEtTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No holdings yet',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Start trading to build your portfolio',
            style: TextStyle(color: TradEtTheme.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _balanceItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _holdingDetail(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }

  void _showDepositSheet(BuildContext context) {
    final controller = TextEditingController();
    showResponsiveSheet(
      context: context,
      backgroundColor: const Color(0xFF1A3D2B),
      builder: (ctx, isDialog) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          isDialog ? 20 : 24,
          24,
          isDialog ? 24 : MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isDialog)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D5A3D),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            if (isDialog)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Deposit ETB',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              )
            else ...[
              const SizedBox(height: 20),
              const Text(
                'Deposit ETB',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
            const SizedBox(height: 4),
            const Text(
              'ገንዘብ አስገባ • Funds via secure channel (no interest)',
              style: TextStyle(fontSize: 13, color: TradEtTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                prefixText: 'ETB  ',
                prefixStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: TradEtTheme.textSecondary,
                ),
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(controller.text);
                if (amount != null && amount > 0) {
                  Navigator.pop(ctx);
                  final result = await context.read<AppProvider>().deposit(
                    amount,
                  );
                  if (context.mounted) {
                    await context.read<AppProvider>().loadPortfolio();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'Deposit complete'),
                        backgroundColor: TradEtTheme.positive,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
    int? selectedMethodId;

    // Ensure payment methods are loaded
    context.read<AppProvider>().loadPaymentMethods();

    showResponsiveSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A3D2B),
      builder: (ctx, isDialog) => StatefulBuilder(
        builder: (ctx, setSheetState) => Consumer<AppProvider>(
          builder: (ctx, provider, _) {
            final methods = provider.paymentMethods;
            final available = provider.availableCashBalance;
            final reserved = provider.reservedForOrders;

            // Auto-select primary on first load
            if (selectedMethodId == null && methods.isNotEmpty) {
              final primary = methods.where((m) => m.isPrimary);
              selectedMethodId =
                  primary.isNotEmpty ? primary.first.id : methods.first.id;
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                isDialog ? 20 : 24,
                24,
                isDialog ? 24 : MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isDialog)
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D5A3D),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  if (isDialog)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Withdraw ETB',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    )
                  else ...[
                    const SizedBox(height: 20),
                    const Text('Withdraw ETB',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                  const SizedBox(height: 4),
                  const Text('Withdraw to your saved bank account (Riba-free)',
                      style: TextStyle(
                          fontSize: 13, color: TradEtTheme.textSecondary)),
                  const SizedBox(height: 12),
                  // Available balance
                  Text('Available: ${available.toStringAsFixed(2)} ETB',
                      style: const TextStyle(
                          fontSize: 13,
                          color: TradEtTheme.positive,
                          fontWeight: FontWeight.w600)),
                  if (reserved > 0)
                    Text(
                        'Reserved in open orders: ${reserved.toStringAsFixed(2)} ETB',
                        style: const TextStyle(
                            fontSize: 11, color: TradEtTheme.warning)),
                  const SizedBox(height: 16),

                  // Payment method selector
                  if (methods.isEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: TradEtTheme.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: TradEtTheme.warning.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: TradEtTheme.warning, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'No payment methods saved. Add a bank account in Profile > Payment Methods first.',
                              style: TextStyle(
                                  color: TradEtTheme.warning, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const Text('Destination Account',
                        style: TextStyle(
                            fontSize: 12,
                            color: TradEtTheme.textSecondary,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    ...methods.map((m) {
                      final selected = selectedMethodId == m.id;
                      return GestureDetector(
                        onTap: () =>
                            setSheetState(() => selectedMethodId = m.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: selected
                                ? TradEtTheme.positive.withValues(alpha: 0.12)
                                : TradEtTheme.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? TradEtTheme.positive
                                  : TradEtTheme.divider,
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: TradEtTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.account_balance,
                                    size: 18,
                                    color: TradEtTheme.primaryLight),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(m.bankName,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        ),
                                        if (m.isPrimary)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: TradEtTheme.accent
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text('Primary',
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: TradEtTheme.accent,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                      ],
                                    ),
                                    Text(
                                        '${m.accountName}  •  ****${m.accountNumber.length > 4 ? m.accountNumber.substring(m.accountNumber.length - 4) : m.accountNumber}',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: TradEtTheme.textSecondary)),
                                  ],
                                ),
                              ),
                              if (selected)
                                const Icon(Icons.check_circle_rounded,
                                    color: TradEtTheme.positive, size: 20),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 14),

                  // Amount input
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    autofocus: methods.isNotEmpty,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    decoration: const InputDecoration(
                      prefixText: 'ETB  ',
                      prefixStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: TradEtTheme.textSecondary),
                      hintText: '0.00',
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: methods.isEmpty
                          ? TradEtTheme.divider
                          : TradEtTheme.accent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: methods.isEmpty
                        ? null
                        : () async {
                            final amount = double.tryParse(amountCtrl.text);
                            if (amount == null || amount <= 0) return;
                            if (amount > available) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Insufficient balance. Available: ${available.toStringAsFixed(2)} ETB'),
                                backgroundColor: TradEtTheme.negative,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ));
                              return;
                            }
                            final method = methods
                                .firstWhere((m) => m.id == selectedMethodId);
                            Navigator.pop(ctx);
                            final result = await context
                                .read<AppProvider>()
                                .withdraw(
                                  amount: amount,
                                  bankName: method.bankName,
                                  accountNumber: method.accountNumber,
                                );
                            if (context.mounted) {
                              await context
                                  .read<AppProvider>()
                                  .loadPortfolio();
                              final isError = result.containsKey('error');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(isError
                                    ? (result['error'] ?? 'Withdrawal failed')
                                    : (result['message'] ??
                                        'Withdrawal complete')),
                                backgroundColor: isError
                                    ? TradEtTheme.negative
                                    : TradEtTheme.positive,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ));
                            }
                          },
                    child: Text(AppLocalizations.of(context).withdraw,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PortfolioSplitCard extends StatelessWidget {
  final dynamic summary;

  const _PortfolioSplitCard({required this.summary});

  Widget _bar(String label, double pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: TradEtTheme.textMuted,
              ),
            ),
            Text(
              '${(pct * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0),
            minHeight: 7,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = summary?.totalPortfolioValue ?? 0;
    final holdings = summary?.totalHoldingsValue ?? 0;
    final cash = summary?.cashBalance ?? 0;
    final holdingsPct = total > 0 ? holdings / total : 0.0;
    final cashPct = total > 0 ? cash / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.donut_small_outlined,
                size: 15,
                color: TradEtTheme.textSecondary,
              ),
              SizedBox(width: 6),
              Text(
                'Portfolio Split',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: TradEtTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bar('Holdings', holdingsPct, const Color(0xFF818CF8)),
          const SizedBox(height: 10),
          _bar('Cash', cashPct, TradEtTheme.accent),
        ],
      ),
    );
  }
}

class _ShariaScoreCard extends StatelessWidget {
  final List<PortfolioHolding> holdings;

  const _ShariaScoreCard({required this.holdings});

  @override
  Widget build(BuildContext context) {
    final total = holdings.length;
    final compliant = holdings.where((h) => h.isShariaCompliant).length;
    final score = total > 0 ? compliant / total : 1.0;
    final pct = (score * 100).toStringAsFixed(0);

    final Color barColor;
    final String statusLabel;
    if (score >= 0.9) {
      barColor = TradEtTheme.positive;
      statusLabel = 'Excellent';
    } else if (score >= 0.7) {
      barColor = const Color(0xFFF59E0B);
      statusLabel = 'Good';
    } else {
      barColor = TradEtTheme.negative;
      statusLabel = 'Review Needed';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: barColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_rounded, color: barColor, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Sharia Compliance Score',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: barColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: barColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: barColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: score,
                    minHeight: 8,
                    backgroundColor: TradEtTheme.divider.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation(barColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$pct%',
                style: TextStyle(
                  color: barColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            total == 0
                ? 'No holdings — AAOIFI screening will apply when you invest'
                : '$compliant of $total holdings meet AAOIFI standards (debt <30%, haram revenue <5%)',
            style: const TextStyle(
              color: TradEtTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
