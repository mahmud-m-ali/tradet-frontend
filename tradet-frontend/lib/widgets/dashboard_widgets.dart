import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../utils/asset_emoji.dart';
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
import '../screens/corporate_events_screen.dart';
import '../utils/security_challenge.dart';

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
            if (provider.reservedForOrders > 0) ...[
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 12, color: TradEtTheme.warning),
                  const SizedBox(width: 4),
                  const Text('Reserved for Orders',
                      style: TextStyle(
                          fontSize: 11, color: TradEtTheme.warning)),
                  const Spacer(),
                  Text('${fmt.format(provider.reservedForOrders)} ETB',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: TradEtTheme.warning)),
                ],
              ),
            ],
          ],
          const SizedBox(height: 8),
          // Compliance micro-badges
          Row(
            children: [
              _MicroBadge(icon: Icons.verified_rounded, label: 'ECX', color: TradEtTheme.primaryLight),
              const SizedBox(width: 8),
              _MicroBadge(icon: Icons.star_rounded, label: 'Sharia', color: TradEtTheme.positive),
              const SizedBox(width: 8),
              _MicroBadge(icon: Icons.gavel_rounded, label: 'AAOIFI', color: TradEtTheme.accent),
            ],
          ),
          if (wide) ...[
            const SizedBox(height: 10),
            // CTA buttons — desktop only
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
                              color: TradEtTheme.divider
                                  .withValues(alpha: 0.5)),
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
        ],
      ),
    );
  }
}

// ─── Micro compliance badge (used inside HeroTradeCard) ───
class _MicroBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MicroBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: color.withValues(alpha: 0.8)),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w600,
                color: color.withValues(alpha: 0.8))),
      ],
    );
  }
}

// ─── Trust / Compliance Strip (kept for backward compat, no longer used in dashboard) ───
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

// ─── Quick Action Tiles Row (mobile dashboard) ────────────────────────────────
class QuickActionsRow extends StatelessWidget {
  final void Function(int)? onNavigateTo;
  const QuickActionsRow({super.key, this.onNavigateTo});

  void _showMoreSheet(BuildContext context) {
    final l = AppLocalizations.of(context);
    final nav = onNavigateTo;
    showModalBottomSheet(
      context: context,
      backgroundColor: TradEtTheme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: TradEtTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.more,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.1,
                children: [
                  _MoreTile(icon: Icons.notifications_outlined, label: l.priceAlertsTitle, color: const Color(0xFFFBBF24), onTap: () { Navigator.pop(context); nav?.call(5); }),
                  _MoreTile(icon: Icons.newspaper_outlined, label: l.newsFeedTitle, color: const Color(0xFFF97316), onTap: () { Navigator.pop(context); nav?.call(6); }),
                  _MoreTile(icon: Icons.volunteer_activism_outlined, label: l.zakatCalculatorTitle, color: const Color(0xFF34D399), onTap: () { Navigator.pop(context); nav?.call(7); }),
                  _MoreTile(icon: Icons.currency_exchange_outlined, label: l.currencyConverter, color: const Color(0xFF22D3EE), onTap: () { Navigator.pop(context); nav?.call(8); }),
                  _MoreTile(icon: Icons.bar_chart_outlined, label: l.analytics, color: const Color(0xFF818CF8), onTap: () { Navigator.pop(context); nav?.call(9); }),
                  _MoreTile(icon: Icons.swap_horiz_outlined, label: l.transactions, color: TradEtTheme.primaryLight, onTap: () { Navigator.pop(context); nav?.call(10); }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        _QATile(
          icon: Icons.bolt_rounded,
          label: l.tradeNow,
          gradient: TradEtTheme.heroGradient,
          onTap: () => onNavigateTo?.call(1),
        ),
        const SizedBox(width: 10),
        _QATile(
          icon: Icons.add_circle_outline_rounded,
          label: l.addMoney,
          color: TradEtTheme.positive,
          onTap: () => showDepositSheet(context),
        ),
        const SizedBox(width: 10),
        _QATile(
          icon: Icons.arrow_circle_up_outlined,
          label: l.withdraw,
          color: TradEtTheme.accent,
          onTap: () => showWithdrawSheet(context),
        ),
        const SizedBox(width: 10),
        _QATile(
          icon: Icons.apps_rounded,
          label: l.more,
          color: const Color(0xFF818CF8),
          onTap: () => _showMoreSheet(context),
        ),
      ],
    );
  }
}

class _QATile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient? gradient;
  final Color? color;
  final VoidCallback onTap;

  const _QATile({
    required this.icon,
    required this.label,
    this.gradient,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null ? color!.withValues(alpha: 0.1) : null,
              borderRadius: BorderRadius.circular(14),
              border: gradient == null
                  ? Border.all(color: color!.withValues(alpha: 0.3))
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: gradient != null ? Colors.white : color, size: 22),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: gradient != null ? Colors.white : color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MoreTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Left: symbol + name + shares
          Expanded(
            flex: 3,
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
                if (holding.assetName != null && (holding.assetName as String).isNotEmpty)
                  Text(
                    holding.assetName as String,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: TradEtTheme.textSecondary),
                  ),
                Text(
                  '${holding.quantity} ${holding.unit}',
                  style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted),
                ),
              ],
            ),
          ),
          // Middle: value + PnL
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${fmt.format(holding.currentValue)} ETB',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${isPositive ? "+" : ""}${fmt.format(holding.pnl)} (${holding.pnlPercentage.toStringAsFixed(1)}%)',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isPositive ? TradEtTheme.positive : TradEtTheme.negative),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Right: Buy/Sell chips
          Consumer<AppProvider>(
            builder: (ctx, prov, _) {
              if (prov.assets.isEmpty) return const SizedBox.shrink();
              final matches = prov.assets.where(
                (a) => a.symbol == holding.symbol || a.id == holding.assetId);
              if (matches.isEmpty) return const SizedBox.shrink();
              final asset = matches.first;
              return _TradeChip(
                label: 'Sell',
                color: TradEtTheme.negative,
                big: true,
                onTap: () => Navigator.of(ctx).push(
                    appRoute(ctx, TradeScreen(asset: asset, initialSell: true))),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TradeChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool big;
  const _TradeChip({required this.label, required this.color, required this.onTap, this.big = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: big
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(big ? 10 : 6),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: big ? 13 : 10, fontWeight: FontWeight.w700, color: color)),
        ),
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

  static const _flags = {
    'USD': '🇺🇸', 'EUR': '🇪🇺', 'GBP': '🇬🇧', 'SAR': '🇸🇦',
    'AED': '🇦🇪', 'KES': '🇰🇪', 'ETB': '🇪🇹', 'CAD': '🇨🇦',
    'CHF': '🇨🇭', 'CNY': '🇨🇳', 'INR': '🇮🇳', 'JPY': '🇯🇵',
    'TRY': '🇹🇷', 'ZAR': '🇿🇦', 'EGP': '🇪🇬', 'QAR': '🇶🇦',
    'KWD': '🇰🇼', 'SGD': '🇸🇬',
  };

  Widget _rateChip(MapEntry<String, ExchangeRate> entry) {
    final flag = _flags[entry.key] ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (flag.isNotEmpty) ...[
            Text(flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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

// ─── Top Opportunities: single tabbed card, each row has a Buy button ─────────

class TopOpportunitiesSection extends StatefulWidget {
  final AppProvider provider;
  final NumberFormat fmt;

  const TopOpportunitiesSection({
    super.key,
    required this.provider,
    required this.fmt,
  });

  @override
  State<TopOpportunitiesSection> createState() =>
      _TopOpportunitiesSectionState();
}

class _TopOpportunitiesSectionState extends State<TopOpportunitiesSection> {
  int _tab = 0; // 0=Top Volume, 1=Trending

  static const _tabs = [
    (Icons.bar_chart_rounded, 'Top Volume'),
    (Icons.trending_up_rounded, 'Trending'),
  ];

  List<Asset> get _tabAssets {
    final all = widget.provider.assets
        .where((a) => a.isShariaCompliant && _isLocal(a))
        .toList();
    switch (_tab) {
      case 0:
        return ([...all]
              ..sort((a, b) => (b.volume24h ?? 0).compareTo(a.volume24h ?? 0)))
            .take(3)
            .toList();
      case 1:
        return ([...all]..sort(
                (a, b) => (b.change24h ?? 0).compareTo(a.change24h ?? 0)))
            .where((a) => (a.change24h ?? 0) > 0)
            .take(3)
            .toList();
      default:
        return [];
    }
  }

  List<Asset> _assetsForTab(int tab) {
    final all = widget.provider.assets
        .where((a) => a.isShariaCompliant && _isLocal(a))
        .toList();
    switch (tab) {
      case 0:
        return ([...all]
              ..sort((a, b) => (b.volume24h ?? 0).compareTo(a.volume24h ?? 0)))
            .take(5)
            .toList();
      case 1:
        return ([...all]..sort(
                (a, b) => (b.change24h ?? 0).compareTo(a.change24h ?? 0)))
            .where((a) => (a.change24h ?? 0) > 0)
            .take(5)
            .toList();
      default:
        return [];
    }
  }

  static const _tabColors = [
    TradEtTheme.primaryLight,
    TradEtTheme.positive,
  ];

  Widget _buildDesktopLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(2, (i) {
          final assets = _assetsForTab(i);
          final color = _tabColors[i];
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: TradEtTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                    child: Row(
                      children: [
                        Icon(_tabs[i].$1, size: 14, color: color),
                        const SizedBox(width: 6),
                        Text(_tabs[i].$2,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: color)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(
                      height: 1,
                      color: TradEtTheme.divider.withValues(alpha: 0.3)),
                  if (assets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                          child: Text('No data',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: TradEtTheme.textMuted))),
                    )
                  else
                    ...assets.map((a) =>
                        _OpportunityRow(asset: a, fmt: widget.fmt, accentColor: color)),
                ],
              ),
            ),
          );
        })
            .expand((w) => [w, const SizedBox(width: 12)])
            .toList()
          ..removeLast(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.provider.assets.isEmpty) return const SizedBox.shrink();
    final wide = isWideScreen(context);
    if (wide) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.lightbulb_rounded,
                  size: 17, color: TradEtTheme.warning),
              const SizedBox(width: 8),
              const Text('Top Opportunities',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ]),
            const SizedBox(height: 14),
            _buildDesktopLayout(),
          ],
        ),
      );
    }

    final assets = _tabAssets;
    final tabColor = _tabColors[_tab];

    return Container(
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tabColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title on its own row
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.lightbulb_rounded,
                      size: 17, color: TradEtTheme.warning),
                  const SizedBox(width: 7),
                  const Text('Top Opportunities',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ]),
                const SizedBox(height: 10),
                // Tab pills row
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: TradEtTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: List.generate(_tabs.length, (i) {
                      final sel = _tab == i;
                      final color = _tabColors[i];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tab = i),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: sel
                                    ? color.withValues(alpha: 0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(7),
                                border: sel
                                    ? Border.all(
                                        color: color.withValues(alpha: 0.4))
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(_tabs[i].$1,
                                      size: 13,
                                      color: sel
                                          ? color
                                          : TradEtTheme.textMuted),
                                  const SizedBox(width: 5),
                                  Text(_tabs[i].$2,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: sel
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: sel
                                              ? color
                                              : TradEtTheme.textMuted)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
          // Asset rows
          if (assets.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                  child: Text('No data',
                      style: TextStyle(
                          fontSize: 12, color: TradEtTheme.textMuted))),
            )
          else
            ...assets.map((asset) => _OpportunityRow(
                  asset: asset,
                  fmt: widget.fmt,
                  accentColor: tabColor,
                )),
        ],
      ),
    );
  }
}

class _OpportunityRow extends StatelessWidget {
  final Asset asset;
  final NumberFormat fmt;
  final Color accentColor;
  const _OpportunityRow(
      {required this.asset, required this.fmt, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final isUp = (asset.change24h ?? 0) >= 0;
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(appRoute(context, TradeScreen(asset: asset))),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: TradEtTheme.divider.withValues(alpha: 0.2)),
            ),
          ),
          child: Row(
            children: [
              // Logo circle
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                ),
                alignment: Alignment.center,
                child: Text(_assetEmoji(asset.symbol, asset.categoryName),
                    style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              // Symbol + name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.symbol,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Text(asset.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10, color: TradEtTheme.textMuted)),
                  ],
                ),
              ),
              // Price + change
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    asset.price != null ? fmt.format(asset.price) : '--',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  if (asset.change24h != null)
                    Text(
                      '${isUp ? "+" : ""}${asset.change24h!.toStringAsFixed(2)}%',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color:
                              isUp ? TradEtTheme.positive : TradEtTheme.negative),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Buy button
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(appRoute(context, TradeScreen(asset: asset))),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      gradient: TradEtTheme.heroGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Buy',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
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
    final content = Column(
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
                    Expanded(child: _tab(l.topGainers, true)),
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
                  ? webTopMoversSection(widget.provider, widget.fmt, widget.desktop)
                  : topMoversSection(widget.provider, widget.fmt))
            : (widget.webMode
                  ? webTopLosersSection(widget.provider, widget.fmt, widget.desktop)
                  : topLosersSection(widget.provider, widget.fmt)),
      ],
    );
    // Wrap in a titled card for visual separation (mobile and desktop)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart_rounded, size: 18, color: TradEtTheme.positive),
              const SizedBox(width: 8),
              Text(l.topMovers,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 14),
          content,
        ],
      ),
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

// 4-column grid for mobile movers — no sparklines, just icon + symbol + change%
Widget _mobileMoversGrid(List<dynamic> assets) {
  if (assets.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('No data', style: TextStyle(color: TradEtTheme.textMuted, fontSize: 13)),
    );
  }
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 14,
      mainAxisSpacing: 18,
      childAspectRatio: 0.78,
    ),
    itemCount: assets.length,
    itemBuilder: (context, i) => _MoverGridItem(asset: assets[i]),
  );
}

// Delegates to shared utility in lib/utils/asset_emoji.dart
String _assetEmoji(String symbol, String? categoryName) =>
    assetEmoji(symbol, categoryName);

Widget topMoversSection(AppProvider provider, NumberFormat fmt) {
  if (provider.assetsLoading && provider.assets.isEmpty) {
    return const Center(child: Padding(padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(color: TradEtTheme.positive)));
  }
  if (provider.assetsError != null && provider.assets.isEmpty) {
    return ErrorRetryWidget(message: provider.assetsError!, onRetry: () => provider.loadAssets());
  }
  return _mobileMoversGrid(getTopMovers(provider).take(3).toList());
}

Widget topLosersSection(AppProvider provider, NumberFormat fmt) {
  if (provider.assets.isEmpty) return const SizedBox.shrink();
  return _mobileMoversGrid(getTopLosers(provider).take(3).toList());
}

class _MoverGridItem extends StatelessWidget {
  final dynamic asset;
  const _MoverGridItem({required this.asset});

  Color get _color {
    final isUp = (asset.change24h ?? 0) >= 0;
    return isUp ? TradEtTheme.positive : TradEtTheme.negative;
  }

  Color get _bgColor {
    switch (asset.categoryName) {
      case 'Islamic Banks': return TradEtTheme.positive;
      case 'Takaful & Insurance': return TradEtTheme.accent;
      case 'Sukuk': return const Color(0xFF22D3EE);
      case 'Ethiopian Equities': return const Color(0xFFF472B6);
      default: return const Color(0xFFFBBF24);
    }
  }

  @override
  Widget build(BuildContext context) {
    final change = asset.change24h;
    final isUp = (change ?? 0) >= 0;
    final symbol = (asset.symbol as String);
    final emoji = _assetEmoji(symbol, asset.categoryName as String?);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(appRoute(context, TradeScreen(asset: asset))),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _bgColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: _bgColor.withValues(alpha: 0.4), width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(height: 7),
            Text(symbol,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center),
            if (change != null) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isUp ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                    size: 14,
                    color: _color,
                  ),
                  Text(
                    '${change.abs().toStringAsFixed(2)}%',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600, color: _color),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
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
        mainAxisSpacing: 18,
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
        mainAxisSpacing: 18,
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

/// Returns true for Ethiopian market assets (excludes foreign/global equities).
bool _isLocal(dynamic a) =>
    a.categoryName?.toLowerCase().contains('global') != true;

List<dynamic> getTopMovers(AppProvider provider) {
  final gainers = provider.assets
      .where((a) => _isLocal(a) && (a.change24h ?? 0) > 0)
      .toList()
    ..sort((a, b) => (b.change24h ?? 0).compareTo(a.change24h ?? 0));
  return gainers.take(6).toList();
}

List<dynamic> getTopLosers(AppProvider provider) {
  final losers = provider.assets
      .where((a) => _isLocal(a) && (a.change24h ?? 0) < 0)
      .toList()
    ..sort((a, b) => (a.change24h ?? 0).compareTo(b.change24h ?? 0));
  return losers.take(6).toList();
}

// ─── Watchlist Mini Section (Dashboard) ────────────────────────────────────

class WatchlistMiniSection extends StatelessWidget {
  final AppProvider provider;
  final NumberFormat fmt;
  final void Function(int)? onNavigateTo;

  const WatchlistMiniSection({
    super.key,
    required this.provider,
    required this.fmt,
    this.onNavigateTo,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = isWideScreen(context);
    final items = provider.watchlist.take(isWide ? 5 : 3).toList();

    return Container(
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFF8C00)),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text('Watchlist',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                GestureDetector(
                  onTap: onNavigateTo != null
                      ? () => onNavigateTo!(4)
                      : null,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('See all',
                            style: TextStyle(fontSize: 12, color: TradEtTheme.primaryLight)),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right_rounded,
                            size: 16, color: TradEtTheme.primaryLight),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.star_outline_rounded,
                        size: 28, color: TradEtTheme.textMuted),
                    const SizedBox(height: 6),
                    const Text('No watchlist items',
                        style: TextStyle(fontSize: 12, color: TradEtTheme.textMuted)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onNavigateTo != null ? () => onNavigateTo!(1) : null,
                      child: const Text('Browse Market →',
                          style: TextStyle(
                              fontSize: 12,
                              color: TradEtTheme.primaryLight,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            )
          else
            ...items.map((asset) => _WatchlistMiniRow(asset: asset, fmt: fmt)),
        ],
      ),
    );
  }
}

class _WatchlistMiniRow extends StatelessWidget {
  final dynamic asset;
  final NumberFormat fmt;
  const _WatchlistMiniRow({required this.asset, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isUp = (asset.change24h ?? 0) >= 0;
    final emoji = _assetEmoji(
        asset.symbol as String, asset.categoryName as String?);

    Color bgColor;
    switch (asset.categoryName) {
      case 'Islamic Banks': bgColor = TradEtTheme.positive; break;
      case 'Takaful & Insurance': bgColor = TradEtTheme.accent; break;
      case 'Sukuk': bgColor = const Color(0xFF22D3EE); break;
      case 'Ethiopian Equities': bgColor = const Color(0xFFF472B6); break;
      default: bgColor = const Color(0xFFFBBF24);
    }

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(appRoute(context, TradeScreen(asset: asset))),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.15)),
            ),
          ),
          child: Row(
            children: [
              // Logo circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bgColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: bgColor.withValues(alpha: 0.35)),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              // Symbol + name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.symbol as String,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Text(asset.name as String,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: TradEtTheme.textMuted)),
                  ],
                ),
              ),
              // Price + change (fixed width for alignment)
              SizedBox(
                width: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      asset.price != null ? fmt.format(asset.price) : '—',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    if (asset.change24h != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isUp
                                ? Icons.arrow_drop_up_rounded
                                : Icons.arrow_drop_down_rounded,
                            size: 14,
                            color: isUp ? TradEtTheme.positive : TradEtTheme.negative,
                          ),
                          Text(
                            '${asset.change24h!.abs().toStringAsFixed(2)}%',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isUp
                                    ? TradEtTheme.positive
                                    : TradEtTheme.negative),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
                    // Auth required for withdrawals ≥ 5,000 ETB
                    if (amount >= kWealthProtectionWithdrawalThreshold) {
                      final authed = await challengeTransactionAuth(
                        context,
                        reason:
                            'Authenticate to withdraw ${amount.toStringAsFixed(2)} ETB',
                      );
                      if (!authed) return;
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

// ─── Market Strip ─────────────────────────────────────────────────────────────
// Dropdown category filter + paginated asset row with prev/next arrows.
// Only shows ECX-listed (Ethiopian) Sharia-compliant assets.

class MarketStrip extends StatefulWidget {
  final AppProvider provider;
  final NumberFormat fmt;
  final void Function(int)? onNavigateTo;
  const MarketStrip({super.key, required this.provider, required this.fmt, this.onNavigateTo});

  @override
  State<MarketStrip> createState() => _MarketStripState();
}

class _MarketStripState extends State<MarketStrip> {
  String _category = 'all';
  int _page = 0;

  static const _categories = [
    ('all', 'All'),
    ('commodity', 'Commodities'),
    ('equity', 'Equities'),
    ('sukuk', 'Sukuk'),
    ('metal', 'Metals'),
  ];

  // Only local Ethiopian assets (ECX listed or non-global), no foreign equities
  List<Asset> get _assets {
    final src = widget.provider.assets
        .where((a) => a.isShariaCompliant && _isLocal(a))
        .toList();
    if (_category == 'all') return src;
    return src.where((a) => a.categoryType == _category).toList();
  }

  int _pageSize(bool wide) => wide ? 6 : 3;

  List<Asset> _pageAssets(bool wide) {
    final all = _assets;
    if (all.isEmpty) return [];
    final size = _pageSize(wide);
    final start = (_page * size).clamp(0, all.length);
    final end = (start + size).clamp(0, all.length);
    return all.sublist(start, end);
  }

  int _maxPage(bool wide) {
    final total = _assets.length;
    if (total == 0) return 0;
    return ((total - 1) / _pageSize(wide)).floor();
  }

  void _setCategory(String cat) {
    setState(() {
      _category = cat;
      _page = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);

    if (widget.provider.assetsLoading && widget.provider.assets.isEmpty) {
      return const SizedBox(height: 70,
          child: Center(child: CircularProgressIndicator(
              strokeWidth: 2, color: TradEtTheme.positive)));
    }
    if (widget.provider.assets.isEmpty) return const SizedBox.shrink();

    final visible = _pageAssets(wide);
    final maxPage = _maxPage(wide);
    final hasPrev = _page > 0;
    final hasNext = _page < maxPage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.25)),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        // Compute card width: total width minus dropdown (~108), arrows (66), gaps
        const dropdownW = 108.0;
        const arrowsW = 66.0; // 2×28px + spacing
        const outerGap = 10.0 + 4.0; // gap after dropdown + gap before arrows
        final ps = _pageSize(wide);
        final cardGaps = (ps - 1) * 8.0;
        final cardsAreaW = constraints.maxWidth - dropdownW - arrowsW - outerGap;
        final cardW = ((cardsAreaW - cardGaps) / ps).clamp(60.0, 260.0);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Category dropdown — always show all categories
            _CategoryDropdown(
              value: _category,
              items: _categories.toList(),
              onChanged: _setCategory,
            ),
            const SizedBox(width: 10),
            // Asset cards — fixed width, aligned left (no expansion when fewer items)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: visible.isEmpty
                    ? [const Text('No assets',
                        style: TextStyle(fontSize: 11, color: TradEtTheme.textMuted))]
                    : visible.map((a) {
                        final isUp = (a.change24h ?? 0) >= 0;
                        return GestureDetector(
                          onTap: () => Navigator.of(context)
                              .push(appRoute(context, TradeScreen(asset: a))),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              width: cardW,
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: TradEtTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: TradEtTheme.divider.withValues(alpha: 0.2)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(a.symbol,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                      ),
                                      if (a.sparkline.length >= 2)
                                        MiniSparkline(
                                            data: a.sparkline,
                                            height: 20,
                                            width: 30),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    a.price != null ? widget.fmt.format(a.price) : '--',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (a.change24h != null)
                                    Text(
                                      '${isUp ? "+" : ""}${a.change24h!.toStringAsFixed(2)}%',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isUp
                                              ? TradEtTheme.positive
                                              : TradEtTheme.negative),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
              ),
            ),
            const SizedBox(width: 4),
            // Prev / Next arrows — only shown when usable
            if (hasPrev)
              _ArrowBtn(
                icon: Icons.chevron_left_rounded,
                enabled: true,
                onTap: () => setState(() => _page--),
              )
            else
              const SizedBox(width: 28, height: 28),
            const SizedBox(width: 2),
            if (hasNext)
              _ArrowBtn(
                icon: Icons.chevron_right_rounded,
                enabled: true,
                onTap: () => setState(() => _page++),
              )
            else
              const SizedBox(width: 28, height: 28),
          ],
        );
      }),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final String value;
  final List<(String, String)> items;
  final void Function(String) onChanged;
  const _CategoryDropdown(
      {required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: TradEtTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: TradEtTheme.positive.withValues(alpha: 0.35)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 14, color: TradEtTheme.positive),
          dropdownColor: const Color(0xFF1A3A25),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: TradEtTheme.positive),
          items: items
              .map((c) => DropdownMenuItem(
                    value: c.$1,
                    child: Text(c.$2),
                  ))
              .toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}

class _ArrowBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _ArrowBtn(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: MouseRegion(
        cursor:
            enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: TradEtTheme.primaryLight.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: TradEtTheme.primaryLight.withValues(alpha: 0.5)),
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

// ─── Holdings + Orders Tabbed Card ────────────────────────────────────────────

class HoldingsOrdersTabCard extends StatefulWidget {
  final AppProvider provider;
  final NumberFormat fmt;
  final void Function(int)? onNavigateTo;
  const HoldingsOrdersTabCard({
    super.key,
    required this.provider,
    required this.fmt,
    this.onNavigateTo,
  });

  @override
  State<HoldingsOrdersTabCard> createState() => _HoldingsOrdersTabCardState();
}

class _HoldingsOrdersTabCardState extends State<HoldingsOrdersTabCard> {
  int _tab = 0; // 0 = Holdings, 1 = Orders

  @override
  Widget build(BuildContext context) {
    final hasHoldings = widget.provider.holdings.isNotEmpty;
    final hasOrders = widget.provider.orders.isNotEmpty;
    final l = AppLocalizations.of(context);
    final wide = isWideScreen(context);

    // ── Desktop: two side-by-side sub-cards (same pattern as TopOpportunitiesSection) ──
    if (wide) {
      const subCards = [
        (Icons.pie_chart_rounded, 'Your Holdings', TradEtTheme.primaryLight),
        (Icons.receipt_long_rounded, 'Recent Orders', TradEtTheme.accent),
      ];

      Widget buildSubCard(int i) {
        final icon = subCards[i].$1;
        final label = subCards[i].$2;
        final color = subCards[i].$3;
        final isEmpty = i == 0 ? !hasHoldings : !hasOrders;

        Widget content;
        if (i == 0) {
          content = hasHoldings
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ...widget.provider.holdings.take(4).map((h) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: HoldingTile(holding: h, fmt: widget.fmt),
                      )),
                  if (widget.provider.holdings.length > 4)
                    _viewAllBtn('View all holdings', () => widget.onNavigateTo?.call(2)),
                ])
              : _emptyHoldings(context);
        } else {
          content = hasOrders
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ...widget.provider.orders.take(4).map((o) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OrderTile(order: o, fmt: widget.fmt),
                      )),
                  if (widget.provider.orders.length > 4)
                    _viewAllBtn('View all orders', () => widget.onNavigateTo?.call(3)),
                ])
              : _emptyState(Icons.receipt_long_outlined, 'No recent orders');
        }

        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                  child: Row(
                    children: [
                      Icon(icon, size: 14, color: color),
                      const SizedBox(width: 6),
                      Text(label,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: color)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
                if (isEmpty)
                  content
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: content,
                  ),
              ],
            ),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.bar_chart_rounded, size: 18, color: TradEtTheme.accent),
              const SizedBox(width: 8),
              const Text('Activity',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ]),
            const SizedBox(height: 14),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildSubCard(0),
                  const SizedBox(width: 12),
                  buildSubCard(1),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ── Mobile: tabbed layout ─────────────────────────────────────────────────
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, size: 18, color: TradEtTheme.accent),
              const SizedBox(width: 8),
              const Text('Activity',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 14),
          // Tab switcher
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: TradEtTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: _tabBtn(l.yourHoldings, 0)),
                const SizedBox(width: 3),
                Expanded(child: _tabBtn(l.recentOrders, 1)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Content
          if (_tab == 0) ...[
            if (!hasHoldings) _emptyHoldings(context)
            else ...[
              ...widget.provider.holdings.take(3).map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: HoldingTile(holding: h, fmt: widget.fmt),
              )),
              if (widget.provider.holdings.length > 3)
                _viewAllBtn('View all holdings', () => widget.onNavigateTo?.call(2)),
            ],
          ] else ...[
            if (!hasOrders) _emptyState(Icons.receipt_long_outlined, 'No recent orders')
            else ...[
              ...widget.provider.orders.take(3).map((o) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OrderTile(order: o, fmt: widget.fmt),
              )),
              if (widget.provider.orders.length > 3)
                _viewAllBtn('View all orders', () => widget.onNavigateTo?.call(3)),
            ],
          ],
        ],
      ),
    );
  }

  Widget _tabBtn(String label, int idx) {
    final sel = _tab == idx;
    return GestureDetector(
      onTap: () => setState(() => _tab = idx),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: sel ? TradEtTheme.cardBgLight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    color: sel ? Colors.white : TradEtTheme.textMuted)),
          ),
        ),
      ),
    );
  }

  Widget _emptyHoldings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: TradEtTheme.positive.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.add_chart_rounded, size: 32, color: TradEtTheme.positive),
          const SizedBox(height: 10),
          const Text('Your portfolio is empty',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 4),
          const Text('Browse the market to place your first\nSharia-compliant trade',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: TradEtTheme.textSecondary)),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => widget.onNavigateTo?.call(1),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: TradEtTheme.heroGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Browse Market',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(IconData icon, String msg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 28, color: TradEtTheme.textMuted),
            const SizedBox(height: 8),
            Text(msg,
                style: const TextStyle(
                    fontSize: 12, color: TradEtTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _viewAllBtn(String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      color: TradEtTheme.primaryLight,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded,
                  size: 13, color: TradEtTheme.primaryLight),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Corporate Events Card ────────────────────────────────────────────────────

class CorporateEventsCard extends StatelessWidget {
  const CorporateEventsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Show the next 3 upcoming events from today
    final upcoming = corporateEvents
        .where((e) =>
            e.date.isAfter(now.subtract(const Duration(days: 1))))
        .take(3)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row — title + "See all" arrow
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
            child: Row(
              children: [
                const Icon(Icons.event_note_rounded,
                    size: 16, color: TradEtTheme.primaryLight),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Corporate Events',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
                GestureDetector(
                  onTap: () {
                    if (isWideScreen(context)) {
                      context.read<AppProvider>().navigateGlobal(12);
                    } else {
                      Navigator.of(context)
                          .push(appRoute(context, const CorporateEventsScreen()));
                    }
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          Text('See all',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: TradEtTheme.primaryLight
                                      .withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 2),
                          const Icon(Icons.chevron_right_rounded,
                              size: 16, color: TradEtTheme.primaryLight),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Event rows
          if (upcoming.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('No upcoming events',
                    style: TextStyle(
                        fontSize: 13, color: TradEtTheme.textMuted)),
              ),
            )
          else
            ...upcoming.map((e) => _EventPreviewRow(event: e)),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _EventPreviewRow extends StatelessWidget {
  final CorporateEvent event;
  const _EventPreviewRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.type);
    final emoji = event.assetSymbol.isNotEmpty
        ? assetEmoji(event.assetSymbol, null)
        : _holidayEmoji(event.assetName);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          // Date column
          SizedBox(
            width: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(event.date.day.toString(),
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1)),
                Text(DateFormat('MMM').format(event.date),
                    style: const TextStyle(
                        fontSize: 10,
                        color: TradEtTheme.textMuted,
                        height: 1.1)),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Event card
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child:
                            Text(emoji, style: const TextStyle(fontSize: 15))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.assetName,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                        Text(event.detail ?? _eventLabel(event.type),
                            style: TextStyle(
                                fontSize: 11,
                                color: color.withValues(alpha: 0.85)),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _holidayEmoji(String name) {
    final n = name.toLowerCase();
    if (n.contains('christmas') || n.contains('genna')) return '🎄';
    if (n.contains('epiphany') || n.contains('timkat')) return '✝️';
    if (n.contains('adwa')) return '🦁';
    if (n.contains('easter') || n.contains('fasika') || n.contains('good friday')) return '✝️';
    if (n.contains('labour') || n.contains('labor')) return '👷';
    if (n.contains('patriots')) return '⚔️';
    if (n.contains('derg') || n.contains('downfall')) return '🇪🇹';
    if (n.contains('new year') || n.contains('enkutatash')) return '🌸';
    if (n.contains('meskel') || n.contains('cross')) return '✝️';
    return '🗓️';
  }
}

Color _eventColor(CorporateEventType type) {
  switch (type) {
    case CorporateEventType.earnings:
      return TradEtTheme.primaryLight;
    case CorporateEventType.agm:
      return TradEtTheme.accent;
    case CorporateEventType.dividend:
      return TradEtTheme.positive;
    case CorporateEventType.marketHoliday:
      return const Color(0xFFF59E0B);
    case CorporateEventType.ecxSession:
      return const Color(0xFF8B5CF6);
  }
}

String _eventLabel(CorporateEventType type) {
  switch (type) {
    case CorporateEventType.earnings:
      return 'Earnings / Report';
    case CorporateEventType.agm:
      return 'Annual Meeting';
    case CorporateEventType.dividend:
      return 'Profit Share';
    case CorporateEventType.marketHoliday:
      return 'Market Holiday';
    case CorporateEventType.ecxSession:
      return 'ECX Session';
  }
}
