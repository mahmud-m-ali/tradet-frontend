import 'package:flutter/material.dart';
import '../theme.dart';

class PriceChange extends StatelessWidget {
  final double change;
  final bool showIcon;
  final double fontSize;

  const PriceChange({
    super.key,
    required this.change,
    this.showIcon = true,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final color = isPositive ? TradEtTheme.positive : TradEtTheme.negative;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon)
            Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              size: fontSize,
              color: color,
            ),
          if (showIcon) const SizedBox(width: 3),
          Text(
            '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
