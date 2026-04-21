import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/disclaimer_footer.dart';
import '../widgets/language_selector.dart';
import '../widgets/dashboard_widgets.dart';
import 'analytics_screen.dart';
import 'transactions_screen.dart';

class DashboardScreen extends StatelessWidget {
  final void Function(int index)? onNavigateTo;
  const DashboardScreen({super.key, this.onNavigateTo});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en');
    final wide = isWideScreen(context);
    final l = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, _) {
            return RefreshIndicator(
              color: TradEtTheme.positive,
              backgroundColor: TradEtTheme.cardBg,
              onRefresh: () => provider.loadAllData(),
              child: wide
                  ? _buildWebLayout(context, provider, fmt, l, onNavigateTo)
                  : _buildMobileLayout(context, provider, fmt, l, onNavigateTo),
            );
          },
        ),
      ),
    );
  }

  // ─── MOBILE LAYOUT ───
  Widget _buildMobileLayout(
    BuildContext context,
    AppProvider provider,
    NumberFormat fmt,
    AppLocalizations l,
    void Function(int)? onNavigateTo,
  ) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _greeting(provider, l)),
                const LanguageSelector(),
                const SizedBox(width: 8),
                HeaderIconButton(
                  icon: Icons.bar_chart_rounded,
                  color: TradEtTheme.primaryLight,
                  onTap: onNavigateTo != null
                      ? () => onNavigateTo(9)
                      : () => Navigator.of(context).push(
                            appRoute(
                              context,
                              WrappedScreen(
                                child: const AnalyticsScreen(),
                                showMobileAppBar: false,
                              ),
                            ),
                          ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Hero: portfolio value + trust badges + CTAs
            HeroTradeCard(
                provider: provider, fmt: fmt, onNavigateTo: onNavigateTo),
            const SizedBox(height: 20),
            // Top Opportunities
            TopOpportunitiesSection(provider: provider, fmt: fmt),
            const SizedBox(height: 24),
            // Market Momentum
            MoversSection(provider: provider, fmt: fmt),
            const SizedBox(height: 24),
            // Holdings + Orders (tabbed)
            HoldingsOrdersTabCard(
                provider: provider, fmt: fmt, onNavigateTo: onNavigateTo),
            const SizedBox(height: 24),
            // Portfolio overview + compliance stats
            _ShariaComplianceScoreCard(provider: provider, fmt: fmt),
            const SizedBox(height: 12),
            _mobileStatsGrid(context, provider, fmt, l, onNavigateTo),
            const SizedBox(height: 20),
            const DisclaimerFooter(),
            const SizedBox(height: 8),
          ],
        ),
        // Sticky Trade FAB
        Positioned(
          bottom: 24,
          right: 20,
          child: _TradeFab(onNavigateTo: onNavigateTo),
        ),
      ],
    );
  }

  // ─── WEB LAYOUT ───
  Widget _buildWebLayout(
    BuildContext context,
    AppProvider provider,
    NumberFormat fmt,
    AppLocalizations l,
    void Function(int)? onNavigateTo,
  ) {
    final desktop = isDesktop(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      children: [
        // Header row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _greeting(provider, l)),
            // Language selector
            const LanguageSelector(),
            const SizedBox(width: 8),
            // Analytics icon
            HeaderIconButton(
              icon: Icons.bar_chart_rounded,
              color: TradEtTheme.primaryLight,
              onTap: () => Navigator.of(context).push(
                appRoute(
                  context,
                  WrappedScreen(
                    child: const AnalyticsScreen(),
                    showMobileAppBar: false,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Refresh icon
            provider.isLoading
                ? const SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: TradEtTheme.textSecondary,
                        ),
                      ),
                    ),
                  )
                : HeaderIconButton(
                    icon: Icons.refresh_rounded,
                    color: TradEtTheme.textSecondary,
                    onTap: () => provider.loadAllData(),
                  ),
          ],
        ),
        const SizedBox(height: 16),
        // Yahoo Finance-style market strip
        MarketStrip(provider: provider, fmt: fmt),
        const SizedBox(height: 16),

        // Hero: portfolio value + trust badges + CTAs (left)
        //        Cash balance (right) — same height via IntrinsicHeight
        if (desktop)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: HeroTradeCard(
                    provider: provider,
                    fmt: fmt,
                    onNavigateTo: onNavigateTo,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CashBalanceCard(
                    value: '${fmt.format(provider.availableCashBalance)} ETB',
                    subLabel: provider.reservedForOrders > 0
                        ? '${fmt.format(provider.reservedForOrders)} reserved'
                        : null,
                  ),
                ),
              ],
            ),
          )
        else
          HeroTradeCard(
              provider: provider, fmt: fmt, onNavigateTo: onNavigateTo),
        const SizedBox(height: 28),

        // Top Opportunities
        TopOpportunitiesSection(provider: provider, fmt: fmt),
        const SizedBox(height: 28),

        // Top Movers / Losers segmented
        MoversSection(
          provider: provider,
          fmt: fmt,
          webMode: true,
          desktop: desktop,
        ),
        const SizedBox(height: 28),

        // Holdings + Orders — tabbed card
        HoldingsOrdersTabCard(
            provider: provider, fmt: fmt, onNavigateTo: onNavigateTo),
        const SizedBox(height: 28),

        // Portfolio overview + compliance section
        if (desktop) ...[
          IntrinsicHeight(child: _webRow2WithSharia(context, provider, l, onNavigateTo, fmt)),
        ] else ...[
          _ShariaComplianceScoreCard(provider: provider, fmt: fmt),
          const SizedBox(height: 14),
          IntrinsicHeight(child: _webRow2(context, provider, l, onNavigateTo)),
        ],
        const SizedBox(height: 28),
        const DisclaimerFooter(),
        const SizedBox(height: 8),
      ],
    );
  }

  // ─── Shared widgets ───

  Widget _greeting(AppProvider provider, AppLocalizations l) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l.assalamuAlaikum}${provider.user != null ? "," : ""}',
                style: const TextStyle(
                  fontSize: 14,
                  color: TradEtTheme.textSecondary,
                ),
              ),
              if (provider.user != null)
                Text(
                  provider.user!.fullName.split(' ').first,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mobileStatsGrid(
    BuildContext context,
    AppProvider provider,
    NumberFormat fmt,
    AppLocalizations l,
    void Function(int)? onNavigateTo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.receipt_long_outlined,
                label: l.openOrders,
                value: '${provider.orders.where((o) => o.isPending).length}',
                color: TradEtTheme.primaryLight,
                onTap: onNavigateTo != null ? () => onNavigateTo(3) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.pie_chart_outline,
                label: l.holdings,
                value: '${provider.holdings.length} assets',
                color: const Color(0xFF818CF8),
                onTap: onNavigateTo != null ? () => onNavigateTo(2) : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.star_outline_rounded,
                label: l.watchlist,
                value: '${provider.watchlist.length} assets',
                color: const Color(0xFFFBBF24),
                onTap: onNavigateTo != null ? () => onNavigateTo(4) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.swap_horiz_rounded,
                label: l.transactions,
                value: l.viewHistory,
                color: const Color(0xFF22D3EE),
                onTap: () => Navigator.of(context).push(
                  appRoute(
                    context,
                    WrappedScreen(
                      child: const TransactionsScreen(),
                      showMobileAppBar: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Desktop combined row: Portfolio Split | Sharia Score | 4 stat cards — all in one line above Quick Access
  Widget _webRow2WithSharia(
    BuildContext context,
    AppProvider provider,
    AppLocalizations l,
    void Function(int)? onNavigateTo,
    NumberFormat fmt,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Portfolio Split — flex:2
        Expanded(
          flex: 2,
          child: AllocationCard(
            provider: provider,
            fmt: NumberFormat('#,##0.00', 'en'),
          ),
        ),
        const SizedBox(width: 14),
        // Sharia Score — flex:2 (compact to match StatCard height)
        Expanded(
          flex: 2,
          child: _ShariaComplianceScoreCard(
              provider: provider, fmt: fmt, compact: true),
        ),
        const SizedBox(width: 14),
        // Transactions — flex:1
        Expanded(
          flex: 1,
          child: StatCard(
            icon: Icons.swap_horiz_rounded,
            label: l.transactions,
            value: l.viewHistory,
            color: const Color(0xFF22D3EE),
            onTap: () => Navigator.of(context).push(
              appRoute(
                context,
                WrappedScreen(
                  child: const TransactionsScreen(),
                  showMobileAppBar: false,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Open Orders — flex:1
        Expanded(
          flex: 1,
          child: StatCard(
            icon: Icons.receipt_long_outlined,
            label: l.openOrders,
            value: '${provider.orders.where((o) => o.isPending).length}',
            color: TradEtTheme.primaryLight,
            onTap: onNavigateTo != null ? () => onNavigateTo(3) : null,
          ),
        ),
        const SizedBox(width: 14),
        // Holdings — flex:1
        Expanded(
          flex: 1,
          child: StatCard(
            icon: Icons.pie_chart_outline,
            label: l.holdings,
            value: '${provider.holdings.length} assets',
            color: const Color(0xFF818CF8),
            onTap: onNavigateTo != null ? () => onNavigateTo(2) : null,
          ),
        ),
        const SizedBox(width: 14),
        // Watchlist — flex:1
        Expanded(
          flex: 1,
          child: StatCard(
            icon: Icons.star_outline_rounded,
            label: l.watchlist,
            value: '${provider.watchlist.length} assets',
            color: const Color(0xFFFBBF24),
            onTap: onNavigateTo != null ? () => onNavigateTo(4) : null,
          ),
        ),
      ],
    );
  }

  /// Row 2: Portfolio Split (flex:2) | Transactions (flex:1) | Open Orders (flex:1) | Holdings (flex:1) | Watchlist (flex:1)
  /// Right 3 cards together = 3/6 = 50% of the row width.
  Widget _webRow2(
    BuildContext context,
    AppProvider provider,
    AppLocalizations l,
    void Function(int)? onNavigateTo,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Portfolio Split — flex:2 (~33%)
        Expanded(
          flex: 2,
          child: AllocationCard(
            provider: provider,
            fmt: NumberFormat('#,##0.00', 'en'),
          ),
        ),
        const SizedBox(width: 14),
        // Transactions — flex:1 (~17%)
        Expanded(
          flex: 1,
          child: StatCard(
            icon: Icons.swap_horiz_rounded,
            label: l.transactions,
            value: l.viewHistory,
            color: const Color(0xFF22D3EE),
            onTap: () => Navigator.of(context).push(
              appRoute(
                context,
                WrappedScreen(
                  child: const TransactionsScreen(),
                  showMobileAppBar: false,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Open Orders — flex:1 (~17%)
        Expanded(
          flex: 1,
          child: StatCard(
            icon: Icons.receipt_long_outlined,
            label: l.openOrders,
            value: '${provider.orders.where((o) => o.isPending).length}',
            color: TradEtTheme.primaryLight,
            onTap: onNavigateTo != null ? () => onNavigateTo(3) : null,
          ),
        ),
        const SizedBox(width: 14),
        // Holdings — flex:1 (~17%)
        Expanded(
          flex: 1,
          child: StatCard(
            icon: Icons.pie_chart_outline,
            label: l.holdings,
            value: '${provider.holdings.length} assets',
            color: const Color(0xFF818CF8),
            onTap: onNavigateTo != null ? () => onNavigateTo(2) : null,
          ),
        ),
        const SizedBox(width: 14),
        // Watchlist — flex:1 (~17%) — right 3 total = 50%
        Expanded(
          flex: 1,
          child: StatCard(
            icon: Icons.star_outline_rounded,
            label: l.watchlist,
            value: '${provider.watchlist.length} assets',
            color: const Color(0xFFFBBF24),
            onTap: onNavigateTo != null ? () => onNavigateTo(4) : null,
          ),
        ),
      ],
    );
  }

  Widget _webHoldingsSection(BuildContext context, AppProvider provider, NumberFormat fmt, AppLocalizations l) {
    return WebSectionCard(
      title: l.yourHoldings,
      isEmpty: provider.holdings.isEmpty,
      emptyIcon: Icons.pie_chart_outline_rounded,
      emptyText: l.noHoldingsYet,
      child: Column(
        children: provider.holdings
            .take(5)
            .map(
              (h) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: HoldingTile(holding: h, fmt: fmt),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _webOrdersSection(BuildContext context, AppProvider provider, NumberFormat fmt, AppLocalizations l) {
    return WebSectionCard(
      title: l.recentOrders,
      isEmpty: provider.orders.isEmpty,
      emptyIcon: Icons.receipt_long_outlined,
      emptyText: l.noOrdersYet,
      child: Column(
        children: provider.orders
            .take(5)
            .map(
              (o) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OrderTile(order: o, fmt: fmt),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Sharia Compliance Score card — shows what % of portfolio value is AAOIFI compliant.
class _ShariaComplianceScoreCard extends StatelessWidget {
  final AppProvider provider;
  final NumberFormat fmt;
  final bool compact;

  const _ShariaComplianceScoreCard({
    required this.provider,
    required this.fmt,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final holdings = provider.holdings;
    if (holdings.isEmpty) return const SizedBox.shrink();

    final totalValue =
        holdings.fold<double>(0, (s, h) => s + h.currentValue);
    final compliantValue = holdings
        .where((h) => h.isShariaCompliant)
        .fold<double>(0, (s, h) => s + h.currentValue);
    final score = totalValue > 0 ? (compliantValue / totalValue) : 1.0;
    final pct = (score * 100).toStringAsFixed(1);

    final color = score >= 0.9
        ? TradEtTheme.positive
        : score >= 0.7
            ? TradEtTheme.warning
            : TradEtTheme.negative;

    final label = score >= 0.9
        ? 'AAOIFI Compliant'
        : score >= 0.7
            ? 'Mostly Compliant'
            : 'Review Required';

    if (compact) {
      // Compact: matches StatCard layout — icon+label on top, value, sublabel
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.stars_rounded, size: 20, color: color),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(label,
                      style: TextStyle(
                          color: color,
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('$pct%',
                style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: score,
                backgroundColor: TradEtTheme.divider,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 4),
            const Text('Sharia Score',
                style: TextStyle(fontSize: 11, color: TradEtTheme.textMuted),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      );
    }

    // Full size (mobile)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded, size: 18, color: color),
              const SizedBox(width: 8),
              const Text('Sharia Compliance Score',
                  style: TextStyle(
                      color: TradEtTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(label,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$pct%',
                  style: TextStyle(
                      color: color,
                      fontSize: 32,
                      fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('of portfolio value',
                    style: const TextStyle(
                        color: TradEtTheme.textMuted, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score,
              backgroundColor: TradEtTheme.divider,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${fmt.format(compliantValue)} ETB compliant',
                  style: const TextStyle(
                      color: TradEtTheme.textMuted, fontSize: 11)),
              const Spacer(),
              Text('AAOIFI Standard No. 21',
                  style: const TextStyle(
                      color: TradEtTheme.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Sticky Trade FAB ─────────────────────────────────────────────────────────

class _TradeFab extends StatelessWidget {
  final void Function(int)? onNavigateTo;
  const _TradeFab({this.onNavigateTo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onNavigateTo?.call(1),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          gradient: TradEtTheme.heroGradient,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: TradEtTheme.positive.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text('Trade',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: 0.3)),
          ],
        ),
      ),
    );
  }
}
