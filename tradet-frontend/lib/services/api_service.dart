/// HTTP client for all TradEt backend endpoints — auth, market, trading, wallet, and more.
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'cache_service.dart';

/// Typed exception carrying both a developer message and an optional user-facing string.
class ApiException implements Exception {
  final String message;
  final String? userMessage;
  final int? statusCode;

  ApiException(this.message, {this.userMessage, this.statusCode});

  String get displayMessage => userMessage ?? message;

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// Maps low-level network errors to human-readable strings shown in the UI.
String _friendlyError(dynamic error) {
  if (error is SocketException) {
    return 'No internet connection. Please check your network.';
  }
  if (error is HttpException) {
    return 'Server is not reachable. Please try again later.';
  }
  if (error.toString().contains('TimeoutException')) {
    return 'Server is taking too long to respond. Please try again.';
  }
  if (error.toString().contains('SocketException') ||
      error.toString().contains('Connection refused')) {
    return 'Cannot connect to server. Please check your connection.';
  }
  return 'Something went wrong. Please try again.';
}

/// Stateless HTTP service that handles auth tokens, caching, and error mapping
/// for every TradEt API call.
class ApiService {
  // Default fallback URLs
  /// Production API base URL (tradet.amber.et backend).
  static const String _defaultTunnelUrl =
      'https://tradet.amber.et/api';
  // ignore: unused_field
  static const String _localUrl = 'http://localhost:8000/api';

  // Cached custom URL from SharedPreferences
  static String? _customBaseUrl;

  /// Returns the active API base URL — custom override or the production default.
  static String get baseUrl {
    if (_customBaseUrl != null) return _customBaseUrl!;
    return _defaultTunnelUrl;
  }

  static const Duration _timeout = Duration(seconds: 15);

  /// Load saved server URL from SharedPreferences
  static Future<void> loadServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    _customBaseUrl = prefs.getString('server_url');
  }

  /// Save a custom server URL
  static Future<void> setServerUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    url = url.trimRight();
    if (url.endsWith('/')) url = url.substring(0, url.length - 1);
    if (!url.endsWith('/api')) url = '$url/api';
    _customBaseUrl = url;
    await prefs.setString('server_url', url);
  }

  /// Returns the server URL without the `/api` suffix for display in settings.
  static String get currentServerDisplay {
    final url = _customBaseUrl ?? _defaultTunnelUrl;
    if (url.endsWith('/api')) return url.substring(0, url.length - 4);
    return url;
  }

  String? _token;

  Future<Map<String, String>> get _headers async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<void> _saveToken(String token, {String? refreshToken}) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    if (refreshToken != null) {
      await prefs.setString('refresh_token', refreshToken);
    }
  }

  /// Removes both access and refresh tokens from storage (called on logout).
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
  }

  Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }

  /// Attempt to refresh the access token using the stored refresh token
  Future<bool> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) return false;

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/refresh'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $refreshToken',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Helper: make GET request with optional caching
  Future<http.Response> _get(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      return await http
          .get(Uri.parse('$baseUrl$path'), headers: headers ?? await _headers)
          .timeout(_timeout);
    } catch (e) {
      throw ApiException(_friendlyError(e), userMessage: _friendlyError(e));
    }
  }

  /// Helper: make POST request
  Future<http.Response> _post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      return await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: headers ?? await _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
    } catch (e) {
      throw ApiException(_friendlyError(e), userMessage: _friendlyError(e));
    }
  }

  /// Helper: make PUT request
  Future<http.Response> _put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      return await http
          .put(
            Uri.parse('$baseUrl$path'),
            headers: await _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
    } catch (e) {
      throw ApiException(_friendlyError(e), userMessage: _friendlyError(e));
    }
  }

  /// Helper: make DELETE request
  Future<http.Response> _delete(String path) async {
    try {
      return await http
          .delete(Uri.parse('$baseUrl$path'), headers: await _headers)
          .timeout(_timeout);
    } catch (e) {
      throw ApiException(_friendlyError(e), userMessage: _friendlyError(e));
    }
  }

  /// Throws an [ApiException] for common HTTP error codes (401, 429, 5xx).
  void _checkResponse(http.Response response, String context) {
    if (response.statusCode == 401) {
      // Token refresh is handled by the provider layer
      throw ApiException(
        'Session expired',
        userMessage: 'Session expired. Please log in again.',
        statusCode: 401,
      );
    }
    if (response.statusCode == 429) {
      throw ApiException(
        'Rate limited',
        userMessage: 'Too many requests. Please wait a moment.',
        statusCode: 429,
      );
    }
    if (response.statusCode >= 500) {
      throw ApiException(
        'Server error',
        userMessage: 'Server error. Please try again later.',
        statusCode: response.statusCode,
      );
    }
  }

  // === AUTH ===

  /// Registers a new user and persists the returned JWT on success.
  Future<Map<String, dynamic>> register({
    required String email,
    required String phone,
    required String password,
    required String fullName,
    String accountType = 'individual',
  }) async {
    final response = await _post(
      '/auth/register',
      body: {
        'email': email,
        'phone': phone,
        'password': password,
        'full_name': fullName,
        'account_type': accountType,
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      await _saveToken(data['token'], refreshToken: data['refresh_token']);
    }
    return data;
  }

  /// Authenticates with email/password and persists the returned JWT.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await _saveToken(data['token'], refreshToken: data['refresh_token']);
    }
    return data;
  }

  /// Submits KYC identity data; returns the server response map.
  Future<Map<String, dynamic>> submitKyc({
    required String idType,
    required String idNumber,
    String? tradeLicenseNumber,
  }) async {
    final response = await _post(
      '/auth/kyc',
      body: {
        'id_type': idType,
        'id_number': idNumber,
        if (tradeLicenseNumber != null)
          'trade_license_number': tradeLicenseNumber,
      },
    );
    return jsonDecode(response.body);
  }

  Future<User> getProfile() async {
    final response = await _get('/auth/profile');
    if (response.statusCode != 200)
      throw ApiException('Failed to load profile');
    final data = jsonDecode(response.body);
    await CacheService.set('profile', data, ttl: const Duration(minutes: 10));
    return User.fromJson(data);
  }

  /// Updates the user's profile fields. Returns the updated User on success.
  /// Gracefully handles backends that don't yet support all fields.
  Future<User> updateProfile(Map<String, dynamic> fields) async {
    // Remove null values before sending
    fields.removeWhere((_, v) => v == null || (v is String && v.isEmpty));
    final response = await _put('/auth/profile', body: fields);
    if (response.statusCode == 200 || response.statusCode == 204) {
      // Refetch the profile to get the server-confirmed values
      return getProfile();
    }
    throw ApiException('Failed to update profile (${response.statusCode})');
  }

  /// Saves user preferences to the server (avatar_color, profile_image).
  /// Silently returns false if the backend doesn't support this endpoint.
  Future<bool> savePreferences(Map<String, dynamic> prefs) async {
    try {
      final response = await _put('/auth/preferences', body: prefs);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  /// Loads user preferences from the server.
  /// Returns null if the backend doesn't support this endpoint.
  Future<Map<String, dynamic>?> loadPreferences() async {
    try {
      final response = await _get('/auth/preferences');
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  // === MARKET ===

  /// Fetches the live asset list; falls back to stale cache if the request fails.
  Future<List<Asset>> getAssets({
    int? categoryId,
    bool shariaOnly = false,
    bool ecxOnly = false,
    bool refresh = false,
  }) async {
    final params = <String, String>{};
    if (categoryId != null) params['category_id'] = categoryId.toString();
    if (shariaOnly) params['sharia_only'] = 'true';
    if (ecxOnly) params['ecx_only'] = 'true';
    if (refresh) params['refresh'] = 'true';

    var path = '/market/assets';
    if (params.isNotEmpty) {
      path = Uri.parse(path).replace(queryParameters: params).toString();
    }

    try {
      final response = await _get(path);
      if (response.statusCode != 200)
        throw ApiException('Failed to load assets');
      final List<dynamic> data = jsonDecode(response.body);
      // Cache for offline use
      await CacheService.set('assets', data, ttl: const Duration(minutes: 5));
      return data.map((j) => Asset.fromJson(j)).toList();
    } catch (e) {
      // Try cached data on failure
      final cached = await CacheService.getStale('assets');
      if (cached != null) {
        return (cached as List).map((j) => Asset.fromJson(j)).toList();
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAssetDetail(int assetId) async {
    final response = await _get('/market/assets/$assetId');
    _checkResponse(response, 'asset detail');
    if (response.statusCode != 200) throw ApiException('Failed to load asset');
    return jsonDecode(response.body);
  }

  // === TRADING ===

  /// Submits a buy or sell order to the trading engine.
  Future<Map<String, dynamic>> placeOrder({
    required int assetId,
    required String orderType,
    required double quantity,
    required double price,
    String executionType = 'market',
  }) async {
    final response = await _post(
      '/trading/orders',
      body: {
        'asset_id': assetId,
        'order_type': orderType,
        'quantity': quantity,
        'price': price,
        'execution_type': executionType,
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> cancelOrder(int orderId) async {
    final response = await _post('/trading/orders/$orderId/cancel');
    return jsonDecode(response.body);
  }

  Future<List<OrderEvent>> getOrderEvents() async {
    final response = await _get('/trading/order-events');
    if (response.statusCode != 200)
      throw ApiException('Failed to load order events');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((j) => OrderEvent.fromJson(j)).toList();
  }

  Future<List<Order>> getOrders({String? status}) async {
    final path = status != null
        ? '/trading/orders?status=$status'
        : '/trading/orders';
    try {
      final response = await _get(path);
      if (response.statusCode != 200)
        throw ApiException('Failed to load orders');
      final List<dynamic> data = jsonDecode(response.body);
      await CacheService.set('orders', data, ttl: const Duration(minutes: 5));
      return data.map((j) => Order.fromJson(j)).toList();
    } catch (e) {
      final cached = await CacheService.getStale('orders');
      if (cached != null) {
        return (cached as List).map((j) => Order.fromJson(j)).toList();
      }
      rethrow;
    }
  }

  // === PORTFOLIO ===

  Future<Map<String, dynamic>> getPortfolio() async {
    try {
      final response = await _get('/portfolio');
      if (response.statusCode != 200)
        throw ApiException('Failed to load portfolio');
      final data = jsonDecode(response.body);
      await CacheService.set(
        'portfolio',
        data,
        ttl: const Duration(minutes: 5),
      );
      return data;
    } catch (e) {
      final cached = await CacheService.getStale('portfolio');
      if (cached != null) return Map<String, dynamic>.from(cached);
      rethrow;
    }
  }

  // === WALLET ===

  Future<Map<String, dynamic>> getWallet() async {
    final response = await _get('/wallet');
    if (response.statusCode != 200) throw ApiException('Failed to load wallet');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deposit(double amount) async {
    final response = await _post('/wallet/deposit', body: {'amount': amount});
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> withdraw({
    required double amount,
    required String bankName,
    required String accountNumber,
  }) async {
    final response = await _post(
      '/wallet/withdraw',
      body: {
        'amount': amount,
        'bank_name': bankName,
        'account_number': accountNumber,
      },
    );
    return jsonDecode(response.body);
  }

  Future<List<Transaction>> getTransactions() async {
    final response = await _get('/wallet/transactions');
    if (response.statusCode != 200)
      throw ApiException('Failed to load transactions');
    final data = jsonDecode(response.body);
    final List<dynamic> list = data is List
        ? data
        : (data['transactions'] ?? []);
    return list.map((j) => Transaction.fromJson(j)).toList();
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    final response = await _get('/payment-methods');
    if (response.statusCode != 200)
      throw ApiException('Failed to load payment methods');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((j) => PaymentMethod.fromJson(j)).toList();
  }

  Future<Map<String, dynamic>> addPaymentMethod({
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) async {
    final response = await _post(
      '/payment-methods',
      body: {
        'bank_name': bankName,
        'account_number': accountNumber,
        'account_name': accountName,
      },
    );
    return jsonDecode(response.body);
  }

  Future<void> deletePaymentMethod(int id) async {
    await _delete('/payment-methods/$id');
  }

  Future<Map<String, dynamic>> setPrimaryPaymentMethod(int id) async {
    final response = await _post('/payment-methods/$id/set-primary');
    return jsonDecode(response.body);
  }

  // === WATCHLIST ===

  Future<List<Asset>> getWatchlist() async {
    final response = await _get('/watchlist');
    if (response.statusCode != 200)
      throw ApiException('Failed to load watchlist');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((j) => Asset.fromJson(j)).toList();
  }

  Future<void> addToWatchlist(int assetId) async {
    await _post('/watchlist', body: {'asset_id': assetId});
  }

  Future<void> removeFromWatchlist(int assetId) async {
    try {
      await http
          .delete(
            Uri.parse('$baseUrl/watchlist/$assetId'),
            headers: await _headers,
          )
          .timeout(_timeout);
    } catch (e) {
      throw ApiException(_friendlyError(e), userMessage: _friendlyError(e));
    }
  }

  // === COMPLIANCE ===

  Future<Map<String, dynamic>> getComplianceInfo() async {
    final response = await _get('/compliance');
    if (response.statusCode != 200)
      throw ApiException('Failed to load compliance');
    return jsonDecode(response.body);
  }

  // === PRICE ALERTS ===

  Future<List<PriceAlert>> getAlerts() async {
    final response = await _get('/alerts');
    if (response.statusCode != 200) throw ApiException('Failed to load alerts');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((j) => PriceAlert.fromJson(j)).toList();
  }

  Future<Map<String, dynamic>> createAlert({
    required int assetId,
    required double targetPrice,
    required String condition,
    String? note,
  }) async {
    final response = await _post(
      '/alerts',
      body: {
        'asset_id': assetId,
        'target_price': targetPrice,
        'condition': condition,
        if (note != null) 'note': note,
      },
    );
    return jsonDecode(response.body);
  }

  Future<void> deleteAlert(int alertId) async {
    try {
      await http
          .delete(
            Uri.parse('$baseUrl/alerts/$alertId'),
            headers: await _headers,
          )
          .timeout(_timeout);
    } catch (e) {
      throw ApiException(_friendlyError(e), userMessage: _friendlyError(e));
    }
  }

  Future<List<PriceAlert>> getTriggeredAlerts() async {
    final response = await _get('/alerts/triggered');
    if (response.statusCode != 200) return [];
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((j) => PriceAlert.fromJson(j)).toList();
  }

  // === NEWS ===

  Future<List<NewsArticle>> getNews({String? category, int limit = 30}) async {
    final params = <String, String>{};
    if (category != null) params['category'] = category;
    params['limit'] = limit.toString();
    var path = '/news';
    if (params.isNotEmpty) {
      path = Uri.parse(path).replace(queryParameters: params).toString();
    }

    try {
      final response = await _get(path);
      if (response.statusCode != 200) throw ApiException('Failed to load news');
      final data = jsonDecode(response.body);
      final List<dynamic> articles = data['articles'] ?? [];
      await CacheService.set(
        'news_${category ?? "all"}',
        articles,
        ttl: const Duration(minutes: 15),
      );
      return articles.map((j) => NewsArticle.fromJson(j)).toList();
    } catch (e) {
      final cached = await CacheService.getStale('news_${category ?? "all"}');
      if (cached != null) {
        return (cached as List).map((j) => NewsArticle.fromJson(j)).toList();
      }
      rethrow;
    }
  }

  // === ZAKAT ===

  /// Calculates Zakat due based on portfolio and additional asset values.
  /// [nisabMethod] determines whether the gold or silver nisab threshold is used.
  Future<Map<String, dynamic>> calculateZakat({
    double otherSavings = 0,
    double goldValue = 0,
    double silverValue = 0,
    double debts = 0,
    double expenses = 0,
    String nisabMethod = 'gold',
  }) async {
    final response = await _post(
      '/zakat/calculate',
      body: {
        'other_savings': otherSavings,
        'gold_value': goldValue,
        'silver_value': silverValue,
        'debts': debts,
        'expenses': expenses,
        'nisab_method': nisabMethod,
      },
    );
    if (response.statusCode != 200)
      throw ApiException('Failed to calculate Zakat');
    return jsonDecode(response.body);
  }

  /// Returns the current Nisab threshold values (gold and silver) from the server.
  Future<Map<String, dynamic>> getNisab() async {
    final response = await _get('/zakat/nisab');
    if (response.statusCode != 200) throw ApiException('Failed to load Nisab');
    return jsonDecode(response.body);
  }

  // === EXCHANGE RATES ===

  /// Fetches NBE exchange rates, cached for one hour with stale fallback.
  Future<Map<String, ExchangeRate>> getExchangeRates() async {
    try {
      final response = await _get('/exchange-rates');
      if (response.statusCode != 200)
        throw ApiException('Failed to load rates');
      final data = jsonDecode(response.body);
      final Map<String, dynamic> rates = data['rates'] ?? {};
      await CacheService.set(
        'exchange_rates',
        rates,
        ttl: const Duration(hours: 1),
      );
      return rates.map((k, v) => MapEntry(k, ExchangeRate.fromJson(k, v)));
    } catch (e) {
      final cached = await CacheService.getStale('exchange_rates');
      if (cached != null) {
        final rates = Map<String, dynamic>.from(cached);
        return rates.map((k, v) => MapEntry(k, ExchangeRate.fromJson(k, v)));
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    final uri = Uri.parse('$baseUrl/convert').replace(
      queryParameters: {'amount': amount.toString(), 'from': from, 'to': to},
    );
    try {
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode != 200) throw ApiException('Conversion failed');
      return jsonDecode(response.body);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(_friendlyError(e), userMessage: _friendlyError(e));
    }
  }

  // === CANDLESTICK HISTORY ===

  /// Retrieves OHLCV candle history for [symbol]; returns empty list on failure.
  Future<List<Map<String, dynamic>>> getChartHistory(
    String symbol, {
    String period = '1mo',
    String interval = '1d',
  }) async {
    final uri = Uri.parse(
      '$baseUrl/market/history/$symbol',
    ).replace(queryParameters: {'period': period, 'interval': interval});
    try {
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode != 200) return [];
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    } catch (_) {
      return [];
    }
  }
}
