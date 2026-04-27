import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../utils/ethiopian_date.dart';
import '../widgets/export_sheet.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/disclaimer_footer.dart';
import 'trade_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();

  static void showOrderActions(BuildContext context, Order order) {
    if (!order.isPending) return;
    showResponsiveSheet<void>(
      context: context,
      backgroundColor: TradEtTheme.cardBg,
      builder: (ctx, isDialog) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isDialog)
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: TradEtTheme.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            if (isDialog)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (order.orderType == 'buy'
                            ? TradEtTheme.positive
                            : TradEtTheme.negative)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.orderType.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: order.orderType == 'buy'
                          ? TradEtTheme.positive
                          : TradEtTheme.negative,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(order.symbol,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
                const SizedBox(width: 8),
                Text(order.assetName,
                    style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${order.quantity} × ${order.price.toStringAsFixed(2)} ETB  |  Total: ${order.totalAmount.toStringAsFixed(2)} ETB',
              style: const TextStyle(fontSize: 13, color: TradEtTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                Navigator.pop(ctx);
                final l = AppLocalizations.of(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dCtx) => AlertDialog(
                    backgroundColor: TradEtTheme.cardBg,
                    title: Text('${l.cancel} ${l.orders}',
                        style: const TextStyle(color: Colors.white)),
                    content: Text(
                      '${l.cancel} ${order.orderType.toUpperCase()} ${l.orders.toLowerCase()} ${order.symbol}?',
                      style: const TextStyle(color: TradEtTheme.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dCtx, false),
                        child: Text(l.cancel,
                            style: const TextStyle(color: TradEtTheme.textSecondary)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: TradEtTheme.negative),
                        onPressed: () => Navigator.pop(dCtx, true),
                        child: Text('${l.cancel} ${l.orders}'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  final result =
                      await context.read<AppProvider>().cancelOrder(order.id);
                  if (context.mounted) {
                    final isError = result.containsKey('error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isError
                            ? (result['error'] ?? AppLocalizations.of(context).failedToCancelOrder)
                            : AppLocalizations.of(context).orderCancelledSuccess),
                        backgroundColor:
                            isError ? TradEtTheme.negative : TradEtTheme.positive,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: TradEtTheme.negative.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: TradEtTheme.negative.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cancel_outlined,
                          color: TradEtTheme.negative, size: 20),
                      const SizedBox(width: 12),
                      Text('${AppLocalizations.of(context).cancel} ${AppLocalizations.of(context).orders}',
                          style: const TextStyle(
                              color: TradEtTheme.negative,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1 && !_tabController.indexIsChanging) {
        context.read<AppProvider>().loadOrderEvents();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en');
    final wide = isWideScreen(context);
    final l = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                  wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.orders,
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5)),
                        Text('${l.orders} • ${l.tradeHistory}',
                            style: const TextStyle(
                                fontSize: 13,
                                color: TradEtTheme.textSecondary)),
                      ],
                    ),
                  ),
                  Consumer<AppProvider>(
                    builder: (context, provider, _) {
                      if (provider.orders.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            final fmt = NumberFormat('#,##0.00', 'en');
                            final l = AppLocalizations.of(context);
                            showExportSheet(
                              context,
                              title: l.orders,
                              subtitle: l.ordersCountLabel(provider.orders.length),
                              pdfTitle: l.orderExportTitle,
                              headers: [
                                l.exportDateHeader,
                                l.exportTypeHeader,
                                l.symbol,
                                l.asset,
                                l.exportQtyHeader,
                                l.exportPriceEtbHeader,
                                l.exportTotalEtbHeader,
                                l.exportFeeEtbHeader,
                                l.exportStatusHeader,
                              ],
                              rows: provider.orders.map((o) => [
                                o.createdAt,
                                o.orderType.toUpperCase(),
                                o.symbol, o.assetName,
                                o.quantity.toString(),
                                fmt.format(o.price),
                                fmt.format(o.totalAmount),
                                fmt.format(o.feeAmount),
                                o.orderStatus.toUpperCase(),
                              ]).toList(),
                            );
                          },
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
                                  size: 20, color: TradEtTheme.positive),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () => context.read<AppProvider>().loadOrders(),
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
            const SizedBox(height: 12),

            // Tab bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 20),
              child: Container(
                decoration: BoxDecoration(
                  color: TradEtTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: TradEtTheme.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: TradEtTheme.textMuted,
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(text: l.orders),
                    Tab(text: l.securityLog),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Orders
                  Consumer<AppProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading && provider.orders.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(color: TradEtTheme.positive));
                      }
                      if (provider.orders.isEmpty) return _emptyState();
                      if (wide) return _buildWebTable(provider, fmt);
                      return _buildMobileList(provider, fmt);
                    },
                  ),
                  // Tab 2: Event Log
                  Consumer<AppProvider>(
                    builder: (context, provider, _) {
                      if (provider.orderEvents.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    color: TradEtTheme.cardBg, shape: BoxShape.circle),
                                child: const Icon(Icons.history_rounded,
                                    size: 48, color: TradEtTheme.textMuted),
                              ),
                              const SizedBox(height: 16),
                              Text(l.noOrdersYet,
                                  style: const TextStyle(fontWeight: FontWeight.w600,
                                      fontSize: 16, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(l.noOrdersYet,
                                  style: const TextStyle(
                                      color: TradEtTheme.textMuted, fontSize: 13)),
                            ],
                          ),
                        );
                      }
                      return wide
                          ? _buildEventWebTable(provider, fmt)
                          : _buildEventMobileList(provider, fmt);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventMobileList(AppProvider provider, NumberFormat fmt) {
    return RefreshIndicator(
      color: TradEtTheme.positive,
      backgroundColor: TradEtTheme.cardBg,
      onRefresh: () => provider.loadOrderEvents(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        itemCount: provider.orderEvents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) => _EventCard(event: provider.orderEvents[i], fmt: fmt),
      ),
    );
  }

  Widget _buildEventWebTable(AppProvider provider, NumberFormat fmt) {
    final wide = isWideScreen(context);
    final l = AppLocalizations.of(context);
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
                SizedBox(width: 90, child: _TH(l.activity)),
                const SizedBox(width: 12),
                SizedBox(width: 64, child: _TH(l.type)),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _TH(l.asset)),
                Expanded(flex: 1, child: _TH(l.quantity)),
                Expanded(flex: 1, child: _TH(l.price)),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TH(l.total))),
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
                itemCount: provider.orderEvents.length,
                itemBuilder: (context, i) {
                  final e = provider.orderEvents[i];
                  return _EventWebRow(event: e, fmt: fmt, isEven: i.isEven);
                },
              ),
            ),
          ),
        ],
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
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_outlined,
                size: 48, color: TradEtTheme.textMuted),
          ),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context).noOrdersYet,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context).noOrdersYet,
              style: const TextStyle(color: TradEtTheme.textMuted, fontSize: 13)),
        ],
      ),
    );
  }

  // ─── Web: Table layout ───
  Widget _buildWebTable(AppProvider provider, NumberFormat fmt) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: TradEtTheme.primaryDark.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                SizedBox(width: 64, child: _TH(l.type)),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _TH(l.asset)),
                Expanded(flex: 1, child: _TH(l.quantity)),
                Expanded(flex: 1, child: _TH(l.price)),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TH(l.total))),
                SizedBox(width: 80, child: Align(alignment: Alignment.centerRight, child: _TH(l.fee))),
                SizedBox(width: 90, child: Align(alignment: Alignment.center, child: _TH(l.status))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TH(l.date))),
              ],
            ),
          ),
          // Table body
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
                itemCount: provider.orders.length + 1,
                itemBuilder: (context, index) {
                  if (index == provider.orders.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: DisclaimerFooter(),
                    );
                  }
                  final order = provider.orders[index];
                  return _WebOrderRow(order: order, fmt: fmt, isEven: index.isEven);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Mobile: Card list (unchanged) ───
  Widget _buildMobileList(AppProvider provider, NumberFormat fmt) {
    final count = provider.orders.length;
    return RefreshIndicator(
      color: TradEtTheme.positive,
      backgroundColor: TradEtTheme.cardBg,
      onRefresh: () => provider.loadOrders(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        itemCount: count + 1,
        separatorBuilder: (_, i) => i < count - 1 ? const SizedBox(height: 8) : const SizedBox.shrink(),
        itemBuilder: (context, index) {
          if (index == count) {
            return const Padding(
              padding: EdgeInsets.only(top: 16),
              child: DisclaimerFooter(),
            );
          }
          final order = provider.orders[index];
          return _OrderCard(order: order, fmt: fmt);
        },
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
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: TradEtTheme.textMuted,
            letterSpacing: 0.5));
  }
}

// ─── Web order row ───
class _WebOrderRow extends StatefulWidget {
  final Order order;
  final NumberFormat fmt;
  final bool isEven;

  const _WebOrderRow({required this.order, required this.fmt, required this.isEven});

  @override
  State<_WebOrderRow> createState() => _WebOrderRowState();
}

class _WebOrderRowState extends State<_WebOrderRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final isBuy = order.orderType == 'buy';
    final statusColor = switch (order.orderStatus) {
      'filled' => TradEtTheme.positive,
      'pending' => TradEtTheme.accent,
      'cancelled' => TradEtTheme.negative,
      _ => TradEtTheme.textMuted,
    };
    final l = AppLocalizations.of(context);
    final statusLabel = switch (order.orderStatus) {
      'pending' => l.openStatus.toUpperCase(),
      'filled' => l.filledStatus.toUpperCase(),
      'cancelled' => l.cancel.toUpperCase(),
      _ => order.orderStatus.toUpperCase(),
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: order.isPending ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: order.isPending ? () => OrdersScreen.showOrderActions(context, order) : null,
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _hovering
              ? TradEtTheme.surfaceLight.withValues(alpha: 0.5)
              : widget.isEven
                  ? TradEtTheme.cardBg.withValues(alpha: 0.3)
                  : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.15)),
          ),
        ),
        child: Row(
          children: [
            // Type badge
            SizedBox(
              width: 64,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isBuy ? TradEtTheme.positive : TradEtTheme.negative)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isBuy ? AppLocalizations.of(context).buy : AppLocalizations.of(context).sell,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isBuy ? TradEtTheme.positive : TradEtTheme.negative,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Asset (tappable → TradeScreen)
            Expanded(
              flex: 2,
              child: Builder(builder: (ctx) {
                final asset = context.read<AppProvider>().assets
                    .where((a) => a.symbol == order.symbol)
                    .firstOrNull;
                return MouseRegion(
                  cursor: asset != null ? SystemMouseCursors.click : MouseCursor.defer,
                  child: GestureDetector(
                    onTap: asset != null
                        ? () => Navigator.of(context).push(appRoute(context, TradeScreen(asset: asset)))
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.symbol,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: asset != null ? TradEtTheme.primaryLight : Colors.white,
                                decoration: asset != null ? TextDecoration.underline : TextDecoration.none,
                                decorationColor: TradEtTheme.primaryLight)),
                        Text(order.assetName,
                            style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                );
              }),
            ),
            // Quantity
            Expanded(
              flex: 1,
              child: Text('${order.quantity}',
                  style: const TextStyle(fontSize: 13, color: Colors.white)),
            ),
            // Price
            Expanded(
              flex: 1,
              child: Text('${widget.fmt.format(order.price)} ETB',
                  style: const TextStyle(fontSize: 13, color: Colors.white)),
            ),
            // Total
            Expanded(
              flex: 1,
              child: Text('${widget.fmt.format(order.totalAmount)} ETB',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                  textAlign: TextAlign.right),
            ),
            // Fee
            SizedBox(
              width: 80,
              child: Text('${widget.fmt.format(order.feeAmount)} ETB',
                  style: const TextStyle(fontSize: 12, color: TradEtTheme.textSecondary),
                  textAlign: TextAlign.right),
            ),
            // Status
            SizedBox(
              width: 90,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
                  ),
                ),
              ),
            ),
            // Date
            Expanded(
              flex: 1,
              child: Text(
                  EthiopianDate.formatIso(order.createdAt,
                      context.read<AppProvider>().langCode),
                  style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted),
                  textAlign: TextAlign.right),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

// ─── Mobile: Order card (fixed layout — 2x2 grid for details) ───
class _OrderCard extends StatelessWidget {
  final Order order;
  final NumberFormat fmt;

  const _OrderCard({required this.order, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isBuy = order.orderType == 'buy';
    final l = AppLocalizations.of(context);

    return GestureDetector(
      onTap: order.isPending ? () => OrdersScreen.showOrderActions(context, order) : null,
      child: MouseRegion(
        cursor: order.isPending ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: order.isPending
              ? TradEtTheme.accent.withValues(alpha: 0.4)
              : TradEtTheme.divider.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: BUY/SELL badge + symbol + asset name + status
          Row(
            children: [
              // BUY/SELL badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isBuy
                      ? TradEtTheme.positive.withValues(alpha: 0.15)
                      : TradEtTheme.negative.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isBuy ? l.buy : l.sell,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isBuy ? TradEtTheme.positive : TradEtTheme.negative,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Symbol + asset name — takes remaining space
              Expanded(
                child: Builder(builder: (ctx) {
                  final asset = context.read<AppProvider>().assets
                      .where((a) => a.symbol == order.symbol)
                      .firstOrNull;
                  return GestureDetector(
                    onTap: asset != null
                        ? () => Navigator.of(context).push(appRoute(context, TradeScreen(asset: asset)))
                        : null,
                    child: Row(
                      children: [
                        Text(order.symbol,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: asset != null ? TradEtTheme.primaryLight : Colors.white,
                                decoration: asset != null ? TextDecoration.underline : TextDecoration.none,
                                decorationColor: TradEtTheme.primaryLight)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(order.assetName,
                              style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              _statusBadge(context, order.orderStatus),
            ],
          ),
          const SizedBox(height: 14),
          // Details: 2x2 grid so values don't overlap
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TradEtTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _detail(l.quantity, '${order.quantity}')),
                    Expanded(child: _detail(l.price, '${fmt.format(order.price)} ETB')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _detail(l.total, '${fmt.format(order.totalAmount)} ETB')),
                    Expanded(child: _detail('${l.fee} (1.5%)', '${fmt.format(order.feeAmount)} ETB')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
              EthiopianDate.formatIso(order.createdAt,
                  context.read<AppProvider>().langCode),
              style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
          if (order.isPending) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.touch_app_outlined, size: 12, color: TradEtTheme.accent.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
                Text(l.tradeNow,
                    style: TextStyle(fontSize: 10, color: TradEtTheme.accent.withValues(alpha: 0.7))),
              ],
            ),
          ],
        ],
      ),
      ),
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white),
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    final l = AppLocalizations.of(context);
    Color color;
    switch (status) {
      case 'filled': color = TradEtTheme.positive; break;
      case 'pending': color = TradEtTheme.accent; break;
      case 'cancelled': color = TradEtTheme.negative; break;
      default: color = TradEtTheme.textMuted;
    }
    final label = switch (status) {
      'pending' => l.openStatus.toUpperCase(),
      'filled' => l.filledStatus.toUpperCase(),
      'cancelled' => l.cancel.toUpperCase(),
      _ => status.toUpperCase(),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

// ─── Event Log widgets ───

Color _eventColor(String eventType) {
  return switch (eventType) {
    'placed' => TradEtTheme.accent,
    'filled' => TradEtTheme.positive,
    'cancelled' => TradEtTheme.negative,
    'partial_fill' => TradEtTheme.warning,
    'expired' => TradEtTheme.textMuted,
    _ => TradEtTheme.textMuted,
  };
}

IconData _eventIcon(String eventType) {
  return switch (eventType) {
    'placed' => Icons.pending_outlined,
    'filled' => Icons.check_circle_outline,
    'cancelled' => Icons.cancel_outlined,
    'partial_fill' => Icons.incomplete_circle,
    'expired' => Icons.timer_off_outlined,
    _ => Icons.history_rounded,
  };
}

class _EventCard extends StatelessWidget {
  final dynamic event;
  final NumberFormat fmt;
  const _EventCard({required this.event, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = _eventColor(event.eventType as String);
    final isBuy = event.orderType == 'buy';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_eventIcon(event.eventType as String), color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      (event.eventType as String).toUpperCase().replaceAll('_', ' '),
                      style: TextStyle(fontWeight: FontWeight.w700,
                          fontSize: 12, color: color),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isBuy ? TradEtTheme.positive : TradEtTheme.negative)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '${isBuy ? l.buy.toUpperCase() : l.sell.toUpperCase()} ${event.symbol}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isBuy ? TradEtTheme.positive : TradEtTheme.negative),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${event.quantity} × ${fmt.format(event.price)} ETB  |  ${fmt.format(event.amount)} ETB',
                  style: const TextStyle(fontSize: 12, color: TradEtTheme.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(event.createdAt as String,
                    style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventWebRow extends StatelessWidget {
  final dynamic event;
  final NumberFormat fmt;
  final bool isEven;
  const _EventWebRow({required this.event, required this.fmt, required this.isEven});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = _eventColor(event.eventType as String);
    final isBuy = event.orderType == 'buy';

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
            width: 90,
            child: Row(
              children: [
                Icon(_eventIcon(event.eventType as String), color: color, size: 14),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    (event.eventType as String).toUpperCase().replaceAll('_', ' '),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 64,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: (isBuy ? TradEtTheme.positive : TradEtTheme.negative)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isBuy ? l.buy.toUpperCase() : l.sell.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isBuy ? TradEtTheme.positive : TradEtTheme.negative),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.symbol as String,
                    style: const TextStyle(fontWeight: FontWeight.w700,
                        fontSize: 13, color: Colors.white)),
                Text(event.assetName as String,
                    style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('${event.quantity}',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
          Expanded(
            flex: 1,
            child: Text('${fmt.format(event.price)} ETB',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
          Expanded(
            flex: 1,
            child: Text('${fmt.format(event.amount)} ETB',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: Colors.white),
                textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 1,
            child: Text(event.createdAt as String,
                style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
