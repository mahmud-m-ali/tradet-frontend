import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';

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

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en');
    final wide = isWideScreen(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: HalalEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: HalalEtTheme.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: HalalEtTheme.divider),
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transactions',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5)),
                          Text('ግብይቶች • Cash ledger',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: HalalEtTheme.textSecondary)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _load,
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
                        gradient: HalalEtTheme.heroGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Cash Balance',
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
                                  Text('${fmt.format(reserved)} ETB reserved in open orders',
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
                              Text('Available',
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 11)),
                              const SizedBox(height: 4),
                              Text('${fmt.format(provider.availableCashBalance)} ETB',
                                  style: const TextStyle(
                                      color: HalalEtTheme.positive,
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
                        child: CircularProgressIndicator(color: HalalEtTheme.positive))
                    : Consumer<AppProvider>(
                        builder: (context, provider, _) {
                          if (provider.transactions.isEmpty) {
                            return _emptyState();
                          }
                          return RefreshIndicator(
                            color: HalalEtTheme.positive,
                            backgroundColor: HalalEtTheme.cardBg,
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
              color: HalalEtTheme.cardBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_outlined,
                size: 48, color: HalalEtTheme.textMuted),
          ),
          const SizedBox(height: 16),
          const Text('No transactions yet',
              style: TextStyle(fontWeight: FontWeight.w600,
                  fontSize: 16, color: Colors.white)),
          const SizedBox(height: 4),
          const Text('Deposit funds to get started',
              style: TextStyle(color: HalalEtTheme.textMuted, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildMobileList(List<Transaction> txns, NumberFormat fmt) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: txns.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _MobileTxCard(tx: txns[i], fmt: fmt),
    );
  }

  Widget _buildWebTable(List<Transaction> txns, NumberFormat fmt) {
    final wide = isWideScreen(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: HalalEtTheme.primaryDark.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                SizedBox(width: 130, child: _TH('Type')),
                Expanded(flex: 3, child: _TH('Description')),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TH('Amount'))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TH('Balance After'))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TH('Date'))),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
                  right: BorderSide(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
                  bottom: BorderSide(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              child: ListView.builder(
                itemCount: txns.length,
                itemBuilder: (_, i) => _WebTxRow(tx: txns[i], fmt: fmt, isEven: i.isEven),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _txTypeLabel(String type) {
  return switch (type) {
    'deposit' => 'Deposit',
    'withdraw' => 'Withdrawal',
    'trade_buy' => 'Trade Buy',
    'trade_sell' => 'Trade Sell',
    'refund' => 'Refund',
    _ => type.replaceAll('_', ' ').toUpperCase(),
  };
}

Color _txTypeColor(String type) {
  return switch (type) {
    'deposit' || 'trade_sell' || 'refund' => HalalEtTheme.positive,
    'withdraw' || 'trade_buy' => HalalEtTheme.negative,
    _ => HalalEtTheme.textMuted,
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
    final color = _txTypeColor(tx.transactionType);
    final isCredit = tx.isCredit;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
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
                Text(_txTypeLabel(tx.transactionType),
                    style: const TextStyle(fontWeight: FontWeight.w600,
                        fontSize: 14, color: Colors.white)),
                if (tx.description != null) ...[
                  const SizedBox(height: 2),
                  Text(tx.description!,
                      style: const TextStyle(fontSize: 11,
                          color: HalalEtTheme.textMuted),
                      overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 2),
                Text(tx.createdAt,
                    style: const TextStyle(fontSize: 10,
                        color: HalalEtTheme.textMuted)),
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
                      color: HalalEtTheme.textMuted)),
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
    final color = _txTypeColor(tx.transactionType);
    final isCredit = tx.isCredit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isEven ? HalalEtTheme.cardBg.withValues(alpha: 0.3) : Colors.transparent,
        border: Border(bottom: BorderSide(
            color: HalalEtTheme.divider.withValues(alpha: 0.15))),
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
                  child: Text(_txTypeLabel(tx.transactionType),
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
                style: const TextStyle(fontSize: 12, color: HalalEtTheme.textSecondary),
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
            child: Text(tx.createdAt,
                style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted),
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
            color: HalalEtTheme.textMuted, letterSpacing: 0.5));
  }
}
