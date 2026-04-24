import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Manages PIN storage and biometric/PIN authentication for the app lock.
class AppLockService {
  static const _storage = FlutterSecureStorage();
  static const _pinKey = 'tradet_app_lock_pin';
  static const _enabledKey = 'tradet_app_lock_enabled';

  static final _auth = LocalAuthentication();

  // ── PIN management ──────────────────────────────────────────────────

  static Future<bool> hasPin() async {
    final v = await _storage.read(key: _pinKey);
    return v != null && v.isNotEmpty;
  }

  static Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    await _storage.write(key: _enabledKey, value: 'true');
  }

  static Future<bool> verifyPin(String pin) async {
    final stored = await _storage.read(key: _pinKey);
    return stored == pin;
  }

  static Future<void> clearPin() async {
    await _storage.delete(key: _pinKey);
    await _storage.write(key: _enabledKey, value: 'false');
  }

  static Future<bool> isEnabled() async {
    if (kIsWeb) return false;
    final v = await _storage.read(key: _enabledKey);
    return v == 'true';
  }

  // ── Wealth Protection ───────────────────────────────────────────────

  static const _wealthProtectionKey = 'tradet_wealth_protection_enabled';
  static const _wealthAuthMethodKey = 'tradet_wealth_auth_method'; // 'biometric' | 'pin' | 'any'

  static Future<bool> isWealthProtectionEnabled() async {
    final v = await _storage.read(key: _wealthProtectionKey);
    return v == 'true';
  }

  static Future<void> setWealthProtectionEnabled(bool enabled) async {
    await _storage.write(key: _wealthProtectionKey, value: enabled ? 'true' : 'false');
  }

  /// Returns the preferred auth method: 'biometric', 'pin', or 'any' (default).
  static Future<String> getWealthAuthMethod() async {
    final v = await _storage.read(key: _wealthAuthMethodKey);
    return v ?? 'any';
  }

  static Future<void> setWealthAuthMethod(String method) async {
    await _storage.write(key: _wealthAuthMethodKey, value: method);
  }

  // ── Session & Lock Timeouts ─────────────────────────────────────────

  static const _sessionTimeoutKey = 'tradet_session_timeout_min'; // default 10
  static const _appLockDelayKey   = 'tradet_app_lock_delay_sec';  // default 60

  /// Session timeout in minutes. Allowed: 5, 10, 15. INSA max = 15.
  static Future<int> getSessionTimeoutMinutes() async {
    final v = await _storage.read(key: _sessionTimeoutKey);
    final parsed = int.tryParse(v ?? '');
    if (parsed != null && [5, 10, 15].contains(parsed)) return parsed;
    return 10;
  }

  static Future<void> setSessionTimeoutMinutes(int minutes) async {
    assert([5, 10, 15].contains(minutes));
    await _storage.write(key: _sessionTimeoutKey, value: minutes.toString());
  }

  /// App lock delay in seconds. Allowed: 30, 60, 120. INSA max = 60 for compliance.
  static Future<int> getAppLockDelaySecs() async {
    final v = await _storage.read(key: _appLockDelayKey);
    final parsed = int.tryParse(v ?? '');
    if (parsed != null && [30, 60, 120].contains(parsed)) return parsed;
    return 60;
  }

  static Future<void> setAppLockDelaySecs(int secs) async {
    assert([30, 60, 120].contains(secs));
    await _storage.write(key: _appLockDelayKey, value: secs.toString());
  }

  // ── Biometric ───────────────────────────────────────────────────────

  static Future<bool> isBiometricAvailable() async {
    if (kIsWeb) return false;
    try {
      final isDeviceSupported = await _auth.isDeviceSupported();
      if (!isDeviceSupported) return false;
      // canCheckBiometrics is true if biometrics are enrolled
      final canCheck = await _auth.canCheckBiometrics;
      return canCheck;
    } catch (_) {
      return false;
    }
  }

  /// Attempt biometric auth. Returns true on success.
  /// Uses biometricOnly: false so Android shows fingerprint/face dialog
  /// and falls back to device PIN/pattern if biometric fails.
  static Future<bool> authenticateWithBiometric() async {
    if (kIsWeb) return true;
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access TradEt',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
          sensitiveTransaction: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  /// Returns the list of available biometric types on the device.
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    if (kIsWeb) return [];
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }
}
