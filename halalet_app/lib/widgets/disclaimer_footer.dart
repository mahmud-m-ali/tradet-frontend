import 'package:flutter/material.dart';
import '../theme.dart';

/// A bottom disclaimer widget shown on all main screens.
/// Informs users that the app does not constitute financial advice.
class DisclaimerFooter extends StatelessWidget {
  const DisclaimerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: TradEtTheme.surfaceLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: TradEtTheme.divider.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: TradEtTheme.textMuted.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Disclaimer: TradEt is a Sharia-compliant trading platform for '
              'Ethiopian commodities. All information provided is for '
              'informational purposes only and does not constitute financial, '
              'investment, or legal advice. Past performance is not indicative '
              'of future results. Trading involves risk — please consult a '
              'qualified financial advisor before making investment decisions.',
              style: TextStyle(
                fontSize: 10,
                color: TradEtTheme.textMuted,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
