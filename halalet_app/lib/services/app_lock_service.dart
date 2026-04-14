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

  // ── Biometric ───────────────────────────────────────────────────────

  static Future<bool> isBiometricAvailable() async {
    if (kIsWeb) return false;
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } catch (_) {
      return false;
    }
  }

  /// Attempt biometric auth. Returns true on success.
  static Future<bool> authenticateWithBiometric() async {
    if (kIsWeb) return true;
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access TradEt',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
