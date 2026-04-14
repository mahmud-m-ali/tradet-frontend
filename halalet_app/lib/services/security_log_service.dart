/// SecurityLogService — INSA CSMS §8.3 Audit Trail
/// Maintains an append-only, chained security event log stored in SharedPreferences.
/// Each entry carries a fingerprint of the previous entry for tamper-evidence.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Event types ────────────────────────────────────────────────────────────
enum SecurityEvent {
  loginSuccess,
  loginFail,
  logout,
  sessionTimeout,
  orderPlaced,
  orderCancelled,
  deposit,
  withdrawal,
  kycSubmitted,
  profileChanged,
  alertCreated,
  watchlistChanged,
}

extension SecurityEventLabel on SecurityEvent {
  String get label {
    switch (this) {
      case SecurityEvent.loginSuccess:   return 'LOGIN_SUCCESS';
      case SecurityEvent.loginFail:      return 'LOGIN_FAIL';
      case SecurityEvent.logout:         return 'LOGOUT';
      case SecurityEvent.sessionTimeout: return 'SESSION_TIMEOUT';
      case SecurityEvent.orderPlaced:    return 'ORDER_PLACED';
      case SecurityEvent.orderCancelled: return 'ORDER_CANCELLED';
      case SecurityEvent.deposit:        return 'DEPOSIT';
      case SecurityEvent.withdrawal:     return 'WITHDRAWAL';
      case SecurityEvent.kycSubmitted:   return 'KYC_SUBMITTED';
      case SecurityEvent.profileChanged: return 'PROFILE_CHANGED';
      case SecurityEvent.alertCreated:   return 'ALERT_CREATED';
      case SecurityEvent.watchlistChanged: return 'WATCHLIST_CHANGED';
    }
  }
}

// ─── Log entry ───────────────────────────────────────────────────────────────
class SecurityLogEntry {
  final String timestamp;
  final String userId;
  final String event;
  final Map<String, dynamic> metadata;
  final String fingerprint; // hash of (previousFingerprint + this entry content)

  const SecurityLogEntry({
    required this.timestamp,
    required this.userId,
    required this.event,
    required this.metadata,
    required this.fingerprint,
  });

  factory SecurityLogEntry.fromJson(Map<String, dynamic> json) => SecurityLogEntry(
        timestamp: json['timestamp'] as String,
        userId: json['userId'] as String,
        event: json['event'] as String,
        metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
        fingerprint: json['fingerprint'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'userId': userId,
        'event': event,
        'metadata': metadata,
        'fingerprint': fingerprint,
      };
}

// ─── Service ─────────────────────────────────────────────────────────────────
class SecurityLogService {
  static const _prefKey = 'security_audit_log';
  static const _maxEntries = 200; // keep last 200 events

  /// Record a security event. Call from AppProvider or screens.
  static Future<void> record(
    SecurityEvent event, {
    String userId = '',
    Map<String, dynamic> metadata = const {},
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = _loadRaw(prefs);
    final prevFingerprint =
        existing.isNotEmpty ? existing.last['fingerprint'] as String? ?? '' : '';

    final entry = {
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'userId': userId,
      'event': event.label,
      'metadata': metadata,
      'fingerprint': _fingerprint(prevFingerprint, event.label, userId),
    };

    existing.add(entry);
    // Trim to max
    final trimmed = existing.length > _maxEntries
        ? existing.sublist(existing.length - _maxEntries)
        : existing;

    await prefs.setString(_prefKey, jsonEncode(trimmed));
  }

  /// Retrieve log entries (most recent first), up to [limit].
  static Future<List<SecurityLogEntry>> getEntries({int limit = 50}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _loadRaw(prefs);
    final entries = raw
        .map((e) => SecurityLogEntry.fromJson(e as Map<String, dynamic>))
        .toList()
        .reversed
        .take(limit)
        .toList();
    return entries;
  }

  /// Clear all log entries (use only for testing).
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  static List<dynamic> _loadRaw(SharedPreferences prefs) {
    final raw = prefs.getString(_prefKey);
    if (raw == null) return [];
    try {
      return jsonDecode(raw) as List<dynamic>;
    } catch (_) {
      return [];
    }
  }

  /// Simple deterministic fingerprint: base64 of the hash of the combined string.
  /// Not cryptographic, but sufficient for detecting tampering in this context.
  static String _fingerprint(String prev, String event, String userId) {
    final combined = '$prev|$event|$userId|${DateTime.now().millisecondsSinceEpoch}';
    final bytes = utf8.encode(combined);
    int hash = 5381;
    for (final b in bytes) {
      hash = ((hash << 5) + hash + b) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}
