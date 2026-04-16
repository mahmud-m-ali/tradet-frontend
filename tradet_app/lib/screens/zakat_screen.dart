import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final _fmt = NumberFormat('#,##0.00');
  final _otherSavingsCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();
  final _debtsCtrl = TextEditingController();
  final _expensesCtrl = TextEditingController();
  String _nisabMethod = 'gold';
  Map<String, dynamic>? _result;
  bool _loading = false;

  Future<void> _calculate() async {
    setState(() => _loading = true);
    try {
      final api = context.read<AppProvider>().api;
      final result = await api.calculateZakat(
        otherSavings: double.tryParse(_otherSavingsCtrl.text) ?? 0,
        goldValue: double.tryParse(_goldCtrl.text) ?? 0,
        silverValue: double.tryParse(_silverCtrl.text) ?? 0,
        debts: double.tryParse(_debtsCtrl.text) ?? 0,
        expenses: double.tryParse(_expensesCtrl.text) ?? 0,
        nisabMethod: _nisabMethod,
      );
      setState(() => _result = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to calculate: $e'),
              backgroundColor: TradEtTheme.negative),
        );
      }
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final wide = isWideScreen(context);
    final content = Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
              wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 20),
          children: [
            const Text('Zakat Calculator',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: -0.5)),
            const Text('የዘካት ማስሊያ • Calculate your annual Zakat',
                style: TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
            const SizedBox(height: 24),

            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TradEtTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: TradEtTheme.accent.withValues(alpha: 0.25)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: TradEtTheme.accent, size: 22),
                  SizedBox(width: 12),
                  Expanded(child: Text(
                    'Your portfolio value and wallet balance are auto-calculated. '
                    'Add other wealth below for a complete Zakat assessment.',
                    style: TextStyle(fontSize: 12, color: TradEtTheme.textSecondary),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input form
            _buildCard(l.additionalWealth, [
              _buildInput(_otherSavingsCtrl, 'Other Savings (ETB)', Icons.savings_outlined),
              const SizedBox(height: 12),
              _buildInput(_goldCtrl, 'Gold Value (ETB)', Icons.diamond_outlined),
              const SizedBox(height: 12),
              _buildInput(_silverCtrl, 'Silver Value (ETB)', Icons.monetization_on_outlined),
            ]),
            const SizedBox(height: 16),

            _buildCard(l.deductions, [
              _buildInput(_debtsCtrl, 'Outstanding Debts (ETB)', Icons.money_off_outlined),
              const SizedBox(height: 12),
              _buildInput(_expensesCtrl, 'Essential Expenses (ETB)', Icons.receipt_long_outlined),
            ]),
            const SizedBox(height: 16),

            // Nisab method
            _buildCard(l.nisabMethod, [
              Row(children: [
                Expanded(child: _methodChip('Gold (85g)', 'gold')),
                const SizedBox(width: 12),
                Expanded(child: _methodChip('Silver (595g)', 'silver')),
              ]),
            ]),
            const SizedBox(height: 20),

            // Calculate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TradEtTheme.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _loading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : Text(l.calculateZakat,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),

            // Results
            if (_result != null) ...[
              const SizedBox(height: 24),
              _buildResultCard(),
            ],
          ],
        ),
      ),
    );

    if (wide) return WebContentWrapper(maxWidth: 800, child: content);
    return content;
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
              color: Colors.white)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixText: 'ETB',
      ),
    );
  }

  Widget _methodChip(String label, String value) {
    final selected = _nisabMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _nisabMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? TradEtTheme.accent.withValues(alpha: 0.2)
              : TradEtTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? TradEtTheme.accent : TradEtTheme.divider,
          ),
        ),
        child: Center(child: Text(label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? TradEtTheme.accent : TradEtTheme.textSecondary,
            ))),
      ),
    );
  }

  Widget _buildResultCard() {
    final r = _result!;
    final isObligatory = r['is_obligatory'] == true;
    final zakatAmount = (r['zakat_amount'] ?? 0).toDouble();
    final breakdown = List<Map<String, dynamic>>.from(r['breakdown'] ?? []);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isObligatory ? TradEtTheme.heroGradient : null,
        color: isObligatory ? null : TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isObligatory
            ? [BoxShadow(color: TradEtTheme.primary.withValues(alpha: 0.3),
                blurRadius: 20, offset: const Offset(0, 8))]
            : null,
      ),
      child: Column(
        children: [
          Icon(isObligatory ? Icons.volunteer_activism : Icons.check_circle_outline,
              size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(isObligatory ? 'Zakat is Obligatory' : 'Zakat Not Due',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                  color: Colors.white)),
          Text(isObligatory ? 'ዘካት ይከፈላል' : 'ዘካት አይከፈልም',
              style: TextStyle(fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 20),

          // Amount
          if (isObligatory) ...[
            Text('${_fmt.format(zakatAmount)} ETB',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800,
                    color: Colors.white)),
            Text('${_fmt.format(r['zakat_amount_monthly'])} ETB/month',
                style: TextStyle(fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7))),
            const SizedBox(height: 20),
          ],

          // Summary
          _resultRow('Total Wealth', r['total_wealth']),
          _resultRow('Deductions', r['total_deductions']),
          _resultRow('Net Wealth', r['net_wealth']),
          _resultRow('Nisab (${r['nisab_method']})', r['nisab_threshold']),

          // Breakdown
          if (breakdown.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),
            const Text('Breakdown', style: TextStyle(fontWeight: FontWeight.w700,
                color: Colors.white)),
            const SizedBox(height: 8),
            ...breakdown.map((b) => _resultRow(
                b['category'], b['zakat'], prefix: 'Zakat: ')),
          ],

          const SizedBox(height: 16),
          Text(r['note'] ?? '', style: TextStyle(fontSize: 11,
              color: Colors.white.withValues(alpha: 0.6)),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _resultRow(String label, dynamic value, {String prefix = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8))),
          Text('$prefix${_fmt.format((value ?? 0).toDouble())} ETB',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
