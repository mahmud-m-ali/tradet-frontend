import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/disclaimer_footer.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedPeriod = 1; // 0=1W 1=1M 2=3M 3=1Y
  final List<String> _periods = ['1W', '1M', '3M', '1Y'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AppProvider>();
      if (p.portfolioSummary == null) p.loadPortfolio();
      if (p.transactions.isEmpty) p.loadTransactions();
      p.loadAnalytics(_selectedPeriod);
    });
  }

  void _onPeriodChanged(int index) {
    setState(() => _selectedPeriod = index);
    context.read<AppProvider>().loadAnalytics(index);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fmt = NumberFormat('#,##0.00', 'en');
    final wide = isWideScreen(context);
    final hPad = wide ? 32.0 : 20.0;

    return Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, _) {
            final summary = provider.portfolioSummary;
            final totalValue = summary?.totalPortfolioValue ?? 0;
            final totalPnl = summary?.totalPnl ?? 0;
            final totalInvested = summary?.totalInvested ?? 0;
            final perfPct = totalInvested > 0 ? (totalPnl / totalInvested * 100) : 0.0;

            // Realised P&L: sum of trade_sell transactions amounts (credit)
            final realisedPnl = provider.transactions
                .where((t) => t.transactionType == 'trade_sell')
                .fold<double>(0, (acc, t) => acc + t.amount);

            // Unrealised = current holdings pnl
            final unrealisedPnl = provider.holdings
                .fold<double>(0, (acc, h) => acc + h.pnl);

            final rawSpots = provider.analyticsSpots;
            final spots = rawSpots.isNotEmpty
                ? rawSpots.map((p) => FlSpot(p['x']!, p['y']!)).toList()
                : <FlSpot>[];

            final minY = spots.isEmpty ? 0.0
                : spots.map((s) => s.y).reduce(math.min) * 0.98;
            final maxY = spots.isEmpty ? 1.0
                : spots.map((s) => s.y).reduce(math.max) * 1.02;

            return RefreshIndicator(
              color: TradEtTheme.positive,
              backgroundColor: TradEtTheme.cardBg,
              onRefresh: () async {
                await provider.loadPortfolio();
                await provider.loadTransactions();
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(hPad, wide ? 24 : 16, hPad, 32),
                children: [
                  // ── Header ──
                  Row(
                    children: [
                      if (!wide && Navigator.of(context).canPop())
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: l.back,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      Text(
                        l.analytics,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Total Portfolio Value Card ──
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.totalPortfolioValue,
                            style: const TextStyle(
                                fontSize: 13, color: TradEtTheme.textSecondary)),
                        const SizedBox(height: 6),
                        Text(
                          '${fmt.format(totalValue)} ETB',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              totalPnl >= 0
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded,
                              size: 16,
                              color: totalPnl >= 0
                                  ? TradEtTheme.positive
                                  : TradEtTheme.negative,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${totalPnl >= 0 ? "+" : ""}${fmt.format(totalPnl)} ETB'
                              '  (${perfPct >= 0 ? "+" : ""}${perfPct.toStringAsFixed(2)}%)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: totalPnl >= 0
                                    ? TradEtTheme.positive
                                    : TradEtTheme.negative,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Period selector
                        Row(
                          children: List.generate(_periods.length, (i) {
                            final selected = i == _selectedPeriod;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => _onPeriodChanged(i),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? TradEtTheme.positive
                                          : TradEtTheme.surfaceLight,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _periods[i],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: selected
                                            ? Colors.white
                                            : TradEtTheme.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),

                        // Line chart
                        if (provider.analyticsLoading)
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: TradEtTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 24, height: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: TradEtTheme.primaryLight),
                              ),
                            ),
                          )
                        else if (spots.isEmpty)
                          SizedBox(
                            height: 140,
                            child: Center(
                              child: Text(l.noPortfolioData,
                                  style: const TextStyle(
                                      color: TradEtTheme.textMuted,
                                      fontSize: 13)),
                            ),
                          )
                        else
                          SizedBox(
                            height: 140,
                            child: LineChart(
                              LineChartData(
                                minY: minY,
                                maxY: maxY,
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: const FlTitlesData(show: false),
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipItems: (spots) => spots
                                        .map((s) => LineTooltipItem(
                                              '${NumberFormat('#,##0', 'en').format(s.y)} ETB',
                                              const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spots,
                                    isCurved: true,
                                    curveSmoothness: 0.3,
                                    color: TradEtTheme.positive,
                                    barWidth: 2.5,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: [
                                          TradEtTheme.positive
                                              .withValues(alpha: 0.25),
                                          TradEtTheme.positive
                                              .withValues(alpha: 0.0),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Performance & P&L row ──
                  if (wide)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _performanceCard(l, fmt, perfPct, totalPnl, totalInvested)),
                          const SizedBox(width: 14),
                          Expanded(child: _pnlCard(l, fmt, unrealisedPnl, realisedPnl)),
                        ],
                      ),
                    )
                  else ...[
                    _performanceCard(l, fmt, perfPct, totalPnl, totalInvested),
                    const SizedBox(height: 14),
                    _pnlCard(l, fmt, unrealisedPnl, realisedPnl),
                  ],
                  const SizedBox(height: 14),

                  // ── Allocation ──
                  _allocationCard(l, provider, fmt),
                  const SizedBox(height: 24),
                  const DisclaimerFooter(),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _performanceCard(AppLocalizations l, NumberFormat fmt, double perfPct, double totalPnl, double totalInvested) {
    final isPositive = perfPct >= 0;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (isPositive ? TradEtTheme.positive : TradEtTheme.negative)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  size: 18,
                  color: isPositive ? TradEtTheme.positive : TradEtTheme.negative,
                ),
              ),
              const SizedBox(width: 10),
              Text(l.performance,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${isPositive ? "+" : ""}${perfPct.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: isPositive ? TradEtTheme.positive : TradEtTheme.negative,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.totalReturn,
            style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted),
          ),
          const SizedBox(height: 12),
          _MetricRow(
            label: l.totalInvested,
            value: '${fmt.format(totalInvested)} ETB',
          ),
          _MetricRow(
            label: l.returnLabel,
            value: '${totalPnl >= 0 ? "+" : ""}${fmt.format(totalPnl)} ETB',
            valueColor: isPositive ? TradEtTheme.positive : TradEtTheme.negative,
          ),
        ],
      ),
    );
  }

  Widget _pnlCard(AppLocalizations l, NumberFormat fmt, double unrealised, double realised) {
    final totalPnl = unrealised + realised;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF22D3EE).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_wallet_outlined,
                    size: 18, color: Color(0xFF22D3EE)),
              ),
              const SizedBox(width: 10),
              Text(l.pnl,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${totalPnl >= 0 ? "+" : ""}${fmt.format(totalPnl)} ETB',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: totalPnl >= 0 ? TradEtTheme.positive : TradEtTheme.negative,
            ),
          ),
          const SizedBox(height: 12),
          // Divider row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: TradEtTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PnlBlock(
                    label: l.unrealised,
                    value: fmt.format(unrealised),
                    isPositive: unrealised >= 0,
                  ),
                ),
                Container(
                    width: 1,
                    height: 36,
                    color: TradEtTheme.divider.withValues(alpha: 0.4)),
                Expanded(
                  child: _PnlBlock(
                    label: l.realised,
                    value: fmt.format(realised),
                    isPositive: realised >= 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allocationCard(AppLocalizations l, AppProvider provider, NumberFormat fmt) {
    if (provider.holdings.isEmpty) {
      return _SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.allocation,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Icon(Icons.pie_chart_outline_rounded,
                      size: 48,
                      color: TradEtTheme.textMuted.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  Text(l.noHoldingsYet,
                      style: const TextStyle(
                          fontSize: 14, color: TradEtTheme.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    final total = provider.holdings
        .fold<double>(0, (acc, h) => acc + h.currentValue);

    // Sort by value descending
    final sorted = List.of(provider.holdings)
      ..sort((a, b) => b.currentValue.compareTo(a.currentValue));

    final colors = [
      TradEtTheme.positive,
      const Color(0xFF818CF8),
      const Color(0xFFFBBF24),
      const Color(0xFF22D3EE),
      const Color(0xFFF472B6),
      const Color(0xFFFF8C00),
    ];

    final largest = sorted.first;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.allocation,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            '${sorted.length} ${l.assetsTracked}',
            style: const TextStyle(
                fontSize: 12, color: TradEtTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          // Largest holding highlight
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: TradEtTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TradEtTheme.positive.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    largest.symbol.substring(0,
                        largest.symbol.length.clamp(0, 2)),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: TradEtTheme.positive,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(l.largestHolding,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: TradEtTheme.textSecondary)),
                          const Spacer(),
                          Text(
                            '${((largest.currentValue / total) * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: TradEtTheme.positive),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        largest.symbol,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${fmt.format(largest.currentValue)} ETB',
                        style: const TextStyle(
                            fontSize: 12,
                            color: TradEtTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bar chart per asset
          ...sorted.asMap().entries.map((entry) {
            final i = entry.key;
            final h = entry.value;
            final pct = total > 0 ? h.currentValue / total : 0.0;
            final color = colors[i % colors.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          h.symbol,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        '${fmt.format(h.currentValue)} ETB',
                        style: const TextStyle(
                            fontSize: 12,
                            color: TradEtTheme.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${(pct * 100).toStringAsFixed(1)}%',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      backgroundColor:
                          TradEtTheme.surfaceLight.withValues(alpha: 0.8),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Supporting widgets ──

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: TradEtTheme.divider.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _MetricRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: TradEtTheme.textSecondary)),
          Text(value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.white,
              )),
        ],
      ),
    );
  }
}

class _PnlBlock extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;
  const _PnlBlock(
      {required this.label, required this.value, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: TradEtTheme.textSecondary)),
        const SizedBox(height: 4),
        Text(
          '${isPositive ? "+" : "-"}$value ETB',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isPositive ? TradEtTheme.positive : TradEtTheme.negative,
          ),
        ),
      ],
    );
  }
}
