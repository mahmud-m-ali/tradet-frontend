/// Demo mode service — provides realistic pre-seeded data for bank presentations.
/// No network calls are made when demo mode is active.
library;

import '../models/models.dart';

/// Static demo data representing a typical Ethiopian commodity trader.
class DemoService {
  // ── Demo user ────────────────────────────────────────────────────────────────
  static User get demoUser => User(
        id: 9999,
        email: 'demo@tradet.et',
        fullName: 'Alemu Bekele (Demo)',
        kycStatus: 'verified',
        accountType: 'individual',
        walletBalance: 485_000,
      );

  // ── Demo assets (ECX commodities) ────────────────────────────────────────────
  static List<Asset> get demoAssets => [
        Asset(
          id: 1, symbol: 'ECXCOF', name: 'Ethiopian Coffee', nameAm: 'ኢትዮጵያ ቡና',
          categoryName: 'Agricultural', categoryType: 'commodity',
          unit: 'KG', minTradeQty: 60, maxTradeQty: 10000,
          isEcxListed: true, isShariaCompliant: true, isHaram: false,
          complianceLevel: 'halal', price: 4850, bidPrice: 4840, askPrice: 4860,
          high24h: 4910, low24h: 4790, volume24h: 12500, change24h: 2.8,
          sparkline: [4600,4620,4680,4710,4690,4750,4800,4820,4790,4850],
          tradingSession: {'start': '09:00', 'end': '15:00'},
          shariaScreening: {'debt_to_assets_ratio': 0.12, 'haram_revenue_ratio': 0.0, 'ruling': 'halal'},
          dataSource: 'live', dataSourceLabel: 'ECX Live',
        ),
        Asset(
          id: 2, symbol: 'ECXSES', name: 'Sesame Seed', nameAm: 'ሰሊጥ',
          categoryName: 'Agricultural', categoryType: 'commodity',
          unit: 'KG', minTradeQty: 100, maxTradeQty: 50000,
          isEcxListed: true, isShariaCompliant: true, isHaram: false,
          complianceLevel: 'halal', price: 2850, bidPrice: 2840, askPrice: 2860,
          high24h: 2880, low24h: 2800, volume24h: 8200, change24h: 1.4,
          sparkline: [2700,2710,2720,2750,2740,2780,2800,2820,2840,2850],
          tradingSession: {'start': '09:00', 'end': '15:00'},
          shariaScreening: {'debt_to_assets_ratio': 0.08, 'haram_revenue_ratio': 0.0, 'ruling': 'halal'},
          dataSource: 'live', dataSourceLabel: 'ECX Live',
        ),
        Asset(
          id: 3, symbol: 'ECXWHT', name: 'Wheat', nameAm: 'ስንዴ',
          categoryName: 'Agricultural', categoryType: 'commodity',
          unit: 'KG', minTradeQty: 100, maxTradeQty: 100000,
          isEcxListed: true, isShariaCompliant: true, isHaram: false,
          complianceLevel: 'halal', price: 780, bidPrice: 778, askPrice: 782,
          high24h: 820, low24h: 775, volume24h: 35000, change24h: -2.5,
          sparkline: [860,850,840,830,825,810,800,795,785,780],
          tradingSession: {'start': '09:00', 'end': '15:00'},
          shariaScreening: {'debt_to_assets_ratio': 0.05, 'haram_revenue_ratio': 0.0, 'ruling': 'halal'},
          dataSource: 'live', dataSourceLabel: 'ECX Live',
        ),
        Asset(
          id: 4, symbol: 'ECXGLD', name: 'Gold', nameAm: 'ወርቅ',
          categoryName: 'Precious Metals', categoryType: 'metal',
          unit: 'g', minTradeQty: 1, maxTradeQty: 1000,
          isEcxListed: true, isShariaCompliant: true, isHaram: false,
          complianceLevel: 'halal', price: 8750, bidPrice: 8740, askPrice: 8760,
          high24h: 8800, low24h: 8680, volume24h: 450, change24h: 0.8,
          sparkline: [8400,8450,8500,8520,8480,8600,8650,8700,8720,8750],
          tradingSession: {'start': '09:00', 'end': '17:00'},
          shariaScreening: {'debt_to_assets_ratio': 0.0, 'haram_revenue_ratio': 0.0, 'ruling': 'halal'},
          dataSource: 'live', dataSourceLabel: 'NBE Gold Fix',
        ),
        Asset(
          id: 5, symbol: 'ECXPUL', name: 'Pulses (Haricot Bean)', nameAm: 'ምስር',
          categoryName: 'Agricultural', categoryType: 'commodity',
          unit: 'KG', minTradeQty: 100, maxTradeQty: 50000,
          isEcxListed: true, isShariaCompliant: true, isHaram: false,
          complianceLevel: 'permissible', price: 1420, bidPrice: 1415, askPrice: 1425,
          high24h: 1440, low24h: 1400, volume24h: 6800, change24h: 0.5,
          sparkline: [1380,1385,1390,1400,1395,1410,1415,1418,1420,1420],
          tradingSession: {'start': '09:00', 'end': '15:00'},
          shariaScreening: {'debt_to_assets_ratio': 0.19, 'haram_revenue_ratio': 0.02, 'ruling': 'permissible'},
          dataSource: 'simulated', dataSourceLabel: 'ECX Indicative',
        ),
      ];

  // ── Demo holdings ─────────────────────────────────────────────────────────────
  static List<PortfolioHolding> get demoHoldings => [
        PortfolioHolding(
          assetId: 1, symbol: 'ECXCOF', assetName: 'Ethiopian Coffee', nameAm: 'ኢትዮጵያ ቡና',
          unit: 'KG', quantity: 500, avgBuyPrice: 4200, totalInvested: 2_100_000,
          currentPrice: 4850, currentValue: 2_425_000, pnl: 325_000,
          pnlPercentage: 15.48, isShariaCompliant: true, complianceLevel: 'halal',
        ),
        PortfolioHolding(
          assetId: 2, symbol: 'ECXSES', assetName: 'Sesame Seed', nameAm: 'ሰሊጥ',
          unit: 'KG', quantity: 300, avgBuyPrice: 2600, totalInvested: 780_000,
          currentPrice: 2850, currentValue: 855_000, pnl: 75_000,
          pnlPercentage: 9.62, isShariaCompliant: true, complianceLevel: 'halal',
        ),
        PortfolioHolding(
          assetId: 4, symbol: 'ECXGLD', assetName: 'Gold', nameAm: 'ወርቅ',
          unit: 'g', quantity: 50, avgBuyPrice: 8200, totalInvested: 410_000,
          currentPrice: 8750, currentValue: 437_500, pnl: 27_500,
          pnlPercentage: 6.71, isShariaCompliant: true, complianceLevel: 'halal',
        ),
        PortfolioHolding(
          assetId: 3, symbol: 'ECXWHT', assetName: 'Wheat', nameAm: 'ስንዴ',
          unit: 'KG', quantity: 1000, avgBuyPrice: 850, totalInvested: 850_000,
          currentPrice: 780, currentValue: 780_000, pnl: -70_000,
          pnlPercentage: -8.24, isShariaCompliant: true, complianceLevel: 'halal',
        ),
      ];

  // ── Demo portfolio summary ────────────────────────────────────────────────────
  static PortfolioSummary get demoSummary => PortfolioSummary(
        totalHoldingsValue: 4_497_500,
        totalInvested: 4_140_000,
        totalPnl: 357_500,
        cashBalance: 485_000,
        totalPortfolioValue: 4_982_500,
      );

  // ── Demo orders ───────────────────────────────────────────────────────────────
  static List<Order> get demoOrders => [
        Order(id: 1001, symbol: 'ECXCOF', assetName: 'Ethiopian Coffee',
            orderType: 'buy', orderStatus: 'filled', executionType: 'market',
            quantity: 500, price: 4200, totalAmount: 2_163_000, feeAmount: 63_000,
            createdAt: '2026-04-10 09:32:15'),
        Order(id: 1002, symbol: 'ECXSES', assetName: 'Sesame Seed',
            orderType: 'buy', orderStatus: 'filled', executionType: 'market',
            quantity: 300, price: 2600, totalAmount: 801_900, feeAmount: 21_900,
            createdAt: '2026-04-09 10:15:42'),
        Order(id: 1003, symbol: 'ECXGLD', assetName: 'Gold',
            orderType: 'buy', orderStatus: 'filled', executionType: 'limit',
            quantity: 50, price: 8200, totalAmount: 422_300, feeAmount: 12_300,
            createdAt: '2026-04-08 11:05:00'),
        Order(id: 1004, symbol: 'ECXWHT', assetName: 'Wheat',
            orderType: 'buy', orderStatus: 'filled', executionType: 'market',
            quantity: 1000, price: 850, totalAmount: 872_750, feeAmount: 22_750,
            createdAt: '2026-04-07 09:45:22'),
        Order(id: 1005, symbol: 'ECXCOF', assetName: 'Ethiopian Coffee',
            orderType: 'sell', orderStatus: 'filled', executionType: 'market',
            quantity: 200, price: 4780, totalAmount: 942_660, feeAmount: 14_340,
            createdAt: '2026-04-05 14:20:10'),
        Order(id: 1006, symbol: 'ECXSES', assetName: 'Sesame Seed',
            orderType: 'buy', orderStatus: 'pending', executionType: 'limit',
            quantity: 500, price: 2800, totalAmount: 1_442_000, feeAmount: 42_000,
            createdAt: '2026-04-17 08:55:00'),
        Order(id: 1007, symbol: 'ECXGLD', assetName: 'Gold',
            orderType: 'buy', orderStatus: 'cancelled', executionType: 'limit',
            quantity: 20, price: 8600, totalAmount: 176_580, feeAmount: 5_160,
            createdAt: '2026-04-14 10:00:00'),
        Order(id: 1008, symbol: 'ECXPUL', assetName: 'Pulses',
            orderType: 'buy', orderStatus: 'filled', executionType: 'market',
            quantity: 200, price: 1400, totalAmount: 287_100, feeAmount: 7_100,
            createdAt: '2026-04-03 09:30:00'),
      ];

  // ── Demo transactions ─────────────────────────────────────────────────────────
  static List<Transaction> get demoTransactions => [
        Transaction(id: 2001, transactionType: 'deposit', amount: 5_000_000,
            balanceAfter: 5_000_000, description: 'Initial deposit — CBE transfer',
            createdAt: '2026-04-01 08:00:00'),
        Transaction(id: 2002, transactionType: 'trade_buy', amount: -2_163_000,
            balanceAfter: 2_837_000, description: 'Buy 500 KG ECXCOF @ 4,200',
            createdAt: '2026-04-10 09:32:15'),
        Transaction(id: 2003, transactionType: 'trade_buy', amount: -801_900,
            balanceAfter: 2_035_100, description: 'Buy 300 KG ECXSES @ 2,600',
            createdAt: '2026-04-09 10:15:42'),
        Transaction(id: 2004, transactionType: 'trade_buy', amount: -422_300,
            balanceAfter: 1_612_800, description: 'Buy 50 g ECXGLD @ 8,200',
            createdAt: '2026-04-08 11:05:00'),
        Transaction(id: 2005, transactionType: 'trade_buy', amount: -872_750,
            balanceAfter: 740_050, description: 'Buy 1,000 KG ECXWHT @ 850',
            createdAt: '2026-04-07 09:45:22'),
        Transaction(id: 2006, transactionType: 'trade_sell', amount: 942_660,
            balanceAfter: 1_682_710, description: 'Sell 200 KG ECXCOF @ 4,780',
            createdAt: '2026-04-05 14:20:10'),
        Transaction(id: 2007, transactionType: 'trade_buy', amount: -287_100,
            balanceAfter: 1_395_610, description: 'Buy 200 KG ECXPUL @ 1,400',
            createdAt: '2026-04-03 09:30:00'),
        Transaction(id: 2008, transactionType: 'trade_sell', amount: 910_610,
            balanceAfter: 485_000, description: 'Sell 200 KG ECXPUL @ 4,500 — realised gain',
            createdAt: '2026-04-12 13:00:00'),
      ];

  // ── Demo analytics chart (30 days of portfolio value) ────────────────────────
  static List<Map<String, double>> demoAnalyticsSpots(int periodIndex) {
    // periodIndex: 0=1W, 1=1M, 2=3M, 3=1Y
    final bases = [4_750_000.0, 4_200_000.0, 3_800_000.0, 3_100_000.0];
    final base = bases[periodIndex.clamp(0, 3)];
    final points = [7, 30, 90, 365][periodIndex.clamp(0, 3)];
    final result = <Map<String, double>>[];
    double val = base;
    for (int i = 0; i < points; i++) {
      // Simulate realistic upward trend with noise
      final noise = (i % 3 == 0 ? -1 : 1) * (val * 0.008);
      val = val + (val * 0.003) + noise;
      result.add({'x': i.toDouble(), 'y': val.clamp(base * 0.9, base * 1.5)});
    }
    // Always end near current portfolio value
    if (result.isNotEmpty) result.last['y'] = 4_982_500;
    return result;
  }

  // ── Demo watchlist ────────────────────────────────────────────────────────────
  static List<Asset> get demoWatchlist => demoAssets.take(3).toList();
}
