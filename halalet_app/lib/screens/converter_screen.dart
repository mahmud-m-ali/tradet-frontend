import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _fmt = NumberFormat('#,##0.00');
  final _amountCtrl = TextEditingController(text: '1000');
  Map<String, ExchangeRate> _rates = {};
  bool _loading = true;

  String _fromCurrency = 'ETB';
  String _toCurrency = 'USD';
  double? _convertedAmount;
  double? _rate;

  final _currencies = ['ETB', 'USD', 'EUR', 'GBP', 'SAR', 'AED', 'KES'];
  final _currencyNames = {
    'ETB': 'Ethiopian Birr',
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'SAR': 'Saudi Riyal',
    'AED': 'UAE Dirham',
    'KES': 'Kenyan Shilling',
  };
  final _currencyFlags = {
    'ETB': '🇪🇹', 'USD': '🇺🇸', 'EUR': '🇪🇺', 'GBP': '🇬🇧',
    'SAR': '🇸🇦', 'AED': '🇦🇪', 'KES': '🇰🇪',
  };

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    setState(() => _loading = true);
    try {
      _rates = await context.read<AppProvider>().api.getExchangeRates();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
    _convert();
  }

  Future<void> _convert() async {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null) return;

    try {
      final result = await context.read<AppProvider>().api.convertCurrency(
        amount: amount,
        from: _fromCurrency,
        to: _toCurrency,
      );
      setState(() {
        _convertedAmount = (result['converted'] as num?)?.toDouble();
        _rate = (result['rate'] as num?)?.toDouble();
      });
    } catch (_) {}
  }

  void _swap() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);

    final content = Container(
      decoration: BoxDecoration(gradient: HalalEtTheme.bgGradient),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
              wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 20),
          children: [
            const Text('Currency Converter',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: -0.5)),
            const Text('የምንዛሬ መቀየሪያ • NBE Exchange Rates',
                style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
            const SizedBox(height: 24),

            // Converter card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: HalalEtTheme.cardGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [HalalEtTheme.cardShadow],
              ),
              child: Column(
                children: [
                  // Amount input
                  TextField(
                    controller: _amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white, fontSize: 24,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter amount',
                      hintStyle: TextStyle(color: HalalEtTheme.textMuted, fontSize: 20),
                    ),
                    onChanged: (_) => _convert(),
                  ),
                  const SizedBox(height: 16),

                  // From currency
                  _buildCurrencyPicker(_fromCurrency, (v) {
                    setState(() => _fromCurrency = v!);
                    _convert();
                  }),
                  const SizedBox(height: 12),

                  // Swap button
                  GestureDetector(
                    onTap: _swap,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: HalalEtTheme.primaryLight.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.swap_vert, color: HalalEtTheme.positive, size: 28),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // To currency
                  _buildCurrencyPicker(_toCurrency, (v) {
                    setState(() => _toCurrency = v!);
                    _convert();
                  }),
                  const SizedBox(height: 20),

                  // Result
                  if (_convertedAmount != null) ...[
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 12),
                    Text(
                      '${_fmt.format(_convertedAmount)} $_toCurrency',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    if (_rate != null)
                      Text(
                        '1 $_fromCurrency = ${_rate!.toStringAsFixed(4)} $_toCurrency',
                        style: TextStyle(fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.7)),
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Exchange rates table
            const Text('NBE Exchange Rates / የኤንቢኢ ምንዛሬ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 12),

            if (_loading)
              const Center(child: CircularProgressIndicator(color: HalalEtTheme.positive))
            else if (_rates.isEmpty)
              const Center(child: Text('No rates available',
                  style: TextStyle(color: HalalEtTheme.textMuted)))
            else
              Container(
                decoration: BoxDecoration(
                  color: HalalEtTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Expanded(flex: 2, child: Text('Currency',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                  color: HalalEtTheme.textMuted))),
                          Expanded(child: Text('Buy', textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                  color: HalalEtTheme.textMuted))),
                          Expanded(child: Text('Sell', textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                  color: HalalEtTheme.textMuted))),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: HalalEtTheme.divider.withValues(alpha: 0.3)),
                    ..._rates.entries.map((e) => _buildRateRow(e.key, e.value)),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            const Center(child: Text(
              'Rates sourced from National Bank of Ethiopia',
              style: TextStyle(fontSize: 11, color: HalalEtTheme.textMuted),
            )),
          ],
        ),
      ),
    );

    if (wide) return WebContentWrapper(maxWidth: 700, child: content);
    return content;
  }

  Widget _buildCurrencyPicker(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: HalalEtTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HalalEtTheme.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: HalalEtTheme.cardBgLight,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: _currencies.map((c) => DropdownMenuItem(
            value: c,
            child: Row(
              children: [
                Text(_currencyFlags[c] ?? '', style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Text(c, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Expanded(child: Text(_currencyNames[c] ?? '',
                    style: const TextStyle(fontSize: 12, color: HalalEtTheme.textMuted),
                    overflow: TextOverflow.ellipsis)),
              ],
            ),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRateRow(String currency, ExchangeRate rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(_currencyFlags[currency] ?? '', style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currency, style: const TextStyle(fontWeight: FontWeight.w700,
                  fontSize: 14, color: Colors.white)),
              Text(_currencyNames[currency] ?? '',
                  style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted)),
            ],
          )),
          Expanded(child: Text(_fmt.format(rate.buying), textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, color: Colors.white))),
          Expanded(child: Text(_fmt.format(rate.selling), textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, color: Colors.white))),
        ],
      ),
    );
  }
}
