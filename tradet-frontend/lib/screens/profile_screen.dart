import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/web_file_picker.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../white_label.dart';
import '../widgets/language_selector.dart';
import '../widgets/responsive_layout.dart';
import '../services/security_log_service.dart';
import '../services/pdf_export_service.dart';
import 'alerts_screen.dart';
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            children: [
              // Top bar: X close + Upgrade pill
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const _UpgradeScreen())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: TradEtTheme.positive.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: TradEtTheme.positive.withValues(alpha: 0.5)),
                      ),
                      child: const Text('Upgrade',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _mobileAvatar(context, provider, user, size: 80),
              const SizedBox(height: 12),
              Text(name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('@${email.split('@').first}',
                      style: const TextStyle(color: TradEtTheme.accent, fontSize: 13)),
                  const SizedBox(width: 6),
                  const Icon(Icons.qr_code_2_rounded, size: 18, color: Colors.white),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: _headerStatCard(
                    icon: Icons.check_circle,
                    title: l.verificationTier,
                    subtitle: l.tier1,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _headerStatCard(
                    icon: Icons.person_add_alt_1_rounded,
                    title: l.inviteFriends,
                    subtitle: l.inviteEarn,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => _InviteFriendsScreen(user: user))),
                  )),
                ],
              ),
            ],
          ),
        ),

        // ── Card 1: Help / Account / Compliance / Learn / Inbox ─────────
        _menuCard([
          _menuItem(context,
              icon: Icons.help_outline_rounded,
              label: l.help,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _HelpMenuScreen()))),
          _menuDivider(),
          _menuItem(context,
              icon: Icons.person_outline_rounded,
              label: l.account,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => _ProfileInformationMenuScreen(user: user)))),
          _menuDivider(),
          _menuItem(context,
              icon: Icons.description_outlined,
              label: l.complianceDocuments,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => _ComplianceDocsScreen()))),
          _menuDivider(),
          _menuItem(context,
              icon: Icons.lightbulb_outline_rounded,
              label: 'Learn',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _LearnScreen()))),
          _menuDivider(),
          _menuItem(context,
              icon: Icons.campaign_outlined,
              label: 'Inbox',
              badge: 4,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _InboxScreen()))),
        ]),
        const SizedBox(height: 12),

        // ── Card 2: Security / Privacy / Appearance / Notification setting ─
        _menuCard([
          _menuItem(context,
              icon: Icons.shield_outlined,
              label: l.security,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SecurityScreen()))),
          _menuDivider(),
          _menuItem(context,
              icon: Icons.visibility_outlined,
              label: l.privacy,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PrivacyControlsScreen()))),
          _menuDivider(),
          _menuItem(context,
              icon: Icons.palette_outlined,
              label: l.appearance,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _AppearanceScreen()))),
          _menuDivider(),
          _menuItem(context,
              icon: Icons.notifications_outlined,
              label: 'Notification setting',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _NotificationsMenuScreen()))),
        ]),
        const SizedBox(height: 12),

        // ── Card 3: About us / Log out ──────────────────────────────────
        _menuCard([
          _menuItem(context,
              icon: Icons.info_outline_rounded,
              label: l.aboutUs,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _AboutUsScreen()))),
          _menuDivider(),
          _menuItem(context,
              icon: Icons.logout_rounded,
              label: l.logout,
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
              Text(l.appVersion,
                  style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
              const Text('Amber Research Inc',
                  style: TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
              Text('${l.lastLogin} ${_lastLoginLabel(context)}',
                  style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _headerStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(
                    color: TradEtTheme.textMuted, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  String _lastLoginLabel(BuildContext context) {
    final now = DateTime.now();
    final langCode = context.read<AppProvider>().langCode;
    final datePart = EthiopianDate.formatDate(now, langCode);
    return '$datePart ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
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
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TradEtTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.aboutTradEt, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l.appNameLocalized} v1.0.0', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text('${l.byBankName} Research Inc.',
                style: const TextStyle(color: TradEtTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 12),
            Text(l.shariaCompliantPlatform,
                style: const TextStyle(color: TradEtTheme.textSecondary, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.close, style: const TextStyle(color: TradEtTheme.positive)),
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
            // Left: Account info + payments
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _webAccountCard(context, provider, user),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Right: Settings + Compliance + Notifications + Help + Security
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _webSettingsCard(context, provider),
                  const SizedBox(height: 16),
                  _webComplianceCard(context),
                  const SizedBox(height: 16),
                  _webNotificationsCard(context),
                  const SizedBox(height: 16),
                  _webHelpCard(context),
                  const SizedBox(height: 16),
                  _webLegalDocsCard(context),
                  const SizedBox(height: 16),
                  const SecurityLogSection(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: Text(
            l.appVersionFooter,
            style: TextStyle(fontSize: 11,
                color: TradEtTheme.textMuted.withValues(alpha: 0.6)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _webUserBanner(BuildContext context, AppProvider provider, dynamic user) {
    final l = AppLocalizations.of(context);
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
                    _kycBadge(isVerified, context),
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
                          Builder(builder: (context) {
                            final l = AppLocalizations.of(context);
                            return Text(l.memberSinceYear('2024'),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.6)));
                          }),
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
              _bannerStat(l.holdings, user?.walletBalance != null ? l.active : '--',
                  Icons.pie_chart_outline),
              const SizedBox(width: 16),
              _bannerStat(l.alerts, l.active, Icons.notifications_outlined),
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

  Widget _kycBadge(bool isVerified, BuildContext context) {
    final l = AppLocalizations.of(context);
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
            isVerified ? l.kycVerified : l.kycPending,
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
              l.subtitleStandardsCert, TradEtTheme.positive),
          const SizedBox(height: 18),
          _webComplianceItem(Icons.verified_rounded, l.shariaAaoifi,
              l.halalScreened, TradEtTheme.positive),
          _webComplianceItem(Icons.account_balance_rounded, l.ecxRegulated,
              l.ethiopianRules, const Color(0xFF60A5FA)),
          _webComplianceItem(Icons.security_rounded, l.nbeSupervised,
              l.nationalBankLabel, const Color(0xFF818CF8)),
          _webComplianceItem(Icons.money_off_rounded, l.ribaFree,
              l.noInterestLabel, const Color(0xFF22D3EE)),
          _webComplianceItem(Icons.block_rounded, l.noShortSell,
              l.spotTradingOnly, TradEtTheme.warning, isLast: true),
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
            subtitle: l.subtitleTermsRiskPrivacy,
            color: const Color(0xFF60A5FA),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => showLegalDocsDialog(context),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.account_balance_outlined,
            title: l.regulatoryStatus,
            subtitle: l.subtitleEcxLicensing,
            color: const Color(0xFF818CF8),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => showRegulatoryStatusDialog(context),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.verified_rounded,
            title: l.halalCompliance,
            subtitle: l.subtitleShariaAudit,
            color: TradEtTheme.positive,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => showHalalComplianceDialog(context),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.receipt_long_outlined,
            title: l.taxStatements,
            subtitle: l.subtitleTaxDeclaration,
            color: TradEtTheme.accent,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            isLast: true,
            onTap: () => showTaxStatementsDialog(context),
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
              l.subtitleAlertsMessaging, TradEtTheme.accent),
          const SizedBox(height: 16),
          _webSettingRow(
            icon: Icons.show_chart_rounded,
            title: l.marketAlerts,
            subtitle: l.subtitlePriceMovements,
            color: TradEtTheme.positive,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AlertsScreen())),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.campaign_outlined,
            title: l.systemMarketing,
            subtitle: l.subtitleNewsletterAi,
            color: TradEtTheme.accent,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            isLast: true,
            onTap: () => showSystemMarketingDialog(context),
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
              l.faqAndSupport, TradEtTheme.positive),
          const SizedBox(height: 16),
          _webSettingRow(
            icon: Icons.support_agent_rounded,
            title: l.supportCenter,
            subtitle: l.subtitleFaqDocs,
            color: TradEtTheme.positive,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => showSupportCenterDialog(context),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.chat_outlined,
            title: l.contactUs,
            subtitle: l.subtitleSupportTicket,
            color: const Color(0xFF60A5FA),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            isLast: true,
            onTap: () => showContactUsDialog(context),
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
          _cardHeader(Icons.settings_rounded, l.preferences,
              l.settingsAndPreferences, TradEtTheme.accent),
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
            subtitle: l.subtitlePasswordTwoFa,
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
            subtitle: l.subtitleDataSharing,
            color: const Color(0xFF60A5FA),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PrivacyControlsScreen())),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          _webSettingRow(
            icon: Icons.shield_rounded,
            title: l.security,
            subtitle: l.subtitleWealthProtection,
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
                    Expanded(
                      child: Text(l.kycRequired,
                          style: const TextStyle(fontWeight: FontWeight.w700,
                              fontSize: 14, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(l.completeKycToTrade,
                    style: const TextStyle(fontSize: 12, color: TradEtTheme.textSecondary)),
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
              _cardHeader(Icons.person_outline_rounded, l.personalInformation,
                  l.personalInformationSub, const Color(0xFF22D3EE)),
              const SizedBox(height: 18),
              _accountInfoRow(l.fullName, user?.fullName ?? '--'),
              _accountInfoRow(l.emailAddress, user?.email ?? '--'),
              _accountInfoRow(l.nationality, user?.nationality ?? 'Ethiopia'),
              _accountInfoRow(l.purposeOfAccount, user?.purposeOfAccount ?? '--'),
              _accountInfoRow(l.taxResidency, user?.taxResidency ?? '--'),
              _accountInfoRow(l.kycStatus,
                  user?.kycStatus == 'verified' ? l.kycVerified : l.kycPending),
              const SizedBox(height: 14),
              _kycTierProgress(context, user?.kycStatus ?? 'pending'),
              const SizedBox(height: 14),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.all(24),
                      child: SizedBox(
                        width: 480,
                        height: 680,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _AccountDetailsScreen(user: user),
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: TradEtTheme.positive.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: TradEtTheme.positive.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit_outlined, size: 16, color: TradEtTheme.positive),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context).editProfile,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                color: TradEtTheme.positive)),
                      ],
                    ),
                  ),
                ),
              ),
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
          _accountInfoRow(l.commissionRate, '1.5%'),
          _accountInfoRow(l.dailyWithdrawalLimit, '100,000 ETB'),
          _accountInfoRow(l.weeklyTradingLimit, '500,000 ETB'),
          _accountInfoRow(l.planType, l.retailTraderStandard),
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

    final l = AppLocalizations.of(context);
    final steps = [l.registrationStep, l.documentUpload, l.tier1Verified];
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
              isVerified ? l.kycTier1Verified : l.kycInProgress,
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
              label: Builder(builder: (context) {
                    final l = AppLocalizations.of(context);
                    return Text(l.submitDocuments,
                        style: const TextStyle(color: TradEtTheme.warning, fontSize: 12));
                  }),
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
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.couldNotLoadImage(e.toString())),
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
      builder: (ctx) {
        final l = AppLocalizations.of(ctx);
        return Padding(
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
            Text(l.profilePhoto,
                style: const TextStyle(color: Colors.white, fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF34D399)),
              title: Text(l.uploadPhoto, style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _pickProfileImage(context, provider);
              },
            ),
            const Divider(color: Color(0xFF2D4A38), height: 1),
            const SizedBox(height: 8),
            Text(l.chooseAvatarColor,
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
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
                title: Text(l.removePhoto,
                    style: const TextStyle(color: Colors.redAccent)),
                onTap: () {
                  provider.clearProfileImage();
                  Navigator.pop(ctx);
                },
              ),
            ],
          ],
        ),
      );
      },
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
              Text(AppLocalizations.of(context).identityVerification,
                  style: const TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
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
// Profile Information Menu — banner + 4 sub-options + Close Account
// ═══════════════════════════════════════════════════════════════════════════

class _ProfileInformationMenuScreen extends StatelessWidget {
  final dynamic user;
  const _ProfileInformationMenuScreen({required this.user});

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
                                            ? l.kycVerified
                                            : l.kycPending,
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
                        title: l.personalInformation,
                        subtitle: l.subtitlePersonalDetails,
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
                            ? l.tier1Verified
                            : l.uploadIdDocuments,
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => _KycDialogContent(),
                        ),
                      ),
                      _subItem(context,
                        icon: Icons.account_balance_outlined,
                        color: TradEtTheme.accent,
                        title: l.paymentMethod,
                        subtitle: l.subtitleBankAccounts,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                const _PaymentMethodsMobileScreen())),
                      ),
                      _subItem(context,
                        icon: Icons.price_change_outlined,
                        color: const Color(0xFF60A5FA),
                        title: l.feesAndLimits,
                        subtitle: l.flatCommissionLimit,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                const _FeesLimitsScreen())),
                      ),
                      _subItem(context,
                        icon: Icons.delete_forever_outlined,
                        color: TradEtTheme.negative,
                        title: l.closeAccount,
                        subtitle: l.closeAccountWarning.split('.').first,
                        isLast: true,
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: const Color(0xFF1A2F22),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: Text(l.closeAccountTitle,
                                style: const TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                            content: Text(l.closeAccountWarning,
                                style: const TextStyle(
                                    color: TradEtTheme.textSecondary,
                                    fontSize: 13)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l.cancel,
                                    style: const TextStyle(
                                        color: TradEtTheme.textMuted)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l.closeAccount,
                                    style: const TextStyle(
                                        color: TradEtTheme.negative,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
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

// _SecurityPrivacyMenuScreen removed — Security and Privacy are now top-level menu items

// ═══════════════════════════════════════════════════════════════════════════
// Notifications Menu Screen
// ═══════════════════════════════════════════════════════════════════════════

class _NotificationsMenuScreen extends StatefulWidget {
  const _NotificationsMenuScreen();

  @override
  State<_NotificationsMenuScreen> createState() => _NotificationsMenuScreenState();
}

class _NotificationsMenuScreenState extends State<_NotificationsMenuScreen> {
  // 5 categories × 3 channels (push, email, in-app)
  final List<_NotifCategory> _categories = [
    _NotifCategory('Personalized TradEt offers', [true, true, true]),
    _NotifCategory('Personalized partners offers', [true, true, true]),
    _NotifCategory('Trade volatility alert', [true, true, true]),
    _NotifCategory('Commodity volatility alert', [true, true, true]),
    _NotifCategory('Personal price alert', [true, true, true]),
  ];

  @override
  Widget build(BuildContext context) {
    return _XCloseScaffold(
      title: 'Notifications',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int c = 0; c < _categories.length; c++) ...[
                  if (c > 0) const SizedBox(height: 18),
                  Text(_categories[c].title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  _channelRow(c, 0, 'Push notification'),
                  _channelRow(c, 1, 'Email'),
                  _channelRow(c, 2, 'In-app recommendation'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _channelRow(int cat, int ch, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: TradEtTheme.textSecondary, fontSize: 13)),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: _categories[cat].channels[ch],
              activeThumbColor: Colors.white,
              activeTrackColor: TradEtTheme.positive,
              onChanged: (v) =>
                  setState(() => _categories[cat].channels[ch] = v),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifCategory {
  final String title;
  final List<bool> channels;
  _NotifCategory(this.title, this.channels);
}

// ═══════════════════════════════════════════════════════════════════════════
// Help & Support Menu Screen
// ═══════════════════════════════════════════════════════════════════════════

class _HelpMenuScreen extends StatelessWidget {
  const _HelpMenuScreen();

  void _showHelpDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TradEtTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(body,
            style: const TextStyle(color: TradEtTheme.textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: TradEtTheme.positive)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppProvider>().user;
    final fullName = user?.fullName ?? 'there';
    final firstName = fullName.split(' ').first;

    final items = <Map<String, dynamic>>[
      {
        'icon': Icons.help_outline_rounded,
        'title': 'Get started',
        'body': 'Learn how to set up your TradEt account, navigate the app, and place your first trade.',
      },
      {
        'icon': Icons.candlestick_chart_outlined,
        'title': 'Trading',
        'body': 'Understand how trading works on TradEt, including order types, ECX session hours, and Sharia screening.',
      },
      {
        'icon': Icons.account_balance_outlined,
        'title': 'Deposit and withdrawal',
        'body': 'Find guidance on how to deposit funds, withdraw to your bank, and manage payment methods.',
      },
      {
        'icon': Icons.badge_outlined,
        'title': 'Profile and kyc',
        'body': 'Complete your KYC verification, update personal information, and manage tier requirements.',
      },
      {
        'icon': Icons.security_rounded,
        'title': 'Security and fraud',
        'body': 'Tips for keeping your account safe, recognizing fraud, and recovering compromised access.',
      },
      {
        'icon': Icons.menu_book_outlined,
        'title': 'Frequently asked questions',
        'body': 'Browse common questions and answers about TradEt.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header: X close
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Hi $firstName,\nhow can we help?',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.2)),
                ),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: TradEtTheme.cardBg,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Ask anything ...',
                            hintStyle: TextStyle(color: TradEtTheme.textMuted),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: TradEtTheme.cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < items.length; i++) ...[
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: Container(
                                width: 36, height: 36,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(items[i]['icon'] as IconData,
                                    color: TradEtTheme.primary, size: 20),
                              ),
                              title: Text(items[i]['title'] as String,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              onTap: () => _showHelpDialog(context,
                                  items[i]['title'] as String,
                                  items[i]['body'] as String),
                            ),
                            if (i < items.length - 1)
                              Divider(height: 1, indent: 64,
                                  color: TradEtTheme.divider.withValues(alpha: 0.3)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Premium support button
                    InkWell(
                      onTap: () => showContactUsDialog(context),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TradEtTheme.primary.withValues(alpha: 0.7),
                              TradEtTheme.positive.withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.workspace_premium_rounded,
                                  color: TradEtTheme.primary, size: 20),
                            ),
                            const SizedBox(width: 14),
                            const Text('Premium Support',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
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
          Text(l.identityVerification,
              style: const TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
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
                        Text(l.commissionLimits,
                            style: const TextStyle(fontSize: 11,
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
                    feeRow(l.commissionRate, l.commissionRateValue,
                        Icons.percent_rounded, TradEtTheme.positive),
                    feeRow(l.dailyWithdrawalLimit, '100,000 ETB',
                        Icons.arrow_upward_rounded, TradEtTheme.warning),
                    feeRow(l.weeklyTradingLimit, '500,000 ETB',
                        Icons.swap_horiz_rounded, const Color(0xFF60A5FA)),
                    feeRow(l.planType, l.retailTraderStandard,
                        Icons.workspace_premium_outlined,
                        const Color(0xFF818CF8)),
                    feeRow(l.settlementType, l.settlementTPlus2,
                        Icons.schedule_rounded, TradEtTheme.accent),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: TradEtTheme.positive.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: TradEtTheme.positive.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: TradEtTheme.positive,
                              size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l.shariaFeeNote,
                              style: const TextStyle(fontSize: 11,
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
  // Per-field edited values (override widget.user when set)
  String? _fullName;
  String? _phone;
  String? _address;
  String? _dob;
  String? _nationality;
  String? _purposeOfAccount;
  String? _taxResidency;
  String? _email;

  // Dropdown state for KYC wealth fields
  String? _occupation;
  String? _sourceOfWealth;
  String? _sourceOfFunds;
  String? _netWorth;
  String? _purposeOfTrading;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _fullName = u?.fullName;
    _phone = u?.phone;
    _address = u?.address;
    _dob = u?.dateOfBirth;
    _nationality = u?.nationality;
    _purposeOfAccount = u?.purposeOfAccount;
    _taxResidency = u?.taxResidency;
    _email = u?.email;
    _occupation = u?.occupation;
    _sourceOfWealth = u?.sourceOfWealth;
    _sourceOfFunds = u?.sourceOfFunds;
    _netWorth = u?.netWorth;
    _purposeOfTrading = u?.purposeOfTrading;
  }

  /// Saves a single field — backend best-effort, local state guaranteed.
  Future<void> _saveField(String apiKey, String? value) async {
    final l = AppLocalizations.of(context);
    debugPrint('[ProfileSave] _saveField: $apiKey = $value');
    try {
      await context.read<AppProvider>().updateProfile({apiKey: value});
      debugPrint('[ProfileSave] updateProfile completed for $apiKey');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l.profileUpdated),
          backgroundColor: TradEtTheme.positive,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } catch (_) {
      // updateProfile already handles backend errors silently with local
      // fallback, but show a snackbar on truly unexpected failures.
    }
  }

  /// Shows a modal bottom-sheet with a single TextField to edit one field.
  Future<void> _showTextEditor({
    required String label,
    required String? initial,
    required TextInputType keyboardType,
    required void Function(String) onSave,
    required String apiKey,
  }) async {
    final ctrl = TextEditingController(text: initial ?? '');
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A2F22),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final l = AppLocalizations.of(ctx);
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20,
              MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.white24,
                        borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text(label,
                  style: const TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                keyboardType: keyboardType,
                autofocus: true,
                style: const TextStyle(fontSize: 15, color: Colors.white),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: TradEtTheme.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: TradEtTheme.divider.withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: TradEtTheme.positive),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor:
                            TradEtTheme.surfaceLight.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(l.cancel,
                          style: const TextStyle(
                              color: TradEtTheme.textSecondary, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onSave(ctrl.text);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TradEtTheme.positive,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(l.save,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    ctrl.dispose();
  }

  /// Static row: label + value + pencil; tapping anywhere opens text editor.
  Widget _editableRow(String label, String? value, String apiKey,
      {TextInputType keyboardType = TextInputType.text,
      bool isLast = false,
      bool editable = true,
      void Function(String)? onSaved}) {
    return InkWell(
      onTap: editable
          ? () => _showTextEditor(
                label: label,
                initial: value,
                keyboardType: keyboardType,
                apiKey: apiKey,
                onSave: (newVal) {
                  setState(() => onSaved?.call(newVal));
                  _saveField(apiKey, newVal);
                },
              )
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  Text((value != null && value.isNotEmpty) ? value : '--',
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ],
              ),
            ),
            if (editable)
              Icon(Icons.edit_outlined,
                  size: 16, color: TradEtTheme.accent.withValues(alpha: 0.85)),
          ],
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final user = widget.user;
    final email = _email ?? user?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top row: back + small avatar (right) ────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Consumer<AppProvider>(
                      builder: (ctx, prov, _) {
                        const avatarColors = [
                          Color(0xFF0F6B3C), Color(0xFF1D4ED8),
                          Color(0xFF7C3AED), Color(0xFFB45309),
                          Color(0xFF0D9488), Color(0xFF9D174D),
                        ];
                        final bg = avatarColors[
                            prov.avatarColorIndex % avatarColors.length];
                        final imgBytes = prov.profileImageBytes;
                        final initial = (_fullName ?? 'U').isNotEmpty
                            ? (_fullName ?? 'U')[0].toUpperCase() : '?';
                        return GestureDetector(
                          onTap: () => _showAvatarOptionsFromState(context, prov),
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
                                    width: 42, height: 42, fit: BoxFit.cover))
                                : Center(child: Text(initial,
                                    style: const TextStyle(fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white))),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ── Large title + @handle ───────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
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

              // ── Content ─────────────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    Text(l.personalSection,
                        style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TradEtTheme.textMuted)),
                    const SizedBox(height: 8),
                    _infoCard([
                      _editableRow(l.fullName, _fullName, 'full_name',
                          onSaved: (v) => _fullName = v),
                      _editableRow(l.dateOfBirth, _dob, 'date_of_birth',
                          keyboardType: TextInputType.datetime,
                          onSaved: (v) => _dob = v),
                      _editableRow(l.nationality, _nationality, 'nationality',
                          onSaved: (v) => _nationality = v),
                      _editableRow(l.residentialAddress, _address, 'address',
                          onSaved: (v) => _address = v),
                      _editableRow(l.phone, _phone, 'phone',
                          keyboardType: TextInputType.phone,
                          onSaved: (v) => _phone = v),
                      _editableRow(l.emailAddress, _email, 'email',
                          keyboardType: TextInputType.emailAddress,
                          editable: false),
                      _editableRow(l.purposeOfAccount, _purposeOfAccount,
                          'purpose_of_account',
                          onSaved: (v) => _purposeOfAccount = v),
                      _editableRow(l.taxResidency, _taxResidency,
                          'tax_residency',
                          isLast: true,
                          onSaved: (v) => _taxResidency = v),
                    ]),
                    const SizedBox(height: 20),

                    // ── Wealth / KYC ─────────────────────────────────
                    Text(l.wealthSection,
                        style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TradEtTheme.textMuted)),
                    const SizedBox(height: 8),
                    _infoCard([
                      _dropdownRow(
                        label: l.occupation,
                        value: _occupation ?? _occupations.first,
                        options: _occupations,
                        onTap: () => _showPicker(
                          l.occupation, _occupations, _occupation,
                          (v) {
                            setState(() => _occupation = v);
                            _saveField('occupation', v);
                          },
                        ),
                      ),
                      _dropdownRow(
                        label: l.sourceOfWealth,
                        value: _sourceOfWealth ?? _wealthSources.first,
                        options: _wealthSources,
                        onTap: () => _showPicker(
                          l.sourceOfWealth, _wealthSources, _sourceOfWealth,
                          (v) {
                            setState(() => _sourceOfWealth = v);
                            _saveField('source_of_wealth', v);
                          },
                        ),
                      ),
                      _dropdownRow(
                        label: l.sourceOfFund,
                        value: _sourceOfFunds ?? _fundSources.first,
                        options: _fundSources,
                        onTap: () => _showPicker(
                          l.sourceOfFund, _fundSources, _sourceOfFunds,
                          (v) {
                            setState(() => _sourceOfFunds = v);
                            _saveField('source_of_funds', v);
                          },
                        ),
                      ),
                      _dropdownRow(
                        label: l.netWorth,
                        value: _netWorth ?? _netWorthRanges.first,
                        options: _netWorthRanges,
                        onTap: () => _showPicker(
                          l.netWorth, _netWorthRanges, _netWorth,
                          (v) {
                            setState(() => _netWorth = v);
                            _saveField('net_worth', v);
                          },
                        ),
                      ),
                      _dropdownRow(
                        label: l.purposeOfTrading,
                        value: _purposeOfTrading ?? _tradingPurposes.first,
                        options: _tradingPurposes,
                        isLast: true,
                        onTap: () => _showPicker(
                          l.purposeOfTrading, _tradingPurposes,
                          _purposeOfTrading,
                          (v) {
                            setState(() => _purposeOfTrading = v);
                            _saveField('purpose_of_trading', v);
                          },
                        ),
                      ),
                    ]),
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
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
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
      onTap: () => _profileMenuAction(context, title),
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
        builder: (ctx, setStateDialog) {
          final l = AppLocalizations.of(ctx);
          return AlertDialog(
          backgroundColor: TradEtTheme.cardBg,
          title: Text(l.addPaymentMethod,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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
                    hint: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.account_balance_outlined,
                            color: TradEtTheme.textMuted, size: 18),
                        const SizedBox(width: 10),
                        Text(l.selectBank,
                            style: const TextStyle(color: TradEtTheme.textMuted, fontSize: 13)),
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
              child: Text(l.cancel,
                  style: const TextStyle(color: TradEtTheme.textMuted)),
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
              child: Text(l.add),
            ),
          ],
        );
        },
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.paymentMethods,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Text(l.linkedAccounts,
                            style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, color: TradEtTheme.positive, size: 14),
                            const SizedBox(width: 4),
                            Text(l.add,
                                style: const TextStyle(color: TradEtTheme.positive,
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
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: TradEtTheme.textMuted, size: 16),
                      const SizedBox(width: 10),
                      Text(l.noPaymentMethodsLinked,
                          style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted)),
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
    final l = AppLocalizations.of(context);
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
                        child: Text(l.primaryLabel,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
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
                  builder: (ctx) {
                    final l = AppLocalizations.of(ctx);
                    return AlertDialog(
                    backgroundColor: TradEtTheme.cardBg,
                    title: Text(l.removeAccount,
                        style: const TextStyle(color: Colors.white)),
                    content: Text('Remove ${method.bankName} ${method.accountNumber}?',
                        style: const TextStyle(color: TradEtTheme.textSecondary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(l.cancel,
                            style: const TextStyle(color: TradEtTheme.textMuted)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: TradEtTheme.negative),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(l.remove),
                      ),
                    ],
                  );},
                );
                if (confirmed == true) {
                  await provider.deletePaymentMethod(method.id);
                }
              }
            },
            itemBuilder: (popupCtx) {
              final l = AppLocalizations.of(popupCtx);
              return [
              if (!method.isPrimary)
                PopupMenuItem(
                  value: 'primary',
                  child: Row(
                    children: [
                      const Icon(Icons.star_outline, size: 16, color: TradEtTheme.positive),
                      const SizedBox(width: 8),
                      Text(l.setAsPrimary,
                          style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, size: 16, color: TradEtTheme.negative),
                    const SizedBox(width: 8),
                    Text(l.remove,
                        style: const TextStyle(color: TradEtTheme.negative, fontSize: 13)),
                  ],
                ),
              ),
            ];},
          ),
        ],
      ),
    );
  }
}

// SecurityLogSection lives in widgets/security_log_section.dart

// ═══════════════════════════════════════════════════════════════════════════
// Appearance Screen
// ═══════════════════════════════════════════════════════════════════════════

class _AppearanceScreen extends StatefulWidget {
  const _AppearanceScreen();

  @override
  State<_AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<_AppearanceScreen> {
  double _textSize = 14.0;

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
                child: Row(children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(l.appearance,
                      style: const TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w700, color: Colors.white)),
                ]),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Consumer<AppProvider>(
                      builder: (ctx, prov, _) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: TradEtTheme.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: TradEtTheme.divider.withValues(alpha: 0.3)),
                        ),
                        child: ListTile(
                          leading: Icon(
                            prov.isDarkMode
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: const Color(0xFF818CF8),
                          ),
                          title: Text(l.appearance,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          subtitle: Text(
                            prov.isDarkMode ? l.darkMode : l.lightMode,
                            style: const TextStyle(
                                color: TradEtTheme.textMuted, fontSize: 11),
                          ),
                          trailing: Switch(
                            value: prov.isDarkMode,
                            onChanged: (_) => prov.toggleTheme(),
                            activeThumbColor: TradEtTheme.positive,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: TradEtTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: TradEtTheme.divider.withValues(alpha: 0.3)),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.language_rounded,
                            color: Color(0xFF60A5FA)),
                        title: Text(l.language,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        trailing: const LanguageSelector(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: TradEtTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: TradEtTheme.divider.withValues(alpha: 0.3)),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.dashboard_outlined,
                            color: Color(0xFF22D3EE)),
                        title: Text(l.interfaceLayout,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        subtitle: Text(l.interfaceSubtitle,
                            style: const TextStyle(
                                color: TradEtTheme.textMuted, fontSize: 11)),
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: TradEtTheme.textMuted, size: 20),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: TradEtTheme.cardBg,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: Text(l.interfaceLayout,
                                  style: const TextStyle(color: Colors.white)),
                              content: const Text('Interface settings coming soon',
                                  style: TextStyle(
                                      color: TradEtTheme.textSecondary,
                                      fontSize: 13)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close',
                                      style: TextStyle(
                                          color: TradEtTheme.positive)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: TradEtTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: TradEtTheme.divider.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.text_fields_rounded,
                                  color: Color(0xFFF59E0B)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(l.textSize,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    Text(l.textSizeSubtitle,
                                        style: const TextStyle(
                                            color: TradEtTheme.textMuted,
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                              Text('${_textSize.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Slider(
                            value: _textSize,
                            min: 12.0,
                            max: 20.0,
                            divisions: 8,
                            label: _textSize.toStringAsFixed(0),
                            activeColor: TradEtTheme.positive,
                            onChanged: (v) => setState(() => _textSize = v),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Sample text at this size',
                              style: TextStyle(
                                  color: Colors.white, fontSize: _textSize),
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
// About Us Screen
// ═══════════════════════════════════════════════════════════════════════════

class _AboutUsScreen extends StatelessWidget {
  const _AboutUsScreen();

  Widget _aboutCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(children: children),
    );
  }

  Widget _aboutItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36, height: 36,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: TradEtTheme.primary, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
              color: Colors.white)),
      onTap: () => _profileMenuAction(context, title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _XCloseScaffold(
      title: l.aboutUs,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _aboutCard([
            _aboutItem(context, Icons.star_rate_rounded, l.rateUs),
          ]),
          _aboutCard([
            _aboutItem(context, Icons.article_outlined, l.ourBlog),
            Divider(height: 1, indent: 64,
                color: TradEtTheme.divider.withValues(alpha: 0.3)),
            _aboutItem(context, Icons.close_rounded, 'Follow us on X'),
            Divider(height: 1, indent: 64,
                color: TradEtTheme.divider.withValues(alpha: 0.3)),
            _aboutItem(context, Icons.facebook_rounded, 'Like us on Facebook'),
          ]),
          _aboutCard([
            _aboutItem(context, Icons.description_outlined, l.openSourceLicenses),
          ]),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Helper dialogs and screens for profile menu actions
// ═══════════════════════════════════════════════════════════════════════════

void _profileMenuAction(BuildContext context, String title) {
  // Route generic doc-item taps to the appropriate dialog by title.
  final lower = title.toLowerCase();
  if (lower.contains('legal')) {
    showLegalDocsDialog(context);
  } else if (lower.contains('regulator')) {
    showRegulatoryStatusDialog(context);
  } else if (lower.contains('halal') || lower.contains('sharia')) {
    showHalalComplianceDialog(context);
  } else if (lower.contains('tax')) {
    showTaxStatementsDialog(context);
  } else {
    showInfoDialog(context, title,
        'Detailed information for "$title" will appear here. '
        'Contact support@tradet.et for the latest documentation.');
  }
}

void showInfoDialog(BuildContext context, String title, String body) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: TradEtTheme.cardBg,
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      content: Text(body,
          style: const TextStyle(color: TradEtTheme.textSecondary, height: 1.4)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

Widget _bullet(String label, String detail, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w600, fontSize: 13)),
              if (detail.isNotEmpty)
                Text(detail,
                    style: const TextStyle(color: TradEtTheme.textMuted, fontSize: 11)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _bulletDialogScaffold(BuildContext context, IconData icon, Color color,
    String title, String? intro, List<Widget> bullets) {
  return AlertDialog(
    backgroundColor: TradEtTheme.cardBg,
    titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
    title: Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(title,
            style: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.w700, fontSize: 16)),
      ),
    ]),
    content: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (intro != null) ...[
              Text(intro,
                  style: const TextStyle(
                      color: TradEtTheme.textSecondary, height: 1.4, fontSize: 13)),
              const SizedBox(height: 8),
            ],
            ...bullets,
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
    ],
  );
}

void showLegalDocsDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => _bulletDialogScaffold(
      ctx, Icons.gavel_rounded, const Color(0xFF60A5FA),
      'Legal Documents',
      'Tap an item to view its full text.',
      [
        for (final doc in const [
          ['Terms of Service', 'Conditions of using TradEt'],
          ['Risk Disclosure', 'Trading risks & ECX rules'],
          ['Privacy Policy', 'How we handle your data'],
          ['Anti-Money Laundering (AML) Policy', 'NBE-compliant AML procedures'],
        ])
          InkWell(
            onTap: () {
              Navigator.pop(ctx);
              showInfoDialog(context, doc[0],
                  '${doc[0]} — ${doc[1]}.\n\nThe full document is available '
                  'on request from compliance@tradet.et.');
            },
            child: _bullet(doc[0], doc[1], const Color(0xFF60A5FA)),
          ),
      ],
    ),
  );
}

void showRegulatoryStatusDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => _bulletDialogScaffold(
      ctx, Icons.account_balance_outlined, const Color(0xFF818CF8),
      'Regulatory Status',
      'TradEt operates under the following regulatory frameworks:',
      [
        _bullet('ECX (Ethiopia Commodity Exchange)', 'Licensed broker',
            const Color(0xFF818CF8)),
        _bullet('NBE (National Bank of Ethiopia)', 'Regulated entity',
            const Color(0xFF60A5FA)),
        _bullet('ECEA (Ethiopian Capital Market Authority)', 'Compliant',
            TradEtTheme.accent),
        _bullet('AAOIFI Standard 21', 'Applied for Sharia compliance',
            TradEtTheme.positive),
      ],
    ),
  );
}

void showHalalComplianceDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => _bulletDialogScaffold(
      ctx, Icons.verified_rounded, TradEtTheme.positive,
      'Halal Compliance',
      'All trades on TradEt comply with the following Sharia principles:',
      [
        _bullet('AAOIFI 30% Screening', 'Debt, interest income & cash thresholds enforced',
            TradEtTheme.positive),
        _bullet('No Riba (Interest)', 'Flat 1.5% commission only',
            const Color(0xFF60A5FA)),
        _bullet('No Short Selling', 'Sale of unowned assets prohibited',
            TradEtTheme.accent),
        _bullet('No Futures or Options', 'Speculative derivatives excluded',
            const Color(0xFF818CF8)),
        _bullet('Sharia Board Oversight', 'Independent scholarly review',
            TradEtTheme.positive),
      ],
    ),
  );
}

void showTaxStatementsDialog(BuildContext context) {
  final provider = Provider.of<AppProvider>(context, listen: false);
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: TradEtTheme.cardBg,
      title: const Row(children: [
        Icon(Icons.receipt_long_outlined, color: TradEtTheme.accent, size: 20),
        SizedBox(width: 10),
        Expanded(
          child: Text('Tax Statements',
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.w700, fontSize: 16)),
        ),
      ]),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('For tax declaration purposes:',
                style: TextStyle(
                    color: TradEtTheme.textSecondary, fontSize: 13, height: 1.4)),
            const SizedBox(height: 12),
            _bullet('Annual P&L Statement (PDF)',
                'Profit & loss for the tax year', TradEtTheme.accent),
            _bullet('Trade History (CSV)',
                'Itemised list of all executed trades', const Color(0xFF60A5FA)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf, size: 16),
                  label: const Text('Export PDF'),
                  onPressed: () async {
                    final user = provider.user;
                    if (user == null) return;
                    Navigator.pop(ctx);
                    try {
                      final events =
                          await SecurityLogService.getEntries(limit: 50);
                      if (!context.mounted) return;
                      await PdfExportService.exportCsmsReport(
                        context: context,
                        user: user,
                        holdings: provider.holdings,
                        events: events,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Tax statement export started'),
                              behavior: SnackBarBehavior.floating));
                      }
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Export failed — please try again'),
                              behavior: SnackBarBehavior.floating));
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.table_chart_outlined, size: 16),
                  label: const Text('CSV (soon)'),
                  onPressed: null,
                ),
              ),
            ]),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void showSystemMarketingDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => const _SystemMarketingDialog(),
  );
}

class _SystemMarketingDialog extends StatefulWidget {
  const _SystemMarketingDialog();
  @override
  State<_SystemMarketingDialog> createState() => _SystemMarketingDialogState();
}

class _SystemMarketingDialogState extends State<_SystemMarketingDialog> {
  bool _newsletter = true;
  bool _aiNotif = true;
  bool _promos = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TradEtTheme.cardBg,
      title: const Text('System & Marketing',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Newsletter subscription',
                  style: TextStyle(color: Colors.white, fontSize: 13)),
              value: _newsletter,
              onChanged: (v) => setState(() => _newsletter = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('AI assistance notifications',
                  style: TextStyle(color: Colors.white, fontSize: 13)),
              value: _aiNotif,
              onChanged: (v) => setState(() => _aiNotif = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Promotional offers',
                  style: TextStyle(color: Colors.white, fontSize: 13)),
              value: _promos,
              onChanged: (v) => setState(() => _promos = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Notification preferences saved'),
                  behavior: SnackBarBehavior.floating));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

void showSupportCenterDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: TradEtTheme.cardBg,
      title: const Text('Support Center',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _FaqTile(question: 'How do I trade?',
                  answer: 'From the Market screen, tap an asset, choose Buy or '
                      'Sell, enter quantity, then confirm. Trades execute during '
                      'ECX session hours only.'),
              _FaqTile(question: 'What is Sharia compliance?',
                  answer: 'TradEt enforces AAOIFI Standard 21 — no riba, no '
                      'short selling, no futures/options, and 30% screening '
                      'thresholds on every asset.'),
              _FaqTile(question: 'How do I withdraw funds?',
                  answer: 'Go to Profile > Wallet > Withdraw. Funds are sent '
                      'to your linked NBE-regulated bank account within 1-2 '
                      'business days.'),
              _FaqTile(question: 'Why is KYC required?',
                  answer: 'NBE regulations require identity verification before '
                      'any trade. KYC also enables tax reporting and AML compliance.'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        iconColor: Colors.white,
        collapsedIconColor: TradEtTheme.textMuted,
        title: Text(question,
            style: const TextStyle(color: Colors.white,
                fontSize: 13, fontWeight: FontWeight.w600)),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(answer,
                style: const TextStyle(
                    color: TradEtTheme.textSecondary, fontSize: 12, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

void showContactUsDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => const _ContactUsDialog(),
  );
}

class _ContactUsDialog extends StatefulWidget {
  const _ContactUsDialog();
  @override
  State<_ContactUsDialog> createState() => _ContactUsDialogState();
}

class _ContactUsDialogState extends State<_ContactUsDialog> {
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Widget _contactRow(IconData icon, String label, String value,
      {bool copy = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(icon, size: 16, color: TradEtTheme.accent),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: TradEtTheme.textMuted, fontSize: 10)),
              Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
        ),
        if (copy)
          IconButton(
            tooltip: 'Copy',
            icon: const Icon(Icons.copy, size: 16, color: TradEtTheme.textMuted),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: value));
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied $value'),
                      behavior: SnackBarBehavior.floating));
              }
            },
          ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TradEtTheme.cardBg,
      title: const Text('Contact Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _contactRow(Icons.email_outlined, 'Email',
                  'support@tradet.et', copy: true),
              _contactRow(Icons.phone_outlined, 'Phone',
                  '+251 11 xxx xxxx', copy: true),
              _contactRow(Icons.location_on_outlined, 'Office',
                  'Addis Ababa, Ethiopia'),
              const SizedBox(height: 12),
              const Text('Send us a message',
                  style: TextStyle(color: Colors.white,
                      fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: _msgCtrl,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'How can we help?',
                  hintStyle: const TextStyle(
                      color: TradEtTheme.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: TradEtTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Thank you — our team will reply within 24h'),
                  behavior: SnackBarBehavior.floating));
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}

// ─── Privacy Controls screen ───────────────────────────────────────────────

class PrivacyControlsScreen extends StatefulWidget {
  const PrivacyControlsScreen({super.key});
  @override
  State<PrivacyControlsScreen> createState() => _PrivacyControlsScreenState();
}

class _PrivacyControlsScreenState extends State<PrivacyControlsScreen> {
  final List<_PrivacyToggle> _items = [
    _PrivacyToggle(
      icon: Icons.visibility_off_outlined,
      title: 'Hide balance',
      description: 'Hide amount for all balance and transaction',
      value: false,
    ),
    _PrivacyToggle(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Make me discoverable',
      description: 'By phone number and TradEt user name',
      value: true,
    ),
    _PrivacyToggle(
      icon: Icons.person_outline_rounded,
      title: 'Show full name and picture',
      description:
          'Share my full name and photo with other TradEt customers when they search my user name, phone number or e-mail',
      value: true,
    ),
    _PrivacyToggle(
      icon: Icons.favorite_outline_rounded,
      title: 'Show my plan',
      description:
          'Your contact on TradEt will see your plan and be able to gift it or upgrade you',
      value: true,
    ),
    _PrivacyToggle(
      icon: Icons.cake_outlined,
      title: 'Show my birthday',
      description: 'Your contact on TradEt will see your birthday',
      value: true,
    ),
    _PrivacyToggle(
      icon: Icons.campaign_outlined,
      title: 'Social media & advertising platforms',
      description:
          'I\'m happy for TradEt to share information, such as my name, email address and app events with social media and advertising platforms to allow to advertise to me',
      value: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _XCloseScaffold(
      title: 'Privacy',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _items.length; i++) ...[
                  _privacyRow(i),
                  if (i < _items.length - 1)
                    Divider(height: 1, indent: 60,
                        color: TradEtTheme.divider.withValues(alpha: 0.3)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _privacyRow(int i) {
    final item = _items[i];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: Colors.white, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(item.description,
                    style: const TextStyle(
                        color: TradEtTheme.textMuted,
                        fontSize: 12,
                        height: 1.3)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: item.value,
            activeThumbColor: Colors.white,
            activeTrackColor: TradEtTheme.positive,
            onChanged: (v) => setState(() => item.value = v),
          ),
        ],
      ),
    );
  }
}

class _PrivacyToggle {
  final IconData icon;
  final String title;
  final String description;
  bool value;
  _PrivacyToggle({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// X-close scaffold (Figma-style modal pages)
// ═══════════════════════════════════════════════════════════════════════════

class _XCloseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final EdgeInsets headerPadding;
  const _XCloseScaffold({
    required this.title,
    required this.body,
    this.headerPadding = const EdgeInsets.fromLTRB(8, 8, 16, 16),
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
              Padding(
                padding: headerPadding,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700)),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Upgrade Screen
// ═══════════════════════════════════════════════════════════════════════════

class _UpgradeScreen extends StatefulWidget {
  const _UpgradeScreen();

  @override
  State<_UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<_UpgradeScreen> {
  int _selected = 1; // 0 Standard, 1 Premium, 2 Elite

  static const _tabs = ['Standard', 'Premium', 'Elite'];

  static const _premiumFeatures = [
    ['Discounted Commissions', 'Reduced brokerage fees (1% per trade) to reward higher volume.'],
    ['Advanced Analytics', 'Real-time technical indicators and charting tools.'],
    ['Price Alerts', 'Unlimited SMS and push-notification alerts for target price movements on the ESX/ECX.'],
    ['Priority Support', 'Dedicated "Fast Track" customer service for trade inquiries.'],
  ];

  static const _eliteFeatures = [
    ['Web Terminal Access', 'A professional-grade desktop trading platform for multi-monitor setups.'],
    ['Advanced Risk Modeling', 'Proprietary tools to simulate portfolio performance.'],
    ['Institutional Data Feeds', 'Level 2 market data (showing the full order book depth of the ESX).'],
    ['Early Access', 'First-look availability for new asset classes, such as new commodity listings.'],
  ];

  static const _standardFeatures = [
    ['1.5% flat commission', 'Sharia-compliant flat commission, no Riba.'],
    ['Basic charting', 'Standard candlestick and line charts.'],
    ['Market alerts', 'Standard price and market notifications.'],
  ];

  void _showComingSoon(String tier) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Join $tier — Coming soon — payment integration in progress'),
        backgroundColor: TradEtTheme.cardBg,
      ),
    );
  }

  Widget _featureRow(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(desc,
              style: const TextStyle(
                  color: TradEtTheme.textMuted, fontSize: 12, height: 1.3)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tier = _tabs[_selected];
    final features = _selected == 0
        ? _standardFeatures
        : _selected == 1
            ? _premiumFeatures
            : _eliteFeatures;
    final platform = _selected == 1
        ? 'Mobile App Only.'
        : _selected == 2
            ? 'Mobile App + Web Terminal.'
            : 'Mobile App.';
    final pricing = _selected == 1
        ? '1000 ETB / Month.'
        : _selected == 2
            ? '3000 ETB / Month.'
            : 'Free — current plan.';

    return _XCloseScaffold(
      title: 'Upgrade plan',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          // Segmented control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selected = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selected == i
                              ? TradEtTheme.positive.withValues(alpha: 0.7)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(_tabs[i],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Feature card
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selected == 0)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text('Your current plan',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                  ),
                for (final f in features) _featureRow(f[0], f[1]),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Platform + pricing
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: TradEtTheme.cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Platform: $platform',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('Pricing: $pricing',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // See all benefits
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showComingSoon(tier),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text('See all benefits',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          // Join tier (only for Premium/Elite)
          if (_selected != 0)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showComingSoon(tier),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: TradEtTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: Text('Join $tier',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
        ],
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════════════════
// Invite Friends Screen — matches Figma "Earn 500 per friend"
// ═══════════════════════════════════════════════════════════════════════════

class _InviteFriendsScreen extends StatelessWidget {
  final dynamic user;
  const _InviteFriendsScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Headline
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text('Ends in 15 days',
                        style: TextStyle(fontSize: 13,
                            color: TradEtTheme.textSecondary)),
                    SizedBox(height: 6),
                    Text('Earn 500 per friend',
                        style: TextStyle(fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                      child: Text('Your friends have to do',
                          style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: TradEtTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: TradEtTheme.divider.withValues(alpha: 0.3)),
                      ),
                      child: Column(children: [
                        _stepRow(Icons.link_rounded, 'Sign up with your link',
                            'And verify their identity'),
                        _stepDivider(),
                        _stepRow(Icons.attach_money_rounded,
                            'Add money to their account',
                            'Via debit card or bank transfer'),
                        _stepDivider(),
                        _stepRow(Icons.bar_chart_rounded,
                            'Make 3 trade orders of 1000 minimum each',
                            "Some cash transactions, like to self and others bank account don't count",
                            isLast: true),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: TradEtTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: TradEtTheme.divider.withValues(alpha: 0.3)),
                      ),
                      child: Column(children: [
                        _navRow(context, 'Past invites'),
                        Divider(height: 1, indent: 20,
                            color: TradEtTheme.divider.withValues(alpha: 0.3)),
                        _navRow(context, 'Get help'),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                          'offer end at each end of the month. Max 5 invites per month. T&C apply',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11,
                              color: TradEtTheme.textMuted)),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invite link copied — share with your friends!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: TradEtTheme.surface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        child: const Text('Invite friends',
                            style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.w700)),
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

  Widget _stepRow(IconData icon, String title, String sub,
      {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 4),
                Text(sub,
                    style: const TextStyle(fontSize: 12,
                        color: TradEtTheme.textMuted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepDivider() => Divider(height: 1, indent: 50,
      color: TradEtTheme.divider.withValues(alpha: 0.3));

  Widget _navRow(BuildContext context, String label) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(label,
          style: const TextStyle(fontSize: 14,
              fontWeight: FontWeight.w500, color: Colors.white)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: TradEtTheme.textMuted, size: 20),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label — coming soon'),
            behavior: SnackBarBehavior.floating)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Learn Screen — placeholder for educational content
// ═══════════════════════════════════════════════════════════════════════════

class _LearnScreen extends StatelessWidget {
  const _LearnScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
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
                    const Text('Learn',
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    _learnTile(context, Icons.school_rounded,
                        'Trading Basics',
                        'Understand the fundamentals of commodity trading.',
                        TradEtTheme.positive),
                    const SizedBox(height: 12),
                    _learnTile(context, Icons.mosque_rounded,
                        'Sharia & Islamic Finance',
                        'Learn how AAOIFI screens halal investments.',
                        const Color(0xFFD4AF37)),
                    const SizedBox(height: 12),
                    _learnTile(context, Icons.show_chart_rounded,
                        'Reading Charts',
                        'Master candlestick patterns and indicators.',
                        const Color(0xFF60A5FA)),
                    const SizedBox(height: 12),
                    _learnTile(context, Icons.security_rounded,
                        'Risk Management',
                        'Protect your capital — diversification & position sizing.',
                        const Color(0xFF818CF8)),
                    const SizedBox(height: 12),
                    _learnTile(context, Icons.account_balance_rounded,
                        'Ethiopian Markets',
                        'ECX, ESX, NBE — how local markets work.',
                        const Color(0xFF22D3EE)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _learnTile(BuildContext context, IconData icon, String title,
      String sub, Color color) {
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
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(sub, style: const TextStyle(fontSize: 12,
                      color: TradEtTheme.textMuted, height: 1.4)),
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
// Inbox Screen — mock unread messages
// ═══════════════════════════════════════════════════════════════════════════

class _InboxScreen extends StatelessWidget {
  const _InboxScreen();

  static const _messages = [
    {
      'icon': Icons.campaign_rounded,
      'title': 'Welcome to TradEt',
      'sub': 'Get started with your first Sharia-compliant trade.',
      'time': '2h ago',
      'color': Color(0xFF22D3EE),
    },
    {
      'icon': Icons.trending_up_rounded,
      'title': 'Coffee price hit your alert',
      'sub': 'ECX-COF reached 4,200 ETB/qt — tap to view market.',
      'time': '5h ago',
      'color': Color(0xFF34D399),
    },
    {
      'icon': Icons.verified_rounded,
      'title': 'KYC verified',
      'sub': 'Your Tier 1 verification is complete. You can now trade.',
      'time': '1d ago',
      'color': Color(0xFFD4AF37),
    },
    {
      'icon': Icons.security_rounded,
      'title': 'New device sign-in',
      'sub': 'A new Chrome on Mac signed in to your account.',
      'time': '3d ago',
      'color': Color(0xFFEF4444),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
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
                    const Text('Inbox',
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w700, color: Colors.white)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Marked all as read'),
                              behavior: SnackBarBehavior.floating)),
                      child: const Text('Mark all read',
                          style: TextStyle(fontSize: 12,
                              color: TradEtTheme.accent)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: _messages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final m = _messages[i];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: TradEtTheme.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: TradEtTheme.divider.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: (m['color'] as Color).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(m['icon'] as IconData,
                                color: m['color'] as Color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(m['title'] as String,
                                          style: const TextStyle(fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    ),
                                    Text(m['time'] as String,
                                        style: const TextStyle(fontSize: 11,
                                            color: TradEtTheme.textMuted)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(m['sub'] as String,
                                    style: const TextStyle(fontSize: 12,
                                        color: TradEtTheme.textSecondary,
                                        height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

