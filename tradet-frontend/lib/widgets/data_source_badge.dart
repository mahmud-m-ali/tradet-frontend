import 'package:flutter/material.dart';
import '../theme.dart';

class DataSourceBadge extends StatelessWidget {
  final String? dataSource;
  final bool compact;

  const DataSourceBadge({super.key, this.dataSource, this.compact = true});

  @override
  Widget build(BuildContext context) {
    final isLive = dataSource == 'live';
    final isPending = dataSource == 'live_pending';

    final color = isLive
        ? TradEtTheme.positive
        : isPending
            ? TradEtTheme.warning
            : TradEtTheme.textMuted;

    final label = isLive
        ? 'LIVE'
        : isPending
            ? 'PENDING'
            : 'SIM';

    final icon = isLive
        ? Icons.cell_tower
        : isPending
            ? Icons.hourglass_top
            : Icons.science_outlined;

    if (compact) {
      return Tooltip(
        message: isLive
            ? 'Live data from Yahoo Finance'
            : isPending
                ? 'Live feed available, waiting for next update'
                : 'Simulated / manually entered data',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 9, color: color),
              const SizedBox(width: 3),
              Text(label, style: TextStyle(
                fontSize: 8, fontWeight: FontWeight.w700,
                color: color, letterSpacing: 0.5,
              )),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            isLive ? 'Live Data' : isPending ? 'Pending Live' : 'Simulated',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
