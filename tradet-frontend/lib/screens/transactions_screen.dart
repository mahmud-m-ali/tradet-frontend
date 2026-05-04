import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../utils/ethiopian_date.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/disclaimer_footer.dart';
import '../widgets/export_sheet.dart';
import '../widgets/security_log_section.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await context.read<AppProvider>().loadTransactions();
    if (mounted) setState(() => _loading = false);
  }

  void _showExportSheet(BuildContext context, List<Transaction> txns) {
    final l = AppLocalizations.of(context);
    final fmt = NumberFormat('#,##0.00', 'en');
    showExportSheet(
      context,
      title: l.transactions,
      subtitle: l.recordsCount(txns.length),
      pdfTitle: l.transactionStatement,
      headers: [l.type, l.description, l.amountEtb, l.balanceAfterEtb, l.date],
      rows: txns.map((tx) => [
        _txTypeLabel(tx.transactionType, l),
        tx.description ?? '—',
        '${tx.isCredit ? '+' : '-'}${fmt.format(tx.amount)}',
        fmt.format(tx.balanceAfter),
        tx.createdAt,
      ]).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fmt = NumberFormat('#,##0.00', 'en');
    final wide = isWideScreen(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        Expanded(
                          child: Text(l.transactions,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5)),
                        ),
                        Consumer<AppProvider>(
                          builder: (context, provider, _) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (provider.transactions.isNotEmpty)
                                GestureDetector(
                                  onTap: () => _showExportSheet(context, provider.transactions),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Container(
                                      width: 40, height: 40,
                                      decoration: BoxDecoration(
                                        color: TradEtTheme.cardBg,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: TradEtTheme.divider),
                                      ),
                                      child: const Icon(Icons.download_rounded,
                                          size: 20, color: TradEtTheme.primaryLight),
                                    ),
                                  ),
                                ),
                              if (provider.transactions.isNotEmpty)
                                const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _load,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Container(
                                    width: 40, height: 40,
                                    decoration: BoxDecoration(
                                      color: TradEtTheme.cardBg,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: TradEtTheme.divider),
                                    ),
                                    child: const Icon(Icons.refresh_rounded,
                                        size: 20, color: TradEtTheme.textSecondary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: !wide && Navigator.of(context).canPop() ? 36 : 0),
                      child: Text(l.cashBalance,
                          style: const TextStyle(
                              fontSize: 13,
                              color: TradEtTheme.textSecondary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Balance summary
              Padding(
                padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 20),
                child: Consumer<AppProvider>(
                  builder: (context, provider, _) {
                    final balance = provider.portfolioSummary?.cashBalance
                        ?? provider.user?.walletBalance ?? 0;
                    final reserved = provider.reservedForOrders;
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: TradEtTheme.heroGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.cashBalance,
                                    style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.7),
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('${fmt.format(balance)} ETB',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800)),
                                if (reserved > 0) ...[
                                  const SizedBox(height: 4),
                                  Text(l.etbReservedInOrders(fmt.format(reserved)),
                                      style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.6),
                                          fontSize: 11)),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(l.available,
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 11)),
                              const SizedBox(height: 4),
                              Text('${fmt.format(provider.availableCashBalance)} ETB',
                                  style: const TextStyle(
                                      color: TradEtTheme.positive,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Transaction list
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(color: TradEtTheme.positive))
                    : Consumer<AppProvider>(
                        builder: (context, provider, _) {
                          if (provider.transactions.isEmpty) {
                            return _emptyState();
                          }
                          return RefreshIndicator(
                            color: TradEtTheme.positive,
                            backgroundColor: TradEtTheme.cardBg,
                            onRefresh: _load,
                            child: wide
                                ? _buildWebTable(provider.transactions, fmt)
                                : _buildMobileList(provider.transactions, fmt),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: TradEtTheme.cardBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_outlined,
                size: 48, color: TradEtTheme.textMuted),
          ),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context).noTransactionsYet,
              style: const TextStyle(fontWeight: FontWeight.w600,
                  fontSize: 16, color: Colors.white)),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context).depositEtb,
              style: const TextStyle(color: TradEtTheme.textMuted, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildMobileList(List<Transaction> txns, NumberFormat fmt) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      itemCount: txns.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        if (i == txns.length) {
          return const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 4),
            child: Column(
              children: [
                SecurityLogSection(),
                SizedBox(height: 12),
                DisclaimerFooter(),
              ],
            ),
          );
        }
        return _MobileTxCard(tx: txns[i], fmt: fmt);
      },
    );
  }

  Widget _buildWebTable(List<Transaction> txns, NumberFormat fmt) {
    final l = AppLocalizations.of(context);
    final wide = isWideScreen(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: TradEtTheme.primaryDark.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                SizedBox(width: 130, child: _TH(l.type)),
                Expanded(flex: 3, child: _TH(l.description)),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TH(l.amountEtb))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TH(l.balanceAfter))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TH(l.date))),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.3)),
                  right: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.3)),
                  bottom: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.3)),
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              child: ListView.builder(
                itemCount: txns.length + 1,
                itemBuilder: (_, i) {
                  if (i == txns.length) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        children: [
                          SecurityLogSection(),
                          SizedBox(height: 12),
                          DisclaimerFooter(),
                        ],
                      ),
                    );
                  }
                  return _WebTxRow(tx: txns[i], fmt: fmt, isEven: i.isEven);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _txTypeLabel(String type, AppLocalizations l) {
  return switch (type) {
    'deposit' => l.txDeposit,
    'withdraw' => l.txWithdrawal,
    'trade_buy' => l.txTradeBuy,
    'trade_sell' => l.txTradeSell,
    'refund' => l.txRefund,
    _ => type.replaceAll('_', ' ').toUpperCase(),
  };
}

Color _txTypeColor(String type) {
  return switch (type) {
    'deposit' || 'trade_sell' || 'refund' => TradEtTheme.positive,
    'withdraw' || 'trade_buy' => TradEtTheme.negative,
    _ => TradEtTheme.textMuted,
  };
}

IconData _txIcon(String type) {
  return switch (type) {
    'deposit' => Icons.add_circle_outline,
    'withdraw' => Icons.remove_circle_outline,
    'trade_buy' => Icons.trending_up_rounded,
    'trade_sell' => Icons.trending_down_rounded,
    'refund' => Icons.undo_rounded,
    _ => Icons.swap_horiz_rounded,
  };
}

class _MobileTxCard extends StatelessWidget {
  final Transaction tx;
  final NumberFormat fmt;
  const _MobileTxCard({required this.tx, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = _txTypeColor(tx.transactionType);
    final isCredit = tx.isCredit;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_txIcon(tx.transactionType), color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_txTypeLabel(tx.transactionType, l),
                    style: const TextStyle(fontWeight: FontWeight.w600,
                        fontSize: 14, color: Colors.white)),
                if (tx.description != null) ...[
                  const SizedBox(height: 2),
                  Text(tx.description!,
                      style: const TextStyle(fontSize: 11,
                          color: TradEtTheme.textMuted),
                      overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 2),
                Text(
                    EthiopianDate.formatIso(tx.createdAt,
                        context.read<AppProvider>().langCode),
                    style: const TextStyle(fontSize: 10,
                        color: TradEtTheme.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}${fmt.format(tx.amount)} ETB',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: color),
              ),
              const SizedBox(height: 2),
              Text('${fmt.format(tx.balanceAfter)} ETB',
                  style: const TextStyle(fontSize: 10,
                      color: TradEtTheme.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebTxRow extends StatelessWidget {
  final Transaction tx;
  final NumberFormat fmt;
  final bool isEven;
  const _WebTxRow({required this.tx, required this.fmt, required this.isEven});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = _txTypeColor(tx.transactionType);
    final isCredit = tx.isCredit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isEven ? TradEtTheme.cardBg.withValues(alpha: 0.3) : Colors.transparent,
        border: Border(bottom: BorderSide(
            color: TradEtTheme.divider.withValues(alpha: 0.15))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_txIcon(tx.transactionType), color: color, size: 14),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(_txTypeLabel(tx.transactionType, l),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                          color: color),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(tx.description ?? '—',
                style: const TextStyle(fontSize: 12, color: TradEtTheme.textSecondary),
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${isCredit ? '+' : '-'}${fmt.format(tx.amount)} ETB',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('${fmt.format(tx.balanceAfter)} ETB',
                style: const TextStyle(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 1,
            child: Text(
                EthiopianDate.formatIso(tx.createdAt,
                    context.read<AppProvider>().langCode),
                style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
            color: TradEtTheme.textMuted, letterSpacing: 0.5));
  }
}

