import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';

class MiniSparkline extends StatelessWidget {
  final List<double> data;
  final Color? color;
  final double height;
  final double width;

  const MiniSparkline({
    super.key,
    required this.data,
    this.color,
    this.height = 40,
    this.width = 80,
  });

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) return SizedBox(height: height, width: width);

    final isPositive = data.last >= data.first;
    final lineColor = color ?? (isPositive ? TradEtTheme.positive : TradEtTheme.negative);

    return SizedBox(
      height: height,
      width: width,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (i) => FlSpot(i.toDouble(), data[i]),
              ),
              isCurved: true,
              curveSmoothness: 0.3,
              color: lineColor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TradingChart extends StatefulWidget {
  final List<double> prices;
  final String symbol;
  final Color? lineColor;

  const TradingChart({
    super.key,
    required this.prices,
    required this.symbol,
    this.lineColor,
  });

  @override
  State<TradingChart> createState() => _TradingChartState();
}

class _TradingChartState extends State<TradingChart> {
  String _period = '1D';
  List<double> _prices = [];
  bool _loading = false;

  // Period label → (API period, interval)
  static const _periodMap = {
    '1D': ('1d',  '15m'),
    '1W': ('5d',  '1h'),
    '1M': ('1mo', '1d'),
    '3M': ('3mo', '1d'),
    '1Y': ('1y',  '1wk'),
  };

  @override
  void initState() {
    super.initState();
    _prices = List<double>.from(widget.prices);
    // Fetch 1M data immediately so the default view isn't the same sparkline
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final (period, interval) = _periodMap[_period] ?? ('1mo', '1d');
      final raw = await ApiService().getChartHistory(
        widget.symbol,
        period: period,
        interval: interval,
      );
      if (!mounted) return;
      final closes = raw
          .map((j) {
            final v = j['close'] ?? j['price'];
            if (v == null) return null;
            return (v as num).toDouble();
          })
          .whereType<double>()
          .toList();
      setState(() {
        if (closes.length >= 2) _prices = closes;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading && _prices.length < 2) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(AppLocalizations.of(context).noChartDataAvailable,
              style: const TextStyle(color: TradEtTheme.textMuted)),
        ),
      );
    }

    final isPositive = _prices.isEmpty || _prices.last >= _prices.first;
    final lineColor = widget.lineColor ??
        (isPositive ? TradEtTheme.positive : TradEtTheme.negative);
    final minY = _prices.isEmpty ? 0.0 :
        _prices.reduce((a, b) => a < b ? a : b) * 0.998;
    final maxY = _prices.isEmpty ? 1.0 :
        _prices.reduce((a, b) => a > b ? a : b) * 1.002;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector
          Row(
            children: [
              Text(AppLocalizations.of(context).priceChart,
                  style: const TextStyle(
                      color: TradEtTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              const Spacer(),
              ..._periodMap.keys.map((p) => _periodChip(p)),
            ],
          ),
          const SizedBox(height: 16),
          // Chart or loader
          SizedBox(
            height: 180,
            child: _loading
                ? const Center(child: CircularProgressIndicator(
                    strokeWidth: 2, color: TradEtTheme.positive))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: (maxY - minY) / 4,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: TradEtTheme.divider.withValues(alpha: 0.3),
                          strokeWidth: 0.5,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) => Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(
                                  color: TradEtTheme.textMuted, fontSize: 10),
                            ),
                          ),
                        ),
                        bottomTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: minY,
                      maxY: maxY,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => TradEtTheme.primaryDark,
                          getTooltipItems: (spots) => spots.map((s) {
                            return LineTooltipItem(
                              '${s.y.toStringAsFixed(2)} ETB',
                              const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            );
                          }).toList(),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            _prices.length,
                            (i) => FlSpot(i.toDouble(), _prices[i]),
                          ),
                          isCurved: true,
                          curveSmoothness: 0.25,
                          color: lineColor,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                lineColor.withValues(alpha: 0.25),
                                lineColor.withValues(alpha: 0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 300),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _periodChip(String label) {
    final selected = _period == label;
    return GestureDetector(
      onTap: () {
        if (_period == label) return;
        setState(() => _period = label);
        _loadData();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.only(left: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: selected
                ? TradEtTheme.primaryLight.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected ? TradEtTheme.positive : TradEtTheme.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
