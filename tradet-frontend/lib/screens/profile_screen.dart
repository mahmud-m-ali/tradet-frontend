import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/web_file_picker.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/language_selector.dart';
import '../widgets/responsive_layout.dart';
import '../services/security_log_service.dart';
import '../services/pdf_export_service.dart';
import 'login_screen.dart';
import 'security_screen.dart';
import '../utils/security_challenge.dart';
import '../utils/ethiopian_date.dart';
import '../widgets/security_log_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);

    return Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, _) {
            final user = provider.user;
            if (wide) return _buildWebLayout(context, provider, user);
            return _buildMobileMenu(context, provider, user);
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MOBILE — 5-category menu matching doc spec
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMobileMenu(BuildContext context, AppProvider provider, dynamic user) {
    final l = AppLocalizations.of(context);
    final name = user?.fullName ?? 'User';
    final email = user?.email ?? '';

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 32),
                  const Spacer(),
                  _mobileAvatar(context, provider, user, size: 72),
                  const Spacer(),
                  const SizedBox(width: 32),
                ],
              ),
              const SizedBox(height: 12),
              Text(name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('@${email.split('@').first}',
                      style: const TextStyle(color: TradEtTheme.accent, fontSize: 13)),
                  const SizedBox(width: 6),
                  const Icon(Icons.qr_code_2_rounded, size: 16,
                      color: TradEtTheme.textSecondary),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _statCard(
                    icon: Icons.verified_rounded,
                    label: l.verificationTier,
                    value: l.tier1,
                    color: TradEtTheme.positive,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _statCard(
                    icon: Icons.person_add_alt_1_rounded,
                    label: l.inviteFriends,
                    value: l.inviteEarn,
                    color: TradEtTheme.accent,
                  )),
                ],
              ),
            ],
          ),
        ),

        // ── 1. Account ───────────────────────────────────────────────────
        _menuCard([
          _menuItem(context,
              icon: Icons.person_outline_rounded,
              label: l.account,
              subtitle: '${l.profileInformation}, ${l.verificationStatus}...',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => _AccountDetailsScreen(user: user)))),
        ]),
        const SizedBox(height: 10),

        // ── 2. Security & Privacy ─────────────────────────────────────────
        _menuCard([
          _menuItem(context,
              icon: Icons.shield_outlined,
              label: l.securityAndPrivacy,
              subtitle: '${l.loginSecurity}, ${l.privacyControls}',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _SecurityPrivacyMenuScreen()))),
        ]),
        const SizedBox(height: 10),

        // ── 3. Notifications ──────────────────────────────────────────────
        _menuCard([
          _menuItem(context,
              icon: Icons.notifications_outlined,
              label: l.notifications,
              subtitle: '${l.marketAlerts}, ${l.systemMarketing}',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _NotificationsMenuScreen()))),
        ]),
        const SizedBox(height: 10),

        // ── 4. Help & Support ─────────────────────────────────────────────
        _menuCard([
          _menuItem(context,
              icon: Icons.help_outline_rounded,
              label: l.helpAndSupport,
              subtitle: '${l.supportCenter}, ${l.contactUs}',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _HelpSupportMenuScreen()))),
        ]),
        const SizedBox(height: 10),

        // ── 5. Compliance & Documents ─────────────────────────────────────
        _menuCard([
          _menuItem(context,
              icon: Icons.description_outlined,
              label: l.complianceDocuments,
              subtitle: '${l.legalDocs}, ${l.halalCompliance}...',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => _ComplianceDocsScreen()))),
        ]),
        const SizedBox(height: 16),

        // ── Preferences (inline) ──────────────────────────────────────────
        _menuCard([
          _menuItem(context, icon: Icons.palette_outlined, label: l.appearance,
              trailing: Consumer<AppProvider>(
                builder: (ctx, prov, _) => Switch(
                  value: prov.isDarkMode,
                  onChanged: (_) => prov.toggleTheme(),
                  activeThumbColor: TradEtTheme.positive,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              onTap: null),
          _menuDivider(),
          _menuItem(context, icon: Icons.language_rounded, label: l.language,
              trailing: const LanguageSelector(),
              onTap: null),
          _menuDivider(),
          _menuItem(context, icon: Icons.info_outline_rounded, label: l.aboutUs,
              onTap: () => _showAboutDialog(context)),
          _menuDivider(),
          _menuItem(context,
              icon: Icons.logout_rounded,
              label: l.logout,
              labelColor: TradEtTheme.negative,
              iconColor: TradEtTheme.negative,
              onTap: () async {
                await provider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              }),
        ]),

        const SizedBox(height: 20),

        // ── Footer ──────────────────────────────────────────────────────
        Center(
          child: Column(
            children: [
              const Text('Version 1.0',
                  style: TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
              const Text('Amber Research Inc.',
                  style: TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
              Text('${l.lastLogin}: ${_lastLoginLabel(context)}',
                  style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  String _lastLoginLabel(BuildContext context) {
    final now = DateTime.now();
    final langCode = context.read<AppProvider>().langCode;
    final datePart = EthiopianDate.formatDate(now, langCode);
    return '$datePart ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
                Text(value,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? subtitle,
    VoidCallback? onTap,
    int? badge,
    Widget? trailing,
    Color? labelColor,
    Color? iconColor,
  }) {
    final tile = ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? TradEtTheme.textSecondary).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? TradEtTheme.textSecondary, size: 20),
      ),
      title: Text(label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
              color: labelColor ?? Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted),
              maxLines: 1, overflow: TextOverflow.ellipsis)
          : null,
      trailing: trailing ??
          (badge != null
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: TradEtTheme.negative,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('$badge',
                        style: const TextStyle(color: Colors.white,
                            fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ])
              : (onTap != null
                  ? const Icon(Icons.chevron_right_rounded,
                      color: TradEtTheme.textMuted, size: 20)
                  : null)),
      onTap: onTap,
    );
    return tile;
  }

  Widget _menuDivider() =>
      Divider(height: 1, indent: 56, color: TradEtTheme.divider.withValues(alpha: 0.3));

  Widget _mobileAvatar(BuildContext context, AppProvider provider, dynamic user, {double size = 64}) {
    const avatarColors = [
      Color(0xFF0F6B3C), Color(0xFF1D4ED8), Color(0xFF7C3AED),
      Color(0xFFB45309), Color(0xFF0D9488), Color(0xFF9D174D),
    ];
    final bg = avatarColors[provider.avatarColorIndex % avatarColors.length];
    final imgBytes = provider.profileImageBytes;
    final initial = (user?.fullName ?? 'U').isNotEmpty
        ? (user?.fullName ?? 'U')[0].toUpperCase()
        : '?';

    // Display-only avatar — photo changes are done in Account → Your Profile
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: imgBytes != null
          ? ClipOval(child: Image.memory(imgBytes, width: size, height: size, fit: BoxFit.cover))
          : Center(child: Text(initial,
              style: TextStyle(fontSize: size * 0.4,
                  fontWeight: FontWeight.w700, color: Colors.white))),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TradEtTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('About TradEt', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TradEt v1.0.0', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text('by Amber Research Inc.',
                style: TextStyle(color: TradEtTheme.textSecondary, fontSize: 13)),
            SizedBox(height: 12),
            Text('Sharia-compliant Ethiopian commodity trading platform. '
                'AAOIFI certified • ECX Licensed • NBE Regulated.',
                style: TextStyle(color: TradEtTheme.textSecondary, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: TradEtTheme.positive)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // WEB LAYOUT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildWebLayout(BuildContext context, AppProvider provider, dynamic user) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      children: [
        Text(l.profile,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
                color: Colors.white, letterSpacing: -0.5)),
        Text(l.accountSettings,
            style: const TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
        const SizedBox(height: 24),

        _webUserBanner(context, provider, user),
        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Compliance + Security Log
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _webComplianceCard(context),
                  const SizedBox(height: 16),
                  _webLegalDocsCard(context),
                  const SizedBox(height: 16),
                  const SecurityLogSection(),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Middle: Preferences + Notifications + Help
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _webSettingsCard(context, provider),
                  const SizedBox(height: 16),
                  _webNotificationsCard(context),
                  const SizedBox(height: 16),
                  _webHelpCard(context),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Right: Account + Payment + Logout
            Expanded(child: _webAccountCard(context, provider, user)),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: Text(
            'TradEt v1.0.0 by Amber — Sharia & Ethiopian Trade Compliant',
            style: TextStyle(fontSize: 11,
                color: TradEtTheme.textMuted.withValues(alpha: 0.6)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _webUserBanner(BuildContext context, AppProvider provider, dynamic user) {
    final name = user?.fullName ?? 'User';
    final email = user?.email ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final isVerified = user?.kycStatus == 'verified';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F6B3C), Color(0xFF1B8A5A), Color(0xFF27AE60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TradEtTheme.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Consumer<AppProvider>(
            builder: (context, prov, _) {
              const avatarColors = [
                Color(0xFF0F6B3C), Color(0xFF1D4ED8), Color(0xFF7C3AED),
                Color(0xFFB45309), Color(0xFF0D9488), Color(0xFF9D174D),
              ];
              final bg = avatarColors[prov.avatarColorIndex % avatarColors.length];
              final imgBytes = prov.profileImageBytes;
              return GestureDetector(
                onTap: () => _showAvatarOptions(context, prov),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Stack(
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: bg,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: imgBytes != null
                            ? ClipOval(child: Image.memory(imgBytes, width: 80, height: 80, fit: BoxFit.cover))
                            : Center(child: Text(initial,
                                style: const TextStyle(fontSize: 32,
                                    fontWeight: FontWeight.w700, color: Colors.white))),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                              border: Border.all(color: bg, width: 2)),
                          child: Icon(Icons.camera_alt, size: 12, color: bg),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700,
                        color: Colors.white, letterSpacing: -0.3)),
                const SizedBox(height: 4),
                Text(email,
                    style: TextStyle(fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7))),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _kycBadge(isVerified),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 12,
                              color: Colors.white.withValues(alpha: 0.6)),
                          const SizedBox(width: 6),
                          Text('Member since 2024',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _bannerStat('Holdings', user?.walletBalance != null ? 'Active' : '--',
                  Icons.pie_chart_outline),
              const SizedBox(width: 16),
              _bannerStat('Alerts', 'Active', Icons.notifications_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bannerStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.7)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
              color: Colors.white)),
          Text(label, style: TextStyle(fontSize: 10,
              color: Colors.white.withValues(alpha: 0.5))),
        ],
      ),
    );
  }

  Widget _kycBadge(bool isVerified) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isVerified
            ? TradEtTheme.positive.withValues(alpha: 0.2)
            : TradEtTheme.warning.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isVerified
              ? TradEtTheme.positive.withValues(alpha: 0.4)
              : TradEtTheme.warning.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified_rounded : Icons.pending_rounded,
            size: 14,
            color: isVerified ? TradEtTheme.positive : TradEtTheme.warning,
          ),
          const SizedBox(width: 5),
          Text(
            isVerified ? 'KYC Verified' : 'KYC Pending',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11,
                color: isVerified ? TradEtTheme.positive : TradEtTheme.warning),
          ),
        ],
      ),
    );
  }

  Widget _webComplianceCard(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.verified_user_rounded, l.compliance,
              'Standards & certification', TradEtTheme.positive),
          const SizedBox(height: 18),
          _webComplianceItem(Icons.verified_rounded, 'Sharia (AAOIFI)',
              'Halal screened', TradEtTheme.positive),
          _webComplianceItem(Icons.account_balance_rounded, 'ECX Regulated',
              'Ethiopian rules', const Color(0xFF60A5FA)),
          _webComplianceItem(Icons.security_rounded, 'NBE Supervised',
              'National Bank', const Color(0xFF818CF8)),
          _webComplianceItem(Icons.money_off_rounded, 'Riba-Free',
              'No interest', const Color(0xFF22D3EE)),
          _webComplianceItem(Icons.block_rounded, 'No Short Sell',
              'Spot trading only', TradEtTheme.warning, isLast: true),
          const SizedBox(height: 14),
          const Divider(color: TradEtTheme.divider, thickness: 0.4),
          const SizedBox(height: 10),
          Consumer<AppProvider>(
            builder: (context, provider, _) => SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final user = provider.user;
                  if (user == null) return;
                  try {
                    final events = await SecurityLogService.getEntries(limit: 30);
                    if (context.mounted) {
                      await PdfExportService.exportCsmsReport(
                        context: context,
                        user: user,
                        holdings: provider.holdings,
                        events: events,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) PdfExportService.showError(context, e);
                  }
                },
                icon: const Icon(Icons.picture_as_pdf_outlined,
                    size: 16, color: TradEtTheme.accent),
                label: Text(l.exportSecurityReport,
                    style: const TextStyle(color: TradEtTheme.accent, fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: TradEtTheme.accent, width: 0.8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _webLegalDocsCard(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.description_outlined, l.complianceDocuments,
              'Legal & regulatory', const Color(0xFF818CF8)),
          const SizedBox(height: 16),
          _webSettingRow(
            icon: Icons.gavel_rounded,
            title: l.legalDocs,
            subtitle: 'Terms, Risk Disclosures, Privacy Policy',
            color: const Color(0xFF60A5FA),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.legalDocs} — coming soon'),
                  behavior: SnackBarBehavior.floating)),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.account_balance_outlined,
            title: l.regulatoryStatus,
            subtitle: 'ESX licensing info',
            color: const Color(0xFF818CF8),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.regulatoryStatus} — coming soon'),
                  behavior: SnackBarBehavior.floating)),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.verified_rounded,
            title: l.halalCompliance,
            subtitle: 'Sharia screening audit',
            color: TradEtTheme.positive,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.halalCompliance} — coming soon'),
                  behavior: SnackBarBehavior.floating)),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.receipt_long_outlined,
            title: l.taxStatements,
            subtitle: 'Annual P&L for tax declaration',
            color: TradEtTheme.accent,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            isLast: true,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.taxStatements} — coming soon'),
                  behavior: SnackBarBehavior.floating)),
          ),
        ],
      ),
    );
  }

  Widget _webNotificationsCard(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.notifications_outlined, l.notifications,
              'Alerts & messaging', TradEtTheme.accent),
          const SizedBox(height: 16),
          _webSettingRow(
            icon: Icons.show_chart_rounded,
            title: l.marketAlerts,
            subtitle: 'Price movements & trends',
            color: TradEtTheme.positive,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.marketAlerts} — coming soon'),
                  behavior: SnackBarBehavior.floating)),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.campaign_outlined,
            title: l.systemMarketing,
            subtitle: 'Newsletter & AI assistance',
            color: TradEtTheme.accent,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            isLast: true,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.systemMarketing} — coming soon'),
                  behavior: SnackBarBehavior.floating)),
          ),
        ],
      ),
    );
  }

  Widget _webHelpCard(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.help_outline_rounded, l.help,
              'FAQ & Support', TradEtTheme.positive),
          const SizedBox(height: 16),
          _webSettingRow(
            icon: Icons.support_agent_rounded,
            title: l.supportCenter,
            subtitle: 'FAQ, docs, community forums',
            color: TradEtTheme.positive,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.supportCenter} — coming soon'),
                  behavior: SnackBarBehavior.floating)),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.chat_outlined,
            title: l.contactUs,
            subtitle: 'Submit ticket or chat with agents',
            color: const Color(0xFF60A5FA),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            isLast: true,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.contactUs} — coming soon'),
                  behavior: SnackBarBehavior.floating)),
          ),
        ],
      ),
    );
  }

  Widget _cardHeader(IconData icon, String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: Colors.white)),
            Text(subtitle,
                style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
          ],
        ),
      ],
    );
  }

  Widget _webComplianceItem(IconData icon, String title, String sub, Color color,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600,
                    fontSize: 12, color: Colors.white)),
                Text(sub, style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, size: 16, color: color.withValues(alpha: 0.6)),
        ],
      ),
    );
  }

  Widget _webSettingsCard(BuildContext context, AppProvider provider) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.settings_rounded, 'Preferences',
              'Settings & preferences', TradEtTheme.accent),
          const SizedBox(height: 18),
          _webSettingRow(
            icon: provider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title: l.appearance,
            subtitle: provider.isDarkMode ? l.darkMode : l.lightMode,
            color: const Color(0xFF818CF8),
            trailing: Switch(
              value: provider.isDarkMode,
              onChanged: (_) => provider.toggleTheme(),
              activeThumbColor: TradEtTheme.positive,
            ),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.shield_outlined,
            title: l.loginSecurity,
            subtitle: 'Password & 2FA',
            color: const Color(0xFF22D3EE),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SecurityScreen())),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.visibility_outlined,
            title: l.privacyControls,
            subtitle: 'Data sharing & visibility',
            color: const Color(0xFF60A5FA),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.privacyControls} — coming soon'),
                  behavior: SnackBarBehavior.floating)),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.shield_rounded,
            title: l.security,
            subtitle: 'Wealth protection & PIN',
            color: TradEtTheme.positive,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            isLast: true,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SecurityScreen())),
          ),
        ],
      ),
    );
  }

  Widget _webSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget trailing,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    final row = Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600,
                  fontSize: 13, color: Colors.white)),
              Text(subtitle, style: const TextStyle(fontSize: 10,
                  color: TradEtTheme.textMuted)),
            ],
          ),
        ),
        trailing,
      ],
    );
    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: row,
        ),
      );
    }
    return row;
  }

  Widget _webAccountCard(BuildContext context, AppProvider provider, dynamic user) {
    final l = AppLocalizations.of(context);
    final isVerified = user?.kycStatus == 'verified';

    return Column(
      children: [
        // KYC warning
        if (!isVerified) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TradEtTheme.warning.withValues(alpha: 0.15),
                  TradEtTheme.warning.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: TradEtTheme.warning.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TradEtTheme.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.warning_amber_rounded,
                          color: TradEtTheme.warning, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('KYC Required',
                          style: TextStyle(fontWeight: FontWeight.w700,
                              fontSize: 14, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Complete identity verification to start trading.',
                    style: TextStyle(fontSize: 12, color: TradEtTheme.textSecondary)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showKycDialog(context),
                    icon: const Icon(Icons.verified_user_outlined, size: 16),
                    label: Text(l.completeKyc,
                        style: const TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TradEtTheme.warning,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Personal Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(Icons.person_outline_rounded, l.profileInformation,
                  'Personal information', const Color(0xFF22D3EE)),
              const SizedBox(height: 18),
              _accountInfoRow(l.fullName, user?.fullName ?? '--'),
              _accountInfoRow(l.emailAddress, user?.email ?? '--'),
              _accountInfoRow(l.nationality, 'Ethiopia'),
              _accountInfoRow(l.purposeOfAccount, 'Investment'),
              _accountInfoRow(l.taxResidency, 'Ethiopia'),
              _accountInfoRow('KYC Status',
                  user?.kycStatus?.toString().toUpperCase() ?? 'PENDING'),
              const SizedBox(height: 14),
              _kycTierProgress(context, user?.kycStatus ?? 'pending'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Wealth / KYC Card (inline on desktop)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(Icons.account_balance_wallet_outlined, l.wealthSection,
                  'KYC financial profile', TradEtTheme.positive),
              const SizedBox(height: 16),
              _accountInfoRow(l.occupation, 'Student'),
              _accountInfoRow(l.sourceOfWealth, 'Personal Savings'),
              _accountInfoRow(l.sourceOfFund, 'Employment Income'),
              _accountInfoRow(l.netWorth, 'ETB 0 – ETB 100,000'),
              _accountInfoRow(l.purposeOfTrading, 'Investing for Learning'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Fees & Limits
        _webFeesCard(context),
        const SizedBox(height: 16),

        // Payment Methods
        const _PaymentMethodsSection(),
        const SizedBox(height: 16),

        // Logout
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              await provider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  appRoute(context, const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: TradEtTheme.negative.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: TradEtTheme.negative.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded,
                      color: TradEtTheme.negative, size: 18),
                  const SizedBox(width: 8),
                  Text(l.logout,
                      style: const TextStyle(color: TradEtTheme.negative,
                          fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _webFeesCard(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.price_change_outlined, l.feesAndLimits,
              'Commission & limits', const Color(0xFF60A5FA)),
          const SizedBox(height: 16),
          _accountInfoRow('Commission rate', '1.5% (flat, Riba-free)'),
          _accountInfoRow('Daily withdrawal limit', '100,000 ETB'),
          _accountInfoRow('Weekly trading limit', '500,000 ETB'),
          _accountInfoRow('Plan', 'Retail Trader — Standard'),
        ],
      ),
    );
  }

  Widget _accountInfoRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Shared: KYC tier progress ──────────────────────────────────────────

  Widget _kycTierProgress(BuildContext context, String kycStatus) {
    final isVerified = kycStatus == 'verified';
    final isPending = kycStatus == 'pending';

    const steps = ['Registration', 'Document Upload', 'Tier 1 Verified'];
    final currentStep = isVerified ? 2 : (isPending ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isVerified ? Icons.verified_user_rounded : Icons.hourglass_top_rounded,
              color: isVerified ? TradEtTheme.positive : TradEtTheme.warning,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              isVerified ? 'KYC Tier 1 — Verified' : 'KYC Tier 1 — In Progress',
              style: TextStyle(
                color: isVerified ? TradEtTheme.positive : TradEtTheme.warning,
                fontWeight: FontWeight.w600, fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              final stepIndex = i ~/ 2;
              final done = stepIndex < currentStep;
              return Expanded(
                child: Container(
                  height: 3,
                  color: done
                      ? TradEtTheme.positive
                      : TradEtTheme.divider.withValues(alpha: 0.3),
                ),
              );
            }
            final stepIndex = i ~/ 2;
            final done = stepIndex <= currentStep;
            final color = done ? TradEtTheme.positive : TradEtTheme.divider;
            return Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: done
                    ? TradEtTheme.positive.withValues(alpha: 0.2)
                    : TradEtTheme.divider.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              child: done
                  ? Icon(Icons.check_rounded, size: 12, color: TradEtTheme.positive)
                  : null,
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps.asMap().entries.map((e) {
            final done = e.key <= currentStep;
            return Text(e.value,
                style: TextStyle(
                    color: done ? TradEtTheme.textSecondary : TradEtTheme.textMuted,
                    fontSize: 9));
          }).toList(),
        ),
        if (!isVerified) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showKycDialog(context),
              icon: const Icon(Icons.upload_file_outlined, size: 14,
                  color: TradEtTheme.warning),
              label: const Text('Submit Documents',
                  style: TextStyle(color: TradEtTheme.warning, fontSize: 12)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: TradEtTheme.warning, width: 0.8),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ─── Avatar picker ──────────────────────────────────────────────────────

  Future<void> _pickProfileImage(BuildContext context, AppProvider provider) async {
    try {
      Uint8List? bytes;
      if (kIsWeb) {
        bytes = await pickImageFromWeb();
      } else {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 400, maxHeight: 400, imageQuality: 85,
        );
        if (picked != null) bytes = await picked.readAsBytes();
      }
      if (bytes != null) await provider.setProfileImage(bytes);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load image: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showAvatarOptions(BuildContext context, AppProvider provider) {
    const avatarColors = [
      Color(0xFF0F6B3C), Color(0xFF1D4ED8), Color(0xFF7C3AED),
      Color(0xFFB45309), Color(0xFF0D9488), Color(0xFF9D174D),
    ];
    const colorLabels = ['Green', 'Blue', 'Purple', 'Amber', 'Teal', 'Rose'];
    final hasPhoto = provider.profileImageBytes != null;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2F22),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Profile Photo',
                style: TextStyle(color: Colors.white, fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF34D399)),
              title: const Text('Upload Photo', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _pickProfileImage(context, provider);
              },
            ),
            const Divider(color: Color(0xFF2D4A38), height: 1),
            const SizedBox(height: 8),
            const Text('Choose Avatar Color',
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: List.generate(avatarColors.length, (i) {
                final selected = provider.avatarColorIndex == i;
                return GestureDetector(
                  onTap: () {
                    provider.setAvatarColorIndex(i);
                    Navigator.pop(ctx);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: avatarColors[i],
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: selected ? Colors.white : Colors.transparent,
                              width: 3),
                        ),
                        child: selected
                            ? const Icon(Icons.check, color: Colors.white, size: 18)
                            : null,
                      ),
                      const SizedBox(height: 4),
                      Text(colorLabels[i],
                          style: const TextStyle(fontSize: 10,
                              color: Color(0xFF9CA3AF))),
                    ],
                  ),
                );
              }),
            ),
            if (hasPhoto) ...[
              const SizedBox(height: 8),
              const Divider(color: Color(0xFF2D4A38), height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent),
                title: const Text('Remove Photo',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  provider.clearProfileImage();
                  Navigator.pop(ctx);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── KYC dialog ────────────────────────────────────────────────────────

  void _showKycDialog(BuildContext context) {
    final idNumberController = TextEditingController();
    String selectedIdType = 'national_id';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: TradEtTheme.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(AppLocalizations.of(context).kycVerification,
              style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Identity verification',
                  style: TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedIdType,
                dropdownColor: TradEtTheme.cardBgLight,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).idType),
                items: [
                  DropdownMenuItem(value: 'national_id',
                      child: Text(AppLocalizations.of(context).nationalId)),
                  DropdownMenuItem(value: 'passport',
                      child: Text(AppLocalizations.of(context).passport)),
                  DropdownMenuItem(value: 'drivers_license',
                      child: Text(AppLocalizations.of(context).driversLicense)),
                  DropdownMenuItem(value: 'kebele_id',
                      child: Text(AppLocalizations.of(context).kebeleId)),
                ],
                onChanged: (v) =>
                    setDialogState(() => selectedIdType = v ?? 'national_id'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idNumberController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).idNumber),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(context).cancel,
                  style: const TextStyle(color: TradEtTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (idNumberController.text.isNotEmpty) {
                  Navigator.pop(ctx);
                  final success = await context.read<AppProvider>().submitKyc(
                        idType: selectedIdType,
                        idNumber: idNumberController.text,
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'KYC verified successfully!'
                            : 'KYC submission failed'),
                        backgroundColor:
                            success ? TradEtTheme.positive : TradEtTheme.negative,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                }
              },
              child: Text(AppLocalizations.of(context).submit),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Account Screen — "Your Profile" hub with banner + 4 sub-options
// ═══════════════════════════════════════════════════════════════════════════

class _AccountMenuScreen extends StatelessWidget {
  final dynamic user;
  const _AccountMenuScreen({required this.user});

  static const _avatarColors = [
    Color(0xFF0F6B3C), Color(0xFF1D4ED8), Color(0xFF7C3AED),
    Color(0xFFB45309), Color(0xFF0D9488), Color(0xFF9D174D),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isVerified = user?.kycStatus == 'verified';
    final name = user?.fullName ?? 'User';
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // ── Header ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(l.account,
                        style: const TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
              ),

              // ── Profile Banner ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F6B3C), Color(0xFF1B8A5A),
                               Color(0xFF27AE60)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Consumer<AppProvider>(
                    builder: (ctx, prov, _) {
                      final bg = _avatarColors[
                          prov.avatarColorIndex % _avatarColors.length];
                      final imgBytes = prov.profileImageBytes;
                      final initial = name.isNotEmpty
                          ? name[0].toUpperCase() : '?';
                      return Row(
                        children: [
                          // Avatar
                          Stack(
                            children: [
                              Container(
                                width: 72, height: 72,
                                decoration: BoxDecoration(
                                  color: bg, shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      width: 2.5),
                                ),
                                child: imgBytes != null
                                    ? ClipOval(child: Image.memory(imgBytes,
                                        width: 72, height: 72,
                                        fit: BoxFit.cover))
                                    : Center(child: Text(initial,
                                        style: const TextStyle(fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white))),
                              ),
                              Positioned(
                                bottom: 0, right: 0,
                                child: Container(
                                  width: 22, height: 22,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: bg, width: 2)),
                                  child: Icon(Icons.camera_alt,
                                      size: 11, color: bg),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // Name + email + badge
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -0.3)),
                                const SizedBox(height: 3),
                                Text('@${email.split('@').first}',
                                    style: TextStyle(fontSize: 12,
                                        color: Colors.white.withValues(
                                            alpha: 0.7))),
                                const SizedBox(height: 10),
                                // KYC badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isVerified
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : TradEtTheme.warning.withValues(
                                            alpha: 0.25),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isVerified
                                          ? Colors.white.withValues(alpha: 0.4)
                                          : TradEtTheme.warning.withValues(
                                              alpha: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isVerified
                                            ? Icons.verified_rounded
                                            : Icons.pending_rounded,
                                        size: 13,
                                        color: isVerified
                                            ? Colors.white
                                            : TradEtTheme.warning,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        isVerified
                                            ? 'KYC Verified'
                                            : 'KYC Pending',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isVerified
                                                ? Colors.white
                                                : TradEtTheme.warning),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── 4 Sub-options ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: TradEtTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: TradEtTheme.divider.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      _subItem(context,
                        icon: Icons.badge_outlined,
                        color: const Color(0xFF22D3EE),
                        title: l.profileInformation,
                        subtitle: 'Update personal details, avatar & contact',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                _AccountDetailsScreen(user: user))),
                      ),
                      _subItem(context,
                        icon: Icons.verified_user_outlined,
                        color: isVerified
                            ? TradEtTheme.positive : TradEtTheme.warning,
                        title: l.verificationStatus,
                        subtitle: isVerified
                            ? 'Tier 1 — Verified ✓'
                            : 'Upload ID documents & check approval',
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => _KycDialogContent(),
                        ),
                      ),
                      _subItem(context,
                        icon: Icons.account_balance_outlined,
                        color: TradEtTheme.accent,
                        title: l.paymentMethod,
                        subtitle: 'Manage linked bank accounts & invoices',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                const _PaymentMethodsMobileScreen())),
                      ),
                      _subItem(context,
                        icon: Icons.price_change_outlined,
                        color: const Color(0xFF60A5FA),
                        title: l.feesAndLimits,
                        subtitle:
                            '1.5% flat commission • 100K ETB daily limit',
                        isLast: true,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                const _FeesLimitsScreen())),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Divider(
      height: 1, indent: 72,
      color: TradEtTheme.divider.withValues(alpha: 0.3));

  Widget _subItem(BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
    String? trailingBadge,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                  color: Colors.white)),
          subtitle: Text(subtitle,
              style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
          trailing: trailingBadge != null
              ? Container(
                  width: 20, height: 20,
                  decoration: const BoxDecoration(
                      color: TradEtTheme.warning, shape: BoxShape.circle),
                  child: Center(child: Text(trailingBadge,
                      style: const TextStyle(fontSize: 11,
                          fontWeight: FontWeight.w800, color: Colors.black))))
              : const Icon(Icons.chevron_right_rounded,
                  color: TradEtTheme.textMuted, size: 20),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(height: 1, indent: 76,
              color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Security & Privacy Menu Screen
// ═══════════════════════════════════════════════════════════════════════════

class _SecurityPrivacyMenuScreen extends StatelessWidget {
  const _SecurityPrivacyMenuScreen();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SubMenuScaffold(
      title: l.securityAndPrivacy,
      icon: Icons.shield_outlined,
      iconColor: const Color(0xFF22D3EE),
      subtitle: 'Protect your account & manage privacy',
      children: [
        _secItem(context,
          icon: Icons.lock_outline_rounded,
          color: const Color(0xFF22D3EE),
          title: l.loginSecurity,
          subtitle: 'Change password & enable Two-Factor Authentication (2FA)',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SecurityScreen())),
        ),
        _secItem(context,
          icon: Icons.visibility_outlined,
          color: const Color(0xFF60A5FA),
          title: l.privacyControls,
          subtitle: 'Manage data sharing & account visibility settings',
          isLast: true,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l.privacyControls} — coming soon'),
                behavior: SnackBarBehavior.floating)),
        ),
      ],
    );
  }

  Widget _secItem(BuildContext context, {
    required IconData icon, required Color color,
    required String title, required String subtitle,
    required VoidCallback onTap, bool isLast = false,
  }) {
    return Column(children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(width: 40, height: 40,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20)),
        title: Text(title, style: const TextStyle(fontSize: 14,
            fontWeight: FontWeight.w600, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11,
            color: TradEtTheme.textMuted)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: TradEtTheme.textMuted, size: 20),
        onTap: onTap,
      ),
      if (!isLast) Divider(height: 1, indent: 76,
          color: TradEtTheme.divider.withValues(alpha: 0.3)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Notifications Menu Screen
// ═══════════════════════════════════════════════════════════════════════════

class _NotificationsMenuScreen extends StatelessWidget {
  const _NotificationsMenuScreen();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SubMenuScaffold(
      title: l.notifications,
      icon: Icons.notifications_outlined,
      iconColor: TradEtTheme.accent,
      subtitle: 'Configure alerts & messaging preferences',
      children: [
        _notifItem(context,
          icon: Icons.show_chart_rounded,
          color: TradEtTheme.positive,
          title: l.marketAlerts,
          subtitle: 'Configure push/email alerts for price movements & trends',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l.marketAlerts} — coming soon'),
                behavior: SnackBarBehavior.floating)),
        ),
        _notifItem(context,
          icon: Icons.campaign_outlined,
          color: TradEtTheme.accent,
          title: l.systemMarketing,
          subtitle: 'Toggle newsletter & system-triggered AI assistance',
          isLast: true,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l.systemMarketing} — coming soon'),
                behavior: SnackBarBehavior.floating)),
        ),
      ],
    );
  }

  Widget _notifItem(BuildContext context, {
    required IconData icon, required Color color,
    required String title, required String subtitle,
    required VoidCallback onTap, bool isLast = false,
  }) {
    return Column(children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(width: 40, height: 40,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20)),
        title: Text(title, style: const TextStyle(fontSize: 14,
            fontWeight: FontWeight.w600, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11,
            color: TradEtTheme.textMuted)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: TradEtTheme.textMuted, size: 20),
        onTap: onTap,
      ),
      if (!isLast) Divider(height: 1, indent: 76,
          color: TradEtTheme.divider.withValues(alpha: 0.3)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Help & Support Menu Screen
// ═══════════════════════════════════════════════════════════════════════════

class _HelpSupportMenuScreen extends StatelessWidget {
  const _HelpSupportMenuScreen();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SubMenuScaffold(
      title: l.helpAndSupport,
      icon: Icons.help_outline_rounded,
      iconColor: TradEtTheme.positive,
      subtitle: 'FAQ, documentation & contact',
      children: [
        _helpItem(context,
          icon: Icons.support_agent_rounded,
          color: TradEtTheme.positive,
          title: l.supportCenter,
          subtitle: 'Access FAQ, help documentation & community forums',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l.supportCenter} — coming soon'),
                behavior: SnackBarBehavior.floating)),
        ),
        _helpItem(context,
          icon: Icons.chat_outlined,
          color: const Color(0xFF60A5FA),
          title: l.contactUs,
          subtitle: 'Submit a support ticket or start an in-app chat',
          isLast: true,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l.contactUs} — coming soon'),
                behavior: SnackBarBehavior.floating)),
        ),
      ],
    );
  }

  Widget _helpItem(BuildContext context, {
    required IconData icon, required Color color,
    required String title, required String subtitle,
    required VoidCallback onTap, bool isLast = false,
  }) {
    return Column(children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(width: 40, height: 40,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20)),
        title: Text(title, style: const TextStyle(fontSize: 14,
            fontWeight: FontWeight.w600, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11,
            color: TradEtTheme.textMuted)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: TradEtTheme.textMuted, size: 20),
        onTap: onTap,
      ),
      if (!isLast) Divider(height: 1, indent: 76,
          color: TradEtTheme.divider.withValues(alpha: 0.3)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Shared sub-menu scaffold
// ═══════════════════════════════════════════════════════════════════════════

class _SubMenuScaffold extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String subtitle;
  final List<Widget> children;

  const _SubMenuScaffold({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w700, color: Colors.white)),
                        Text(subtitle,
                            style: const TextStyle(fontSize: 11,
                                color: TradEtTheme.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: TradEtTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
                  ),
                  child: Column(children: children),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// KYC Dialog (extracted for reuse)
// ═══════════════════════════════════════════════════════════════════════════

class _KycDialogContent extends StatefulWidget {
  @override
  State<_KycDialogContent> createState() => _KycDialogContentState();
}

class _KycDialogContentState extends State<_KycDialogContent> {
  final _idCtrl = TextEditingController();
  String _idType = 'national_id';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: TradEtTheme.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l.kycVerification,
          style: const TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Identity verification',
              style: TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _idType,
            dropdownColor: TradEtTheme.cardBgLight,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(labelText: l.idType),
            items: [
              DropdownMenuItem(value: 'national_id', child: Text(l.nationalId)),
              DropdownMenuItem(value: 'passport', child: Text(l.passport)),
              DropdownMenuItem(value: 'drivers_license', child: Text(l.driversLicense)),
              DropdownMenuItem(value: 'kebele_id', child: Text(l.kebeleId)),
            ],
            onChanged: (v) => setState(() => _idType = v ?? 'national_id'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _idCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: l.idNumber),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel,
              style: const TextStyle(color: TradEtTheme.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_idCtrl.text.isNotEmpty) {
              Navigator.pop(context);
              final success = await context.read<AppProvider>().submitKyc(
                    idType: _idType, idNumber: _idCtrl.text);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success
                      ? 'KYC verified successfully!'
                      : 'KYC submission failed'),
                  backgroundColor:
                      success ? TradEtTheme.positive : TradEtTheme.negative,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            }
          },
          child: Text(l.submit),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Payment Methods — Mobile screen
// ═══════════════════════════════════════════════════════════════════════════

class _PaymentMethodsMobileScreen extends StatelessWidget {
  const _PaymentMethodsMobileScreen();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Text(l.paymentMethod,
                        style: const TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const _PaymentMethodsSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Fees & Limits — Mobile screen
// ═══════════════════════════════════════════════════════════════════════════

class _FeesLimitsScreen extends StatelessWidget {
  const _FeesLimitsScreen();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    Widget feeRow(String label, String value, IconData icon, Color color) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 13,
                      color: TradEtTheme.textSecondary)),
            ),
            Text(value,
                style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.feesAndLimits,
                            style: const TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w700, color: Colors.white)),
                        const Text('Commission & trading limits',
                            style: TextStyle(fontSize: 11,
                                color: TradEtTheme.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    feeRow('Commission rate', '1.5% flat (Riba-free)',
                        Icons.percent_rounded, TradEtTheme.positive),
                    feeRow('Daily withdrawal limit', '100,000 ETB',
                        Icons.arrow_upward_rounded, TradEtTheme.warning),
                    feeRow('Weekly trading limit', '500,000 ETB',
                        Icons.swap_horiz_rounded, const Color(0xFF60A5FA)),
                    feeRow('Plan', 'Retail Trader — Standard',
                        Icons.workspace_premium_outlined,
                        const Color(0xFF818CF8)),
                    feeRow('Settlement', 'T+2 (ECX standard)',
                        Icons.schedule_rounded, TradEtTheme.accent),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: TradEtTheme.positive.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: TradEtTheme.positive.withValues(alpha: 0.2)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: TradEtTheme.positive,
                              size: 16),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'All fees are Sharia-compliant flat commissions. '
                              'No hidden interest (Riba) charges.',
                              style: TextStyle(fontSize: 11,
                                  color: TradEtTheme.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Account Details Screen (mobile "Profile Information" subpage)
// ═══════════════════════════════════════════════════════════════════════════

class _AccountDetailsScreen extends StatefulWidget {
  final dynamic user;
  const _AccountDetailsScreen({required this.user});

  @override
  State<_AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<_AccountDetailsScreen> {
  // Dropdown state for KYC wealth fields
  String? _occupation;
  String? _sourceOfWealth;
  String? _sourceOfFunds;
  String? _netWorth;
  String? _purposeOfTrading;

  static const _occupations = [
    'Public Sector Employee (Government)',
    'Private Sector Employee',
    'Self-Employed / Entrepreneur',
    'Freelancer / Digital Professional',
    'Student',
    'Unemployed',
    'Retired / Pensioner',
    'Homemaker',
    'NGO / International Organization Employee',
  ];

  static const _wealthSources = [
    'Personal Savings',
    'Inheritance',
    'Business Profits',
    'Investment Returns / Dividends',
    'Real Estate / Property Sale',
    'Gratuity / Severance Pay',
    'Gift / Family Support',
  ];

  static const _fundSources = [
    'Employment Income (Salary)',
    'Business Revenue',
    'Sale of Assets',
    'Remittances (Diaspora Support)',
    'Government Allowance / Pension',
    'Savings Withdrawal',
  ];

  static const _netWorthRanges = [
    'ETB 0 – ETB 100,000',
    'ETB 100,001 – ETB 500,000',
    'ETB 500,001 – ETB 2,500,000',
    'ETB 2,500,001 – ETB 10,000,000',
    'ETB 10,000,001 – ETB 50,000,000',
    'Above ETB 50,000,000',
  ];

  static const _tradingPurposes = [
    'Investing for Learning Purposes',
    'Long-term Wealth Building',
    'Infrequent trading, when I see an opportunity',
    'Frequent trading focused on generating ongoing income',
    'Preserve capital',
    'Exploratory investing',
  ];

  void _showPicker(String title, List<String> options, String? current,
      void Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2F22),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white24,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(title,
                style: const TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w700, color: Colors.white)),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              itemCount: options.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.2)),
              itemBuilder: (ctx, i) {
                final selected = options[i] == current;
                return ListTile(
                  dense: true,
                  title: Text(options[i],
                      style: TextStyle(fontSize: 13,
                          color: selected ? TradEtTheme.positive : Colors.white,
                          fontWeight: selected
                              ? FontWeight.w600 : FontWeight.normal)),
                  trailing: selected
                      ? const Icon(Icons.check_rounded,
                          color: TradEtTheme.positive, size: 18)
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    onSelected(options[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static const _avatarColors = [
    Color(0xFF0F6B3C), Color(0xFF1D4ED8), Color(0xFF7C3AED),
    Color(0xFFB45309), Color(0xFF0D9488), Color(0xFF9D174D),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final user = widget.user;
    final name = user?.fullName ?? 'User';
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top row: back button (left) + small avatar (right) ───
              Consumer<AppProvider>(
                builder: (ctx, prov, _) {
                  final bg = _avatarColors[
                      prov.avatarColorIndex % _avatarColors.length];
                  final imgBytes = prov.profileImageBytes;
                  final initial = name.isNotEmpty
                      ? name[0].toUpperCase() : '?';
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                    child: Row(
                      children: [
                        // Back button
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        // Small circular avatar top-right
                        GestureDetector(
                          onTap: () =>
                              _showAvatarOptionsFromState(context, prov),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              width: 42, height: 42,
                              decoration: BoxDecoration(
                                color: bg, shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 2),
                              ),
                              child: imgBytes != null
                                  ? ClipOval(child: Image.memory(imgBytes,
                                      width: 42, height: 42,
                                      fit: BoxFit.cover))
                                  : Center(child: Text(initial,
                                      style: const TextStyle(fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // ── Large title + @handle (left-aligned) ────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.yourProfile,
                        style: const TextStyle(fontSize: 26,
                            fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('@${email.split('@').first}',
                        style: const TextStyle(fontSize: 14,
                            color: TradEtTheme.accent,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              // ── Content ──────────────────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    // ── Personal ──────────────────────────────────────────
                    Text(l.personalSection,
                        style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TradEtTheme.textMuted)),
                    const SizedBox(height: 8),
                    _infoCard([
                      _infoRow(l.basicInfo,
                          '${user?.fullName ?? '--'}\n14 January 1995',
                          editIcon: true),
                      _infoRow(l.nationality, 'Ethiopia'),
                      _infoRow(l.residentialAddress,
                          'Komoros st 29, 489, Addis Ababa', editIcon: true),
                      _infoRow(l.phone, '+251 921 970 367', editIcon: true),
                      _infoRow(l.emailAddress,
                          user?.email ?? '--', editIcon: true),
                      _infoRow(l.purposeOfAccount, 'Investment', editIcon: true),
                      _infoRow(l.taxResidency, 'Ethiopia', editIcon: true),
                      _infoRow(l.riskAssessment, 'None',
                          editIcon: true, isLast: true),
                    ]),
                    const SizedBox(height: 20),

                    // ── Wealth / KYC ──────────────────────────────────────
                    Text(l.wealthSection,
                        style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TradEtTheme.textMuted)),
                    const SizedBox(height: 8),
                    _infoCard([
                      _dropdownRow(
                        label: l.occupation,
                        value: _occupation ?? 'Student',
                        options: _occupations,
                        onTap: () => _showPicker(
                          l.occupation, _occupations, _occupation,
                          (v) => setState(() => _occupation = v),
                        ),
                      ),
                      _dropdownRow(
                        label: l.sourceOfWealth,
                        value: _sourceOfWealth ?? 'Personal Savings',
                        options: _wealthSources,
                        onTap: () => _showPicker(
                          l.sourceOfWealth, _wealthSources, _sourceOfWealth,
                          (v) => setState(() => _sourceOfWealth = v),
                        ),
                      ),
                      _dropdownRow(
                        label: l.sourceOfFund,
                        value: _sourceOfFunds ?? 'Employment Income (Salary)',
                        options: _fundSources,
                        onTap: () => _showPicker(
                          l.sourceOfFund, _fundSources, _sourceOfFunds,
                          (v) => setState(() => _sourceOfFunds = v),
                        ),
                      ),
                      _dropdownRow(
                        label: l.netWorth,
                        value: _netWorth ?? 'ETB 0 – ETB 100,000',
                        options: _netWorthRanges,
                        onTap: () => _showPicker(
                          l.netWorth, _netWorthRanges, _netWorth,
                          (v) => setState(() => _netWorth = v),
                        ),
                      ),
                      _dropdownRow(
                        label: l.purposeOfTrading,
                        value: _purposeOfTrading ??
                            'Investing for Learning Purposes',
                        options: _tradingPurposes,
                        isLast: true,
                        onTap: () => _showPicker(
                          l.purposeOfTrading, _tradingPurposes,
                          _purposeOfTrading,
                          (v) => setState(() => _purposeOfTrading = v),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Profile updated successfully'),
                              backgroundColor: TradEtTheme.positive,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TradEtTheme.positive,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(l.save,
                            style: const TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarOptionsFromState(BuildContext context, AppProvider prov) {
    // Delegate to the shared avatar options method on ProfileScreen
    const ProfileScreen()._showAvatarOptions(context, prov);
  }

  Widget _infoCard(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(String label, String value,
      {bool editIcon = false, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(
                color: TradEtTheme.divider.withValues(alpha: 0.3))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 11,
                        color: TradEtTheme.textMuted)),
                const SizedBox(height: 3),
                Text(value,
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w500, color: Colors.white)),
              ],
            ),
          ),
          if (editIcon)
            Icon(Icons.edit_outlined, size: 16,
                color: TradEtTheme.accent.withValues(alpha: 0.8)),
        ],
      ),
    );
  }

  Widget _dropdownRow({
    required String label,
    required String value,
    required List<String> options,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(
                  color: TradEtTheme.divider.withValues(alpha: 0.3))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(fontSize: 11,
                          color: TradEtTheme.textMuted)),
                  const SizedBox(height: 3),
                  Text(value,
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w500, color: Colors.white),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.edit_outlined,
                color: TradEtTheme.accent, size: 18),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Compliance Docs Screen (mobile)
// ═══════════════════════════════════════════════════════════════════════════

class _ComplianceDocsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Text(l.complianceDocuments,
                        style: const TextStyle(fontSize: 17,
                            fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    _docItem(context, Icons.gavel_rounded, l.legalDocs,
                        'Terms, Risk Disclosures, Privacy Policy',
                        const Color(0xFF60A5FA)),
                    const SizedBox(height: 12),
                    _docItem(context, Icons.account_balance_outlined, l.regulatoryStatus,
                        'ESX licensing & compliance status',
                        const Color(0xFF818CF8)),
                    const SizedBox(height: 12),
                    _docItem(context, Icons.verified_rounded, l.halalCompliance,
                        'Sharia screening process & audit reports',
                        TradEtTheme.positive),
                    const SizedBox(height: 12),
                    _docItem(context, Icons.receipt_long_outlined, l.taxStatements,
                        'Annual P&L statements for tax declaration',
                        TradEtTheme.accent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _docItem(BuildContext context, IconData icon, String title, String sub,
      Color color) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title — coming soon'),
            behavior: SnackBarBehavior.floating)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 3),
                  Text(sub,
                      style: const TextStyle(fontSize: 11,
                          color: TradEtTheme.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Payment Methods Section
// ═══════════════════════════════════════════════════════════════════════════

class _PaymentMethodsSection extends StatefulWidget {
  const _PaymentMethodsSection();

  @override
  State<_PaymentMethodsSection> createState() => _PaymentMethodsSectionState();
}

class _PaymentMethodsSectionState extends State<_PaymentMethodsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<AppProvider>().loadPaymentMethods());
  }

  static const List<String> _ethiopianBanks = [
    'Commercial Bank of Ethiopia (CBE)',
    'Awash Bank',
    'Dashen Bank',
    'Abyssinia Bank',
    'Wegagen Bank',
    'United Bank',
    'Nib International Bank',
    'Cooperative Bank of Oromia',
    'Oromia International Bank',
    'Berhan Bank',
    'Bunna International Bank',
    'Addis International Bank',
    'Amhara Bank',
    'Tsehay Bank',
    'Shabelle Bank',
    'Gadaa Bank',
    'Hijra Bank',
    'ZamZam Bank',
    'Siinqee Bank',
    'Enat Bank',
    'Other',
  ];

  Future<void> _showAddDialog() async {
    final authed = await challengeTransactionAuth(
      context,
      reason: 'Authenticate to add a payment method',
    );
    if (!authed) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).authRequiredPayment),
          backgroundColor: TradEtTheme.negative,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
      return;
    }

    String? selectedBank;
    final acctNumCtrl = TextEditingController();
    final acctNameCtrl = TextEditingController();

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          backgroundColor: TradEtTheme.cardBg,
          title: const Text('Add Payment Method',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: TradEtTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedBank,
                    isExpanded: true,
                    dropdownColor: TradEtTheme.cardBg,
                    hint: const Row(
                      children: [
                        SizedBox(width: 12),
                        Icon(Icons.account_balance_outlined,
                            color: TradEtTheme.textMuted, size: 18),
                        SizedBox(width: 10),
                        Text('Select Bank',
                            style: TextStyle(color: TradEtTheme.textMuted, fontSize: 13)),
                      ],
                    ),
                    items: _ethiopianBanks.map((bank) => DropdownMenuItem(
                      value: bank,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(bank,
                            style: const TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    )).toList(),
                    onChanged: (v) => setStateDialog(() => selectedBank = v),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _inputField(acctNumCtrl, 'Account Number', Icons.credit_card_outlined,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _inputField(acctNameCtrl, 'Account Holder Name', Icons.person_outline),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: TradEtTheme.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: TradEtTheme.positive),
              onPressed: () async {
                final bank = selectedBank;
                final num = acctNumCtrl.text.trim();
                final name = acctNameCtrl.text.trim();
                if (bank == null || num.isEmpty || name.isEmpty) return;
                Navigator.pop(ctx);
                final result = await context.read<AppProvider>().addPaymentMethod(
                  bankName: bank,
                  accountNumber: num,
                  accountName: name,
                );
                if (mounted && result.containsKey('error')) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(result['error'] ?? 'Failed to add'),
                    backgroundColor: TradEtTheme.negative,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ));
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController ctrl, String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: TradEtTheme.textMuted, fontSize: 13),
        prefixIcon: Icon(icon, color: TradEtTheme.textMuted, size: 18),
        filled: true,
        fillColor: TradEtTheme.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final methods = provider.paymentMethods;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TradEtTheme.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance_rounded,
                        color: TradEtTheme.accent, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Methods',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Text('Linked accounts',
                            style: TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _showAddDialog,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: TradEtTheme.positive.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: TradEtTheme.positive.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: TradEtTheme.positive, size: 14),
                            SizedBox(width: 4),
                            Text('Add',
                                style: TextStyle(color: TradEtTheme.positive,
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (methods.isEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TradEtTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: TradEtTheme.textMuted, size: 16),
                      SizedBox(width: 10),
                      Text('No payment methods linked yet',
                          style: TextStyle(fontSize: 12, color: TradEtTheme.textMuted)),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
                ...methods.map((m) => _MethodTile(method: m)),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MethodTile extends StatelessWidget {
  final PaymentMethod method;
  const _MethodTile({required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TradEtTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: method.isPrimary
            ? Border.all(color: TradEtTheme.positive.withValues(alpha: 0.4))
            : Border.all(color: TradEtTheme.divider.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: TradEtTheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.account_balance_outlined,
                color: TradEtTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(method.bankName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600,
                              fontSize: 13, color: Colors.white)),
                    ),
                    if (method.isPrimary) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: TradEtTheme.positive.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Primary',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                                color: TradEtTheme.positive)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '**** ${method.accountNumber.length > 4 ? method.accountNumber.substring(method.accountNumber.length - 4) : method.accountNumber} • ${method.accountName}',
                  style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            color: TradEtTheme.cardBg,
            icon: const Icon(Icons.more_vert, color: TradEtTheme.textMuted, size: 18),
            onSelected: (value) async {
              final provider = context.read<AppProvider>();
              if (value == 'primary') {
                await provider.setPrimaryPaymentMethod(method.id);
              } else if (value == 'delete') {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: TradEtTheme.cardBg,
                    title: const Text('Remove Account',
                        style: TextStyle(color: Colors.white)),
                    content: Text('Remove ${method.bankName} ${method.accountNumber}?',
                        style: const TextStyle(color: TradEtTheme.textSecondary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel',
                            style: TextStyle(color: TradEtTheme.textMuted)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: TradEtTheme.negative),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await provider.deletePaymentMethod(method.id);
                }
              }
            },
            itemBuilder: (_) => [
              if (!method.isPrimary)
                const PopupMenuItem(
                  value: 'primary',
                  child: Row(
                    children: [
                      Icon(Icons.star_outline, size: 16, color: TradEtTheme.positive),
                      SizedBox(width: 8),
                      Text('Set as Primary',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 16, color: TradEtTheme.negative),
                    SizedBox(width: 8),
                    Text('Remove',
                        style: TextStyle(color: TradEtTheme.negative, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// SecurityLogSection lives in widgets/security_log_section.dart
