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
import '../screens/trade_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/news_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/zakat_screen.dart';
import '../screens/converter_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';

// ─── Web Section Card ───
class WebSectionCard extends StatelessWidget {
  final String title;
  final bool isEmpty;
  final IconData emptyIcon;
  final String emptyText;
  final Widget child;

  const WebSectionCard({
    super.key,
    required this.title,
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
        color: TradEtTheme.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Icon(emptyIcon, size: 36, color: TradEtTheme.textMuted),
                    const SizedBox(height: 8),
                    Text(
                      emptyText,
                      style: const TextStyle(
                        color: TradEtTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
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

// ─── Hero Trade Card (wireframe: combined portfolio + cash + CTAs) ───
class HeroTradeCard extends StatelessWidget {
  final AppProvider provider;
  final NumberFormat fmt;
  final void Function(int)? onNavigateTo;

  const HeroTradeCard({
    super.key,
    required this.provider,
    required this.fmt,
    this.onNavigateTo,
  });

  @override
  Widget build(BuildContext context) {
    final summary = provider.portfolioSummary;
    final totalValue = summary?.totalPortfolioValue ?? 0;
    final cashBalance = provider.availableCashBalance;
    final holdingsValue = totalValue - cashBalance;
    final totalPnl = summary?.totalPnl ?? 0;
    final totalInvested = summary?.totalInvested ?? 0;
    final pnlPct = totalInvested > 0 ? (totalPnl / totalInvested * 100) : 0.0;
    final wide = isWideScreen(context);

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: wide ? 16 : 20, vertical: wide ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0D3B20),
            const Color(0xFF0B2E1A).withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TradEtTheme.positive.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label + Halal badge
          Row(
            children: [
              const Icon(Icons.account_balance_rounded,
                  size: 13, color: TradEtTheme.textSecondary),
              const SizedBox(width: 5),
              const Text('Total Portfolio Value',
                  style: TextStyle(
                      fontSize: 11, color: TradEtTheme.textSecondary)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TradEtTheme.positive.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text('Halal',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: TradEtTheme.positive)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          // Value + P&L on same line on desktop to save vertical space
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${fmt.format(totalValue)} ETB',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5)),
                if (summary != null) ...[
                  const SizedBox(width: 10),
                  Icon(
                    totalPnl >= 0 ? Icons.trending_up : Icons.trending_down,
                    size: 13,
                    color: totalPnl >= 0
                        ? TradEtTheme.positive
                        : TradEtTheme.negative,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${totalPnl >= 0 ? "+" : ""}${fmt.format(totalPnl)} (${pnlPct.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: totalPnl >= 0
                          ? TradEtTheme.positive
                          : TradEtTheme.negative,
                    ),
                  ),
                ],
              ],
            )
          else ...[
            Text('${fmt.format(totalValue)} ETB',
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5)),
            if (summary != null) ...[
              const SizedBox(height: 2),
              Row(children: [
                Icon(
                  totalPnl >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 13,
                  color: totalPnl >= 0
                      ? TradEtTheme.positive
                      : TradEtTheme.negative,
                ),
                const SizedBox(width: 3),
                Text(
                  '${totalPnl >= 0 ? "+" : ""}${fmt.format(totalPnl)} (${pnlPct.toStringAsFixed(1)}%)',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: totalPnl >= 0
                          ? TradEtTheme.positive
                          : TradEtTheme.negative),
                ),
              ]),
            ],
          ],
          const SizedBox(height: 8),
          // Capital at Risk + optional cash (mobile) inline
          Row(
            children: [
              const Icon(Icons.show_chart_rounded,
                  size: 12, color: TradEtTheme.textMuted),
              const SizedBox(width: 4),
              const Text('Capital at Risk',
                  style: TextStyle(
                      fontSize: 11, color: TradEtTheme.textSecondary)),
              const Spacer(),
              Text('${fmt.format(holdingsValue)} ETB',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
          if (!wide) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    size: 12, color: TradEtTheme.textMuted),
                const SizedBox(width: 4),
                const Text('Available Cash',
                    style: TextStyle(
                        fontSize: 11, color: TradEtTheme.textSecondary)),
                const Spacer(),
                Text('${fmt.format(cashBalance)} ETB',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ],
          const SizedBox(height: 10),
          // CTA buttons — compact height
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onNavigateTo?.call(1),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: TradEtTheme.heroGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bolt_rounded,
                              size: 14, color: Colors.white),
                          SizedBox(width: 5),
                          Text('Trade Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => onNavigateTo?.call(2),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: TradEtTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color:
                                TradEtTheme.divider.withValues(alpha: 0.5)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pie_chart_outline,
                              size: 14,
                              color: TradEtTheme.primaryLight),
                          SizedBox(width: 5),
                          Text('Portfolio',
                              style: TextStyle(
                                  color: TradEtTheme.primaryLight,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
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

// ─── Trust / Compliance Strip ───
class TrustStrip extends StatelessWidget {
  const TrustStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: TradEtTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TrustBadge(icon: Icons.verified_rounded,
              label: 'ECX Regulated', color: TradEtTheme.primaryLight),
          _TrustDivider(),
          _TrustBadge(icon: Icons.star_rounded,
              label: 'Sharia Certified', color: TradEtTheme.positive),
          _TrustDivider(),
          _TrustBadge(icon: Icons.gavel_rounded,
              label: 'AAOIFI Compliant', color: TradEtTheme.accent),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _TrustBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

class _TrustDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 16, color: TradEtTheme.divider.withValues(alpha: 0.5));
  }
}

// ─── Portfolio Card ───
class PortfolioCard extends StatelessWidget {
  final AppProvider provider;
  final NumberFormat fmt;

  const PortfolioCard({super.key, required this.provider, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final summary = provider.portfolioSummary;
    final holdingsValue =
        (summary?.totalPortfolioValue ?? 0) - (summary?.cashBalance ?? 0);
    final totalPnl = summary?.totalPnl ?? 0;
    final pnlPercent = summary != null && summary.totalInvested > 0
        ? (totalPnl / summary.totalInvested * 100)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: TradEtTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.4)),
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
                style: const TextStyle(
                  fontSize: 13,
                  color: TradEtTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: TradEtTheme.positive.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Halal',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: TradEtTheme.positive,
                  ),
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
                      ? TradEtTheme.positive
                      : TradEtTheme.negative,
                ),
                const SizedBox(width: 4),
                Text(
                  '${totalPnl >= 0 ? "+" : ""}${fmt.format(totalPnl)} ETB (${pnlPercent.toStringAsFixed(1)}%)',
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
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
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
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: onTap != null
                  ? color.withValues(alpha: 0.25)
                  : TradEtTheme.divider.withValues(alpha: 0.3),
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
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: color.withValues(alpha: 0.5),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: TradEtTheme.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Cash Balance Card ────────────────────────────────────────────────────────
class CashBalanceCard extends StatefulWidget {
  final String value;
  final String? subLabel;

  const CashBalanceCard({super.key, required this.value, this.subLabel});

  @override
  State<CashBalanceCard> createState() => _CashBalanceCardState();
}

class _CashBalanceCardState extends State<CashBalanceCard> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TradEtTheme.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title + icon on top row
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 13, color: TradEtTheme.accent),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  l.cashBalance,
                  style: const TextStyle(
                      fontSize: 11, color: TradEtTheme.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _visible = !_visible),
                child: Icon(
                  _visible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 14,
                  color: TradEtTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _visible ? widget.value : '••••••',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (widget.subLabel != null) ...[
            const SizedBox(height: 2),
            Text(
              widget.subLabel!,
              style: const TextStyle(fontSize: 10, color: TradEtTheme.warning),
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => showDepositSheet(context),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: TradEtTheme.positive.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: TradEtTheme.positive.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle_outline,
                            color: TradEtTheme.positive,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l.deposit,
                            style: const TextStyle(
                              color: TradEtTheme.positive,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: GestureDetector(
                  onTap: () => showWithdrawSheet(context),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: TradEtTheme.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: TradEtTheme.accent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.remove_circle_outline,
                            color: TradEtTheme.accent,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l.withdraw,
                            style: const TextStyle(
                              color: TradEtTheme.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
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
}

class AllocationCard extends StatelessWidget {
  final AppProvider provider;
  final NumberFormat fmt;

  const AllocationCard({super.key, required this.provider, required this.fmt});

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
    final summary = provider.portfolioSummary;
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.donut_small_outlined,
                size: 15,
                color: TradEtTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              const Text(
                'Portfolio Split',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: TradEtTheme.textSecondary,
                ),
              ),
            ],
          ),
          _bar('Holdings', holdingsPct, const Color(0xFF818CF8)),
          _bar('Cash', cashPct, TradEtTheme.accent),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}

class TopMoverCard extends StatelessWidget {
  final dynamic asset;
  final NumberFormat fmt;
  final bool webMode;

  const TopMoverCard({
    super.key,
    required this.asset,
    required this.fmt,
    this.webMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(appRoute(context, TradeScreen(asset: asset))),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: webMode ? null : 140,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: TradEtTheme.divider.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asset.symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                asset.name,
                style: const TextStyle(
                  fontSize: 10,
                  color: TradEtTheme.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
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
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.white,
                      ),
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

class HoldingTile extends StatelessWidget {
  final dynamic holding;
  final NumberFormat fmt;

  const HoldingTile({super.key, required this.holding, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isPositive = holding.pnl >= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${holding.quantity} ${holding.unit}',
                  style: const TextStyle(
                    fontSize: 11,
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
                '${fmt.format(holding.currentValue)} ETB',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              Text(
                '${isPositive ? "+" : ""}${fmt.format(holding.pnl)} (${holding.pnlPercentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isPositive
                      ? TradEtTheme.positive
                      : TradEtTheme.negative,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final dynamic order;
  final NumberFormat fmt;

  const OrderTile({super.key, required this.order, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isBuy = order.orderType == 'buy';
    final statusColor = switch (order.orderStatus) {
      'filled' => TradEtTheme.positive,
      'pending' => TradEtTheme.warning,
      'cancelled' => TradEtTheme.negative,
      _ => TradEtTheme.textMuted,
    };

    final statusLabel = order.orderStatus == 'pending'
        ? 'OPEN'
        : order.orderStatus.toString().toUpperCase();
    return GestureDetector(
      onTap: order.isPending
          ? () {
              // Navigate to Orders screen and show action sheet
              Navigator.of(context).push(
                appRoute(context, WrappedScreen(child: const OrdersScreen())),
              );
            }
          : null,
      child: MouseRegion(
        cursor: order.isPending ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: order.isPending
                  ? TradEtTheme.accent.withValues(alpha: 0.3)
                  : TradEtTheme.divider.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: (isBuy ? TradEtTheme.positive : TradEtTheme.negative)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isBuy ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 16,
                  color: isBuy ? TradEtTheme.positive : TradEtTheme.negative,
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
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${order.quantity} @ ${fmt.format(order.price)} ETB',
                      style: const TextStyle(
                        fontSize: 11,
                        color: TradEtTheme.textMuted,
                      ),
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
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
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
class ExchangeRateTicker extends StatefulWidget {
  final dynamic api;
  const ExchangeRateTicker({super.key, required this.api});

  @override
  State<ExchangeRateTicker> createState() => _ExchangeRateTickerState();
}

class _ExchangeRateTickerState extends State<ExchangeRateTicker>
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
        setState(() {
          _rates = rates;
          _loading = false;
        });
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
            colors: [
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
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
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: TradEtTheme.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              entry.key,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: TradEtTheme.accent,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            entry.value.buying.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            ' / ${entry.value.selling.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted),
          ),
          const SizedBox(width: 4),
          const Text(
            'ETB',
            style: TextStyle(fontSize: 9, color: TradEtTheme.textMuted),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Access Grid ───
class QuickAccessGrid extends StatelessWidget {
  final AppLocalizations l;
  const QuickAccessGrid({super.key, required this.l});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.quickAccess,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickAccessCard(
                icon: Icons.currency_exchange,
                label: l.exchangeRates,
                color: const Color(0xFF60A5FA),
                onTap: () => _pushScreen(context, 7),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickAccessCard(
                icon: Icons.volunteer_activism,
                label: l.zakatCalculator,
                color: TradEtTheme.accent,
                onTap: () => _pushScreen(context, 6),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickAccessCard(
                icon: Icons.newspaper,
                label: l.newsFeed,
                color: TradEtTheme.positive,
                onTap: () => _pushScreen(context, 5),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickAccessCard(
                icon: Icons.notifications,
                label: l.priceAlerts,
                color: const Color(0xFF818CF8),
                onTap: () => _pushScreen(context, 4),
              ),
            ),
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
    Navigator.of(
      context,
    ).push(appRoute(context, WrappedScreen(child: screen)));
  }
}

/// Consistent icon button for the dashboard header — same height as LanguageSelector.
class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: TradEtTheme.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: TradEtTheme.divider.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

class WrappedScreen extends StatelessWidget {
  final Widget child;
  final bool showMobileAppBar;
  const WrappedScreen({super.key, required this.child, this.showMobileAppBar = true});

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            Consumer<AppProvider>(
              builder: (context, provider, _) => AppWebSidebar(
                currentIndex: -1,
                onTap: (i) {
                  Navigator.of(context).pop();
                  provider.navigateGlobal(i);
                },
                onLogout: () async {
                  await provider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      appRoute(context, const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ),
            Container(width: 1, color: const Color(0xFF2D5A3D)),
            Expanded(child: child),
          ],
        ),
      );
    }
    if (!showMobileAppBar) {
      return Scaffold(backgroundColor: const Color(0xFF0D3B20), body: child);
    }
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

class QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickAccessCard({
    super.key,
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
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorRetryWidget({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 20,
            color: TradEtTheme.textMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: TradEtTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: TradEtTheme.primaryLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: TradEtTheme.positive,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Opportunities Section ───

class TopOpportunitiesSection extends StatelessWidget {
  final AppProvider provider;
  final NumberFormat fmt;

  const TopOpportunitiesSection({
    super.key,
    required this.provider,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final assets = provider.assets.where((a) => a.isShariaCompliant).toList();
    if (assets.isEmpty) return const SizedBox.shrink();

    // Top Volume — highest volume24h
    final byVolume = [...assets]
      ..sort((a, b) => (b.volume24h ?? 0).compareTo(a.volume24h ?? 0));
    final topVolume = byVolume.take(3).toList();

    // Trending — highest positive change24h
    final byChange = [...assets]
      ..sort((a, b) => (b.change24h ?? 0).compareTo(a.change24h ?? 0));
    final trending = byChange.where((a) => (a.change24h ?? 0) > 0).take(3).toList();

    // Popular — ECX-listed with high volume
    final popular = [...assets.where((a) => a.isEcxListed)]
      ..sort((a, b) => (b.volume24h ?? 0).compareTo(a.volume24h ?? 0));
    final topPopular = popular.take(3).toList();

    final categories = [
      _OpportunityCategory(
        label: 'Top Volume',
        icon: Icons.show_chart_rounded,
        color: TradEtTheme.primaryLight,
        assets: topVolume,
      ),
      _OpportunityCategory(
        label: 'Trending',
        icon: Icons.trending_up_rounded,
        color: TradEtTheme.positive,
        assets: trending,
      ),
      _OpportunityCategory(
        label: 'ECX Listed',
        icon: Icons.verified_rounded,
        color: TradEtTheme.accent,
        assets: topPopular,
      ),
    ];

    final wide = isWideScreen(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Opportunities',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        // On wide screens: 3 equal-width cards in a Row
        // On mobile: horizontal scroll with fixed-width cards
        if (wide)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < categories.length; i++) ...[
                  if (i > 0) const SizedBox(width: 14),
                  Expanded(
                    child: _OpportunityCategoryCard(
                        category: categories[i], fmt: fmt),
                  ),
                ],
              ],
            ),
          )
        else
          SizedBox(
            height: 160,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) =>
                    _OpportunityCategoryCard(category: categories[i], fmt: fmt),
              ),
            ),
          ),
      ],
    );
  }
}

class _OpportunityCategory {
  final String label;
  final IconData icon;
  final Color color;
  final List<Asset> assets;
  const _OpportunityCategory({
    required this.label,
    required this.icon,
    required this.color,
    required this.assets,
  });
}

class _OpportunityCategoryCard extends StatelessWidget {
  final _OpportunityCategory category;
  final NumberFormat fmt;
  const _OpportunityCategoryCard({
    required this.category,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: category.color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, color: category.color, size: 16),
              const SizedBox(width: 6),
              Text(
                category.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: category.color,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: category.assets.isEmpty
                  ? [
                      const Text('No data',
                          style: TextStyle(
                              color: TradEtTheme.textMuted, fontSize: 11)),
                    ]
                  : category.assets
                      .map((asset) => GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              appRoute(context, TradeScreen(asset: asset)),
                            ),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      asset.symbol,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    asset.price != null
                                        ? fmt.format(asset.price!)
                                        : '--',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: TradEtTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: ((asset.change24h ?? 0) >= 0
                                              ? TradEtTheme.positive
                                              : TradEtTheme.negative)
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${(asset.change24h ?? 0) >= 0 ? '+' : ''}${(asset.change24h ?? 0).toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: (asset.change24h ?? 0) >= 0
                                            ? TradEtTheme.positive
                                            : TradEtTheme.negative,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Segmented Movers / Losers Section ───

class MoversSection extends StatefulWidget {
  final AppProvider provider;
  final NumberFormat fmt;
  final bool webMode;
  final bool desktop;
  const MoversSection({
    super.key,
    required this.provider,
    required this.fmt,
    this.webMode = false,
    this.desktop = false,
  });
  @override
  State<MoversSection> createState() => _MoversSectionState();
}

class _MoversSectionState extends State<MoversSection> {
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
                  color: TradEtTheme.surfaceLight,
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
                  ? webTopMoversSection(
                      widget.provider,
                      widget.fmt,
                      widget.desktop,
                    )
                  : topMoversSection(widget.provider, widget.fmt))
            : (widget.webMode
                  ? webTopLosersSection(
                      widget.provider,
                      widget.fmt,
                      widget.desktop,
                    )
                  : topLosersSection(widget.provider, widget.fmt)),
      ],
    );
  }

  Widget _tab(String label, bool isGainers) {
    final selected = _showGainers == isGainers;
    final color = isGainers ? TradEtTheme.positive : TradEtTheme.negative;
    return GestureDetector(
      onTap: () => setState(() => _showGainers = isGainers),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? Border.all(color: color.withValues(alpha: 0.4))
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: selected ? color : TradEtTheme.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─── Top-level mover section builders (used by MoversSection widget) ───

Widget topMoversSection(AppProvider provider, NumberFormat fmt) {
  if (provider.assets.isNotEmpty) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: getTopMovers(provider).length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final asset = getTopMovers(provider)[index];
          return TopMoverCard(asset: asset, fmt: fmt);
        },
      ),
    );
  } else if (provider.assetsLoading) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(color: TradEtTheme.positive),
      ),
    );
  } else if (provider.assetsError != null) {
    return ErrorRetryWidget(
      message: provider.assetsError!,
      onRetry: () => provider.loadAssets(),
    );
  }
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text(
      'No market data available',
      style: TextStyle(color: TradEtTheme.textMuted, fontSize: 13),
    ),
  );
}

Widget topLosersSection(AppProvider provider, NumberFormat fmt) {
  if (provider.assets.isNotEmpty) {
    final losers = getTopLosers(provider);
    if (losers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'No losers today',
          style: TextStyle(color: TradEtTheme.textMuted, fontSize: 13),
        ),
      );
    }
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: losers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return TopMoverCard(asset: losers[index], fmt: fmt);
        },
      ),
    );
  }
  return const SizedBox.shrink();
}

Widget webTopMoversSection(
  AppProvider provider,
  NumberFormat fmt,
  bool desktop,
) {
  if (provider.assets.isNotEmpty) {
    final movers = getTopMovers(provider);
    final crossAxisCount = desktop ? 6 : 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.5,
      ),
      itemCount: movers.length,
      itemBuilder: (context, index) {
        return TopMoverCard(asset: movers[index], fmt: fmt, webMode: true);
      },
    );
  } else if (provider.assetsLoading) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(color: TradEtTheme.positive),
      ),
    );
  } else if (provider.assetsError != null) {
    return ErrorRetryWidget(
      message: provider.assetsError!,
      onRetry: () => provider.loadAssets(),
    );
  }
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text(
      'No market data available',
      style: TextStyle(color: TradEtTheme.textMuted, fontSize: 13),
    ),
  );
}

Widget webTopLosersSection(
  AppProvider provider,
  NumberFormat fmt,
  bool desktop,
) {
  if (provider.assets.isNotEmpty) {
    final losers = getTopLosers(provider);
    if (losers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'No losers today',
          style: TextStyle(color: TradEtTheme.textMuted, fontSize: 13),
        ),
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
        childAspectRatio: 1.5,
      ),
      itemCount: losers.length,
      itemBuilder: (context, index) {
        return TopMoverCard(asset: losers[index], fmt: fmt, webMode: true);
      },
    );
  }
  return const SizedBox.shrink();
}

List<dynamic> getTopMovers(AppProvider provider) {
  final gainers = provider.assets.where((a) => (a.change24h ?? 0) > 0).toList()
    ..sort((a, b) => (b.change24h ?? 0).compareTo(a.change24h ?? 0));
  return gainers.take(6).toList();
}

List<dynamic> getTopLosers(AppProvider provider) {
  final losers = provider.assets.where((a) => (a.change24h ?? 0) < 0).toList()
    ..sort((a, b) => (a.change24h ?? 0).compareTo(b.change24h ?? 0));
  return losers.take(6).toList();
}

// ─── Deposit / Withdraw sheets ───

void showDepositSheet(BuildContext context) {
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
            style: TextStyle(fontSize: 13, color: Color(0xFF8BAF97)),
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
                color: Color(0xFF8BAF97),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'] ?? 'Deposit complete'),
                      backgroundColor: const Color(0xFF2E7D52),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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

void showWithdrawSheet(BuildContext context) {
  final amountCtrl = TextEditingController();
  PaymentMethod? selectedMethod;

  // Ensure payment methods are loaded
  if (context.read<AppProvider>().paymentMethods.isEmpty) {
    context.read<AppProvider>().loadPaymentMethods();
  }

  showResponsiveSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF1A3D2B),
    builder: (ctx, isDialog) => StatefulBuilder(
      builder: (ctx, setSheetState) {
        final provider = ctx.read<AppProvider>();
        final methods = provider.paymentMethods;
        final available = provider.availableCashBalance;
        final reserved = provider.reservedForOrders;
        final l = AppLocalizations.of(ctx);

        // Auto-select primary on first load
        if (selectedMethod == null && methods.isNotEmpty) {
          selectedMethod = methods.firstWhere(
            (m) => m.isPrimary,
            orElse: () => methods.first,
          );
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
                    Text(
                      l.withdrawEtb,
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
                  l.withdrawEtb,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              const Text(
                'Riba-free withdrawal to your saved bank account',
                style: TextStyle(
                  fontSize: 13,
                  color: TradEtTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Available: ${available.toStringAsFixed(2)} ETB',
                style: const TextStyle(
                  fontSize: 13,
                  color: TradEtTheme.positive,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (reserved > 0)
                Text(
                  'Reserved in open orders: ${reserved.toStringAsFixed(2)} ETB',
                  style: const TextStyle(
                    fontSize: 11,
                    color: TradEtTheme.warning,
                  ),
                ),
              const SizedBox(height: 16),
              if (methods.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TradEtTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: TradEtTheme.warning.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.account_balance_outlined,
                        color: TradEtTheme.warning,
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No payment methods saved.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Go to Profile → Payment Methods to add your bank account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: TradEtTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const Text(
                  'Select payment method:',
                  style: TextStyle(fontSize: 12, color: TradEtTheme.textMuted),
                ),
                const SizedBox(height: 8),
                ...methods.map(
                  (m) => GestureDetector(
                    onTap: () => setSheetState(() => selectedMethod = m),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selectedMethod?.id == m.id
                            ? TradEtTheme.positive.withValues(alpha: 0.1)
                            : TradEtTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedMethod?.id == m.id
                              ? TradEtTheme.positive.withValues(alpha: 0.5)
                              : TradEtTheme.divider.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_outlined,
                            size: 18,
                            color: selectedMethod?.id == m.id
                                ? TradEtTheme.positive
                                : TradEtTheme.textMuted,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.bankName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '**** ${m.accountNumber.length > 4 ? m.accountNumber.substring(m.accountNumber.length - 4) : m.accountNumber} • ${m.accountName}',
                                  style: const TextStyle(
                                    color: TradEtTheme.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (m.isPrimary)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: TradEtTheme.positive.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Primary',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: TradEtTheme.positive,
                                ),
                              ),
                            ),
                          const SizedBox(width: 6),
                          Icon(
                            selectedMethod?.id == m.id
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selectedMethod?.id == m.id
                                ? TradEtTheme.positive
                                : TradEtTheme.textMuted,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TradEtTheme.accent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    final amount = double.tryParse(amountCtrl.text);
                    if (amount == null || amount <= 0) return;
                    if (selectedMethod == null) return;
                    if (amount > available) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Insufficient balance. Available: ${available.toStringAsFixed(2)} ETB',
                          ),
                          backgroundColor: TradEtTheme.negative,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isError
                                ? (result['error'] ?? 'Withdrawal failed')
                                : (result['message'] ?? 'Withdrawal complete'),
                          ),
                          backgroundColor: isError
                              ? TradEtTheme.negative
                              : TradEtTheme.positive,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    l.withdraw,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    ),
  );
}
