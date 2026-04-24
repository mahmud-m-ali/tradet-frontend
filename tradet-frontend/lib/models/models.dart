/// Domain model classes for the TradEt platform — users, assets, orders, wallet, and more.

/// Authenticated platform user with KYC state and wallet balance.
class User {
  final int id;
  final String email;
  final String fullName;
  final String kycStatus;
  final String accountType;
  final double walletBalance;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.kycStatus,
    required this.accountType,
    this.walletBalance = 0,
  });

  /// Deserialises a [User] from the `/auth/profile` API response.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      kycStatus: json['kyc_status'] ?? 'pending',
      accountType: json['account_type'] ?? 'individual',
      walletBalance: (json['wallet_balance'] ?? 0).toDouble(),
    );
  }

  bool get isKycVerified => kycStatus == 'verified';
}

/// Tradeable commodity asset with live market data and Sharia compliance metadata.
class Asset {
  final int id;
  final String symbol;
  final String name;
  final String? nameAm;
  final String? categoryName;
  final String? categoryType;
  final String? description;
  final String unit;
  final double minTradeQty;
  final double maxTradeQty;
  final bool isEcxListed;
  final bool isShariaCompliant;
  final bool isHaram;
  /// Sharia ruling for this asset: `'halal'`, `'permissible'`, or `'non_compliant'`.
  final String complianceLevel; // 'halal' | 'permissible' | 'non_compliant'
  final double? price;
  final double? bidPrice;
  final double? askPrice;
  final double? high24h;
  final double? low24h;
  final double? volume24h;
  final double? change24h;
  final Map<String, dynamic>? tradingSession;
  final Map<String, dynamic>? shariaScreening;
  final List<double> sparkline;
  final String? dataSource;
  final String? dataSourceLabel;

  Asset({
    required this.id,
    required this.symbol,
    required this.name,
    this.nameAm,
    this.categoryName,
    this.categoryType,
    this.description,
    this.unit = 'KG',
    this.minTradeQty = 1,
    this.maxTradeQty = 10000,
    this.isEcxListed = false,
    this.isShariaCompliant = true,
    this.isHaram = false,
    this.complianceLevel = 'halal',
    this.price,
    this.bidPrice,
    this.askPrice,
    this.high24h,
    this.low24h,
    this.volume24h,
    this.change24h,
    this.sparkline = const [],
    this.tradingSession,
    this.shariaScreening,
    this.dataSource,
    this.dataSourceLabel,
  });

  /// Deserialises an [Asset] from the `/market/assets` API response.
  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      nameAm: json['name_am'],
      categoryName: json['category_name'],
      categoryType: json['category_type'],
      description: json['description'],
      unit: json['unit'] ?? 'KG',
      minTradeQty: (json['min_trade_qty'] ?? 1).toDouble(),
      maxTradeQty: (json['max_trade_qty'] ?? 10000).toDouble(),
      isEcxListed: json['is_ecx_listed'] == 1,
      isShariaCompliant: json['is_sharia_compliant'] == 1,
      isHaram: json['is_haram'] == 1,
      complianceLevel: json['compliance_level'] ?? (json['is_sharia_compliant'] == 1 ? 'halal' : 'permissible'),
      price: json['price']?.toDouble(),
      bidPrice: json['bid_price']?.toDouble(),
      askPrice: json['ask_price']?.toDouble(),
      high24h: json['high_24h']?.toDouble(),
      low24h: json['low_24h']?.toDouble(),
      volume24h: json['volume_24h']?.toDouble(),
      change24h: json['change_24h']?.toDouble(),
      sparkline: (json['sparkline'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      tradingSession: json['trading_session'],
      shariaScreening: json['sharia_screening'],
      dataSource: json['data_source'],
      dataSourceLabel: json['data_source_label'],
    );
  }

  bool get isPositiveChange => (change24h ?? 0) >= 0;
  bool get isLiveData => dataSource == 'live';
  bool get isSimulated => dataSource == 'simulated';
}

/// A single commodity position held by the user, including P&L and compliance status.
class PortfolioHolding {
  final int assetId;
  final String symbol;
  final String assetName;
  final String? nameAm;
  final String unit;
  final double quantity;
  final double avgBuyPrice;
  final double totalInvested;
  final double currentPrice;
  final double currentValue;
  final double pnl;
  final double pnlPercentage;
  final bool isShariaCompliant;
  final String complianceLevel;

  PortfolioHolding({
    required this.assetId,
    required this.symbol,
    required this.assetName,
    this.nameAm,
    this.unit = 'KG',
    required this.quantity,
    required this.avgBuyPrice,
    required this.totalInvested,
    required this.currentPrice,
    required this.currentValue,
    required this.pnl,
    required this.pnlPercentage,
    this.isShariaCompliant = true,
    this.complianceLevel = 'halal',
  });

  factory PortfolioHolding.fromJson(Map<String, dynamic> json) {
    final isShariaCompliant = json['is_sharia_compliant'] == 1;
    return PortfolioHolding(
      assetId: json['asset_id'],
      symbol: json['symbol'] ?? '',
      assetName: json['asset_name'] ?? '',
      nameAm: json['name_am'],
      unit: json['unit'] ?? 'KG',
      quantity: (json['quantity'] ?? 0).toDouble(),
      avgBuyPrice: (json['avg_buy_price'] ?? 0).toDouble(),
      totalInvested: (json['total_invested'] ?? 0).toDouble(),
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      currentValue: (json['current_value'] ?? 0).toDouble(),
      pnl: (json['pnl'] ?? 0).toDouble(),
      pnlPercentage: (json['pnl_percentage'] ?? 0).toDouble(),
      isShariaCompliant: isShariaCompliant,
      complianceLevel: isShariaCompliant ? 'halal' : 'permissible',
    );
  }
}

/// Aggregated financial snapshot of the user's full portfolio including cash.
class PortfolioSummary {
  final double totalHoldingsValue;
  final double totalInvested;
  final double totalPnl;
  final double cashBalance;
  final double totalPortfolioValue;

  PortfolioSummary({
    required this.totalHoldingsValue,
    required this.totalInvested,
    required this.totalPnl,
    required this.cashBalance,
    required this.totalPortfolioValue,
  });

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) {
    return PortfolioSummary(
      totalHoldingsValue: (json['total_holdings_value'] ?? 0).toDouble(),
      totalInvested: (json['total_invested'] ?? 0).toDouble(),
      totalPnl: (json['total_pnl'] ?? 0).toDouble(),
      cashBalance: (json['cash_balance'] ?? 0).toDouble(),
      totalPortfolioValue: (json['total_portfolio_value'] ?? 0).toDouble(),
    );
  }
}

/// A buy or sell order placed by the user, with execution type and fee details.
class Order {
  final int id;
  final String symbol;
  final String assetName;
  final String orderType;
  final String orderStatus;
  final String executionType;
  final double quantity;
  final double price;
  final double totalAmount;
  final double feeAmount;
  final String createdAt;

  Order({
    required this.id,
    required this.symbol,
    required this.assetName,
    required this.orderType,
    required this.orderStatus,
    this.executionType = 'market',
    required this.quantity,
    required this.price,
    required this.totalAmount,
    required this.feeAmount,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      symbol: json['symbol'] ?? '',
      assetName: json['asset_name'] ?? '',
      orderType: json['order_type'] ?? '',
      orderStatus: json['order_status'] ?? '',
      executionType: json['execution_type'] ?? 'market',
      quantity: (json['quantity'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      feeAmount: (json['fee_amount'] ?? 0).toDouble(),
      createdAt: json['created_at'] ?? '',
    );
  }

  bool get isPending => orderStatus == 'pending' || orderStatus == 'partial';
  bool get isLimit => executionType == 'limit';
}

/// User-defined price alert that fires when an asset crosses a target threshold.
class PriceAlert {
  final int id;
  final int assetId;
  final String symbol;
  final String assetName;
  final double targetPrice;
  final double? currentPrice;
  final String condition;
  final bool isActive;
  final bool isTriggered;
  final String? triggeredAt;
  final String? note;
  final String createdAt;

  PriceAlert({
    required this.id,
    required this.assetId,
    required this.symbol,
    required this.assetName,
    required this.targetPrice,
    this.currentPrice,
    required this.condition,
    this.isActive = true,
    this.isTriggered = false,
    this.triggeredAt,
    this.note,
    required this.createdAt,
  });

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return PriceAlert(
      id: json['id'],
      assetId: json['asset_id'],
      symbol: json['symbol'] ?? '',
      assetName: json['asset_name'] ?? '',
      targetPrice: (json['target_price'] ?? 0).toDouble(),
      currentPrice: json['current_price']?.toDouble(),
      condition: json['condition'] ?? 'above',
      isActive: json['is_active'] == 1,
      isTriggered: json['is_triggered'] == 1,
      triggeredAt: json['triggered_at'],
      note: json['note'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

/// A news article fetched from the market/news feed.
class NewsArticle {
  final String title;
  final String description;
  final String link;
  final String source;
  final String category;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.link,
    required this.source,
    required this.category,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      source: json['source'] ?? '',
      category: json['category'] ?? 'global',
      publishedAt: json['published_at'] ?? '',
    );
  }
}

/// NBE (National Bank of Ethiopia) exchange rate for a single currency pair.
class ExchangeRate {
  final String currency;
  final double buying;
  final double selling;
  final double mid;

  ExchangeRate({
    required this.currency,
    required this.buying,
    required this.selling,
    required this.mid,
  });

  /// Deserialises from a rates map entry keyed by [currency] code.
  factory ExchangeRate.fromJson(String currency, Map<String, dynamic> json) {
    return ExchangeRate(
      currency: currency,
      buying: (json['buying'] ?? 0).toDouble(),
      selling: (json['selling'] ?? 0).toDouble(),
      mid: (json['mid'] ?? 0).toDouble(),
    );
  }
}

/// A wallet ledger entry — deposit, withdrawal, trade buy/sell, or refund.
class Transaction {
  final int id;
  final String transactionType;
  final double amount;
  final double balanceAfter;
  final String? description;
  final String createdAt;

  Transaction({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.balanceAfter,
    this.description,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      transactionType: json['transaction_type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      balanceAfter: (json['balance_after'] ?? 0).toDouble(),
      description: json['description'],
      createdAt: json['created_at'] ?? '',
    );
  }

  /// True when this transaction adds funds to the wallet (deposit, sell, refund).
  bool get isCredit => transactionType == 'deposit' || transactionType == 'trade_sell' || transactionType == 'refund';
}

/// Audit-trail event for a single order lifecycle step (placed, filled, cancelled, etc.).
class OrderEvent {
  final int id;
  final int orderId;
  final String eventType; // placed, filled, cancelled, expired, partial_fill
  final String orderType; // buy, sell
  final String symbol;
  final String assetName;
  final double quantity;
  final double price;
  final double amount;
  final String? details;
  final String createdAt;

  OrderEvent({
    required this.id,
    required this.orderId,
    required this.eventType,
    required this.orderType,
    required this.symbol,
    required this.assetName,
    required this.quantity,
    required this.price,
    required this.amount,
    this.details,
    required this.createdAt,
  });

  factory OrderEvent.fromJson(Map<String, dynamic> json) {
    return OrderEvent(
      id: json['id'],
      orderId: json['order_id'],
      eventType: json['event_type'] ?? '',
      orderType: json['order_type'] ?? '',
      symbol: json['symbol'] ?? '',
      assetName: json['asset_name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      details: json['details'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

/// A linked bank account used for withdrawals.
class PaymentMethod {
  final int id;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final bool isPrimary;
  final String createdAt;

  PaymentMethod({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.isPrimary,
    required this.createdAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      bankName: json['bank_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      accountName: json['account_name'] ?? '',
      isPrimary: json['is_primary'] == 1 || json['is_primary'] == true,
      createdAt: json['created_at'] ?? '',
    );
  }
}
