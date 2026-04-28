import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/app_lock_service.dart';
import '../theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/security_log_section.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _loading = true;
  bool _wealthProtectionEnabled = false;
  String _authMethod = 'any'; // 'biometric' | 'pin' | 'any'
  bool _biometricAvailable = false;
  bool _pinSet = false;
  int _sessionTimeoutMins = 10;
  int _appLockDelaySecs = 60;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await AppLockService.isWealthProtectionEnabled();
    final method = await AppLockService.getWealthAuthMethod();
    final biometric = await AppLockService.isBiometricAvailable();
    final pin = await AppLockService.hasPin();
    final sessionMins = await AppLockService.getSessionTimeoutMinutes();
    final lockSecs = await AppLockService.getAppLockDelaySecs();
    if (mounted) {
      setState(() {
        _wealthProtectionEnabled = enabled;
        _authMethod = method;
        _biometricAvailable = biometric;
        _pinSet = pin;
        _sessionTimeoutMins = sessionMins;
        _appLockDelaySecs = lockSecs;
        _loading = false;
      });
    }
  }

  Future<void> _toggleWealthProtection(bool enabled) async {
    // If enabling, ensure at least one auth method is available
    if (enabled && !_pinSet && !_biometricAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Set a PIN or enable biometrics first before activating wealth protection.'),
          backgroundColor: TradEtTheme.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await AppLockService.setWealthProtectionEnabled(enabled);
    if (mounted) setState(() => _wealthProtectionEnabled = enabled);
  }

  Future<void> _setAuthMethod(String method) async {
    await AppLockService.setWealthAuthMethod(method);
    if (mounted) setState(() => _authMethod = method);
  }

  // ─── Build ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: TradEtTheme.positive, strokeWidth: 2))
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                        children: [
                          // ── Wealth Protection ──────────────────────────
                          _wealthProtectionCard(),
                          const SizedBox(height: 16),

                          // ── Auth Method (only when wealth protection on) ─
                          if (_wealthProtectionEnabled) ...[
                            _authMethodCard(),
                            const SizedBox(height: 16),
                          ],

                          // ── Sign-in & Passcode ─────────────────────────
                          _passcodeCard(),
                          const SizedBox(height: 16),

                          // ── Session Protection (info) ──────────────────
                          _sessionInfoCard(),
                          const SizedBox(height: 16),

                          // ── Compliance note ────────────────────────────
                          _complianceNote(),
                          const SizedBox(height: 16),

                          // ── Security Audit Log ─────────────────────────
                          const SecurityLogSection(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
      child: Row(
        children: [
          if (!isWideScreen(context))
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          if (!isWideScreen(context))
            const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF22D3EE).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shield_rounded,
                color: Color(0xFF22D3EE), size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.security,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              Text(l.protectYourAccount,
                  style: const TextStyle(
                      fontSize: 11, color: TradEtTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Wealth Protection card ───────────────────────────────────────────

  Widget _wealthProtectionCard() {
    final l = AppLocalizations.of(context);
    final statusColor =
        _wealthProtectionEnabled ? TradEtTheme.positive : TradEtTheme.textMuted;
    final statusLabel = _wealthProtectionEnabled ? l.wealthProtectionActive : l.wealthProtectionInactive;
    final methodLabel = _wealthProtectionEnabled
        ? _methodLabel(_authMethod, _biometricAvailable, l)
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _wealthProtectionEnabled
              ? TradEtTheme.positive.withValues(alpha: 0.35)
              : TradEtTheme.divider.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (_wealthProtectionEnabled
                          ? TradEtTheme.positive
                          : TradEtTheme.textMuted)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.fingerprint_rounded,
                    color: _wealthProtectionEnabled
                        ? TradEtTheme.positive
                        : TradEtTheme.textMuted,
                    size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.wealthProtection,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(statusLabel,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor)),
                        ),
                        if (methodLabel != null) ...[
                          const SizedBox(width: 6),
                          Text('· $methodLabel',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: TradEtTheme.textSecondary)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Switch(
                value: _wealthProtectionEnabled,
                onChanged: _toggleWealthProtection,
                activeTrackColor: TradEtTheme.positive,
                activeThumbColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
          const SizedBox(height: 14),
          // What it protects
          Text(l.requiresAuthFor,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: TradEtTheme.textSecondary)),
          const SizedBox(height: 10),
          _protectionItem(Icons.swap_horiz_rounded, l.buySellOrders, l.everyOrderPlacement),
          _protectionItem(Icons.arrow_upward_rounded, l.withdrawalsOver, l.largeTransfersToBank),
          _protectionItem(Icons.account_balance_outlined, l.addingPaymentMethods, l.linkingNewBankAccounts),
          if (kIsWeb) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TradEtTheme.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: TradEtTheme.warning.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 14, color: TradEtTheme.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l.biometricWebNote,
                      style: const TextStyle(
                          fontSize: 11, color: TradEtTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _protectionItem(IconData icon, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TradEtTheme.positive.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: TradEtTheme.positive),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                Text(sub,
                    style: const TextStyle(
                        fontSize: 10, color: TradEtTheme.textMuted)),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded,
              size: 14,
              color: _wealthProtectionEnabled
                  ? TradEtTheme.positive
                  : TradEtTheme.divider),
        ],
      ),
    );
  }

  // ─── Auth method card ────────────────────────────────────────────────

  Widget _authMethodCard() {
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
                  color: const Color(0xFF818CF8).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: Color(0xFF818CF8), size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).authMethod,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  Text(AppLocalizations.of(context).howToVerifyIdentity,
                      style:
                          const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _authMethodTile(
            method: 'any',
            icon: Icons.security_rounded,
            title: 'Any Available',
            subtitle: 'Biometrics first, then PIN',
            color: TradEtTheme.positive,
          ),
          const SizedBox(height: 8),
          _authMethodTile(
            method: 'biometric',
            icon: Icons.fingerprint_rounded,
            title: 'Biometrics Only',
            subtitle: _biometricAvailable
                ? 'Fingerprint or Face ID'
                : 'Not available on this device',
            color: const Color(0xFF60A5FA),
            disabled: !_biometricAvailable,
          ),
          const SizedBox(height: 8),
          _authMethodTile(
            method: 'pin',
            icon: Icons.pin_rounded,
            title: 'PIN Only',
            subtitle: _pinSet ? '4-digit security PIN' : 'No PIN set — set one below',
            color: const Color(0xFF818CF8),
            disabled: !_pinSet,
          ),
        ],
      ),
    );
  }

  Widget _authMethodTile({
    required String method,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool disabled = false,
  }) {
    final selected = _authMethod == method;
    return GestureDetector(
      onTap: disabled ? null : () => _setAuthMethod(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.12)
              : TradEtTheme.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: 0.5)
                : TradEtTheme.divider.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (disabled ? TradEtTheme.textMuted : color)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: disabled ? TradEtTheme.textMuted : color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: disabled ? TradEtTheme.textMuted : Colors.white)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 10, color: TradEtTheme.textMuted)),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.radio_button_checked_rounded,
                  color: color, size: 20)
            else
              Icon(Icons.radio_button_off_rounded,
                  color: disabled
                      ? TradEtTheme.divider
                      : TradEtTheme.textMuted,
                  size: 20),
          ],
        ),
      ),
    );
  }

  // ─── Passcode card ───────────────────────────────────────────────────

  Widget _passcodeCard() {
    return Container(
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // PIN row
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TradEtTheme.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _pinSet ? Icons.lock_rounded : Icons.lock_open_rounded,
                color: _pinSet ? TradEtTheme.positive : TradEtTheme.accent,
                size: 18,
              ),
            ),
            title: Text(AppLocalizations.of(context).appLock,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            subtitle: Text(
              _pinSet
                  ? 'PIN set · tap to change or remove'
                  : 'No PIN — tap to set one',
              style: const TextStyle(
                  fontSize: 11, color: TradEtTheme.textMuted),
            ),
            trailing: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (_pinSet ? TradEtTheme.positive : TradEtTheme.accent)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _pinSet ? 'Change' : 'Set PIN',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _pinSet
                        ? TradEtTheme.positive
                        : TradEtTheme.accent),
              ),
            ),
            onTap: () => _showSetPinDialog(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 11, color: TradEtTheme.textMuted),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'PIN is stored on this device only. Set a PIN on each device you use.',
                    style: TextStyle(fontSize: 10, color: TradEtTheme.textMuted),
                  ),
                ),
              ],
            ),
          ),
          Divider(
              height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
          // Biometrics row
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF60A5FA).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.fingerprint_rounded,
                  color: Color(0xFF60A5FA), size: 18),
            ),
            title: Text(AppLocalizations.of(context).biometrics,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            subtitle: Text(
              kIsWeb
                  ? 'Available on mobile only'
                  : _biometricAvailable
                      ? 'Fingerprint / Face ID enrolled'
                      : 'Go to Android Settings → Security → Fingerprint',
              style: const TextStyle(
                  fontSize: 11, color: TradEtTheme.textMuted),
            ),
            trailing: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (_biometricAvailable && !kIsWeb
                        ? TradEtTheme.positive
                        : TradEtTheme.textMuted)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                kIsWeb
                    ? 'Web'
                    : _biometricAvailable
                        ? 'Verify'
                        : 'Set up',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: (_biometricAvailable && !kIsWeb
                        ? TradEtTheme.positive
                        : TradEtTheme.accent)),
              ),
            ),
            onTap: kIsWeb ? null : () => _handleBiometricTap(),
          ),
        ],
      ),
    );
  }

  // ─── Session protection card (configurable) ─────────────────────────

  Widget _sessionInfoCard() {
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
                  color: const Color(0xFF22D3EE).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.timer_outlined,
                    color: Color(0xFF22D3EE), size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).sessionProtection,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  Text(AppLocalizations.of(context).configWithinInsa,
                      style: const TextStyle(
                          fontSize: 10, color: TradEtTheme.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Session Timeout
          _timeoutSection(
            icon: Icons.hourglass_top_rounded,
            color: const Color(0xFF22D3EE),
            label: 'Session Timeout',
            sublabel: 'Auto-logout after inactivity',
            options: const [5, 10, 15],
            labels: const ['5 min', '10 min', '15 min'],
            selected: _sessionTimeoutMins,
            onSelect: (v) async {
              await AppLockService.setSessionTimeoutMinutes(v);
              if (mounted) setState(() => _sessionTimeoutMins = v);
            },
          ),
          const SizedBox(height: 18),

          // App Lock Delay
          _timeoutSection(
            icon: Icons.screen_lock_portrait_rounded,
            color: TradEtTheme.accent,
            label: 'App Lock Delay',
            sublabel: 'Lock screen after backgrounding',
            options: const [30, 60, 120],
            labels: const ['30 sec', '1 min', '2 min'],
            selected: _appLockDelaySecs,
            onSelect: (v) async {
              await AppLockService.setAppLockDelaySecs(v);
              if (mounted) setState(() => _appLockDelaySecs = v);
            },
          ),
          const SizedBox(height: 18),

          Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
          const SizedBox(height: 16),

          // Account lockout — INSA mandated, read-only
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: TradEtTheme.negative.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.block_rounded,
                    size: 15, color: TradEtTheme.negative),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).accountLockout,
                        style: const TextStyle(
                            fontSize: 12, color: TradEtTheme.textSecondary)),
                    const Text('5 failed attempts → 15 min block',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: TradEtTheme.negative.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: TradEtTheme.negative.withValues(alpha: 0.25)),
                ),
                child: Text(AppLocalizations.of(context).insaMandated,
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: TradEtTheme.negative)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeoutSection({
    required IconData icon,
    required Color color,
    required String label,
    required String sublabel,
    required List<int> options,
    required List<String> labels,
    required int selected,
    required Future<void> Function(int) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 15, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Text(sublabel,
                    style: const TextStyle(
                        fontSize: 10, color: TradEtTheme.textMuted)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: List.generate(options.length, (i) {
            final isSelected = options[i] == selected;
            return GestureDetector(
              onTap: () => onSelect(options[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : TradEtTheme.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.5)
                        : TradEtTheme.divider.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? color : TradEtTheme.textSecondary,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ─── Compliance note ─────────────────────────────────────────────────

  Widget _complianceNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TradEtTheme.positive.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: TradEtTheme.positive.withValues(alpha: 0.15)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined,
              size: 14, color: TradEtTheme.positive),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Security controls meet INSA CSMS Advanced (91–100) target maturity. '
              'All authentication events are recorded in the tamper-evident Security Log.',
              style: TextStyle(
                  fontSize: 11,
                  color: TradEtTheme.textSecondary,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────

  Future<void> _handleBiometricTap() async {
    final l = AppLocalizations.of(context);
    if (!_biometricAvailable) {
      // Guide to Android settings
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.biometricEnrollPrompt),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }
    // Test biometric auth
    final success = await AppLockService.authenticateWithBiometric();
    if (!mounted) return;
    final l2 = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l2.biometricSuccess : l2.biometricFailed),
        backgroundColor: success ? TradEtTheme.positive : TradEtTheme.negative,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _methodLabel(String method, bool biometricAvailable, AppLocalizations l) {
    switch (method) {
      case 'biometric':
        return biometricAvailable ? l.withBiometrics : l.biometricsUnavailable;
      case 'pin':
        return l.withPin;
      default:
        return biometricAvailable ? l.withBiometrics : l.withPin;
    }
  }

  void _showSetPinDialog() {
    final l = AppLocalizations.of(context);
    final pin1 = TextEditingController();
    final pin2 = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TradEtTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(_pinSet ? l.changePinTitle : l.setPinTitle,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Enter a 4-digit PIN. Used to confirm orders, withdrawals, and payment changes.',
                style: TextStyle(
                    color: TradEtTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            TextField(
              controller: pin1,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: l.newPinHint, counterText: ''),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: pin2,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: l.confirmPinHint, counterText: ''),
            ),
          ],
        ),
        actions: [
          if (_pinSet)
            TextButton(
              onPressed: () async {
                await AppLockService.clearPin();
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  setState(() => _pinSet = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l.pinRemoved),
                    backgroundColor: TradEtTheme.warning,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
              child: Text(l.removePinButton,
                  style: const TextStyle(color: TradEtTheme.negative)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel,
                style: const TextStyle(color: TradEtTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final p1 = pin1.text.trim();
              final p2 = pin2.text.trim();
              if (p1.length != 4 || !RegExp(r'^\d{4}$').hasMatch(p1)) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(l.pinInvalid),
                  backgroundColor: TradEtTheme.warning,
                  behavior: SnackBarBehavior.floating,
                ));
                return;
              }
              if (p1 != p2) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(l.pinsDoNotMatch),
                  backgroundColor: TradEtTheme.negative,
                  behavior: SnackBarBehavior.floating,
                ));
                return;
              }
              await AppLockService.setPin(p1);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                setState(() => _pinSet = true);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(l.pinSet),
                  backgroundColor: TradEtTheme.positive,
                  behavior: SnackBarBehavior.floating,
                ));
              }
            },
            child: Text(l.savePin),
          ),
        ],
      ),
    );
  }
}
