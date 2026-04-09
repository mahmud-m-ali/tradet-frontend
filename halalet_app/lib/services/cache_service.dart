import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple local cache for offline support.
/// Stores JSON data with TTL (time-to-live) in SharedPreferences.
class CacheService {
  static const Duration defaultTtl = Duration(minutes: 30);

  static Future<void> set(String key, dynamic data, {Duration? ttl}) async {
    final prefs = await SharedPreferences.getInstance();
    final entry = {
      'data': data,
      'cached_at': DateTime.now().toIso8601String(),
      'expires_at': DateTime.now().add(ttl ?? defaultTtl).toIso8601String(),
    };
    await prefs.setString('cache_$key', jsonEncode(entry));
  }

  static Future<dynamic> get(String key, {bool ignoreExpiry = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cache_$key');
    if (raw == null) return null;

    try {
      final entry = jsonDecode(raw);
      if (!ignoreExpiry) {
        final expires = DateTime.parse(entry['expires_at']);
        if (DateTime.now().isAfter(expires)) return null;
      }
      return entry['data'];
    } catch (_) {
      return null;
    }
  }

  /// Get cached data even if expired (for offline fallback)
  static Future<dynamic> getStale(String key) async {
    return get(key, ignoreExpiry: true);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cache_$key');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('cache_'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
