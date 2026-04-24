import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/app_lock_service.dart';
import '../theme.dart';

/// Withdrawals at or above this amount require authentication.
const double kWealthProtectionWithdrawalThreshold = 5000.0;

/// Challenge the user to authenticate for a sensitive financial action.
///
/// Auth is ALWAYS required for orders, payments, and withdrawals.
/// The Wealth Protection settings control which method (biometric/PIN/any);
/// they do NOT gate whether auth is required.
///
/// Returns true if the user successfully authenticates.
/// Returns false if:
///   - No auth method is configured (shows setup prompt)
///   - The user cancels or fails authentication
Future<bool> challengeTransactionAuth(
  BuildContext context, {
  String reason = 'Authenticate to continue',
}) async {
  final pinSet = await AppLockService.hasPin();
  final biometricAvailable =
      kIsWeb ? false : await AppLockService.isBiometricAvailable();

  // No auth method set up at all → prompt user to configure one
  if (!pinSet && !biometricAvailable) {
    if (!context.mounted) return false;
    _showNoAuthMethodDialog(context);
    return false;
  }

  // Preferred method from settings (biometric / pin / any)
  final method = await AppLockService.getWealthAuthMethod();

  // Biometric (mobile only)
  if (!kIsWeb && (method == 'biometric' || method == 'any') && biometricAvailable) {
    final success = await AppLockService.authenticateWithBiometric();
    if (success) return true;
    // biometric-only mode and it failed → deny
    if (method == 'biometric') return false;
    // 'any' mode → fall through to PIN
  }

  // PIN — works on both mobile and web
  if (!pinSet) {
    // Biometric was the only option and already failed above; or method == 'pin'
    // but no PIN is set. Prompt user to set one up.
    if (!context.mounted) return false;
    _showNoAuthMethodDialog(context);
    return false;
  }

  if (!context.mounted) return false;
  return _showPinChallengeDialog(context, reason: reason);
}

/// Shown when no auth method (PIN or biometrics) is configured.
void _showNoAuthMethodDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: TradEtTheme.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TradEtTheme.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lock_open_rounded,
                color: TradEtTheme.warning, size: 18),
          ),
          const SizedBox(width: 12),
          const Text('Security Required',
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      content: const Text(
        'A security PIN is required to authorize transactions.\n\n'
        'Go to Profile → Security → App Lock to set up your PIN.',
        style: TextStyle(color: TradEtTheme.textSecondary, fontSize: 13, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('OK',
              style: TextStyle(color: TradEtTheme.accent)),
        ),
      ],
    ),
  );
}

Future<bool> _showPinChallengeDialog(BuildContext context,
    {String reason = 'Authenticate to continue'}) async {
  final ctrl = TextEditingController();
  var attempts = 0;
  var authResult = false;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        Future<void> checkPin() async {
          final ok = await AppLockService.verifyPin(ctrl.text);
          if (ok) {
            authResult = true;
            if (ctx.mounted) Navigator.pop(ctx);
          } else {
            ctrl.clear();
            setState(() => attempts++);
            if (ctx.mounted && attempts >= 3) {
              Navigator.pop(ctx);
            }
          }
        }

        return AlertDialog(
          backgroundColor: TradEtTheme.cardBg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TradEtTheme.positive.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_rounded,
                    color: TradEtTheme.positive, size: 18),
              ),
              const SizedBox(width: 12),
              const Text('Enter PIN',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(reason,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: TradEtTheme.textSecondary,
                      fontSize: 13,
                      height: 1.4)),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                autofocus: true,
                style: const TextStyle(
                    color: Colors.white, letterSpacing: 12, fontSize: 22),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '• • • •',
                  hintStyle:
                      TextStyle(color: TradEtTheme.textMuted, letterSpacing: 8),
                ),
                onChanged: (v) {
                  if (v.length == 4) checkPin();
                },
              ),
              if (attempts > 0 && attempts < 3) ...[
                const SizedBox(height: 10),
                Text(
                  '${3 - attempts} attempt(s) remaining',
                  style: const TextStyle(
                      color: TradEtTheme.negative, fontSize: 11),
                ),
              ],
              if (attempts >= 3) ...[
                const SizedBox(height: 10),
                const Text(
                  'Too many failed attempts',
                  style: TextStyle(color: TradEtTheme.negative, fontSize: 11),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: TradEtTheme.textSecondary)),
            ),
          ],
        );
      },
    ),
  );

  ctrl.dispose();
  return authResult;
}
