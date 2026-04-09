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

class TradeScreen extends StatefulWidget {
  final Asset asset;
  const TradeScreen({super.key, required this.asset});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  bool _isBuy = true;
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

  double get _fee => _total * 0.015;

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      _qtyController.text =
          value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);
    });
  }

  Future<void> _placeOrder() async {
    final qty = double.tryParse(_qtyController.text);
    final price = double.tryParse(_priceController.text);
    if (qty == null || qty <= 0 || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter valid quantity and price'),
          backgroundColor: HalalEtTheme.negative,
        ),
      );
      return;
    }

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: HalalEtTheme.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ConfirmSheet(
        isBuy: _isBuy,
        asset: widget.asset,
        qty: qty,
        price: price,
        total: _total,
        fee: _fee,
        fmt: _fmt,
      ),
    );

    if (confirmed != true || !mounted) return;

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
              ? 'Limit order placed (pending fill)'
              : 'Order filled! Fee: ${_fmt.format(result['fee_amount'])} ETB'),
          backgroundColor: HalalEtTheme.positive,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Order failed'),
          backgroundColor: HalalEtTheme.negative,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;
    final wide = isWideScreen(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: HalalEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: wide ? 24 : 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: 20, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Text(asset.symbol,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.white)),
                    const SizedBox(width: 8),
                    ShariaBadge(
                        isCompliant: asset.isShariaCompliant, compact: true),
                    const Spacer(),
                    if (asset.isEcxListed) const EcxBadge(),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: wide
                    ? _buildWebLayout(asset)
                    : _buildMobileLayout(asset),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Mobile layout (unchanged) ───
  Widget _buildMobileLayout(Asset asset) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _priceHeader(asset),
          const SizedBox(height: 16),
          CandlestickChart(symbol: asset.symbol, fallbackPrices: asset.sparkline),
          const SizedBox(height: 16),
          _statsRow(asset),
          _sessionStatus(asset),
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
          const SizedBox(height: 32),
        ],
      ),
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
                  color: HalalEtTheme.cardBg.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: HalalEtTheme.divider.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(AppLocalizations.of(context).placeOrder,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          asset.nameAm != null
              ? '${asset.name} / ${asset.nameAm}'
              : asset.name,
          style: const TextStyle(
              fontSize: 13, color: HalalEtTheme.textSecondary),
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
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _stat('Bid', asset.bidPrice),
          _divider(),
          _stat('Ask', asset.askPrice),
          _divider(),
          _stat('High', asset.high24h),
          _divider(),
          _stat('Low', asset.low24h),
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
                ? HalalEtTheme.positive.withValues(alpha: 0.1)
                : HalalEtTheme.warning.withValues(alpha: 0.1),
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
                    ? HalalEtTheme.positive
                    : HalalEtTheme.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(asset.tradingSession!['reason'] ?? '',
                    style: const TextStyle(
                        fontSize: 12, color: HalalEtTheme.textSecondary)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _webAssetDetails(Asset asset) {
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
          const Text('Asset Information',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 14),
          _detailRow('Symbol', asset.symbol),
          _detailRow('Name', asset.name),
          if (asset.nameAm != null) _detailRow('Amharic', asset.nameAm!),
          _detailRow('Category', asset.categoryName ?? '--'),
          _detailRow('Unit', asset.unit),
          _detailRow('Min Trade', '${asset.minTradeQty}'),
          _detailRow('Max Trade', '${asset.maxTradeQty}'),
          _detailRow('24h Volume',
              asset.volume24h != null ? _fmt.format(asset.volume24h) : '--'),
          _detailRow('Sharia', asset.isShariaCompliant ? 'Compliant' : 'N/A'),
          _detailRow('ECX Listed', asset.isEcxListed ? 'Yes' : 'No'),
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
                  fontSize: 12, color: HalalEtTheme.textMuted)),
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
            color: HalalEtTheme.surfaceLight,
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
            color: HalalEtTheme.surfaceLight,
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
            color: selected ? HalalEtTheme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected ? Colors.white : HalalEtTheme.textMuted)),
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
            const Text('Quantity / ብዛት',
                style: TextStyle(
                    color: HalalEtTheme.textSecondary,
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
                    color: HalalEtTheme.textMuted, fontSize: 14),
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
                    _isBuy ? HalalEtTheme.positive : HalalEtTheme.negative,
                inactiveTrackColor: HalalEtTheme.divider,
                thumbColor:
                    _isBuy ? HalalEtTheme.positive : HalalEtTheme.negative,
                overlayColor:
                    (_isBuy ? HalalEtTheme.positive : HalalEtTheme.negative)
                        .withValues(alpha: 0.15),
                trackHeight: 4,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: _sliderValue.clamp(
                    asset.minTradeQty, asset.maxTradeQty),
                min: asset.minTradeQty,
                max: asset.maxTradeQty,
                onChanged: _onSliderChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    _isBuy
                        ? 'Cash: ${_fmt.format(cashBalance)} ETB'
                        : 'Holdings: ${holdingQty > 0 ? holdingQty.toStringAsFixed(holdingQty == holdingQty.roundToDouble() ? 0 : 1) : "0"}',
                    style: TextStyle(
                        fontSize: 10,
                        color: !_isBuy && holdingQty <= 0 ? HalalEtTheme.negative : HalalEtTheme.textMuted)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price per unit (ETB)',
            style: TextStyle(
                color: HalalEtTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          decoration: const InputDecoration(
            suffixText: 'ETB',
            suffixStyle:
                TextStyle(color: HalalEtTheme.textMuted, fontSize: 14),
            prefixIcon: Icon(Icons.payments_outlined, size: 20),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        if (asset.price != null)
          Row(
            children: [
              _quickPriceButton('Bid', asset.bidPrice ?? asset.price!),
              _quickPriceButton('Market', asset.price!),
              _quickPriceButton('Ask', asset.askPrice ?? asset.price!),
            ],
          ),
      ],
    );
  }

  Widget _orderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', '${_fmt.format(_total)} ETB'),
          const SizedBox(height: 6),
          _summaryRow('Fee (1.5% flat)', '${_fmt.format(_fee)} ETB'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
                color: HalalEtTheme.divider.withValues(alpha: 0.3)),
          ),
          _summaryRow(
            'Total',
            '${_fmt.format(_total + (_isBuy ? _fee : -_fee))} ETB',
            bold: true,
          ),
          const SizedBox(height: 6),
          const Text('No interest (Riba-free) — flat commission',
              style: TextStyle(
                  fontSize: 11,
                  color: HalalEtTheme.positive,
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
        final bool canTrade;
        final String? disabledReason;
        if (provider.isLoading) {
          canTrade = false;
          disabledReason = null;
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
                    _isBuy ? HalalEtTheme.positive : HalalEtTheme.negative,
                disabledBackgroundColor: HalalEtTheme.surfaceLight,
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
                          color: canTrade ? Colors.white : HalalEtTheme.textMuted)),
            ),
            if (disabledReason != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(disabledReason,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12,
                        color: HalalEtTheme.negative,
                        fontWeight: FontWeight.w500)),
              ),
          ],
        );
      },
    );
  }

  Widget _toggle(String label, bool isBuy) {
    final selected = _isBuy == isBuy;
    final color = isBuy ? HalalEtTheme.positive : HalalEtTheme.negative;
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
                  color: selected ? Colors.white : HalalEtTheme.textMuted)),
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
            color: HalalEtTheme.cardBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: HalalEtTheme.divider),
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: HalalEtTheme.textSecondary,
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
              color: HalalEtTheme.cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: HalalEtTheme.divider),
            ),
            alignment: Alignment.center,
            child: Text('$label\n${_fmt.format(value)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11,
                    color: HalalEtTheme.textSecondary,
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
                  fontSize: 10, color: HalalEtTheme.textMuted)),
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
      color: HalalEtTheme.divider.withValues(alpha: 0.3));

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: HalalEtTheme.textSecondary,
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

  const _ConfirmSheet({
    required this.isBuy,
    required this.asset,
    required this.qty,
    required this.price,
    required this.total,
    required this.fee,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: HalalEtTheme.divider,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(isBuy ? AppLocalizations.of(context).confirmBuy : AppLocalizations.of(context).confirmSell,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 20),
          _row('Asset', asset.symbol),
          _row('Type', isBuy ? AppLocalizations.of(context).buy : AppLocalizations.of(context).sell),
          _row('Quantity', '$qty ${asset.unit}'),
          _row('Price', '${fmt.format(price)} ETB'),
          Divider(color: HalalEtTheme.divider, height: 24),
          _row('Subtotal', '${fmt.format(total)} ETB'),
          _row('Fee (1.5%)', '${fmt.format(fee)} ETB'),
          _row('Total', '${fmt.format(total + (isBuy ? fee : -fee))} ETB',
              bold: true),
          const SizedBox(height: 6),
          const Text('Riba-free flat commission',
              style: TextStyle(
                  fontSize: 11,
                  color: HalalEtTheme.positive,
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: HalalEtTheme.divider),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: HalalEtTheme.textSecondary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBuy
                        ? HalalEtTheme.positive
                        : HalalEtTheme.negative,
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
                  color: HalalEtTheme.textSecondary,
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
