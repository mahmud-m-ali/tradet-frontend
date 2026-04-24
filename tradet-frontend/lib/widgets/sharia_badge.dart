/// Reusable compliance badge widgets for Sharia and ECX status indicators.
import 'package:flutter/material.dart';
import '../theme.dart';

/// Displays a colour-coded Sharia compliance label for an asset.
/// Permissible assets render nothing; only `halal` and `non_compliant` show a badge.
class ShariaBadge extends StatelessWidget {
  /// Falls back to [complianceLevel] when provided; otherwise derived from [isCompliant].
  final bool isCompliant;
  /// When true, renders a compact pill without an icon.
  final bool compact;
  /// If provided, overrides isCompliant: 'halal' | 'permissible' | 'non_compliant'
  final String? complianceLevel;

  const ShariaBadge({
    super.key,
    required this.isCompliant,
    this.compact = false,
    this.complianceLevel,
  });

  String get _level {
    if (complianceLevel != null) return complianceLevel!;
    return isCompliant ? 'halal' : 'permissible';
  }

  Color get _bgColor {
    switch (_level) {
      case 'halal':
        return TradEtTheme.positive.withValues(alpha: 0.15);
      case 'permissible':
        return const Color(0xFFF59E0B).withValues(alpha: 0.15);
      default:
        return TradEtTheme.negative.withValues(alpha: 0.15);
    }
  }

  Color get _fgColor {
    switch (_level) {
      case 'halal':
        return TradEtTheme.positive;
      case 'permissible':
        return const Color(0xFFF59E0B);
      default:
        return TradEtTheme.negative;
    }
  }

  String get _label {
    switch (_level) {
      case 'halal':
        return compact ? 'Halal' : 'Sharia Compliant';
      case 'permissible':
        return compact ? 'Permissible' : 'Permissible';
      default:
        return compact ? 'Non-Halal' : 'Non-Compliant';
    }
  }

  IconData get _icon {
    switch (_level) {
      case 'halal':
        return Icons.verified_rounded;
      case 'permissible':
        return Icons.info_rounded;
      default:
        return Icons.warning_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Permissible assets show no badge — only Halal and Non-Compliant are labelled
    if (_level == 'permissible') return const SizedBox.shrink();

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          _label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _fgColor),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: _fgColor),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _fgColor),
          ),
        ],
      ),
    );
  }
}

/// Small blue pill shown on assets that are listed on the ECX (Ethiopian Commodity Exchange).
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
