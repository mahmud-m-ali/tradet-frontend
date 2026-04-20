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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
        const SizedBox(height: 16),
        // Hero: portfolio value + cash + CTAs
        HeroTradeCard(
            provider: provider, fmt: fmt, onNavigateTo: onNavigateTo),
        const SizedBox(height: 10),
        // Trust / compliance strip
        const TrustStrip(),
        const SizedBox(height: 14),
        // Exchange rate ticker
        ExchangeRateTicker(api: provider.api),
        const SizedBox(height: 20),
        // Top Opportunities
        TopOpportunitiesSection(provider: provider, fmt: fmt),
        const SizedBox(height: 24),
        // Market Momentum
        MoversSection(provider: provider, fmt: fmt),
        const SizedBox(height: 24),
        _ShariaComplianceScoreCard(provider: provider, fmt: fmt),
        const SizedBox(height: 14),
        _mobileStatsGrid(context, provider, fmt, l, onNavigateTo),
        const SizedBox(height: 24),
        if (provider.holdings.isNotEmpty) ...[
          SectionHeader(title: l.yourHoldings),
          const SizedBox(height: 12),
          ...provider.holdings
              .take(3)
              .map(
                (h) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HoldingTile(holding: h, fmt: fmt),
                ),
              ),
        ],
        if (provider.orders.isNotEmpty) ...[
          const SizedBox(height: 16),
          SectionHeader(title: l.recentOrders),
          const SizedBox(height: 12),
          ...provider.orders
              .take(3)
              .map(
                (o) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OrderTile(order: o, fmt: fmt),
                ),
              ),
        ],
        const SizedBox(height: 24),
        // Utility shortcuts (bottom)
        QuickAccessGrid(l: l),
        const SizedBox(height: 20),
        const DisclaimerFooter(),
        const SizedBox(height: 8),
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
        // Hero: portfolio value + cash + CTAs
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: CashBalanceCard(
                        value: '${fmt.format(provider.availableCashBalance)} ETB',
                        subLabel: provider.reservedForOrders > 0
                            ? '${fmt.format(provider.reservedForOrders)} reserved'
                            : null,
                      )),
                      const SizedBox(height: 12),
                      Expanded(child: PortfolioCard(provider: provider, fmt: fmt)),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          HeroTradeCard(
              provider: provider, fmt: fmt, onNavigateTo: onNavigateTo),
        const SizedBox(height: 12),
        // Trust strip
        const TrustStrip(),
        const SizedBox(height: 16),
        // Exchange rate ticker
        ExchangeRateTicker(api: provider.api),
        const SizedBox(height: 20),

        // Stats row (web)
        if (desktop) ...[
          IntrinsicHeight(child: _webRow2(context, provider, l, onNavigateTo)),
          const SizedBox(height: 14),
          _ShariaComplianceScoreCard(provider: provider, fmt: fmt),
        ] else ...[
          _ShariaComplianceScoreCard(provider: provider, fmt: fmt),
          const SizedBox(height: 14),
          IntrinsicHeight(child: _webRow2(context, provider, l, onNavigateTo)),
        ],
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

        // Holdings + Orders side by side on desktop
        if (desktop)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _webHoldingsSection(context, provider, fmt, l)),
                const SizedBox(width: 20),
                Expanded(child: _webOrdersSection(context, provider, fmt, l)),
              ],
            ),
          )
        else ...[
          _webHoldingsSection(context, provider, fmt, l),
          const SizedBox(height: 20),
          _webOrdersSection(context, provider, fmt, l),
        ],
        const SizedBox(height: 28),

        // Utility shortcuts (bottom)
        QuickAccessGrid(l: l),
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

  const _ShariaComplianceScoreCard({required this.provider, required this.fmt});

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
          // Progress bar
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
