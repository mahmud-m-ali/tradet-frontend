import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/api_service.dart';

/// OHLCV data point for candlestick chart.
class OhlcData {
  final String date;
  final double open, high, low, close;
  final int volume;

  OhlcData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory OhlcData.fromJson(Map<String, dynamic> j) => OhlcData(
        date: j['date'] ?? '',
        open: (j['open'] ?? 0).toDouble(),
        high: (j['high'] ?? 0).toDouble(),
        low: (j['low'] ?? 0).toDouble(),
        close: (j['close'] ?? 0).toDouble(),
        volume: (j['volume'] ?? 0).toInt(),
      );

  bool get isBullish => close >= open;
}

/// Interactive candlestick chart with period selector and touch info.
class CandlestickChart extends StatefulWidget {
  final String symbol;
  final List<double> fallbackPrices;

  const CandlestickChart({
    super.key,
    required this.symbol,
    this.fallbackPrices = const [],
  });

  @override
  State<CandlestickChart> createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart> {
  List<OhlcData> _data = [];
  bool _loading = true;
  String _period = '1mo';
  int? _selectedIndex;
  bool _isLine = false; // toggle between candle and line

  /// Active data for the chart (real OHLCV or synthetic from sparkline).
  List<OhlcData> get _activeData {
    if (_data.isNotEmpty) return _data;
    return _syntheticCandles();
  }

  /// Generate synthetic OHLCV candles from sparkline fallback prices.
  /// Uses wider open/close spread so candlesticks are clearly visible.
  List<OhlcData> _syntheticCandles() {
    final prices = widget.fallbackPrices;
    if (prices.length < 2) return [];
    final result = <OhlcData>[];
    for (int i = 0; i < prices.length; i++) {
      final close = prices[i];
      // Open is midpoint between previous and current price for body width
      final prev = i > 0 ? prices[i - 1] : close;
      final open = i > 0 ? prev : close * 0.99;
      // Wicks extend 2% beyond the body for clear visibility
      final bodyMax = close > open ? close : open;
      final bodyMin = close < open ? close : open;
      final high = bodyMax + (bodyMax - bodyMin).abs() * 0.5 + bodyMax * 0.01;
      final low = bodyMin - (bodyMax - bodyMin).abs() * 0.5 - bodyMin * 0.01;
      result.add(OhlcData(
        date: 'Day ${i + 1}',
        open: open,
        high: high,
        low: low,
        close: close,
        volume: 0,
      ));
    }
    return result;
  }

  static const _periods = {
    '5d': '5D',
    '1mo': '1M',
    '3mo': '3M',
    '6mo': '6M',
    '1y': '1Y',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final api = ApiService();
    final raw = await api.getChartHistory(widget.symbol, period: _period);
    final parsed = raw.map((j) => OhlcData.fromJson(j)).toList();
    if (mounted) {
      setState(() {
        _data = parsed;
        _loading = false;
        _selectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: title + toggle + period pills
          Row(
            children: [
              const Text('Price Chart',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(width: 8),
              // Candle / Line toggle — clearly labeled
              GestureDetector(
                onTap: () => setState(() => _isLine = !_isLine),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: TradEtTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: TradEtTheme.accent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isLine ? Icons.show_chart : Icons.candlestick_chart,
                          size: 16,
                          color: TradEtTheme.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isLine ? 'Line' : 'Candle',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: TradEtTheme.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ..._periods.entries.map((e) => _periodChip(e.key, e.value)),
            ],
          ),
          const SizedBox(height: 8),
          // Info bar
          if (_selectedIndex != null && _selectedIndex! < _activeData.length)
            _infoBar(_activeData[_selectedIndex!])
          else if (_activeData.isNotEmpty)
            _infoBar(_activeData.last),
          const SizedBox(height: 8),
          // Chart area
          SizedBox(
            height: 200,
            child: _loading
                ? const Center(
                    child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: TradEtTheme.accent)))
                : _activeData.isEmpty
                    ? const Center(
                        child: Text('No chart data',
                            style: TextStyle(color: TradEtTheme.textMuted)))
                    : GestureDetector(
                        onPanUpdate: (details) => _onPan(details),
                        onPanEnd: (_) => setState(() => _selectedIndex = null),
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _isLine
                              ? _LinePainter(_activeData, _selectedIndex)
                              : _CandlePainter(_activeData, _selectedIndex),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _infoBar(OhlcData d) {
    final change = d.close - d.open;
    final changePct = d.open > 0 ? (change / d.open * 100) : 0.0;
    final color = change >= 0 ? TradEtTheme.positive : TradEtTheme.negative;
    return Row(
      children: [
        Text(d.date,
            style: const TextStyle(color: TradEtTheme.textMuted, fontSize: 10)),
        const Spacer(),
        _infoChip('O', d.open),
        _infoChip('H', d.high),
        _infoChip('L', d.low),
        _infoChip('C', d.close, color: color),
        const SizedBox(width: 4),
        Text('${changePct >= 0 ? "+" : ""}${changePct.toStringAsFixed(1)}%',
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _infoChip(String label, double value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: '$label ',
                style: const TextStyle(color: TradEtTheme.textMuted, fontSize: 9)),
            TextSpan(
                text: value.toStringAsFixed(0),
                style: TextStyle(
                    color: color ?? Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _periodChip(String key, String label) {
    final selected = _period == key;
    return GestureDetector(
      onTap: () {
        setState(() => _period = key);
        _loadData();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? TradEtTheme.primaryLight.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? TradEtTheme.positive : TradEtTheme.textMuted)),
      ),
    );
  }

  void _onPan(DragUpdateDetails details) {
    final data = _activeData;
    if (data.isEmpty) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final localX = details.localPosition.dx;
    final chartWidth = box.size.width - 32; // padding
    final idx = (localX / chartWidth * data.length).clamp(0, data.length - 1).toInt();
    if (idx != _selectedIndex) setState(() => _selectedIndex = idx);
  }
}

// ─── Candlestick Painter ───

class _CandlePainter extends CustomPainter {
  final List<OhlcData> data;
  final int? selectedIndex;

  _CandlePainter(this.data, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final allPrices = data.expand((d) => [d.high, d.low]);
    final minP = allPrices.reduce((a, b) => a < b ? a : b);
    final maxP = allPrices.reduce((a, b) => a > b ? a : b);
    final range = maxP - minP;
    // If all prices identical, add tiny range to avoid division by zero
    final effectiveRange = range == 0 ? 1.0 : range;

    final candleWidth = (size.width / data.length * 0.65).clamp(4.0, 14.0);
    final gap = size.width / data.length;

    double toY(double price) =>
        size.height * 0.05 +
        (size.height * 0.9) -
        ((price - minP) / effectiveRange * (size.height * 0.9));

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      final x = gap * i + gap / 2;
      final bullish = d.isBullish;
      final color = bullish ? const Color(0xFF26A69A) : const Color(0xFFEF5350);

      // Wick (thin line through high-low)
      canvas.drawLine(
        Offset(x, toY(d.high)),
        Offset(x, toY(d.low)),
        Paint()
          ..color = color
          ..strokeWidth = 1.5,
      );

      // Body — ensure minimum 4px height for visibility
      final bodyTop = toY(bullish ? d.close : d.open);
      final bodyBottom = toY(bullish ? d.open : d.close);
      final rawHeight = (bodyBottom - bodyTop).abs();
      final bodyHeight = rawHeight < 4.0 ? 4.0 : rawHeight;
      final bodyY = rawHeight < 4.0
          ? (bodyTop + bodyBottom) / 2 - 2.0
          : (bodyTop < bodyBottom ? bodyTop : bodyBottom);

      final bodyRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - candleWidth / 2, bodyY, candleWidth, bodyHeight),
        const Radius.circular(1.5),
      );

      // Filled body
      canvas.drawRRect(bodyRect, Paint()..color = color);

      // Border for extra clarity
      canvas.drawRRect(
        bodyRect,
        Paint()
          ..color = bullish
              ? const Color(0xFF2ECC71)
              : const Color(0xFFFF6B6B)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );

      // Selected highlight
      if (i == selectedIndex) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.4)
            ..strokeWidth = 1,
        );
        // Highlight dot on close price
        canvas.drawCircle(
          Offset(x, toY(d.close)),
          3.5,
          Paint()..color = Colors.white,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CandlePainter old) => true;
}

// ─── Line Painter (from OHLCV close prices) ───

class _LinePainter extends CustomPainter {
  final List<OhlcData> data;
  final int? selectedIndex;

  _LinePainter(this.data, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final closes = data.map((d) => d.close).toList();
    final minP = closes.reduce((a, b) => a < b ? a : b);
    final maxP = closes.reduce((a, b) => a > b ? a : b);
    final range = maxP - minP;
    if (range == 0) return; // flat line, nothing to draw

    final isPositive = closes.last >= closes.first;
    final color = isPositive ? const Color(0xFF4CAF50) : const Color(0xFFEF5350);
    final gap = size.width / (data.length - 1);

    double toY(double price) => size.height - ((price - minP) / range * size.height);

    final path = Path();
    for (int i = 0; i < closes.length; i++) {
      final x = gap * i;
      final y = toY(closes[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // Fill
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Selected crosshair
    if (selectedIndex != null && selectedIndex! < closes.length) {
      final sx = gap * selectedIndex!;
      final sy = toY(closes[selectedIndex!]);
      canvas.drawLine(
        Offset(sx, 0),
        Offset(sx, size.height),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..strokeWidth = 1,
      );
      canvas.drawCircle(Offset(sx, sy), 4, Paint()..color = color);
      canvas.drawCircle(
          Offset(sx, sy), 6, Paint()..color = color.withValues(alpha: 0.3));
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) => true;
}

// _FallbackLinePainter removed — synthetic candles are now used for all modes.
