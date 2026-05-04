import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/security_log_service.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';

/// Collapsible security audit log widget.
/// Shows a 2-column grid on wide screens and a vertical timeline on mobile.
class SecurityLogSection extends StatefulWidget {
  const SecurityLogSection({super.key});

  @override
  State<SecurityLogSection> createState() => _SecurityLogSectionState();
}

class _SecurityLogSectionState extends State<SecurityLogSection> {
  List<SecurityLogEntry> _entries = [];
  bool _loading = true;
  bool _collapsed = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final entries = await SecurityLogService.getEntries(limit: 20);
    if (mounted) setState(() { _entries = entries; _loading = false; });
  }

  static IconData _iconFor(String event) {
    switch (event) {
      case 'LOGIN_SUCCESS': return Icons.login;
      case 'LOGIN_FAIL': return Icons.gpp_bad_outlined;
      case 'LOGOUT': return Icons.logout;
      case 'SESSION_TIMEOUT': return Icons.timer_off_outlined;
      case 'ORDER_PLACED': return Icons.check_circle_outline;
      case 'ORDER_CANCELLED': return Icons.cancel_outlined;
      case 'DEPOSIT': return Icons.arrow_downward;
      case 'WITHDRAWAL': return Icons.arrow_upward;
      case 'KYC_SUBMITTED': return Icons.verified_user_outlined;
      case 'PROFILE_CHANGED': return Icons.edit_outlined;
      case 'ALERT_CREATED': return Icons.notifications_outlined;
      case 'WATCHLIST_CHANGED': return Icons.bookmark_outline;
      default: return Icons.circle_outlined;
    }
  }

  static Color _colorFor(String event) {
    switch (event) {
      case 'LOGIN_FAIL':
      case 'SESSION_TIMEOUT':
      case 'ORDER_CANCELLED':
        return TradEtTheme.negative;
      case 'LOGIN_SUCCESS':
      case 'KYC_SUBMITTED':
      case 'ORDER_PLACED':
        return TradEtTheme.positive;
      default:
        return TradEtTheme.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBgLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _collapsed = !_collapsed),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Icon(Icons.security, size: 18, color: TradEtTheme.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(AppLocalizations.of(context).securityLog,
                      style: const TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                if (!_loading)
                  Text('${_entries.length} events',
                      style: const TextStyle(color: TradEtTheme.textMuted, fontSize: 11)),
                const SizedBox(width: 4),
                if (!_collapsed)
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18,
                        color: TradEtTheme.textSecondary),
                    tooltip: AppLocalizations.of(context).refresh,
                    onPressed: _load,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                AnimatedRotation(
                  turns: _collapsed ? -0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.expand_more,
                      size: 20, color: TradEtTheme.textSecondary),
                ),
              ],
            ),
          ),

          if (!_collapsed) ...[
            const SizedBox(height: 12),
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(
                      color: TradEtTheme.accent, strokeWidth: 2),
                ),
              )
            else if (_entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(AppLocalizations.of(context).noSecurityEvents,
                      style: const TextStyle(color: TradEtTheme.textSecondary, fontSize: 13)),
                ),
              )
            else if (wide)
              _buildGrid()
            else
              _buildTimeline(),
          ],
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final rows = <List<SecurityLogEntry>>[];
    for (var i = 0; i < _entries.length; i += 2) {
      rows.add([_entries[i], if (i + 1 < _entries.length) _entries[i + 1]]);
    }
    return Column(
      children: rows.map((pair) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Expanded(child: _gridCell(pair[0])),
              const SizedBox(width: 6),
              if (pair.length > 1)
                Expanded(child: _gridCell(pair[1]))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _gridCell(SecurityLogEntry e) {
    final color = _colorFor(e.event);
    final tsLabel = e.timestamp.length >= 16
        ? e.timestamp.substring(0, 16).replaceFirst('T', ' ')
        : e.timestamp;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(_iconFor(e.event), size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.event,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: color, fontSize: 11,
                        fontWeight: FontWeight.w600, letterSpacing: 0.2)),
                Text(tsLabel,
                    style: const TextStyle(color: TradEtTheme.textMuted, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: List.generate(_entries.length, (i) {
        final e = _entries[i];
        final color = _colorFor(e.event);
        final tsLabel = e.timestamp.length >= 16
            ? e.timestamp.substring(0, 16).replaceFirst('T', ' ')
            : e.timestamp;
        final isLast = i == _entries.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_iconFor(e.event), size: 12, color: color),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1.5,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: TradEtTheme.divider.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(e.event,
                            style: TextStyle(color: color, fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                      Text(tsLabel,
                          style: const TextStyle(
                              color: TradEtTheme.textMuted, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
