/// Global state provider — manages auth, market data, portfolio, orders, and preferences.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/security_log_service.dart';

/// Central [ChangeNotifier] that drives all app state via the Provider package.
class AppProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  // Theme mode
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Locale
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  String get langCode => _locale.languageCode;

  /// Loads both theme mode and locale from persistent storage.
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('theme_mode') ?? 'dark';
    _themeMode = mode == 'light' ? ThemeMode.light : ThemeMode.dark;
    final lang = prefs.getString('locale') ?? 'en';
    _locale = Locale(lang);
    notifyListeners();
  }

  Future<void> loadThemePreference() async {
    await loadPreferences();
  }

  /// Toggles between dark and light mode and persists the selection.
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme_mode',
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  /// Sets the active locale and persists it for subsequent launches.
  Future<void> setLocale(String langCode) async {
    _locale = Locale(langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', langCode);
    notifyListeners();
  }

  /// Legacy toggle kept for backward compat (cycles en→am→en)
  Future<void> toggleLocale() async {
    await setLocale(_locale.languageCode == 'en' ? 'am' : 'en');
  }

  User? _user;
  List<Asset> _assets = [];
  List<PortfolioHolding> _holdings = [];
  PortfolioSummary? _portfolioSummary;
  List<Order> _orders = [];
  List<Asset> _watchlist = [];
  List<Transaction> _transactions = [];
  List<OrderEvent> _orderEvents = [];
  List<PaymentMethod> _paymentMethods = [];

  // Analytics chart data: list of {x, y} double pairs
  List<Map<String, double>> _analyticsSpots = [];
  bool _analyticsLoading = false;
  List<Map<String, double>> get analyticsSpots => _analyticsSpots;
  bool get analyticsLoading => _analyticsLoading;
  bool _isLoggedIn = false;

  // Separate loading/error states per section
  bool _assetsLoading = false;
  String? _assetsError;
  bool _portfolioLoading = false;
  String? _portfolioError;
  bool _ordersLoading = false;
  String? _ordersError;

  // General loading/error for auth operations
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  List<Asset> get assets => _assets;
  List<PortfolioHolding> get holdings => _holdings;
  PortfolioSummary? get portfolioSummary => _portfolioSummary;
  List<Order> get orders => _orders;
  List<Asset> get watchlist => _watchlist;
  List<Transaction> get transactions => _transactions;
  List<OrderEvent> get orderEvents => _orderEvents;
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  ApiService get api => _api;

  /// Total funds reserved for open buy orders (not yet executed)
  double get reservedForOrders {
    return _orders
        .where((o) => o.isPending && o.orderType == 'buy')
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  /// Available cash balance after subtracting reserved order funds
  double get availableCashBalance {
    final cash = _portfolioSummary?.cashBalance ?? _user?.walletBalance ?? 0;
    return (cash - reservedForOrders).clamp(0.0, double.infinity);
  }

  // Global navigation callback (set by HomeScreen, used by detail screens)
  Function(int)? _globalNavCallback;

  /// Registers the bottom-nav callback from [HomeScreen] so detail screens can
  /// switch tabs without holding a direct reference.
  void setGlobalNav(Function(int)? fn) {
    _globalNavCallback = fn;
  }

  /// Triggers a bottom-nav tab switch from anywhere in the widget tree.
  void navigateGlobal(int index) {
    _globalNavCallback?.call(index);
  }

  bool get assetsLoading => _assetsLoading;
  String? get assetsError => _assetsError;
  bool get portfolioLoading => _portfolioLoading;
  String? get portfolioError => _portfolioError;
  bool get ordersLoading => _ordersLoading;
  String? get ordersError => _ordersError;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Convenience wrapper: runs [fn], captures any error into [_error], and
  /// always calls [notifyListeners] in the finally block.
  /// Use this for fire-and-forget void operations; methods that return a value
  /// must manage [_isLoading] and [notifyListeners] themselves.
  Future<void> _run(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Checks for a stored token, refreshes it if expired, and hydrates [user].
  Future<void> checkAuthStatus() async {
    _isLoggedIn = await _api.isLoggedIn;
    if (_isLoggedIn) {
      try {
        _user = await _api.getProfile();
      } catch (e) {
        // If 401, try refresh token
        if (e is ApiException && e.statusCode == 401) {
          final refreshed = await _api.refreshAccessToken();
          if (refreshed) {
            try {
              _user = await _api.getProfile();
              notifyListeners();
              return;
            } catch (_) {}
          }
        }
        _isLoggedIn = false;
        await _api.clearToken();
      }
    }
    notifyListeners();
  }

  /// Creates a new account and signs the user in on success.
  Future<bool> register({
    required String email,
    required String phone,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _api.register(
        email: email,
        phone: phone,
        password: password,
        fullName: fullName,
      );
      if (result.containsKey('token')) {
        _isLoggedIn = true;
        _user = await _api.getProfile();
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = result['error'] ?? 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e is ApiException
          ? e.displayMessage
          : 'Cannot connect to server. Please check your connection.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Authenticates the user and records a security audit event.
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _api.login(email: email, password: password);
      if (result.containsKey('token')) {
        _isLoggedIn = true;
        _user = User.fromJson(result['user']);
        _error = null;
        _isLoading = false;
        notifyListeners();
        SecurityLogService.record(SecurityEvent.loginSuccess, userId: email);
        return true;
      }
      _error = result['error'] ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      SecurityLogService.record(SecurityEvent.loginFail, userId: email);
      return false;
    } catch (e) {
      _error = e is ApiException
          ? e.displayMessage
          : 'Cannot connect to server. Please check your connection.';
      _isLoading = false;
      notifyListeners();
      SecurityLogService.record(SecurityEvent.loginFail, userId: email);
      return false;
    }
  }

  /// Loads portfolio value history for the analytics chart.
  /// Aggregates per-asset chart history weighted by holding quantity, plus cash.
  Future<void> loadAnalytics(int periodIndex) async {
    _analyticsLoading = true;
    notifyListeners();
    try {
      final periodMap = {0: '1wk', 1: '1mo', 2: '3mo', 3: '1y'};
      final period = periodMap[periodIndex] ?? '1mo';
      final cash = _portfolioSummary?.cashBalance ?? 0;

      if (_holdings.isEmpty) {
        // No holdings: flat line at cash balance
        final pts = [7, 30, 90, 365][periodIndex];
        _analyticsSpots = List.generate(
          pts,
          (i) => {'x': i.toDouble(), 'y': cash},
        );
        _analyticsLoading = false;
        notifyListeners();
        return;
      }

      // Fetch chart history for each held asset
      final Map<String, List<double>> seriesMap = {};
      int maxLen = 0;
      for (final h in _holdings) {
        final history = await _api.getChartHistory(h.symbol, period: period);
        if (history.isNotEmpty) {
          final prices = history
              .map((p) => (p['close'] as num?)?.toDouble() ?? 0.0)
              .toList();
          seriesMap[h.symbol] = prices.map((p) => p * h.quantity).toList();
          if (prices.length > maxLen) maxLen = prices.length;
        }
      }

      if (maxLen == 0) {
        // Chart history unavailable — fall back to flat line at current value
        final currentValue =
            (_portfolioSummary?.totalPortfolioValue ??
                _holdings.fold<double>(0.0, (s, h) => s + h.currentValue)) +
            cash;
        final pts = [7, 30, 90, 365][periodIndex];
        _analyticsSpots = List.generate(
          pts,
          (i) => {'x': i.toDouble(), 'y': currentValue.toDouble()},
        );
        _analyticsLoading = false;
        notifyListeners();
        return;
      }

      // Sum all series at each time point
      final combined = List<double>.filled(maxLen, 0);
      for (final series in seriesMap.values) {
        for (int i = 0; i < series.length && i < maxLen; i++) {
          combined[i] += series[i];
        }
      }
      // Add cash to each point
      _analyticsSpots = List.generate(
        maxLen,
        (i) => {'x': i.toDouble(), 'y': combined[i] + cash},
      );
    } catch (_) {
      // On any error, show flat line at current known value
      final currentValue =
          (_portfolioSummary?.totalPortfolioValue ??
              _holdings.fold<double>(0.0, (s, h) => s + h.currentValue)) +
          (_portfolioSummary?.cashBalance ?? 0);
      final pts = [7, 30, 90, 365][periodIndex];
      _analyticsSpots = List.generate(
        pts,
        (i) => {'x': i.toDouble(), 'y': currentValue.toDouble()},
      );
    }
    _analyticsLoading = false;
    notifyListeners();
  }

  /// Clears token, purges all cached data, and resets in-memory state.
  Future<void> logout() async {
    final uid = _user?.email ?? '';
    await _api.clearToken();
    await CacheService.clearAll();
    _isLoggedIn = false;
    _user = null;
    _holdings = [];
    _orders = [];
    _watchlist = [];
    _transactions = [];
    _orderEvents = [];
    _paymentMethods = [];
    _portfolioSummary = null;
    notifyListeners();
    SecurityLogService.record(SecurityEvent.logout, userId: uid);
  }

  /// Submits KYC identity documents and refreshes the user profile on success.
  Future<bool> submitKyc({
    required String idType,
    required String idNumber,
    String? tradeLicenseNumber,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _api.submitKyc(
        idType: idType,
        idNumber: idNumber,
        tradeLicenseNumber: tradeLicenseNumber,
      );
      _user = await _api.getProfile();
      _isLoading = false;
      notifyListeners();
      SecurityLogService.record(
        SecurityEvent.kycSubmitted,
        userId: _user?.email ?? '',
      );
      return true;
    } catch (e) {
      _error = 'KYC submission failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetches tradeable assets; pass [refresh] to bypass the server-side cache.
  Future<void> loadAssets({
    bool shariaOnly = false,
    bool ecxOnly = false,
    bool refresh = false,
  }) async {
    _assetsLoading = true;
    _assetsError = null;
    notifyListeners();
    try {
      _assets = await _api.getAssets(
        shariaOnly: shariaOnly,
        ecxOnly: ecxOnly,
        refresh: refresh,
      );
      _assetsError = null;
    } catch (e) {
      _assetsError = 'Failed to load market data. Pull down to retry.';
    }
    _assetsLoading = false;
    notifyListeners();
  }

  /// Fetches holdings and summary from the portfolio endpoint.
  Future<void> loadPortfolio() async {
    _portfolioLoading = true;
    _portfolioError = null;
    notifyListeners();
    try {
      final data = await _api.getPortfolio();
      _holdings = (data['holdings'] as List)
          .map((j) => PortfolioHolding.fromJson(j))
          .toList();
      _portfolioSummary = PortfolioSummary.fromJson(data['summary']);
      _portfolioError = null;
    } catch (e) {
      _portfolioError = 'Failed to load portfolio';
    }
    _portfolioLoading = false;
    notifyListeners();
  }

  Future<void> loadOrders() async {
    _ordersLoading = true;
    _ordersError = null;
    notifyListeners();
    try {
      _orders = await _api.getOrders();
      _ordersError = null;
    } catch (e) {
      _ordersError = 'Failed to load orders';
    }
    _ordersLoading = false;
    notifyListeners();
  }

  Future<void> loadWatchlist() async {
    try {
      _watchlist = await _api.getWatchlist();
      notifyListeners();
    } catch (_) {}
  }

  /// Load all data at once (used by dashboard)
  Future<void> loadAllData() async {
    await Future.wait([
      loadAssets(),
      loadPortfolio(),
      loadOrders(),
      loadWatchlist(),
    ]);
  }

  /// Places a buy or sell order and refreshes portfolio and order state on success.
  Future<Map<String, dynamic>> placeOrder({
    required int assetId,
    required String orderType,
    required double quantity,
    required double price,
    String executionType = 'market',
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _api.placeOrder(
        assetId: assetId,
        orderType: orderType,
        quantity: quantity,
        price: price,
        executionType: executionType,
      );
      if (result.containsKey('order_id')) {
        await loadPortfolio();
        await loadOrders();
        SecurityLogService.record(
          SecurityEvent.orderPlaced,
          userId: _user?.email ?? '',
          metadata: {'assetId': assetId, 'type': orderType, 'qty': quantity},
        );
      }
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'error': 'Failed to place order'};
    }
  }

  /// Cancels a pending order and logs the security event.
  Future<Map<String, dynamic>> cancelOrder(int orderId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _api.cancelOrder(orderId);
      await loadOrders();
      await loadPortfolio();
      SecurityLogService.record(
        SecurityEvent.orderCancelled,
        userId: _user?.email ?? '',
        metadata: {'orderId': orderId},
      );
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'error': 'Failed to cancel order'};
    }
  }

  Future<void> loadTransactions() async {
    try {
      _transactions = await _api.getTransactions();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadOrderEvents() async {
    try {
      _orderEvents = await _api.getOrderEvents();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadPaymentMethods() async {
    try {
      _paymentMethods = await _api.getPaymentMethods();
      notifyListeners();
    } catch (_) {}
  }

  Future<Map<String, dynamic>> addPaymentMethod({
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) async {
    try {
      final result = await _api.addPaymentMethod(
        bankName: bankName,
        accountNumber: accountNumber,
        accountName: accountName,
      );
      await loadPaymentMethods();
      return result;
    } catch (e) {
      return {'error': 'Failed to add payment method'};
    }
  }

  Future<bool> deletePaymentMethod(int id) async {
    try {
      await _api.deletePaymentMethod(id);
      await loadPaymentMethods();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setPrimaryPaymentMethod(int id) async {
    try {
      await _api.setPrimaryPaymentMethod(id);
      await loadPaymentMethods();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> addToWatchlist(int assetId) async {
    try {
      await _api.addToWatchlist(assetId);
      await loadWatchlist();
      SecurityLogService.record(
        SecurityEvent.watchlistChanged,
        userId: _user?.email ?? '',
        metadata: {'action': 'add', 'assetId': assetId},
      );
    } catch (_) {}
  }

  Future<void> removeFromWatchlist(int assetId) async {
    try {
      await _api.removeFromWatchlist(assetId);
      await loadWatchlist();
    } catch (_) {}
  }

  /// Credits [amount] to the wallet and refreshes user profile and portfolio.
  Future<Map<String, dynamic>> deposit(double amount) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _api.deposit(amount);
      _user = await _api.getProfile();
      await loadPortfolio();
      SecurityLogService.record(
        SecurityEvent.deposit,
        userId: _user?.email ?? '',
        metadata: {'amount': amount},
      );
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'error': 'Deposit failed'};
    }
  }

  /// Initiates a bank withdrawal and refreshes user profile and portfolio.
  Future<Map<String, dynamic>> withdraw({
    required double amount,
    required String bankName,
    required String accountNumber,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _api.withdraw(
        amount: amount,
        bankName: bankName,
        accountNumber: accountNumber,
      );
      _user = await _api.getProfile();
      await loadPortfolio();
      SecurityLogService.record(
        SecurityEvent.withdrawal,
        userId: _user?.email ?? '',
        metadata: {'amount': amount, 'bank': bankName},
      );
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'error': 'Withdrawal failed'};
    }
  }
}
