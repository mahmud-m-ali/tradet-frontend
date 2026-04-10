import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/price_change.dart';
import '../widgets/mini_chart.dart';
import '../widgets/responsive_layout.dart';
import 'trade_screen.dart';
import 'alerts_screen.dart';
import 'news_screen.dart';
import 'orders_screen.dart';
import 'zakat_screen.dart';
import 'converter_screen.dart';
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
      decoration: BoxDecoration(gradient: HalalEtTheme.bgGradient),
      child: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, _) {
            return RefreshIndicator(
              color: HalalEtTheme.positive,
              backgroundColor: HalalEtTheme.cardBg,
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
  Widget _buildMobileLayout(BuildContext context, AppProvider provider, NumberFormat fmt, AppLocalizations l, void Function(int)? onNavigateTo) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        _greeting(provider, l),
        const SizedBox(height: 16),
        // Exchange rate ticker
        _ExchangeRateTicker(api: provider.api),
        const SizedBox(height: 16),
        _PortfolioCard(provider: provider, fmt: fmt),
        const SizedBox(height: 14),
        _CashBalanceCard(
          value: '${fmt.format(provider.availableCashBalance)} ETB',
          subLabel: provider.reservedForOrders > 0
              ? '${fmt.format(provider.reservedForOrders)} reserved'
              : null,
        ),
        const SizedBox(height: 14),
        _mobileStatsGrid(context, provider, fmt, l, onNavigateTo),
        const SizedBox(height: 16),
        // Quick access cards for new features
        _QuickAccessGrid(l: l),
        const SizedBox(height: 24),
        _MoversSection(provider: provider, fmt: fmt),
        const SizedBox(height: 24),
        if (provider.holdings.isNotEmpty) ...[
          _SectionHeader(title: l.yourHoldings),
          const SizedBox(height: 12),
          ...provider.holdings.take(3).map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _HoldingTile(holding: h, fmt: fmt),
              )),
        ],
        if (provider.orders.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionHeader(title: l.recentOrders),
          const SizedBox(height: 12),
          ...provider.orders.take(3).map((o) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _OrderTile(order: o, fmt: fmt),
              )),
        ],
        const SizedBox(height: 20),
      ],
    );
  }


  // ─── WEB LAYOUT ───
  Widget _buildWebLayout(BuildContext context, AppProvider provider, NumberFormat fmt, AppLocalizations l, void Function(int)? onNavigateTo) {
    final desktop = isDesktop(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      children: [
        // Header row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _greeting(provider, l)),
            provider.isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: HalalEtTheme.textSecondary),
                  ),
                )
              : IconButton(
                  onPressed: () => provider.loadAllData(),
                  icon: const Icon(Icons.refresh_rounded, color: HalalEtTheme.textSecondary),
                  tooltip: l.refreshAllData,
                ),
          ],
        ),
        const SizedBox(height: 16),
        // Exchange rate ticker
        _ExchangeRateTicker(api: provider.api),
        const SizedBox(height: 20),

        // Top row: Capital at Risk + Cash Balance (equal height)
        if (desktop) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: _PortfolioCard(provider: provider, fmt: fmt),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 4,
                  child: _CashBalanceCard(
                    value: '${fmt.format(provider.availableCashBalance)} ETB',
                    subLabel: provider.reservedForOrders > 0
                        ? '${fmt.format(provider.reservedForOrders)} reserved'
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Bottom row: Allocation + 3 stat cards (all equal height)
          _webStatsGrid(context, provider, fmt, onNavigateTo),
        ]
        else ...[
          _PortfolioCard(provider: provider, fmt: fmt),
          const SizedBox(height: 14),
          _CashBalanceCard(
            value: '${fmt.format(provider.availableCashBalance)} ETB',
            subLabel: provider.reservedForOrders > 0
                ? '${fmt.format(provider.reservedForOrders)} reserved'
                : null,
          ),
          const SizedBox(height: 14),
          _webStatsGrid(context, provider, fmt, onNavigateTo),
        ],
        const SizedBox(height: 28),

        // Top Movers / Losers segmented
        _MoversSection(provider: provider, fmt: fmt, webMode: true, desktop: desktop),
        const SizedBox(height: 28),

        // Quick access to new features
        _QuickAccessGrid(l: l),
        const SizedBox(height: 28),

        // Holdings + Orders side by side on desktop
        if (desktop)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _webHoldingsSection(provider, fmt)),
                const SizedBox(width: 20),
                Expanded(child: _webOrdersSection(provider, fmt)),
              ],
            ),
          )
        else ...[
          _webHoldingsSection(provider, fmt),
          const SizedBox(height: 20),
          _webOrdersSection(provider, fmt),
        ],
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
                  color: HalalEtTheme.textSecondary,
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
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: HalalEtTheme.heroGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.show_chart_rounded, size: 22, color: Colors.white),
        ),
      ],
    );
  }

  Widget _mobileStatsGrid(BuildContext context, AppProvider provider, NumberFormat fmt, AppLocalizations l, void Function(int)? onNavigateTo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AllocationCard(provider: provider, fmt: fmt),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.receipt_long_outlined,
                label: l.openOrders,
                value: '${provider.orders.where((o) => o.isPending).length}',
                color: HalalEtTheme.primaryLight,
                onTap: onNavigateTo != null ? () => onNavigateTo(3) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.pie_chart_outline,
                label: l.holdings,
                value: '${provider.holdings.length} assets',
                color: const Color(0xFF818CF8),
                onTap: onNavigateTo != null ? () => onNavigateTo(2) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.star_outline_rounded,
                label: l.watchlist,
                value: '${provider.watchlist.length} assets',
                color: const Color(0xFFFBBF24),
                onTap: onNavigateTo != null ? () => onNavigateTo(4) : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _webStatsGrid(BuildContext context, AppProvider provider, NumberFormat fmt, void Function(int)? onNavigateTo) {
    final l = AppLocalizations.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: _AllocationCard(provider: provider, fmt: fmt),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _StatCard(
              icon: Icons.receipt_long_outlined,
              label: l.openOrders,
              value: '${provider.orders.where((o) => o.isPending).length}',
              color: HalalEtTheme.primaryLight,
              onTap: onNavigateTo != null ? () => onNavigateTo(3) : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _StatCard(
              icon: Icons.pie_chart_outline,
              label: l.holdings,
              value: '${provider.holdings.length} assets',
              color: const Color(0xFF818CF8),
              onTap: onNavigateTo != null ? () => onNavigateTo(2) : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _StatCard(
              icon: Icons.star_outline_rounded,
              label: l.watchlist,
              value: '${provider.watchlist.length} assets',
              color: const Color(0xFFFBBF24),
              onTap: onNavigateTo != null ? () => onNavigateTo(4) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _webHoldingsSection(AppProvider provider, NumberFormat fmt) {
    return _WebSectionCard(
      title: 'Your Holdings',
      titleAm: 'የእርስዎ ንብረቶች',
      isEmpty: provider.holdings.isEmpty,
      emptyIcon: Icons.pie_chart_outline_rounded,
      emptyText: 'No holdings yet',
      child: Column(
        children: provider.holdings.take(5).map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _HoldingTile(holding: h, fmt: fmt),
            )).toList(),
      ),
    );
  }

  Widget _webOrdersSection(AppProvider provider, NumberFormat fmt) {
    return _WebSectionCard(
      title: 'Recent Orders',
      titleAm: 'የቅርብ ጊዜ ትዕዛዞች',
      isEmpty: provider.orders.isEmpty,
      emptyIcon: Icons.receipt_long_outlined,
      emptyText: 'No orders yet',
      child: Column(
        children: provider.orders.take(5).map((o) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _OrderTile(order: o, fmt: fmt),
            )).toList(),
      ),
    );
  }

}

// ─── Top-level mover section builders (used by _MoversSection widget) ───

Widget _topMoversSection(AppProvider provider, NumberFormat fmt) {
  if (provider.assets.isNotEmpty) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _getTopMovers(provider).length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final asset = _getTopMovers(provider)[index];
          return _TopMoverCard(asset: asset, fmt: fmt);
        },
      ),
    );
  } else if (provider.assetsLoading) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(color: HalalEtTheme.positive),
      ),
    );
  } else if (provider.assetsError != null) {
    return _ErrorRetryWidget(
      message: provider.assetsError!,
      onRetry: () => provider.loadAssets(),
    );
  }
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text('No market data available',
        style: TextStyle(color: HalalEtTheme.textMuted, fontSize: 13)),
  );
}

Widget _topLosersSection(AppProvider provider, NumberFormat fmt) {
  if (provider.assets.isNotEmpty) {
    final losers = _getTopLosers(provider);
    if (losers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No losers today',
            style: TextStyle(color: HalalEtTheme.textMuted, fontSize: 13)),
      );
    }
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: losers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _TopMoverCard(asset: losers[index], fmt: fmt);
        },
      ),
    );
  }
  return const SizedBox.shrink();
}

Widget _webTopMoversSection(AppProvider provider, NumberFormat fmt, bool desktop) {
  if (provider.assets.isNotEmpty) {
    final movers = _getTopMovers(provider);
    final crossAxisCount = desktop ? 6 : 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.1,
      ),
      itemCount: movers.length,
      itemBuilder: (context, index) {
        return _TopMoverCard(asset: movers[index], fmt: fmt, webMode: true);
      },
    );
  } else if (provider.assetsLoading) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(color: HalalEtTheme.positive),
      ),
    );
  } else if (provider.assetsError != null) {
    return _ErrorRetryWidget(
      message: provider.assetsError!,
      onRetry: () => provider.loadAssets(),
    );
  }
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text('No market data available',
        style: TextStyle(color: HalalEtTheme.textMuted, fontSize: 13)),
  );
}

Widget _webTopLosersSection(AppProvider provider, NumberFormat fmt, bool desktop) {
  if (provider.assets.isNotEmpty) {
    final losers = _getTopLosers(provider);
    if (losers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No losers today',
            style: TextStyle(color: HalalEtTheme.textMuted, fontSize: 13)),
      );
    }
    final crossAxisCount = desktop ? 6 : 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.1,
      ),
      itemCount: losers.length,
      itemBuilder: (context, index) {
        return _TopMoverCard(asset: losers[index], fmt: fmt, webMode: true);
      },
    );
  }
  return const SizedBox.shrink();
}

List<dynamic> _getTopMovers(AppProvider provider) {
  final gainers = provider.assets.where((a) => (a.change24h ?? 0) > 0).toList()
    ..sort((a, b) => (b.change24h ?? 0).compareTo(a.change24h ?? 0));
  return gainers.take(6).toList();
}

List<dynamic> _getTopLosers(AppProvider provider) {
  final losers = provider.assets.where((a) => (a.change24h ?? 0) < 0).toList()
    ..sort((a, b) => (a.change24h ?? 0).compareTo(b.change24h ?? 0));
  return losers.take(6).toList();
}

// ─── Web Section Card ───
class _WebSectionCard extends StatelessWidget {
  final String title;
  final String titleAm;
  final bool isEmpty;
  final IconData emptyIcon;
  final String emptyText;
  final Widget child;

  const _WebSectionCard({
    required this.title,
    required this.titleAm,
    required this.isEmpty,
    required this.emptyIcon,
    required this.emptyText,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(width: 8),
              Text(titleAm,
                  style: const TextStyle(fontSize: 12, color: HalalEtTheme.textMuted)),
            ],
          ),
          const SizedBox(height: 16),
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Icon(emptyIcon, size: 36, color: HalalEtTheme.textMuted),
                    const SizedBox(height: 8),
                    Text(emptyText,
                        style: const TextStyle(
                            color: HalalEtTheme.textMuted, fontSize: 13)),
                  ],
                ),
              ),
            )
          else
            child,
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final AppProvider provider;
  final NumberFormat fmt;

  const _PortfolioCard({required this.provider, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final summary = provider.portfolioSummary;
    final holdingsValue = (summary?.totalPortfolioValue ?? 0) - (summary?.cashBalance ?? 0);
    final totalPnl = summary?.totalPnl ?? 0;
    final pnlPercent = summary != null && summary.totalInvested > 0
        ? (totalPnl / summary.totalInvested * 100)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: HalalEtTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l.capitalAtRisk,
                style: const TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: HalalEtTheme.positive.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Halal',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: HalalEtTheme.positive),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${fmt.format(holdingsValue)} ETB',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          if (summary != null)
            Row(
              children: [
                Icon(
                  totalPnl >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: totalPnl >= 0
                      ? HalalEtTheme.positive
                      : HalalEtTheme.negative,
                ),
                const SizedBox(width: 4),
                Text(
                  '${totalPnl >= 0 ? "+" : ""}${fmt.format(totalPnl)} ETB (${pnlPercent.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: totalPnl >= 0
                        ? HalalEtTheme.positive
                        : HalalEtTheme.negative,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subLabel;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.subLabel,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: HalalEtTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: onTap != null
                  ? color.withValues(alpha: 0.25)
                  : HalalEtTheme.divider.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 20, color: color),
                  if (onTap != null)
                    Icon(Icons.arrow_forward_ios_rounded, size: 10, color: color.withValues(alpha: 0.5)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted),
                overflow: TextOverflow.ellipsis,
              ),
              if (subLabel != null) ...[
                const SizedBox(height: 2),
                Text(
                  subLabel!,
                  style: const TextStyle(fontSize: 10, color: HalalEtTheme.warning),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CashBalanceCard extends StatelessWidget {
  final String value;
  final String? subLabel;

  const _CashBalanceCard({required this.value, this.subLabel});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HalalEtTheme.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 20, color: HalalEtTheme.accent),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Text(
            l.cashBalance,
            style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted),
            overflow: TextOverflow.ellipsis,
          ),
          if (subLabel != null) ...[
            const SizedBox(height: 2),
            Text(
              subLabel!,
              style: const TextStyle(fontSize: 10, color: HalalEtTheme.warning),
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showDepositSheet(context),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: HalalEtTheme.positive.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: HalalEtTheme.positive.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline, color: HalalEtTheme.positive, size: 13),
                          const SizedBox(width: 4),
                          Text(l.deposit,
                              style: const TextStyle(color: HalalEtTheme.positive, fontWeight: FontWeight.w700, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showWithdrawSheet(context),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: HalalEtTheme.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: HalalEtTheme.accent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.remove_circle_outline, color: HalalEtTheme.accent, size: 13),
                          const SizedBox(width: 4),
                          Text(l.withdraw,
                              style: const TextStyle(color: HalalEtTheme.accent, fontWeight: FontWeight.w700, fontSize: 11)),
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
}

class _AllocationCard extends StatelessWidget {
  final AppProvider provider;
  final NumberFormat fmt;

  const _AllocationCard({required this.provider, required this.fmt});

  Widget _bar(String label, double pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted)),
            Text('${(pct * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
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
    final summary = provider.portfolioSummary;
    final total = summary?.totalPortfolioValue ?? 0;
    final holdings = summary?.totalHoldingsValue ?? 0;
    final cash = summary?.cashBalance ?? 0;
    final holdingsPct = total > 0 ? holdings / total : 0.0;
    final cashPct = total > 0 ? cash / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.donut_small_outlined, size: 15, color: HalalEtTheme.textSecondary),
              const SizedBox(width: 6),
              const Text('Portfolio Split',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: HalalEtTheme.textSecondary)),
            ],
          ),
          _bar('Holdings', holdingsPct, const Color(0xFF818CF8)),
          _bar('Cash', cashPct, HalalEtTheme.accent),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white));
  }
}

class _TopMoverCard extends StatelessWidget {
  final dynamic asset;
  final NumberFormat fmt;
  final bool webMode;

  const _TopMoverCard({required this.asset, required this.fmt, this.webMode = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TradeScreen(asset: asset)),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: webMode ? null : 140,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: HalalEtTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asset.symbol,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                asset.name,
                style: const TextStyle(fontSize: 10, color: HalalEtTheme.textMuted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              if (asset.sparkline.length >= 2)
                SizedBox(
                  height: 30,
                  child: MiniSparkline(
                    data: asset.sparkline,
                    height: 30,
                    width: webMode ? 120 : 110,
                  ),
                ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      asset.price != null ? fmt.format(asset.price) : '--',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 12, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (asset.change24h != null)
                    PriceChange(change: asset.change24h!, fontSize: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoldingTile extends StatelessWidget {
  final dynamic holding;
  final NumberFormat fmt;

  const _HoldingTile({required this.holding, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isPositive = holding.pnl >= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(holding.symbol,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
                Text('${holding.quantity} ${holding.unit}',
                    style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${fmt.format(holding.currentValue)} ETB',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white)),
              Text(
                '${isPositive ? "+" : ""}${fmt.format(holding.pnl)} (${holding.pnlPercentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? HalalEtTheme.positive : HalalEtTheme.negative,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final dynamic order;
  final NumberFormat fmt;

  const _OrderTile({required this.order, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isBuy = order.orderType == 'buy';
    final statusColor = switch (order.orderStatus) {
      'filled' => HalalEtTheme.positive,
      'pending' => HalalEtTheme.warning,
      'cancelled' => HalalEtTheme.negative,
      _ => HalalEtTheme.textMuted,
    };

    final statusLabel = order.orderStatus == 'pending' ? 'OPEN' : order.orderStatus.toString().toUpperCase();
    return GestureDetector(
      onTap: order.isPending ? () {
        // Navigate to Orders screen and show action sheet
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => _WrappedScreen(child: const OrdersScreen()),
        ));
      } : null,
      child: MouseRegion(
        cursor: order.isPending ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: order.isPending
              ? HalalEtTheme.accent.withValues(alpha: 0.3)
              : HalalEtTheme.divider.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: (isBuy ? HalalEtTheme.positive : HalalEtTheme.negative)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isBuy ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
              color: isBuy ? HalalEtTheme.positive : HalalEtTheme.negative,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${order.orderType.toString().toUpperCase()} ${order.symbol}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                ),
                Text(
                  '${order.quantity} @ ${fmt.format(order.price)} ETB',
                  style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
            ),
          ),
        ],
      ),
      ),
      ),
    );
  }
}

// ─── Exchange Rate Ticker (auto-scrolling marquee) ───
class _ExchangeRateTicker extends StatefulWidget {
  final dynamic api;
  const _ExchangeRateTicker({required this.api});

  @override
  State<_ExchangeRateTicker> createState() => _ExchangeRateTickerState();
}

class _ExchangeRateTickerState extends State<_ExchangeRateTicker>
    with SingleTickerProviderStateMixin {
  Map<String, ExchangeRate> _rates = {};
  bool _loading = true;
  late final ScrollController _scrollCtrl;
  late final AnimationController _animCtrl;
  bool _paused = false;
  double _singleSetWidth = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // placeholder, updated later
    );
    _loadRates();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadRates() async {
    try {
      final rates = await widget.api.getExchangeRates();
      if (mounted) {
        setState(() { _rates = rates; _loading = false; });
        // Start auto-scroll after layout
        WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startAutoScroll() {
    if (!mounted || _rates.isEmpty || !_scrollCtrl.hasClients) return;
    final maxScroll = _scrollCtrl.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    // Half the content is one set (we duplicate items for seamless loop)
    _singleSetWidth = (maxScroll + _scrollCtrl.position.viewportDimension) / 2;

    // Speed: ~40 pixels per second
    final durationMs = (_singleSetWidth / 40 * 1000).round();
    _animCtrl.duration = Duration(milliseconds: durationMs);

    _animCtrl.addListener(_onTick);
    _animCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Jump back to start seamlessly and repeat
        _scrollCtrl.jumpTo(0);
        _animCtrl.forward(from: 0);
      }
    });

    _animCtrl.forward();
  }

  void _onTick() {
    if (!_scrollCtrl.hasClients || _singleSetWidth <= 0) return;
    _scrollCtrl.jumpTo(_animCtrl.value * _singleSetWidth);
  }

  void _pause() {
    if (!_paused) {
      _paused = true;
      _animCtrl.stop();
    }
  }

  void _resume() {
    if (_paused) {
      _paused = false;
      _animCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _rates.isEmpty) return const SizedBox.shrink();

    // Duplicate the entries for seamless looping
    final entries = _rates.entries.toList();
    final doubledEntries = [...entries, ...entries];

    return MouseRegion(
      onEnter: (_) => _pause(),
      onExit: (_) => _resume(),
      child: GestureDetector(
        onPanDown: (_) => _pause(),
        onPanEnd: (_) => Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _resume();
        }),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
            stops: [0.0, 0.02, 0.95, 1.0],
          ).createShader(bounds),
          blendMode: BlendMode.dstIn,
          child: SizedBox(
            height: 42,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: ListView.separated(
                controller: _scrollCtrl,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: doubledEntries.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (ctx, i) {
                  final entry = doubledEntries[i];
                  return _rateChip(entry);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rateChip(MapEntry<String, ExchangeRate> entry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: HalalEtTheme.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(entry.key,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    color: HalalEtTheme.accent)),
          ),
          const SizedBox(width: 8),
          Text(entry.value.buying.toStringAsFixed(2),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: Colors.white)),
          Text(' / ${entry.value.selling.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted)),
          const SizedBox(width: 4),
          const Text('ETB', style: TextStyle(fontSize: 9, color: HalalEtTheme.textMuted)),
        ],
      ),
    );
  }
}

// ─── Quick Access Grid ───
class _QuickAccessGrid extends StatelessWidget {
  final AppLocalizations l;
  const _QuickAccessGrid({required this.l});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.quickAccess,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _QuickAccessCard(
              icon: Icons.currency_exchange,
              label: l.exchangeRates,
              color: const Color(0xFF60A5FA),
              onTap: () => _pushScreen(context, 7),
            )),
            const SizedBox(width: 10),
            Expanded(child: _QuickAccessCard(
              icon: Icons.volunteer_activism,
              label: l.zakatCalculator,
              color: HalalEtTheme.accent,
              onTap: () => _pushScreen(context, 6),
            )),
            const SizedBox(width: 10),
            Expanded(child: _QuickAccessCard(
              icon: Icons.newspaper,
              label: l.newsFeed,
              color: HalalEtTheme.positive,
              onTap: () => _pushScreen(context, 5),
            )),
            const SizedBox(width: 10),
            Expanded(child: _QuickAccessCard(
              icon: Icons.notifications,
              label: l.priceAlerts,
              color: const Color(0xFF818CF8),
              onTap: () => _pushScreen(context, 4),
            )),
          ],
        ),
      ],
    );
  }

  void _pushScreen(BuildContext context, int index) {
    late Widget screen;
    switch (index) {
      case 4:
        screen = const AlertsScreen();
        break;
      case 5:
        screen = const NewsScreen();
        break;
      case 6:
        screen = const ZakatScreen();
        break;
      case 7:
        screen = const ConverterScreen();
        break;
      default:
        return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _WrappedScreen(child: screen),
    ));
  }
}

class _WrappedScreen extends StatelessWidget {
  final Widget child;
  const _WrappedScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3B20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B20),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: child,
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                    color: color, height: 1.2),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─── Deposit / Withdraw Row (shown on Dashboard) ───
// ─── Deposit / Withdraw sheets (top-level so any widget can call them) ───

void _showDepositSheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: HalalEtTheme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: HalalEtTheme.divider, borderRadius: BorderRadius.circular(2))),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
              decoration: const InputDecoration(
                prefixText: 'ETB  ',
                prefixStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: HalalEtTheme.textSecondary),
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
              child: Text(AppLocalizations.of(ctx).deposit),
            ),
          ],
        ),
      ),
    );
  }

void _showWithdrawSheet(BuildContext context) {
  final amountCtrl = TextEditingController();
  PaymentMethod? selectedMethod;

  // Ensure payment methods are loaded
  if (context.read<AppProvider>().paymentMethods.isEmpty) {
    context.read<AppProvider>().loadPaymentMethods();
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: HalalEtTheme.cardBg,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheetState) {
        final provider = ctx.read<AppProvider>();
        final methods = provider.paymentMethods;
        final available = provider.availableCashBalance;
        final reserved = provider.reservedForOrders;
        final l = AppLocalizations.of(ctx);

        // Auto-select primary on first load
        if (selectedMethod == null && methods.isNotEmpty) {
          selectedMethod = methods.firstWhere(
            (m) => m.isPrimary, orElse: () => methods.first);
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: HalalEtTheme.divider,
                      borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text(l.withdrawEtb,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 4),
              const Text('Riba-free withdrawal to your saved bank account',
                  style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
              const SizedBox(height: 12),
              Text('Available: ${available.toStringAsFixed(2)} ETB',
                  style: const TextStyle(fontSize: 13, color: HalalEtTheme.positive, fontWeight: FontWeight.w600)),
              if (reserved > 0)
                Text('Reserved in open orders: ${reserved.toStringAsFixed(2)} ETB',
                    style: const TextStyle(fontSize: 11, color: HalalEtTheme.warning)),
              const SizedBox(height: 16),
              if (methods.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: HalalEtTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: HalalEtTheme.warning.withValues(alpha: 0.4)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.account_balance_outlined, color: HalalEtTheme.warning, size: 32),
                      SizedBox(height: 8),
                      Text('No payment methods saved.',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      SizedBox(height: 4),
                      Text('Go to Profile → Payment Methods to add your bank account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: HalalEtTheme.textSecondary)),
                    ],
                  ),
                ),
              ] else ...[
                const Text('Select payment method:',
                    style: TextStyle(fontSize: 12, color: HalalEtTheme.textMuted)),
                const SizedBox(height: 8),
                ...methods.map((m) => GestureDetector(
                  onTap: () => setSheetState(() => selectedMethod = m),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedMethod?.id == m.id
                          ? HalalEtTheme.positive.withValues(alpha: 0.1)
                          : HalalEtTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedMethod?.id == m.id
                            ? HalalEtTheme.positive.withValues(alpha: 0.5)
                            : HalalEtTheme.divider.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_outlined,
                            size: 18, color: selectedMethod?.id == m.id
                                ? HalalEtTheme.positive : HalalEtTheme.textMuted),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.bankName,
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                              Text('${m.accountNumber} • ${m.accountName}',
                                  style: const TextStyle(
                                      color: HalalEtTheme.textMuted, fontSize: 11)),
                            ],
                          ),
                        ),
                        if (m.isPrimary)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: HalalEtTheme.positive.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Primary',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                                    color: HalalEtTheme.positive)),
                          ),
                        const SizedBox(width: 6),
                        Icon(
                          selectedMethod?.id == m.id
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selectedMethod?.id == m.id
                              ? HalalEtTheme.positive
                              : HalalEtTheme.textMuted,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 8),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                  decoration: const InputDecoration(
                    prefixText: 'ETB  ',
                    prefixStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700,
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
                    if (selectedMethod == null) return;
                    if (amount > available) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Insufficient balance. Available: ${available.toStringAsFixed(2)} ETB'),
                        backgroundColor: HalalEtTheme.negative,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ));
                      return;
                    }
                    Navigator.pop(ctx);
                    final result = await context.read<AppProvider>().withdraw(
                      amount: amount,
                      bankName: selectedMethod!.bankName,
                      accountNumber: selectedMethod!.accountNumber,
                    );
                    if (context.mounted) {
                      final isError = result.containsKey('error');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(isError
                            ? (result['error'] ?? 'Withdrawal failed')
                            : (result['message'] ?? 'Withdrawal complete')),
                        backgroundColor: isError ? HalalEtTheme.negative : HalalEtTheme.positive,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ));
                    }
                  },
                  child: Text(l.withdraw,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ],
            ],
          ),
        );
      },
    ),
  );
}

class _ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetryWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 20, color: HalalEtTheme.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: HalalEtTheme.textMuted, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: HalalEtTheme.primaryLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Retry',
                  style: TextStyle(
                      color: HalalEtTheme.positive,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Segmented Movers / Losers Section ───

class _MoversSection extends StatefulWidget {
  final AppProvider provider;
  final NumberFormat fmt;
  final bool webMode;
  final bool desktop;
  const _MoversSection({
    required this.provider,
    required this.fmt,
    this.webMode = false,
    this.desktop = false,
  });
  @override
  State<_MoversSection> createState() => _MoversSectionState();
}

class _MoversSectionState extends State<_MoversSection> {
  bool _showGainers = true;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: HalalEtTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(child: _tab(l.topMovers, true)),
                    const SizedBox(width: 3),
                    Expanded(child: _tab(l.topLosers, false)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _showGainers
            ? (widget.webMode
                ? _webTopMoversSection(widget.provider, widget.fmt, widget.desktop)
                : _topMoversSection(widget.provider, widget.fmt))
            : (widget.webMode
                ? _webTopLosersSection(widget.provider, widget.fmt, widget.desktop)
                : _topLosersSection(widget.provider, widget.fmt)),
      ],
    );
  }

  Widget _tab(String label, bool isGainers) {
    final selected = _showGainers == isGainers;
    final color = isGainers ? HalalEtTheme.positive : HalalEtTheme.negative;
    return GestureDetector(
      onTap: () => setState(() => _showGainers = isGainers),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: selected ? Border.all(color: color.withValues(alpha: 0.4)) : null,
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: selected ? color : HalalEtTheme.textMuted,
            )),
      ),
    );
  }
}
