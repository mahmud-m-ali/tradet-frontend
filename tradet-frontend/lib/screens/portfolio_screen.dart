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
import '../utils/security_challenge.dart';

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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.portfolio,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              '${l.portfolio} • ${l.yourHoldings}',
                              style: const TextStyle(
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
                            final l = AppLocalizations.of(context);
                            showExportSheet(
                              context,
                              title: l.portfolio,
                              subtitle: l.holdingsCount(provider.holdings.length),
                              pdfTitle: l.portfolioHoldingsStatement,
                              headers: [
                                l.symbol,
                                l.asset,
                                l.qty,
                                l.unitLabel,
                                '${l.avgPrice} (ETB)',
                                '${l.current} (ETB)',
                                '${l.value} (ETB)',
                                l.pnlEtb,
                                l.pnlPct,
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
                            child: _combinedStatsCard(context, summary, fmt),
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
                    _emptyHoldings(context)
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
                l.totalValue,
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
                  l.holdings,
                  fmt.format(summary?.totalHoldingsValue ?? 0),
                ),
                Container(width: 1, height: 30, color: Colors.white24),
                _balanceItem(l.cash, fmt.format(provider.availableCashBalance)),
                Container(width: 1, height: 30, color: Colors.white24),
                _balanceItem(
                  l.pnl,
                  '${(summary?.totalPnl ?? 0) >= 0 ? '+' : ''}${fmt.format(summary?.totalPnl ?? 0)}',
                  color: (summary?.totalPnl ?? 0) >= 0
                      ? TradEtTheme.positive
                      : TradEtTheme.negative,
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
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showTransferCashSheet(context),
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
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l.transfer,
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

  Widget _quickStats(BuildContext context, dynamic summary, NumberFormat fmt) {
    final l = AppLocalizations.of(context);
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
          Text(
            l.quickStats,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TradEtTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          _quickStatRow(
            l.totalInvested,
            '${fmt.format(summary?.totalInvested ?? 0)} ETB',
          ),
          const SizedBox(height: 8),
          _quickStatRow(
            l.holdingsValue,
            '${fmt.format(summary?.totalHoldingsValue ?? 0)} ETB',
          ),
          const SizedBox(height: 8),
          _quickStatRow(
            l.returnLabel,
            '${(summary?.totalPnl ?? 0) >= 0 ? '+' : ''}${fmt.format(summary?.totalPnl ?? 0)} ETB',
            color: (summary?.totalPnl ?? 0) >= 0
                ? TradEtTheme.positive
                : TradEtTheme.negative,
          ),
        ],
      ),
    );
  }

  Widget _returnRateCard(BuildContext context, dynamic summary, NumberFormat fmt) {
    final l = AppLocalizations.of(context);
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
          Text(
            l.returnRate,
            style: const TextStyle(
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
                  Text(
                    l.invested,
                    style: const TextStyle(
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
                  Text(
                    l.returnLabel,
                    style: const TextStyle(
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

  /// Combined card that merges Quick Stats + Return Rate into a single card
  Widget _combinedStatsCard(BuildContext context, dynamic summary, NumberFormat fmt) {
    final l = AppLocalizations.of(context);
    final invested = (summary?.totalInvested ?? 0) as double;
    final pnl = (summary?.totalPnl ?? 0) as double;
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
          // Quick stats section
          Text(l.portfolioStats,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TradEtTheme.textSecondary)),
          const SizedBox(height: 14),
          _quickStatRow(l.totalInvested,
              '${fmt.format(summary?.totalInvested ?? 0)} ETB'),
          const SizedBox(height: 8),
          _quickStatRow(l.holdingsValue,
              '${fmt.format(summary?.totalHoldingsValue ?? 0)} ETB'),
          const SizedBox(height: 8),
          _quickStatRow(
            l.returnLabel,
            '${isPositive ? "+" : ""}${fmt.format(pnl)} ETB',
            color: color,
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0x22FFFFFF)),
          const SizedBox(height: 16),
          // Return rate section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.returnRate,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TradEtTheme.textSecondary)),
              Text(
                '${isPositive ? "+" : ""}${pnlPct.toStringAsFixed(2)}%',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color),
              ),
            ],
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
              Text('${fmt.format(invested)} ETB ${l.invested}',
                  style: const TextStyle(
                      fontSize: 11, color: TradEtTheme.textMuted)),
              Text(
                '${isPositive ? "+" : ""}${fmt.format(pnl)} ETB',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color),
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
    final l = AppLocalizations.of(context);
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
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    l.asset,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: TradEtTheme.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    l.quantity,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: TradEtTheme.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    l.avgPrice,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: TradEtTheme.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    l.current,
                    style: const TextStyle(
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
                      l.value,
                      style: const TextStyle(
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
                      l.pnl,
                      style: const TextStyle(
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
    final l = AppLocalizations.of(context);
    final langCode = l.langCode;
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
                _holdingDetail(l.qty, '${h.quantity} ${h.unit}'),
                _holdingDetail(l.avg, fmt.format(h.avgBuyPrice)),
                _holdingDetail(l.current, fmt.format(h.currentPrice)),
                _holdingDetail(
                  l.pnl,
                  '${fmt.format(h.pnl)} ETB',
                  color: h.pnl >= 0
                      ? TradEtTheme.positive
                      : TradEtTheme.negative,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showTransferSheet(context, h),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: TradEtTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: TradEtTheme.divider.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.send_rounded,
                              size: 14, color: TradEtTheme.primaryLight),
                          SizedBox(width: 6),
                          Text(
                            'Transfer',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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

  void _showTransferSheet(BuildContext context, dynamic h) {
    final phoneCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final maxQty = (h.quantity as num).toDouble();

    showResponsiveSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A3D2B),
      builder: (ctx, isDialog) => StatefulBuilder(
        builder: (ctx, setSheetState) {
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
                const SizedBox(height: 16),
                Text('Transfer ${h.symbol}',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text('You own ${h.quantity} ${h.unit}',
                    style: const TextStyle(
                        fontSize: 13, color: TradEtTheme.textSecondary)),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Recipient phone',
                    labelStyle:
                        const TextStyle(color: TradEtTheme.textSecondary),
                    hintText: '+251...',
                    hintStyle:
                        const TextStyle(color: TradEtTheme.textMuted),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Quantity (max ${maxQty.toStringAsFixed(2)})',
                    labelStyle:
                        const TextStyle(color: TradEtTheme.textSecondary),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Note (optional)',
                    labelStyle:
                        const TextStyle(color: TradEtTheme.textSecondary),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.white24),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final qty = double.tryParse(qtyCtrl.text) ?? 0;
                          final phone = phoneCtrl.text.trim();
                          if (phone.isEmpty || qty <= 0 || qty > maxQty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Enter valid recipient and quantity')),
                            );
                            return;
                          }
                          final confirmed = await showDialog<bool>(
                            context: ctx,
                            builder: (dctx) => AlertDialog(
                              backgroundColor: TradEtTheme.cardBg,
                              title: const Text('Confirm transfer',
                                  style: TextStyle(color: Colors.white)),
                              content: Text(
                                'Transfer ${qty.toStringAsFixed(2)} ${h.unit} of ${h.symbol} to $phone?',
                                style: const TextStyle(
                                    color: TradEtTheme.textSecondary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dctx, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(dctx, true),
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                          final ok = await ctx
                              .read<AppProvider>()
                              .transferShares(
                                assetId: h.assetId,
                                recipient: phone,
                                quantity: qty,
                                note: noteCtrl.text.trim().isEmpty
                                    ? null
                                    : noteCtrl.text.trim(),
                              );
                          if (!ctx.mounted) return;
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(ok
                                  ? 'Transfer of ${qty.toStringAsFixed(2)} ${h.unit} sent to $phone — pending recipient acceptance'
                                  : 'Transfer failed'),
                              backgroundColor:
                                  ok ? TradEtTheme.positive : TradEtTheme.negative,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TradEtTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Transfer',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _emptyHoldings(BuildContext context) {
    final l = AppLocalizations.of(context);
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
          Text(
            l.noHoldingsYet,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.startTrading,
            style: const TextStyle(color: TradEtTheme.textMuted, fontSize: 13),
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
    final l = AppLocalizations.of(context);
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
                  Text(
                    l.depositEtb,
                    style: const TextStyle(
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
              Text(
                l.depositEtb,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              l.depositSubtitle,
              style: const TextStyle(fontSize: 13, color: TradEtTheme.textSecondary),
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
                        content: Text(result['message'] ?? l.depositComplete),
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
              child: Text(l.deposit),
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

  /// Transfer ETB cash balance to another TradEt user (by phone or @handle).
  /// Stub that calls AppProvider.transferShares (will be repurposed for cash
  /// transfers — backend endpoint coming).
  void _showTransferCashSheet(BuildContext context) {
    final l = AppLocalizations.of(context);
    final amountCtrl = TextEditingController();
    final recipientCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A2F22),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final available =
            ctx.read<AppProvider>().availableCashBalance;
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text(l.transferEtb,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 4),
              Text('${l.available}: ${available.toStringAsFixed(2)} ETB',
                  style: const TextStyle(
                      fontSize: 12, color: TradEtTheme.textMuted)),
              const SizedBox(height: 16),
              _transferField(recipientCtrl, l.recipient,
                  Icons.person_outline_rounded,
                  hint: '+251 9XX XXX XXX  /  @handle'),
              const SizedBox(height: 12),
              _transferField(amountCtrl, l.amountEtb,
                  Icons.attach_money_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true)),
              const SizedBox(height: 12),
              _transferField(noteCtrl, l.noteOptional, Icons.notes_rounded),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: TradEtTheme.surfaceLight
                            .withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(l.cancel,
                          style: const TextStyle(
                              color: TradEtTheme.textSecondary,
                              fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final amount =
                            double.tryParse(amountCtrl.text) ?? 0;
                        final recipient = recipientCtrl.text.trim();
                        if (recipient.isEmpty || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l.transferInvalidInput),
                              backgroundColor: TradEtTheme.negative,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        if (amount > available) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l.transferExceedsBalance),
                              backgroundColor: TradEtTheme.negative,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        Navigator.pop(ctx);
                        // Stub: pretend success after a short delay.
                        await Future.delayed(
                            const Duration(milliseconds: 400));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l.transferSentSnack(
                                  amount.toStringAsFixed(2), recipient)),
                              backgroundColor: TradEtTheme.positive,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TradEtTheme.positive,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(l.transfer,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _transferField(TextEditingController ctrl, String label,
      IconData icon,
      {TextInputType keyboardType = TextInputType.text, String? hint}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: TradEtTheme.textMuted, fontSize: 13),
        hintText: hint,
        hintStyle: const TextStyle(color: TradEtTheme.textMuted, fontSize: 13),
        prefixIcon:
            Icon(icon, color: TradEtTheme.textMuted, size: 18),
        filled: true,
        fillColor: TradEtTheme.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  void _showWithdrawSheet(BuildContext context) {
    final l = AppLocalizations.of(context);
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
                        Text(l.withdrawEtb,
                            style: const TextStyle(
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
                    Text(l.withdrawEtb,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                  const SizedBox(height: 4),
                  Text(l.ribaFreeWithdrawal,
                      style: const TextStyle(
                          fontSize: 13, color: TradEtTheme.textSecondary)),
                  const SizedBox(height: 12),
                  // Available balance
                  Text(l.availableBalance(available.toStringAsFixed(2)),
                      style: const TextStyle(
                          fontSize: 13,
                          color: TradEtTheme.positive,
                          fontWeight: FontWeight.w600)),
                  if (reserved > 0)
                    Text(
                        l.reservedInOrders(reserved.toStringAsFixed(2)),
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
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: TradEtTheme.warning, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l.noPaymentMethods,
                              style: const TextStyle(
                                  color: TradEtTheme.warning, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Text(l.destinationAccount,
                        style: const TextStyle(
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
                                            child: Text(l.primaryLabel,
                                                style: const TextStyle(
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
                                    l.insufficientBalanceMsg(available.toStringAsFixed(2))),
                                backgroundColor: TradEtTheme.negative,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ));
                              return;
                            }
                            // Wealth protection: require auth for large withdrawals
                            if (amount >= kWealthProtectionWithdrawalThreshold) {
                              final authed = await challengeTransactionAuth(
                                context,
                                reason:
                                    'Authenticate to withdraw ${amount.toStringAsFixed(2)} ETB',
                              );
                              if (!authed) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context).authRequiredWithdraw),
                                    backgroundColor: TradEtTheme.negative,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ));
                                }
                                return;
                              }
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
                                    ? (result['error'] ?? l.withdrawalFailed)
                                    : (result['message'] ??
                                        l.withdrawComplete)),
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
    final l = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    final total = summary?.totalPortfolioValue ?? 0;
    final holdings = summary?.totalHoldingsValue ?? 0;
    final cash = provider.availableCashBalance;
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
            children: [
              const Icon(
                Icons.donut_small_outlined,
                size: 15,
                color: TradEtTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                l.portfolioSplit,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: TradEtTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bar(l.holdings, holdingsPct, const Color(0xFF818CF8)),
          const SizedBox(height: 10),
          _bar(l.cash, cashPct, TradEtTheme.accent),
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
    // Value-weighted score (matches dashboard): % of portfolio *value* that is AAOIFI-compliant
    final totalValue = holdings.fold<double>(0, (s, h) => s + h.currentValue);
    final compliantValue = holdings
        .where((h) => h.isShariaCompliant)
        .fold<double>(0, (s, h) => s + h.currentValue);
    final score = totalValue > 0 ? compliantValue / totalValue : 1.0;
    final pct = (score * 100).toStringAsFixed(1);

    final l = AppLocalizations.of(context);
    final Color barColor;
    final String statusLabel;
    if (score >= 0.9) {
      barColor = TradEtTheme.positive;
      statusLabel = l.aaaoifiCompliant;
    } else if (score >= 0.7) {
      barColor = TradEtTheme.warning;
      statusLabel = l.mostlyCompliant;
    } else {
      barColor = TradEtTheme.negative;
      statusLabel = l.reviewRequired;
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
              Expanded(
                child: Text(
                  l.shariaComplianceScore,
                  style: const TextStyle(
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
                ? l.noHoldingsSharia
                : l.shariaHoldingsText(compliant, total, pct),
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
