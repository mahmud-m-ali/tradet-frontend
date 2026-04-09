import 'package:flutter/material.dart';
import '../theme.dart';

class ShariaBadge extends StatelessWidget {
  final bool isCompliant;
  final bool compact;

  const ShariaBadge({
    super.key,
    required this.isCompliant,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isCompliant
        ? HalalEtTheme.positive.withValues(alpha: 0.15)
        : HalalEtTheme.negative.withValues(alpha: 0.15);
    final fgColor =
        isCompliant ? HalalEtTheme.positive : HalalEtTheme.negative;

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          isCompliant ? 'Halal' : 'Non-Halal',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fgColor),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isCompliant ? Icons.verified_rounded : Icons.warning_rounded,
              size: 14, color: fgColor),
          const SizedBox(width: 4),
          Text(
            isCompliant ? 'Sharia Compliant' : 'Non-Compliant',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fgColor),
          ),
        ],
      ),
    );
  }
}

class EcxBadge extends StatelessWidget {
  const EcxBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF60A5FA).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'ECX',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF93C5FD)),
      ),
    );
  }
}
