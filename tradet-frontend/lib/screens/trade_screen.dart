import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/sharia_badge.dart';
import '../widgets/price_change.dart';
import '../widgets/candlestick_chart.dart';
import '../widgets/responsive_layout.dart';
import 'alerts_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../widgets/disclaimer_footer.dart';
import '../utils/security_challenge.dart';

class TradeScreen extends StatefulWidget {
  final Asset asset;
  final bool initialSell;
  const TradeScreen({super.key, required this.asset, this.initialSell = false});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  static const double _kFeeRate = 0.015;

  late bool _isBuy = !widget.initialSell;
  bool _isLimitOrder = false; // false = market, true = limit
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _fmt = NumberFormat('#,##0.00', 'en');
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    if (widget.asset.price != null) {
      _priceController.text = widget.asset.price!.toStringAsFixed(2);
    }
    _sliderValue = widget.asset.minTradeQty;
    _qtyController.text = _sliderValue.toStringAsFixed(
        _sliderValue == _sliderValue.roundToDouble() ? 0 : 1);
    // Ensure watchlist is loaded so the star icon shows the correct state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadWatchlist();
    });
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  double get _total {
    final qty = double.tryParse(_qtyController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    return qty * price;
  }

  double get _fee => _total * _kFeeRate;

  void _showAlertSheet(BuildContext ctx, AppProvider prov, Asset asset) {
    final priceCtrl = TextEditingController(
        text: asset.price != null ? asset.price!.toStringAsFixed(2) : '');
    String condition = 'above';

    showResponsiveSheet(
      context: ctx,
      backgroundColor: const Color(0xFF1A3A25),
      builder: (sheetCtx, isDialog) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20,
              isDialog ? 20 : 32 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle — mobile only
              if (!isDialog)
                Center(
                  child: Container(
                    width: 36, height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.add_alert_outlined,
                        color: Color(0xFF8BAF97), size: 18),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).priceAlertFor(asset.symbol),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
                if (asset.price != null) ...[
                  const SizedBox(height: 4),
                  Text(AppLocalizations.of(context).currentPriceDisplay(_fmt.format(asset.price!)),
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF8BAF97))),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: priceCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).targetPriceEtb,
                    suffixText: 'ETB',
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: const TextStyle(color: Color(0xFF8BAF97)),
                  ),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setSheetState(() => condition = 'above'),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: condition == 'above'
                              ? TradEtTheme.positive.withValues(alpha: 0.18)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: condition == 'above'
                                ? TradEtTheme.positive
                                : Colors.white24,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.trending_up, size: 15,
                                  color: condition == 'above'
                                      ? TradEtTheme.positive
                                      : const Color(0xFF8BAF97)),
                              const SizedBox(width: 6),
                              Text(AppLocalizations.of(context).above,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: condition == 'above'
                                        ? TradEtTheme.positive
                                        : const Color(0xFF8BAF97),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setSheetState(() => condition = 'below'),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: condition == 'below'
                              ? TradEtTheme.negative.withValues(alpha: 0.18)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: condition == 'below'
                                ? TradEtTheme.negative
                                : Colors.white24,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.trending_down, size: 15,
                                  color: condition == 'below'
                                      ? TradEtTheme.negative
                                      : const Color(0xFF8BAF97)),
                              const SizedBox(width: 6),
                              Text(AppLocalizations.of(context).below,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: condition == 'below'
                                        ? TradEtTheme.negative
                                        : const Color(0xFF8BAF97),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TradEtTheme.positive,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final price = double.tryParse(priceCtrl.text);
                      if (price == null) return;
                      Navigator.pop(context);
                      try {
                        await prov.api.createAlert(
                          assetId: asset.id,
                          targetPrice: price,
                          condition: condition,
                        );
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context).alertSet(asset.symbol, _fmt.format(price))),
                              backgroundColor: TradEtTheme.positive,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      } catch (_) {}
                    },
                    child: Text(AppLocalizations.of(context).setAlert,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      _qtyController.text =
          value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);
    });
  }

  Future<void> _placeOrder() async {
    final l = AppLocalizations.of(context);
    final qty = double.tryParse(_qtyController.text);
    final price = double.tryParse(_priceController.text);
    if (qty == null || qty <= 0 || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.enterValidQtyPrice),
          backgroundColor: TradEtTheme.negative,
        ),
      );
      return;
    }

    final confirmed = await showResponsiveSheet<bool>(
      context: context,
      backgroundColor: TradEtTheme.surfaceLight,
      builder: (ctx, isDialog) => _ConfirmSheet(
        isBuy: _isBuy,
        asset: widget.asset,
        qty: qty,
        price: price,
        total: _total,
        fee: _fee,
        fmt: _fmt,
        isDialog: isDialog,
      ),
    );

    if (confirmed != true || !mounted) return;

    // Wealth protection: require authentication before placing the order
    final authed = await challengeTransactionAuth(
      context,
      reason:
          _isBuy ? AppLocalizations.of(context).authenticateToBuy(widget.asset.symbol) : AppLocalizations.of(context).authenticateToSell(widget.asset.symbol),
    );
    if (!authed || !mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).authRequiredOrder),
        backgroundColor: TradEtTheme.negative,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }

    final result = await context.read<AppProvider>().placeOrder(
          assetId: widget.asset.id,
          orderType: _isBuy ? 'buy' : 'sell',
          quantity: qty,
          price: price,
          executionType: _isLimitOrder ? 'limit' : 'market',
        );

    if (!mounted) return;

    if (result.containsKey('order_id')) {
      final isLimit = result['execution_type'] == 'limit';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLimit
              ? l.limitOrderPlaced
              : l.orderFilled(_fmt.format(result['fee_amount']))),
          backgroundColor: TradEtTheme.positive,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? l.orderFailed),
          backgroundColor: TradEtTheme.negative,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;
    final wide = isWideScreen(context);

    final mainContent = Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wide ? 24 : 12, vertical: 4),
              child: Row(
                children: [
                  if (!wide)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  // Mobile: symbol + full name + category stacked
                  if (!wide)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(asset.symbol,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
                            const SizedBox(width: 6),
                            ShariaBadge(isCompliant: asset.isShariaCompliant, complianceLevel: asset.complianceLevel, compact: true),
                            if (asset.isEcxListed) ...[const SizedBox(width: 4), const EcxBadge()],
                          ]),
                          Text(
                            asset.categoryName != null
                                ? '${asset.name} · ${asset.categoryName}'
                                : asset.name,
                            style: const TextStyle(fontSize: 11, color: TradEtTheme.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  // Web: flat row
                  else ...[
                    Text(asset.symbol,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
                    const SizedBox(width: 8),
                    ShariaBadge(isCompliant: asset.isShariaCompliant, compact: true),
                    const Spacer(),
                    if (asset.isEcxListed) const EcxBadge(),
                  ],
                  Consumer<AppProvider>(
                    builder: (ctx, prov, _) {
                      final inWatchlist = prov.watchlist.any(
                          (a) => a.id == widget.asset.id || a.symbol == widget.asset.symbol);
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_alert_outlined, color: Color(0xFF8BAF97)),
                            onPressed: () => _showAlertSheet(ctx, prov, widget.asset),
                          ),
                          IconButton(
                            icon: Icon(
                              inWatchlist ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: inWatchlist ? const Color(0xFFFBBF24) : const Color(0xFF8BAF97),
                            ),
                            onPressed: () async {
                              if (inWatchlist) {
                                await prov.removeFromWatchlist(widget.asset.id);
                              } else {
                                await prov.addToWatchlist(widget.asset.id);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: wide ? _buildWebLayout(asset) : _buildMobileLayout(asset),
            ),
          ],
        ),
      ),
    );

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
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      appRoute(context, const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ),
            Container(width: 1, color: const Color(0xFF2D5A3D)),
            Expanded(child: mainContent),
          ],
        ),
      );
    }

    return Scaffold(body: mainContent);
  }

  // ─── Mobile layout: price header + 4 segment tabs ───
  Widget _buildMobileLayout(Asset asset) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Price header — always visible above tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: _priceHeader(asset),
          ),
          // Segment tab bar
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: TradEtTheme.positive,
            unselectedLabelColor: TradEtTheme.textMuted,
            indicatorColor: TradEtTheme.positive,
            indicatorWeight: 2,
            dividerColor: TradEtTheme.divider.withValues(alpha: 0.3),
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text: AppLocalizations.of(context).overview),
              Tab(text: AppLocalizations.of(context).financials),
              Tab(text: AppLocalizations.of(context).newsTab),
              Tab(text: AppLocalizations.of(context).orderBook),
            ],
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                _overviewTab(asset),
                _financialsTab(asset),
                _newsTab(asset),
                _orderBookTab(asset),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab 1: chart + stats + order form
  Widget _overviewTab(Asset asset) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          CandlestickChart(symbol: asset.symbol, fallbackPrices: asset.sparkline),
          const SizedBox(height: 16),
          _statsRow(asset),
          _sessionStatus(asset),
          _kycGateBanner(),
          const SizedBox(height: 20),
          _buySelltoggle(),
          const SizedBox(height: 20),
          _quantityInput(asset),
          const SizedBox(height: 16),
          _priceInput(asset),
          const SizedBox(height: 20),
          _orderSummary(),
          const SizedBox(height: 20),
          _placeOrderButton(),
          const SizedBox(height: 20),
          const DisclaimerFooter(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Tab 2: asset information table + AAOIFI sharia detail
  Widget _financialsTab(Asset asset) {
    final l = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.assetInformation,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _mobileDetailRow(l.symbol, asset.symbol, first: true),
                _mobileDetailRow(l.nameLabel, asset.name),
                if (asset.nameAm != null) _mobileDetailRow(l.amharicName, asset.nameAm!),
                _mobileDetailRow(l.categoryLabel, asset.categoryName ?? '—'),
                _mobileDetailRow(l.unitLabel, asset.unit),
                _mobileDetailRow(l.minTrade, '${asset.minTradeQty}'),
                _mobileDetailRow(l.maxTrade, '${asset.maxTradeQty}'),
                _mobileDetailRow(l.volume24h,
                    asset.volume24h != null ? _fmt.format(asset.volume24h) : '—'),
                _mobileDetailRow(l.shariaLabel, asset.isShariaCompliant ? l.compliant : l.notApplicable),
                _mobileDetailRow(l.ecxListed, asset.isEcxListed ? l.yes : l.no, last: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _shariaScreeningCard(asset),
        ],
      ),
    );
  }

  Widget _shariaScreeningCard(Asset asset) {
    final l = AppLocalizations.of(context);
    final screening = asset.shariaScreening;
    final color = asset.complianceLevel == 'halal'
        ? TradEtTheme.positive
        : asset.complianceLevel == 'permissible'
            ? TradEtTheme.warning
            : TradEtTheme.negative;
    final debtRatio = screening?['debt_to_assets_ratio'];
    final haramRevenue = screening?['haram_revenue_ratio'];
    final ruling = screening?['ruling'] ?? asset.complianceLevel;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.verified_rounded, color: color, size: 18),
          ),
          title: Text(l.aaaoifiShariaScreening,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          subtitle: Text(
            ruling.toString().toUpperCase(),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
          iconColor: TradEtTheme.textMuted,
          collapsedIconColor: TradEtTheme.textMuted,
          children: [
            const Divider(height: 1, color: Color(0xFF2D5A3D)),
            const SizedBox(height: 12),
            // Debt ratio bar
            _screeningMetric(
              label: l.debtToAssetsRatio,
              threshold: l.debtToAssetsThreshold,
              value: debtRatio != null ? (debtRatio as num).toDouble() : null,
              thresholdValue: 0.30,
            ),
            const SizedBox(height: 10),
            // Haram revenue bar
            _screeningMetric(
              label: l.haramRevenueRatio,
              threshold: l.haramRevenueThreshold,
              value: haramRevenue != null ? (haramRevenue as num).toDouble() : null,
              thresholdValue: 0.05,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: TradEtTheme.positive.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l.aaoifiScreeningNote,
                style: const TextStyle(fontSize: 10, color: TradEtTheme.textSecondary, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _screeningMetric({
    required String label,
    required String threshold,
    double? value,
    required double thresholdValue,
  }) {
    final bool pass = value == null || value <= thresholdValue;
    final color = pass ? TradEtTheme.positive : TradEtTheme.negative;
    final displayValue = value != null ? '${(value * 100).toStringAsFixed(1)}%' : 'N/A';
    final barValue = value != null ? (value / (thresholdValue * 2)).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: TradEtTheme.textSecondary)),
            Row(
              children: [
                Text(displayValue,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                const SizedBox(width: 6),
                Icon(pass ? Icons.check_circle_outline : Icons.cancel_outlined,
                    size: 14, color: color),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 4, width: double.infinity,
              decoration: BoxDecoration(
                color: TradEtTheme.divider.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: barValue,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(threshold,
            style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
      ],
    );
  }

  // Tab 3: news (placeholder)
  Widget _newsTab(Asset asset) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper_outlined, size: 52,
              color: TradEtTheme.textMuted.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(l.newsForSymbol(asset.symbol),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 6),
          Text(l.newsForAsset,
              style: const TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
        ],
      ),
    );
  }

  // Tab 4: this asset's orders
  Widget _orderBookTab(Asset asset) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final orders = provider.orders
            .where((o) => o.symbol == asset.symbol)
            .toList();

        if (orders.isEmpty) {
          return Center(
            child: Builder(
              builder: (ctx) {
                final l = AppLocalizations.of(ctx);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 52,
                        color: TradEtTheme.textMuted.withValues(alpha: 0.4)),
                    const SizedBox(height: 16),
                    Text(l.noOrdersForAsset(asset.symbol),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(l.yourOrdersAppearHere,
                        style: const TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
                  ],
                );
              },
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          itemCount: orders.length,
          itemBuilder: (_, i) {
            final o = orders[i];
            final isBuy = o.orderType == 'buy';
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: TradEtTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: (isBuy ? TradEtTheme.positive : TradEtTheme.negative)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isBuy ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      size: 18,
                      color: isBuy ? TradEtTheme.positive : TradEtTheme.negative,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (ctx) {
                            final l = AppLocalizations.of(ctx);
                            return Text(
                              '${isBuy ? l.buy : l.sell} · ${o.executionType.toUpperCase()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 13,
                                  color: isBuy ? TradEtTheme.positive : TradEtTheme.negative),
                            );
                          },
                        ),
                        Text('${o.quantity} ${asset.unit} @ ${_fmt.format(o.price)} ETB',
                            style: const TextStyle(fontSize: 12, color: TradEtTheme.textSecondary)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_fmt.format(o.totalAmount),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white)),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: o.isPending
                              ? TradEtTheme.warning.withValues(alpha: 0.15)
                              : TradEtTheme.positive.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(o.orderStatus.toUpperCase(),
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600,
                                color: o.isPending ? TradEtTheme.warning : TradEtTheme.positive)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Mobile-style detail row with dividers
  Widget _mobileDetailRow(String label, String value, {bool first = false, bool last = false}) {
    return Column(
      children: [
        if (!first)
          Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3),
              indent: 16, endIndent: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 13, color: TradEtTheme.textMuted)),
              Flexible(
                child: Text(value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Web layout: Chart left, Form right ───
  Widget _buildWebLayout(Asset asset) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Chart + info
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _priceHeader(asset),
                  const SizedBox(height: 20),
                  // Bigger chart for web
                  CandlestickChart(
                      symbol: asset.symbol, fallbackPrices: asset.sparkline),
                  const SizedBox(height: 20),
                  _statsRow(asset),
                  _sessionStatus(asset),
                  const SizedBox(height: 20),
                  // Asset details card
                  _webAssetDetails(asset),
                ],
              ),
            ),
          ),
          const SizedBox(width: 28),
          // Right: Order form
          SizedBox(
            width: 380,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: TradEtTheme.cardBg.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: TradEtTheme.divider.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(AppLocalizations.of(context).placeOrder,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    _kycGateBanner(),
                    const SizedBox(height: 20),
                    _buySelltoggle(),
                    const SizedBox(height: 20),
                    _quantityInput(asset),
                    const SizedBox(height: 16),
                    _priceInput(asset),
                    const SizedBox(height: 20),
                    _orderSummary(),
                    const SizedBox(height: 20),
                    _placeOrderButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Shared building blocks ───

  Widget _priceHeader(Asset asset) {
    final langCode = AppLocalizations.of(context).langCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          (langCode == 'am' || langCode == 'ti') && asset.nameAm != null
              ? asset.nameAm!
              : asset.name,
          style: const TextStyle(
              fontSize: 13, color: TradEtTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              asset.price != null ? _fmt.format(asset.price) : '—',
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('ETB',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.5))),
            ),
            const Spacer(),
            if (asset.change24h != null) PriceChange(change: asset.change24h!),
          ],
        ),
      ],
    );
  }

  Widget _statsRow(Asset asset) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _stat(AppLocalizations.of(context).bid, asset.bidPrice),
          _divider(),
          _stat(AppLocalizations.of(context).ask, asset.askPrice),
          _divider(),
          _stat(AppLocalizations.of(context).high, asset.high24h),
          _divider(),
          _stat(AppLocalizations.of(context).low, asset.low24h),
        ],
      ),
    );
  }

  Widget _sessionStatus(Asset asset) {
    if (asset.tradingSession == null) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: asset.tradingSession!['is_open'] == true
                ? TradEtTheme.positive.withValues(alpha: 0.1)
                : TradEtTheme.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                asset.tradingSession!['is_open'] == true
                    ? Icons.check_circle_outline
                    : Icons.schedule,
                size: 16,
                color: asset.tradingSession!['is_open'] == true
                    ? TradEtTheme.positive
                    : TradEtTheme.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(asset.tradingSession!['reason'] ?? '',
                    style: const TextStyle(
                        fontSize: 12, color: TradEtTheme.textSecondary)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _kycGateBanner() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final kycStatus = provider.user?.kycStatus ?? 'pending';
        if (kycStatus == 'verified') return const SizedBox.shrink();
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: TradEtTheme.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: TradEtTheme.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.verified_user_outlined, size: 18, color: TradEtTheme.warning),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context).identityVerificationRequired,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: TradEtTheme.warning)),
                        const SizedBox(height: 4),
                        Text(AppLocalizations.of(context).kycRequiredDescription,
                            style: const TextStyle(fontSize: 11, color: TradEtTheme.textSecondary)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            provider.navigateGlobal(11); // Profile screen
                          },
                          child: Text(AppLocalizations.of(context).completeVerification,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: TradEtTheme.warning,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _webAssetDetails(Asset asset) {
    final l = AppLocalizations.of(context);
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
          Text(l.assetInformation,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 14),
          _detailRow(l.symbol, asset.symbol),
          _detailRow(l.nameLabel, asset.name),
          if (asset.nameAm != null) _detailRow(l.amharicName, asset.nameAm!),
          _detailRow(l.categoryLabel, asset.categoryName ?? '--'),
          _detailRow(l.unitLabel, asset.unit),
          _detailRow(l.minTrade, '${asset.minTradeQty}'),
          _detailRow(l.maxTrade, '${asset.maxTradeQty}'),
          _detailRow(l.volume24h,
              asset.volume24h != null ? _fmt.format(asset.volume24h) : '--'),
          _detailRow(l.shariaLabel, asset.isShariaCompliant ? l.compliant : l.notApplicable),
          _detailRow(l.ecxListed, asset.isEcxListed ? l.yes : l.no),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: TradEtTheme.textMuted)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buySelltoggle() {
    return Column(
      children: [
        // Buy / Sell toggle
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: TradEtTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(child: _toggle(AppLocalizations.of(context).buy, true)),
              const SizedBox(width: 3),
              Expanded(child: _toggle(AppLocalizations.of(context).sell, false)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Market / Limit toggle
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: TradEtTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(child: _executionToggle(AppLocalizations.of(context).marketOrder, false)),
              const SizedBox(width: 3),
              Expanded(child: _executionToggle(AppLocalizations.of(context).limitOrder, true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _executionToggle(String label, bool isLimit) {
    final selected = _isLimitOrder == isLimit;
    return GestureDetector(
      onTap: () => setState(() {
        _isLimitOrder = isLimit;
        // When switching to market, reset price to current
        if (!isLimit && widget.asset.price != null) {
          _priceController.text = widget.asset.price!.toStringAsFixed(2);
        }
      }),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? TradEtTheme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected ? Colors.white : TradEtTheme.textMuted)),
        ),
      ),
    );
  }

  Widget _quantityInput(Asset asset) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final cashBalance = provider.portfolioSummary?.cashBalance ?? 0.0;
        final price = double.tryParse(_priceController.text) ?? (asset.price ?? 1);
        // Calculate max qty from cash balance (for buy) or holdings (for sell)
        double maxFromCash = price > 0 ? (cashBalance / (price * 1.015)) : 0; // account for 1.5% fee
        maxFromCash = maxFromCash.clamp(0, asset.maxTradeQty);
        // For sell: use actual holdings quantity
        final holdingMatch = provider.holdings.where((h) => h.assetId == asset.id);
        final holdingQty = holdingMatch.isNotEmpty ? holdingMatch.first.quantity : 0.0;
        final double maxSellQty = holdingQty.clamp(0.0, asset.maxTradeQty.toDouble());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).quantity,
                style: const TextStyle(
                    color: TradEtTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _qtyController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                suffixText: asset.unit,
                suffixStyle: const TextStyle(
                    color: TradEtTheme.textMuted, fontSize: 14),
              ),
              onChanged: (v) {
                final val = double.tryParse(v);
                if (val != null) {
                  setState(() => _sliderValue =
                      val.clamp(asset.minTradeQty, asset.maxTradeQty));
                }
              },
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor:
                    _isBuy ? TradEtTheme.positive : TradEtTheme.negative,
                inactiveTrackColor: TradEtTheme.divider,
                thumbColor:
                    _isBuy ? TradEtTheme.positive : TradEtTheme.negative,
                overlayColor:
                    (_isBuy ? TradEtTheme.positive : TradEtTheme.negative)
                        .withValues(alpha: 0.15),
                trackHeight: 4,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Builder(builder: (context) {
                final sliderMax = _isBuy
                    ? maxFromCash.clamp(asset.minTradeQty, asset.maxTradeQty)
                    : maxSellQty.clamp(asset.minTradeQty, asset.maxTradeQty);
                final effectiveMax = sliderMax > asset.minTradeQty
                    ? sliderMax
                    : asset.minTradeQty * 2;
                return Slider(
                  value: _sliderValue.clamp(asset.minTradeQty, effectiveMax),
                  min: asset.minTradeQty,
                  max: effectiveMax,
                  onChanged: _onSliderChanged,
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    _isBuy
                        ? AppLocalizations.of(context).cashAvailableLabel(_fmt.format(cashBalance))
                        : AppLocalizations.of(context).holdingsQtyLabel(holdingQty > 0 ? holdingQty.toStringAsFixed(holdingQty == holdingQty.roundToDouble() ? 0 : 1) : '0'),
                    style: TextStyle(
                        fontSize: 10,
                        color: !_isBuy && holdingQty <= 0 ? TradEtTheme.negative : TradEtTheme.textMuted)),
                Row(
                  children: _isBuy
                      ? [
                          // Buy: % of available cash
                          _quickQtyButton('25%', (maxFromCash * 0.25).clamp(asset.minTradeQty, asset.maxTradeQty)),
                          _quickQtyButton('50%', (maxFromCash * 0.50).clamp(asset.minTradeQty, asset.maxTradeQty)),
                          _quickQtyButton('75%', (maxFromCash * 0.75).clamp(asset.minTradeQty, asset.maxTradeQty)),
                          _quickQtyButton('Max', maxFromCash.clamp(asset.minTradeQty, asset.maxTradeQty)),
                        ]
                      : [
                          // Sell: % of actual holdings
                          _quickQtyButton('25%', (maxSellQty * 0.25).clamp(asset.minTradeQty, asset.maxTradeQty)),
                          _quickQtyButton('50%', (maxSellQty * 0.50).clamp(asset.minTradeQty, asset.maxTradeQty)),
                          _quickQtyButton('75%', (maxSellQty * 0.75).clamp(asset.minTradeQty, asset.maxTradeQty)),
                          _quickQtyButton('Max', maxSellQty.clamp(asset.minTradeQty, asset.maxTradeQty)),
                        ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _priceInput(Asset asset) {
    final isMarket = !_isLimitOrder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context).pricePerUnitEtb,
                style: const TextStyle(
                    color: TradEtTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            if (isMarket) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TradEtTheme.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(AppLocalizations.of(context).marketPriceLabel,
                    style: const TextStyle(
                        color: TradEtTheme.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          readOnly: isMarket,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
              color: isMarket
                  ? TradEtTheme.textSecondary
                  : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            suffixText: 'ETB',
            suffixStyle:
                const TextStyle(color: TradEtTheme.textMuted, fontSize: 14),
            prefixIcon: Icon(
              isMarket ? Icons.lock_outline_rounded : Icons.payments_outlined,
              size: 20,
              color: isMarket ? TradEtTheme.textMuted : null,
            ),
            helperText: isMarket ? AppLocalizations.of(context).filledAtMarketPrice : null,
            helperStyle: const TextStyle(
                color: TradEtTheme.textMuted, fontSize: 11),
          ),
          onChanged: (_) => setState(() {}),
        ),
        if (!isMarket && asset.price != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              _quickPriceButton(AppLocalizations.of(context).bid, asset.bidPrice ?? asset.price!),
              _quickPriceButton(AppLocalizations.of(context).market, asset.price!),
              _quickPriceButton(AppLocalizations.of(context).ask, asset.askPrice ?? asset.price!),
            ],
          ),
        ],
      ],
    );
  }

  Widget _orderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _summaryRow(AppLocalizations.of(context).subtotal, '${_fmt.format(_total)} ETB'),
          const SizedBox(height: 6),
          _summaryRow(AppLocalizations.of(context).feeFlat, '${_fmt.format(_fee)} ETB'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
                color: TradEtTheme.divider.withValues(alpha: 0.3)),
          ),
          _summaryRow(
            AppLocalizations.of(context).total,
            '${_fmt.format(_total + (_isBuy ? _fee : -_fee))} ETB',
            bold: true,
          ),
          const SizedBox(height: 6),
          Text(AppLocalizations.of(context).ribaFreeLabel,
              style: const TextStyle(
                  fontSize: 11,
                  color: TradEtTheme.positive,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _placeOrderButton() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final qty = double.tryParse(_qtyController.text) ?? 0;
        final price = double.tryParse(_priceController.text) ?? 0;
        final orderTotal = qty * price * 1.015; // including fee
        final cash = provider.portfolioSummary?.cashBalance ?? provider.user?.walletBalance ?? 0;
        final holding = provider.holdings.where((h) => h.assetId == widget.asset.id);
        final holdingQty = holding.isNotEmpty ? holding.first.quantity : 0.0;

        final l = AppLocalizations.of(context);
        final bool sessionOpen = widget.asset.tradingSession == null ||
            widget.asset.tradingSession!['is_open'] == true;
        final String? sessionReason = sessionOpen
            ? null
            : (widget.asset.tradingSession!['reason'] as String?)?.isNotEmpty == true
                ? widget.asset.tradingSession!['reason'] as String
                : AppLocalizations.of(context).ecxSessionClosedFallback;
        final bool kycVerified = provider.user?.kycStatus == 'verified';
        final bool canTrade;
        final String? disabledReason;
        if (provider.isLoading) {
          canTrade = false;
          disabledReason = null;
        } else if (!kycVerified) {
          canTrade = false;
          disabledReason = AppLocalizations.of(context).kycBeforeTrading;
        } else if (!sessionOpen) {
          canTrade = false;
          disabledReason = sessionReason;
        } else if (_isBuy && orderTotal > cash && qty > 0 && price > 0) {
          canTrade = false;
          disabledReason = l.insufficientBalance;
        } else if (!_isBuy && holdingQty <= 0) {
          canTrade = false;
          disabledReason = l.noHoldingsToSell;
        } else if (!_isBuy && qty > holdingQty) {
          canTrade = false;
          disabledReason = '${l.exceedsHoldings} (${holdingQty.toStringAsFixed(0)})';
        } else {
          canTrade = true;
          disabledReason = null;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: canTrade ? _placeOrder : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isBuy ? TradEtTheme.positive : TradEtTheme.negative,
                disabledBackgroundColor: TradEtTheme.surfaceLight,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(
                      _isBuy
                          ? AppLocalizations.of(context).placeBuyOrder
                          : AppLocalizations.of(context).placeSellOrder,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: canTrade ? Colors.white : TradEtTheme.textMuted)),
            ),
            if (disabledReason != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(disabledReason,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12,
                        color: TradEtTheme.negative,
                        fontWeight: FontWeight.w500)),
              ),
          ],
        );
      },
    );
  }

  Widget _toggle(String label, bool isBuy) {
    final selected = _isBuy == isBuy;
    final color = isBuy ? TradEtTheme.positive : TradEtTheme.negative;
    return GestureDetector(
      onTap: () => setState(() => _isBuy = isBuy),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: selected ? Colors.white : TradEtTheme.textMuted)),
        ),
      ),
    );
  }

  Widget _quickQtyButton(String label, double value) {
    return GestureDetector(
      onTap: () => _onSliderChanged(value),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.only(left: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: TradEtTheme.divider),
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: TradEtTheme.textSecondary,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _quickPriceButton(String label, double value) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _priceController.text = value.toStringAsFixed(2);
          setState(() {});
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: TradEtTheme.divider),
            ),
            alignment: Alignment.center,
            child: Text('$label\n${_fmt.format(value)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11,
                    color: TradEtTheme.textSecondary,
                    height: 1.3)),
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, double? value) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: TradEtTheme.textMuted)),
          const SizedBox(height: 2),
          Text(value != null ? _fmt.format(value) : '—',
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _divider() => Container(
      width: 1,
      height: 28,
      color: TradEtTheme.divider.withValues(alpha: 0.3));

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: TradEtTheme.textSecondary,
                fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13)),
        Text(value,
            style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                fontSize: bold ? 15 : 13,
                color: Colors.white)),
      ],
    );
  }
}

class _ConfirmSheet extends StatelessWidget {
  final bool isBuy;
  final Asset asset;
  final double qty;
  final double price;
  final double total;
  final double fee;
  final NumberFormat fmt;
  final bool isDialog;

  const _ConfirmSheet({
    required this.isBuy,
    required this.asset,
    required this.qty,
    required this.price,
    required this.total,
    required this.fee,
    required this.fmt,
    this.isDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isDialog)
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: TradEtTheme.divider,
                    borderRadius: BorderRadius.circular(2))),
          if (isDialog)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isBuy ? AppLocalizations.of(context).confirmBuy : AppLocalizations.of(context).confirmSell,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            )
          else ...[
            const SizedBox(height: 20),
            Text(isBuy ? AppLocalizations.of(context).confirmBuy : AppLocalizations.of(context).confirmSell,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          ],
          const SizedBox(height: 20),
          _row(AppLocalizations.of(context).asset, asset.symbol),
          _row(AppLocalizations.of(context).type, isBuy ? AppLocalizations.of(context).buy : AppLocalizations.of(context).sell),
          _row(AppLocalizations.of(context).quantity, '$qty ${asset.unit}'),
          _row(AppLocalizations.of(context).price, '${fmt.format(price)} ETB'),
          Divider(color: TradEtTheme.divider, height: 24),
          _row(AppLocalizations.of(context).subtotal, '${fmt.format(total)} ETB'),
          _row(AppLocalizations.of(context).feeShort, '${fmt.format(fee)} ETB'),
          _row(AppLocalizations.of(context).total, '${fmt.format(total + (isBuy ? fee : -fee))} ETB',
              bold: true),
          const SizedBox(height: 6),
          Text(AppLocalizations.of(context).ribaFreeShort,
              style: const TextStyle(
                  fontSize: 11,
                  color: TradEtTheme.positive,
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: TradEtTheme.divider),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(AppLocalizations.of(context).cancel,
                      style: const TextStyle(color: TradEtTheme.textSecondary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBuy
                        ? TradEtTheme.positive
                        : TradEtTheme.negative,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(isBuy ? AppLocalizations.of(context).confirmBuy : AppLocalizations.of(context).confirmSell),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String v, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l,
              style: TextStyle(
                  color: TradEtTheme.textSecondary,
                  fontWeight: bold ? FontWeight.w600 : FontWeight.normal)),
          Text(v,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
