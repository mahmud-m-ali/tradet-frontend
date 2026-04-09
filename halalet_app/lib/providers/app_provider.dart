import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

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

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

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
      _error = e is ApiException ? e.displayMessage : 'Cannot connect to server. Please check your connection.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

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
        return true;
      }
      _error = result['error'] ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e is ApiException ? e.displayMessage : 'Cannot connect to server. Please check your connection.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
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
  }

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
      return true;
    } catch (e) {
      _error = 'KYC submission failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadAssets({bool shariaOnly = false, bool ecxOnly = false}) async {
    _assetsLoading = true;
    _assetsError = null;
    notifyListeners();
    try {
      _assets = await _api.getAssets(shariaOnly: shariaOnly, ecxOnly: ecxOnly);
      _assetsError = null;
    } catch (e) {
      _assetsError = 'Failed to load market data. Pull down to retry.';
    }
    _assetsLoading = false;
    notifyListeners();
  }

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

  Future<Map<String, dynamic>> cancelOrder(int orderId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _api.cancelOrder(orderId);
      await loadOrders();
      await loadPortfolio();
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

  Future<Map<String, dynamic>> deposit(double amount) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _api.deposit(amount);
      _user = await _api.getProfile();
      await loadPortfolio();
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'error': 'Deposit failed'};
    }
  }

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
