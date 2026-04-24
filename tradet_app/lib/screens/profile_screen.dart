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
import '../services/app_lock_service.dart';
import 'login_screen.dart';
import 'security_screen.dart';
import '../utils/security_challenge.dart';

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

            if (wide) {
              return _buildWebLayout(context, provider, user);
            }
            return _buildMobileLayout(context, provider, user);
          },
        ),
      ),
    );
  }

  // ─── WEB LAYOUT — redesigned ───
  Widget _buildWebLayout(BuildContext context, AppProvider provider, dynamic user) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      children: [
        // Header
        const Text('Profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
                color: Colors.white, letterSpacing: -0.5)),
        const Text('Account settings',
            style: TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
        const SizedBox(height: 24),

        // Hero user banner — full width
        _webUserBanner(user),
        const SizedBox(height: 24),

        // Three-column grid — each column sizes to its own content
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Compliance + Security Log stacked
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _webComplianceCard(),
                  const SizedBox(height: 16),
                  const _SecurityLogSection(),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Middle: Preferences
            Expanded(child: _webSettingsCard(context, provider)),
            const SizedBox(width: 20),
            // Right: Account + Payment + Logout
            Expanded(child: _webAccountCard(context, provider, user)),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: Text(
            'TradEt v1.0.0 by Amber — Sharia & Ethiopian Trade Compliant',
            style: TextStyle(fontSize: 11, color: TradEtTheme.textMuted.withValues(alpha: 0.6)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _webUserBanner(dynamic user) {
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
          // Avatar
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
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: imgBytes != null
                            ? ClipOval(child: Image.memory(imgBytes, width: 80, height: 80, fit: BoxFit.cover))
                            : Center(child: Text(initial, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white))),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: bg, width: 2)),
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
          // Name & email
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
                // KYC badge + member since
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
          // Quick stats on the right
          Row(
            children: [
              _bannerStat('Holdings', user?.walletBalance != null ? 'Active' : '--', Icons.pie_chart_outline),
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

  Widget _webComplianceCard() {
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
                  color: TradEtTheme.positive.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.verified_user_rounded,
                    color: TradEtTheme.positive, size: 18),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Compliance',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  Text('Standards & certification',
                      style: TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
                ],
              ),
            ],
          ),
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
        ],
      ),
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
                Text(sub, style: const TextStyle(fontSize: 10,
                    color: TradEtTheme.textMuted)),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, size: 16, color: color.withValues(alpha: 0.6)),
        ],
      ),
    );
  }

  Widget _webSettingsCard(BuildContext context, AppProvider provider) {
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
                child: const Icon(Icons.settings_rounded,
                    color: TradEtTheme.accent, size: 18),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preferences',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  Text('Settings & preferences',
                      style: TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Theme toggle
          _webSettingRow(
            icon: provider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title: AppLocalizations.of(context).theme,
            subtitle: provider.isDarkMode ? 'Dark mode' : 'Light mode',
            color: const Color(0xFF818CF8),
            trailing: Switch(
              value: provider.isDarkMode,
              onChanged: (_) => provider.toggleTheme(),
              activeThumbColor: TradEtTheme.positive,
            ),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          // Language
          _webSettingRow(
            icon: Icons.language_rounded,
            title: AppLocalizations.of(context).language,
            subtitle: AppLocalizations.languageNames[provider.langCode] ?? 'English',
            color: const Color(0xFF60A5FA),
            trailing: const LanguageSelector(),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          // Notifications
          _webSettingRow(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage price & order alerts',
            color: TradEtTheme.accent,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification preferences — coming soon'),
                behavior: SnackBarBehavior.floating,
              ),
            ),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          // Security
          _webSettingRow(
            icon: Icons.shield_outlined,
            title: 'Security',
            subtitle: 'Wealth protection & PIN',
            color: const Color(0xFF22D3EE),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SecurityScreen())),
          ),
          Divider(height: 24, color: TradEtTheme.divider.withValues(alpha: 0.2)),
          // Help
          _webSettingRow(
            icon: Icons.help_outline_rounded,
            title: 'Help',
            subtitle: 'FAQ & Support',
            color: TradEtTheme.positive,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: TradEtTheme.textMuted, size: 20),
            isLast: true,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Help & FAQ — coming soon'),
                behavior: SnackBarBehavior.floating,
              ),
            ),
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
    final isVerified = user?.kycStatus == 'verified';

    return Column(
      children: [
        // KYC Card
        if (!isVerified)
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
                    label: const Text('Verify Now', style: TextStyle(fontSize: 13)),
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

        if (!isVerified) const SizedBox(height: 16),

        // Account info card
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22D3EE).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person_outline_rounded,
                        color: Color(0xFF22D3EE), size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Account',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text('Your information',
                          style: TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _accountInfoRow('Full Name', user?.fullName ?? '--'),
              _accountInfoRow('Email', user?.email ?? '--'),
              _accountInfoRow('KYC Status',
                  user?.kycStatus?.toString().toUpperCase() ?? 'PENDING'),
              _accountInfoRow('Account Type', 'Retail Trader'),
              const SizedBox(height: 14),
              _kycTierProgress(context, user?.kycStatus ?? 'pending'),
            ],
          ),
        ),
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
                  const Icon(Icons.logout_rounded, color: TradEtTheme.negative, size: 18),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context).logout,
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

  Widget _accountInfoRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
              color: Colors.white)),
        ],
      ),
    );
  }

  // ─── MOBILE LAYOUT — unchanged ───
  Widget _buildMobileLayout(BuildContext context, AppProvider provider, dynamic user) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        const Text('Profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
                color: Colors.white, letterSpacing: -0.5)),
        const Text('Account settings',
            style: TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
        const SizedBox(height: 24),
        _userCard(user),
        const SizedBox(height: 16),
        if (user?.kycStatus != 'verified') ...[
          _kycWarning(context),
          const SizedBox(height: 16),
        ],
        _kycTierCard(context, user?.kycStatus ?? 'pending'),
        const SizedBox(height: 16),
        _complianceCard(context),
        const SizedBox(height: 16),
        _settingsCard(),
        const SizedBox(height: 16),
        const _PaymentMethodsSection(),
        const SizedBox(height: 16),
        const _SecurityLogSection(),
        const SizedBox(height: 16),
        _logoutButton(context, provider),
        const SizedBox(height: 24),
        const Center(
          child: Text('TradEt v1.0.0 — Sharia & Ethiopian Trade Compliant',
              style: TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ─── Mobile-only widgets ───

  Widget _userCard(dynamic user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: TradEtTheme.heroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TradEtTheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Consumer<AppProvider>(
            builder: (context, prov, _) {
              final avatarColors = [
                const Color(0xFF0F6B3C), const Color(0xFF1D4ED8), const Color(0xFF7C3AED),
                const Color(0xFFB45309), const Color(0xFF0D9488), const Color(0xFF9D174D),
              ];
              final bg = avatarColors[prov.avatarColorIndex % avatarColors.length];
              final imgBytes = prov.profileImageBytes;
              return GestureDetector(
                onTap: () => _showAvatarOptions(context, prov),
                child: Stack(
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        color: bg,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      child: imgBytes != null
                          ? ClipOval(child: Image.memory(imgBytes, width: 72, height: 72, fit: BoxFit.cover))
                          : Center(child: Text(
                              user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : '?',
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
                            )),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: bg, width: 2)),
                        child: Icon(Icons.camera_alt, size: 11, color: bg),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          Text(user?.fullName ?? 'User',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 4),
          Text(user?.email ?? '',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
          const SizedBox(height: 14),
          _kycStatusBadge(user?.kycStatus ?? 'pending'),
        ],
      ),
    );
  }

  Widget _kycWarning(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TradEtTheme.warning.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: TradEtTheme.warning, size: 22),
              const SizedBox(width: 8),
              const Text('KYC Verification Required',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
              'Complete KYC to start trading. Required by NBE and ECX regulations.',
              style: TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showKycDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: TradEtTheme.warning,
                foregroundColor: Colors.black,
              ),
              child: Text(AppLocalizations.of(context).completeKyc),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kycTierCard(BuildContext context, String kycStatus) {
    final isVerified = kycStatus == 'verified';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: (isVerified ? TradEtTheme.positive : TradEtTheme.warning)
                .withValues(alpha: 0.25)),
      ),
      child: _kycTierProgress(context, kycStatus),
    );
  }

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
                fontWeight: FontWeight.w600,
                fontSize: 13,
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
            final active = stepIndex == currentStep;
            final color = done
                ? TradEtTheme.positive
                : active
                    ? TradEtTheme.warning
                    : TradEtTheme.divider;
            return Container(
              width: 20,
              height: 20,
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
            return Text(
              e.value,
              style: TextStyle(
                color: done ? TradEtTheme.textSecondary : TradEtTheme.textMuted,
                fontSize: 9,
              ),
            );
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _complianceCard(BuildContext context) {
    final l = AppLocalizations.of(context);
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
          Text(l.compliance,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 14),
          _complianceItem(Icons.verified_rounded, 'Sharia Compliant (AAOIFI)',
              'All assets screened for halal compliance', TradEtTheme.positive),
          _complianceItem(Icons.account_balance_rounded, 'ECX Regulated',
              'Trading under Ethiopia Commodity Exchange rules', const Color(0xFF60A5FA)),
          _complianceItem(Icons.security_rounded, 'NBE Supervised',
              'National Bank of Ethiopia regulatory framework', const Color(0xFF818CF8)),
          _complianceItem(Icons.money_off_rounded, 'No Interest (Riba-Free)',
              'Flat commission fees only — no interest charges', const Color(0xFF22D3EE)),
          _complianceItem(Icons.block_rounded, 'No Short Selling',
              'Only sell assets you own — spot trading only', TradEtTheme.warning),
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
                label: const Text('Export Security Report',
                    style: TextStyle(color: TradEtTheme.accent, fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: TradEtTheme.accent, width: 0.8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TradEtTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    provider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: TradEtTheme.accent, size: 20,
                  ),
                ),
                title: Text(AppLocalizations.of(context).theme,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text(provider.isDarkMode ? 'Dark mode' : 'Light mode',
                    style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted)),
                trailing: Switch(
                  value: provider.isDarkMode,
                  onChanged: (_) => provider.toggleTheme(),
                  activeThumbColor: TradEtTheme.positive,
                ),
              ),
              Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TradEtTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.language_rounded,
                      color: TradEtTheme.accent, size: 20),
                ),
                title: Text(AppLocalizations.of(context).language,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text(AppLocalizations.languageNames[provider.langCode] ?? 'English',
                    style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted)),
                trailing: const LanguageSelector(),
              ),
              Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
              _settingsTile(
                  Icons.notifications_outlined, AppLocalizations.of(context).notifications, 'Manage price & order alerts',
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification preferences — coming soon'), behavior: SnackBarBehavior.floating),
                  )),
              Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
              _settingsTile(
                  Icons.shield_outlined, AppLocalizations.of(context).security, 'Wealth protection & PIN',
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen()))),
              Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
              _appLockTile(context),
              Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
              _settingsTile(
                  Icons.help_outline_rounded, AppLocalizations.of(context).help, 'FAQ & Support',
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & FAQ — coming soon'), behavior: SnackBarBehavior.floating),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _appLockTile(BuildContext context) {
    return FutureBuilder<bool>(
      future: AppLockService.isEnabled(),
      builder: (ctx, snap) {
        final enabled = snap.data ?? false;
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TradEtTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              enabled ? Icons.lock_rounded : Icons.lock_open_rounded,
              color: enabled ? TradEtTheme.positive : TradEtTheme.accent,
              size: 20,
            ),
          ),
          title: Text(AppLocalizations.of(context).appLock,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          subtitle: Text(
            enabled ? 'PIN set — tap to change or disable' : 'Set a PIN to lock the app',
            style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted),
          ),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: TradEtTheme.textMuted, size: 20),
          onTap: () => _showSetPinDialog(context, enabled),
        );
      },
    );
  }

  void _showSetPinDialog(BuildContext context, bool currentlyEnabled) {
    final pin1 = TextEditingController();
    final pin2 = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TradEtTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(currentlyEnabled ? 'Change / Remove PIN' : 'Set App Lock PIN',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter a 4-digit PIN to lock TradEt when backgrounded for 60+ seconds.',
                style: TextStyle(color: TradEtTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            TextField(
              controller: pin1,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'New PIN (4 digits)',
                  counterText: ''),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: pin2,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  counterText: ''),
            ),
          ],
        ),
        actions: [
          if (currentlyEnabled)
            TextButton(
              onPressed: () async {
                await AppLockService.clearPin();
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App lock disabled'),
                        backgroundColor: TradEtTheme.warning,
                        behavior: SnackBarBehavior.floating),
                  );
                }
              },
              child: const Text('Disable', style: TextStyle(color: TradEtTheme.negative)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: TradEtTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final p1 = pin1.text.trim();
              final p2 = pin2.text.trim();
              if (p1.length != 4 || !RegExp(r'^\d{4}$').hasMatch(p1)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN must be exactly 4 digits'),
                      backgroundColor: TradEtTheme.warning,
                      behavior: SnackBarBehavior.floating),
                );
                return;
              }
              if (p1 != p2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PINs do not match'),
                      backgroundColor: TradEtTheme.negative,
                      behavior: SnackBarBehavior.floating),
                );
                return;
              }
              await AppLockService.setPin(p1);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App lock PIN set'),
                      backgroundColor: TradEtTheme.positive,
                      behavior: SnackBarBehavior.floating),
                );
              }
            },
            child: const Text('Save PIN'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickProfileImage(BuildContext context, AppProvider provider) async {
    try {
      Uint8List? bytes;
      if (kIsWeb) {
        bytes = await pickImageFromWeb();
      } else {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 400,
          maxHeight: 400,
          imageQuality: 85,
        );
        if (picked != null) bytes = await picked.readAsBytes();
      }
      if (bytes != null) await provider.setProfileImage(bytes);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load image: $e'), backgroundColor: Colors.red),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Profile Photo', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
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
            const Text('Choose Avatar Color', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
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
                            width: 3,
                          ),
                        ),
                        child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                      ),
                      const SizedBox(height: 4),
                      Text(colorLabels[i], style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
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
                leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.redAccent)),
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

  Widget _logoutButton(BuildContext context, AppProvider provider) {
    return GestureDetector(
      onTap: () async {
        await provider.logout();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: TradEtTheme.negative.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: TradEtTheme.negative.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: TradEtTheme.negative, size: 20),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).logout,
                style: const TextStyle(
                    color: TradEtTheme.negative,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _kycStatusBadge(String status) {
    final isVerified = status == 'verified';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isVerified
            ? TradEtTheme.positive.withValues(alpha: 0.15)
            : TradEtTheme.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isVerified
              ? TradEtTheme.positive.withValues(alpha: 0.3)
              : TradEtTheme.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified_rounded : Icons.pending_rounded,
            size: 16,
            color: isVerified ? TradEtTheme.positive : TradEtTheme.warning,
          ),
          const SizedBox(width: 6),
          Text(
            isVerified ? 'KYC Verified' : 'KYC Pending',
            style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 13,
              color: isVerified ? TradEtTheme.positive : TradEtTheme.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _complianceItem(IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: TradEtTheme.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: TradEtTheme.textSecondary, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: TradEtTheme.textMuted)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: TradEtTheme.textMuted, size: 20),
      onTap: onTap,
    );
  }

  void _showKycDialog(BuildContext context) {
    final idNumberController = TextEditingController();
    String selectedIdType = 'national_id';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: TradEtTheme.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('KYC Verification', style: TextStyle(color: Colors.white)),
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
                decoration: InputDecoration(labelText: AppLocalizations.of(context).idType),
                items: [
                  DropdownMenuItem(
                      value: 'national_id', child: Text(AppLocalizations.of(context).nationalId)),
                  DropdownMenuItem(value: 'passport', child: Text(AppLocalizations.of(context).passport)),
                  DropdownMenuItem(
                      value: 'drivers_license',
                      child: Text(AppLocalizations.of(context).driversLicense)),
                  DropdownMenuItem(
                      value: 'kebele_id', child: Text(AppLocalizations.of(context).kebeleId)),
                ],
                onChanged: (v) =>
                    setDialogState(() => selectedIdType = v ?? 'national_id'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idNumberController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(labelText: AppLocalizations.of(context).idNumber),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: TradEtTheme.textSecondary)),
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
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Payment Methods Section ───
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
    // Wealth protection: require auth before adding a payment method
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
            // Bank name dropdown
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              // Header
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
                Text('**** ${method.accountNumber.length > 4 ? method.accountNumber.substring(method.accountNumber.length - 4) : method.accountNumber} • ${method.accountName}',
                    style: const TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
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

// ─── Security Log Section ───
class _SecurityLogSection extends StatefulWidget {
  const _SecurityLogSection();

  @override
  State<_SecurityLogSection> createState() => _SecurityLogSectionState();
}

class _SecurityLogSectionState extends State<_SecurityLogSection> {
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
          // ── Header ──
          GestureDetector(
            onTap: () => setState(() => _collapsed = !_collapsed),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Icon(Icons.security, size: 18, color: TradEtTheme.accent),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Security Log',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
                if (!_loading)
                  Text('${_entries.length} events',
                      style: const TextStyle(
                          color: TradEtTheme.textMuted, fontSize: 11)),
                const SizedBox(width: 4),
                if (!_collapsed)
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18,
                        color: TradEtTheme.textSecondary),
                    tooltip: 'Refresh',
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text('No security events recorded',
                      style: TextStyle(
                          color: TradEtTheme.textSecondary, fontSize: 13)),
                ),
              )
            // ── Wide: 2-column grid ──
            else if (wide)
              _buildGrid()
            // ── Mobile: compact timeline ──
            else
              _buildTimeline(),
          ],
        ],
      ),
    );
  }

  Widget _buildGrid() {
    // Pair entries into rows of 2
    final rows = <List<SecurityLogEntry>>[];
    for (var i = 0; i < _entries.length; i += 2) {
      rows.add([
        _entries[i],
        if (i + 1 < _entries.length) _entries[i + 1],
      ]);
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2)),
                Text(tsLabel,
                    style: const TextStyle(
                        color: TradEtTheme.textMuted, fontSize: 10)),
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
              // Timeline spine
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
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(e.event,
                            style: TextStyle(
                                color: color,
                                fontSize: 12,
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
