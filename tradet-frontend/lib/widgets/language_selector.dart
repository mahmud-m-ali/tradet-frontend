import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';

/// Compact language dropdown: shows short code with a dropdown to switch.
class LanguageSelector extends StatelessWidget {
  final bool showLabel;
  const LanguageSelector({super.key, this.showLabel = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final currentCode = provider.langCode;
        final shortLabel = AppLocalizations.languageShort[currentCode] ?? 'EN';

        return PopupMenuButton<String>(
          onSelected: (value) {
            if (value != currentCode) {
              provider.setLocale(value);
            }
          },
          offset: const Offset(0, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: TradEtTheme.cardBg,
          itemBuilder: (_) => AppLocalizations.languageNames.entries
              .map((e) => _buildItem(e.key, e.value, e.key == currentCode))
              .toList(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: TradEtTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 16, color: TradEtTheme.accent),
                const SizedBox(width: 4),
                Text(
                  shortLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_drop_down, size: 16, color: TradEtTheme.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<String> _buildItem(String code, String label, bool selected) {
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        children: [
          if (selected)
            const Icon(Icons.check, size: 16, color: TradEtTheme.positive)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
