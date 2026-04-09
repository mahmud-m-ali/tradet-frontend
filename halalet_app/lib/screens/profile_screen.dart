import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/language_selector.dart';
import '../widgets/responsive_layout.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);

    return Container(
      decoration: BoxDecoration(gradient: HalalEtTheme.bgGradient),
      child: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, provider, _) {
            final user = provider.user;

            if (wide) {
              return WebContentWrapper(
                maxWidth: 1060,
                child: _buildWebLayout(context, provider, user),
              );
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
        const Text('መገለጫ • Account settings',
            style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
        const SizedBox(height: 24),

        // Hero user banner — full width
        _webUserBanner(user),
        const SizedBox(height: 24),

        // Three-column grid: Compliance | Settings | Security
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compliance
            Expanded(child: _webComplianceCard()),
            const SizedBox(width: 20),
            // Settings
            Expanded(child: _webSettingsCard(context, provider)),
            const SizedBox(width: 20),
            // Account actions
            Expanded(child: _webAccountCard(context, provider, user)),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: Text(
            'TradEt v1.0.0 by Amber — Sharia & Ethiopian Trade Compliant',
            style: TextStyle(fontSize: 11, color: HalalEtTheme.textMuted.withValues(alpha: 0.6)),
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
            color: HalalEtTheme.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(initial,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
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
            ? HalalEtTheme.positive.withValues(alpha: 0.2)
            : HalalEtTheme.warning.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isVerified
              ? HalalEtTheme.positive.withValues(alpha: 0.4)
              : HalalEtTheme.warning.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified_rounded : Icons.pending_rounded,
            size: 14,
            color: isVerified ? HalalEtTheme.positive : HalalEtTheme.warning,
          ),
          const SizedBox(width: 5),
          Text(
            isVerified ? 'KYC Verified' : 'KYC Pending',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11,
              color: isVerified ? HalalEtTheme.positive : HalalEtTheme.warning),
          ),
        ],
      ),
    );
  }

  Widget _webComplianceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: HalalEtTheme.positive.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.verified_user_rounded,
                    color: HalalEtTheme.positive, size: 18),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Compliance',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  Text('ቁጥጥር',
                      style: TextStyle(fontSize: 10, color: HalalEtTheme.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          _webComplianceItem(Icons.verified_rounded, 'Sharia (AAOIFI)',
              'Halal screened', HalalEtTheme.positive),
          _webComplianceItem(Icons.account_balance_rounded, 'ECX Regulated',
              'Ethiopian rules', const Color(0xFF60A5FA)),
          _webComplianceItem(Icons.security_rounded, 'NBE Supervised',
              'National Bank', const Color(0xFF818CF8)),
          _webComplianceItem(Icons.money_off_rounded, 'Riba-Free',
              'No interest', const Color(0xFF22D3EE)),
          _webComplianceItem(Icons.block_rounded, 'No Short Sell',
              'Spot trading only', HalalEtTheme.warning, isLast: true),
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
                    color: HalalEtTheme.textMuted)),
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
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: HalalEtTheme.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.settings_rounded,
                    color: HalalEtTheme.accent, size: 18),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preferences',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  Text('ምርጫዎች',
                      style: TextStyle(fontSize: 10, color: HalalEtTheme.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Theme toggle
          _webSettingRow(
            icon: provider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title: 'Theme / ገጽታ',
            subtitle: provider.isDarkMode ? 'Dark mode' : 'Light mode',
            color: const Color(0xFF818CF8),
            trailing: Switch(
              value: provider.isDarkMode,
              onChanged: (_) => provider.toggleTheme(),
              activeThumbColor: HalalEtTheme.positive,
            ),
          ),
          Divider(height: 24, color: HalalEtTheme.divider.withValues(alpha: 0.2)),
          // Language
          _webSettingRow(
            icon: Icons.language_rounded,
            title: AppLocalizations.of(context).language,
            subtitle: AppLocalizations.languageNames[provider.langCode] ?? 'English',
            color: const Color(0xFF60A5FA),
            trailing: const LanguageSelector(),
          ),
          Divider(height: 24, color: HalalEtTheme.divider.withValues(alpha: 0.2)),
          // Notifications
          _webSettingRow(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'ማሳወቂያ • Manage alerts',
            color: HalalEtTheme.accent,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: HalalEtTheme.textMuted, size: 20),
          ),
          Divider(height: 24, color: HalalEtTheme.divider.withValues(alpha: 0.2)),
          // Security
          _webSettingRow(
            icon: Icons.shield_outlined,
            title: 'Security',
            subtitle: 'ደህንነት • Password & 2FA',
            color: const Color(0xFF22D3EE),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: HalalEtTheme.textMuted, size: 20),
          ),
          Divider(height: 24, color: HalalEtTheme.divider.withValues(alpha: 0.2)),
          // Help
          _webSettingRow(
            icon: Icons.help_outline_rounded,
            title: 'Help',
            subtitle: 'እርዳታ • FAQ & Support',
            color: HalalEtTheme.positive,
            trailing: const Icon(Icons.chevron_right_rounded,
                color: HalalEtTheme.textMuted, size: 20),
            isLast: true,
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
  }) {
    return Row(
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
                  color: HalalEtTheme.textMuted)),
            ],
          ),
        ),
        trailing,
      ],
    );
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
                  HalalEtTheme.warning.withValues(alpha: 0.15),
                  HalalEtTheme.warning.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: HalalEtTheme.warning.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: HalalEtTheme.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.warning_amber_rounded,
                          color: HalalEtTheme.warning, size: 18),
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
                    style: TextStyle(fontSize: 12, color: HalalEtTheme.textSecondary)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showKycDialog(context),
                    icon: const Icon(Icons.verified_user_outlined, size: 16),
                    label: const Text('Verify Now', style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HalalEtTheme.warning,
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
            color: HalalEtTheme.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
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
                      Text('መለያ',
                          style: TextStyle(fontSize: 10, color: HalalEtTheme.textMuted)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _accountInfoRow('Full Name', user?.fullName ?? '--'),
              _accountInfoRow('Email', user?.email ?? '--'),
              _accountInfoRow('KYC Status',
                  user?.kycStatus?.toString().toUpperCase() ?? 'PENDING'),
              _accountInfoRow('Account Type', 'Retail Trader', isLast: true),
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
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: HalalEtTheme.negative.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: HalalEtTheme.negative.withValues(alpha: 0.2)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: HalalEtTheme.negative, size: 18),
                  SizedBox(width: 8),
                  Text('Logout / ውጣ',
                      style: TextStyle(color: HalalEtTheme.negative,
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
          Text(label, style: const TextStyle(fontSize: 12, color: HalalEtTheme.textMuted)),
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
        const Text('መገለጫ • Account settings',
            style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
        const SizedBox(height: 24),
        _userCard(user),
        const SizedBox(height: 16),
        if (user?.kycStatus != 'verified') ...[
          _kycWarning(context),
          const SizedBox(height: 16),
        ],
        _complianceCard(),
        const SizedBox(height: 16),
        _settingsCard(),
        const SizedBox(height: 16),
        const _PaymentMethodsSection(),
        const SizedBox(height: 16),
        _logoutButton(context, provider),
        const SizedBox(height: 24),
        const Center(
          child: Text('TradEt v1.0.0 — Sharia & Ethiopian Trade Compliant',
              style: TextStyle(fontSize: 11, color: HalalEtTheme.textMuted)),
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
        gradient: HalalEtTheme.heroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: HalalEtTheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            ),
            child: Center(
              child: Text(
                user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : '?',
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
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
        color: HalalEtTheme.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HalalEtTheme.warning.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: HalalEtTheme.warning, size: 22),
              const SizedBox(width: 8),
              const Text('KYC Verification Required',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
              'Complete KYC to start trading. Required by NBE and ECX regulations.',
              style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showKycDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: HalalEtTheme.warning,
                foregroundColor: Colors.black,
              ),
              child: const Text('Complete KYC / ማንነት ያረጋግጡ'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _complianceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HalalEtTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Compliance / ቁጥጥር',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 14),
          _complianceItem(Icons.verified_rounded, 'Sharia Compliant (AAOIFI)',
              'All assets screened for halal compliance', HalalEtTheme.positive),
          _complianceItem(Icons.account_balance_rounded, 'ECX Regulated',
              'Trading under Ethiopia Commodity Exchange rules', const Color(0xFF60A5FA)),
          _complianceItem(Icons.security_rounded, 'NBE Supervised',
              'National Bank of Ethiopia regulatory framework', const Color(0xFF818CF8)),
          _complianceItem(Icons.money_off_rounded, 'No Interest (Riba-Free)',
              'Flat commission fees only — no interest charges', const Color(0xFF22D3EE)),
          _complianceItem(Icons.block_rounded, 'No Short Selling',
              'Only sell assets you own — spot trading only', HalalEtTheme.warning),
        ],
      ),
    );
  }

  Widget _settingsCard() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            color: HalalEtTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  provider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: HalalEtTheme.accent, size: 22,
                ),
                title: const Text('Theme / ገጽታ',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text(provider.isDarkMode ? 'Dark mode' : 'Light mode',
                    style: const TextStyle(fontSize: 12, color: HalalEtTheme.textMuted)),
                trailing: Switch(
                  value: provider.isDarkMode,
                  onChanged: (_) => provider.toggleTheme(),
                  activeThumbColor: HalalEtTheme.positive,
                ),
              ),
              Divider(height: 1, color: HalalEtTheme.divider.withValues(alpha: 0.3)),
              ListTile(
                leading: const Icon(Icons.language_rounded, color: HalalEtTheme.accent, size: 22),
                title: Text(AppLocalizations.of(context).language,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text(AppLocalizations.languageNames[provider.langCode] ?? 'English',
                    style: const TextStyle(fontSize: 12, color: HalalEtTheme.textMuted)),
                trailing: const LanguageSelector(),
              ),
              Divider(height: 1, color: HalalEtTheme.divider.withValues(alpha: 0.3)),
              _settingsTile(
                  Icons.notifications_outlined, 'Notifications / ማሳወቂያ', 'Manage alerts', () {}),
              Divider(height: 1, color: HalalEtTheme.divider.withValues(alpha: 0.3)),
              _settingsTile(
                  Icons.shield_outlined, 'Security / ደህንነት', 'Password & 2FA', () {}),
              Divider(height: 1, color: HalalEtTheme.divider.withValues(alpha: 0.3)),
              _settingsTile(
                  Icons.help_outline_rounded, 'Help / እርዳታ', 'FAQ & Support', () {}),
            ],
          ),
        );
      },
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
          color: HalalEtTheme.negative.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: HalalEtTheme.negative.withValues(alpha: 0.25)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: HalalEtTheme.negative, size: 20),
            SizedBox(width: 8),
            Text('Logout / ውጣ',
                style: TextStyle(
                    color: HalalEtTheme.negative,
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
            ? HalalEtTheme.positive.withValues(alpha: 0.15)
            : HalalEtTheme.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isVerified
              ? HalalEtTheme.positive.withValues(alpha: 0.3)
              : HalalEtTheme.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified_rounded : Icons.pending_rounded,
            size: 16,
            color: isVerified ? HalalEtTheme.positive : HalalEtTheme.warning,
          ),
          const SizedBox(width: 6),
          Text(
            isVerified ? 'KYC Verified' : 'KYC Pending',
            style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 13,
              color: isVerified ? HalalEtTheme.positive : HalalEtTheme.warning,
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
                    style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted)),
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
          color: HalalEtTheme.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: HalalEtTheme.textSecondary, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: HalalEtTheme.textMuted)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: HalalEtTheme.textMuted, size: 20),
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
          backgroundColor: HalalEtTheme.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('KYC Verification', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('ማንነት ማረጋገጫ • Identity verification',
                  style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedIdType,
                dropdownColor: HalalEtTheme.cardBgLight,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(labelText: 'ID Type / የመታወቂያ አይነት'),
                items: const [
                  DropdownMenuItem(
                      value: 'national_id', child: Text('National ID / ብሔራዊ መታወቂያ')),
                  DropdownMenuItem(value: 'passport', child: Text('Passport / ፓስፖርት')),
                  DropdownMenuItem(
                      value: 'drivers_license',
                      child: Text('Driver\'s License / መንጃ ፈቃድ')),
                  DropdownMenuItem(
                      value: 'kebele_id', child: Text('Kebele ID / የቀበሌ መታወቂያ')),
                ],
                onChanged: (v) =>
                    setDialogState(() => selectedIdType = v ?? 'national_id'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idNumberController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'ID Number / መታወቂያ ቁጥር'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: HalalEtTheme.textSecondary)),
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
                            success ? HalalEtTheme.positive : HalalEtTheme.negative,
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

  void _showAddDialog() {
    String? selectedBank;
    final acctNumCtrl = TextEditingController();
    final acctNameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
        backgroundColor: HalalEtTheme.cardBg,
        title: const Text('Add Payment Method',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bank name dropdown
            Container(
              decoration: BoxDecoration(
                color: HalalEtTheme.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedBank,
                  isExpanded: true,
                  dropdownColor: HalalEtTheme.cardBg,
                  hint: const Row(
                    children: [
                      SizedBox(width: 12),
                      Icon(Icons.account_balance_outlined,
                          color: HalalEtTheme.textMuted, size: 18),
                      SizedBox(width: 10),
                      Text('Select Bank',
                          style: TextStyle(color: HalalEtTheme.textMuted, fontSize: 13)),
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
                style: TextStyle(color: HalalEtTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: HalalEtTheme.positive),
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
                  backgroundColor: HalalEtTheme.negative,
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
        hintStyle: const TextStyle(color: HalalEtTheme.textMuted, fontSize: 13),
        prefixIcon: Icon(icon, color: HalalEtTheme.textMuted, size: 18),
        filled: true,
        fillColor: HalalEtTheme.surfaceLight,
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
            color: HalalEtTheme.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
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
                      color: HalalEtTheme.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance_rounded,
                        color: HalalEtTheme.accent, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Methods',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Text('የባንክ ሒሳቦች • Linked accounts',
                            style: TextStyle(fontSize: 10, color: HalalEtTheme.textMuted)),
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
                          color: HalalEtTheme.positive.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: HalalEtTheme.positive.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: HalalEtTheme.positive, size: 14),
                            SizedBox(width: 4),
                            Text('Add',
                                style: TextStyle(color: HalalEtTheme.positive,
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
                    color: HalalEtTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: HalalEtTheme.textMuted, size: 16),
                      SizedBox(width: 10),
                      Text('No payment methods linked yet',
                          style: TextStyle(fontSize: 12, color: HalalEtTheme.textMuted)),
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
        color: HalalEtTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: method.isPrimary
            ? Border.all(color: HalalEtTheme.positive.withValues(alpha: 0.4))
            : Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: HalalEtTheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.account_balance_outlined,
                color: HalalEtTheme.primary, size: 18),
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
                          color: HalalEtTheme.positive.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Primary',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                                color: HalalEtTheme.positive)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text('${method.accountNumber} • ${method.accountName}',
                    style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted)),
              ],
            ),
          ),
          PopupMenuButton<String>(
            color: HalalEtTheme.cardBg,
            icon: const Icon(Icons.more_vert, color: HalalEtTheme.textMuted, size: 18),
            onSelected: (value) async {
              final provider = context.read<AppProvider>();
              if (value == 'primary') {
                await provider.setPrimaryPaymentMethod(method.id);
              } else if (value == 'delete') {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: HalalEtTheme.cardBg,
                    title: const Text('Remove Account',
                        style: TextStyle(color: Colors.white)),
                    content: Text('Remove ${method.bankName} ${method.accountNumber}?',
                        style: const TextStyle(color: HalalEtTheme.textSecondary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel',
                            style: TextStyle(color: HalalEtTheme.textMuted)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HalalEtTheme.negative),
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
                      Icon(Icons.star_outline, size: 16, color: HalalEtTheme.positive),
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
                    Icon(Icons.delete_outline, size: 16, color: HalalEtTheme.negative),
                    SizedBox(width: 8),
                    Text('Remove',
                        style: TextStyle(color: HalalEtTheme.negative, fontSize: 13)),
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
