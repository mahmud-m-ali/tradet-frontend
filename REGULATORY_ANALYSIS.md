# Regulatory Analysis: Sharia & Ethiopian Trade Compliance

## 1. Sharia (Islamic Finance) Compliance Requirements

### 1.1 Core Prohibitions
| Principle | Arabic Term | Description |
|-----------|------------|-------------|
| No Interest | **Riba** | Earning money from money itself without real economic effort is forbidden |
| No Excessive Uncertainty | **Gharar** | All contract terms must be transparent; outcomes must not be wildly unpredictable |
| No Gambling/Speculation | **Maisir** | Pure speculative trading resembling gambling is prohibited |
| No Haram Products | **Haram** | Trading in alcohol, tobacco, pork, weapons, adult entertainment is forbidden |

### 1.2 AAOIFI Financial Screening Thresholds
- **Debt Ratio**: Interest-bearing debt must NOT exceed **30%** of market capitalization
- **Investment Ratio**: Interest-earning (non-compliant) investments must NOT exceed **30%** of market cap
- **Revenue Ratio**: Non-permissible income must NOT exceed **5%** of total revenue

### 1.3 Permitted Trading Types
- **Spot Trading (Murabaha)**: Buying and selling goods at agreed markup — HALAL
- **Commodity Trading**: Physical commodities with real delivery — HALAL
- **Sukuk (Islamic Bonds)**: Asset-backed certificates — HALAL
- **Musharakah**: Partnership-based profit sharing — HALAL
- **Mudarabah**: Profit-sharing investment — HALAL

### 1.4 Prohibited Trading Types
- **Short Selling**: Selling assets you don't own — HARAM
- **Futures/Options**: Speculative derivatives — HARAM (conservative view)
- **Margin Trading with Interest**: Leveraged trading with interest — HARAM
- **Conventional Bonds**: Interest-bearing instruments — HARAM

### 1.5 App Compliance Implementation
1. All assets must pass Sharia screening before listing
2. No interest-based fees (use fixed admin fees instead)
3. Transparent pricing with no hidden charges
4. Real asset-backed transactions only
5. Sharia compliance badge on all approved assets
6. Regular re-screening of listed assets

---

## 2. Ethiopian Trade Regulations

### 2.1 Ethiopia Commodity Exchange (ECX) Rules
- Governed by **ECX Rules Rev. No 549/2021**
- Overseen by **Ethiopia Commodity Exchange Authority (ECEA)**
- Trading commodities: Coffee, Sesame, Haricot Beans, Mung Beans, Red Kidney Beans, Maize, Wheat

### 2.2 Trading Sessions (ECX)
| Commodity | Days | Time (EAT) |
|-----------|------|------------|
| Grains | Wednesday | 9:00 - 9:30 AM |
| Sesame | Daily | 10:00 - 11:00 AM |
| Local Coffee | Tue - Thu | 11:30 AM - 12:30 PM |
| Export Coffee | Daily | 2:00 - 6:00 PM |

### 2.3 National Bank of Ethiopia (NBE) Requirements
- **Payment System**: Governed by Proclamation No. 718/2011, amended by No. 1282/2023
- **Digital Payments**: National Digital Payments Strategy Phase Two (2025-2029)
- **KYC/AML**: Mandatory Know Your Customer and Anti-Money Laundering compliance
- **Currency**: Ethiopian Birr (ETB) as primary trading currency
- **Foreign Exchange**: Regulated by NBE directives
- **Licensing**: Trade license required from Ministry of Trade and Regional Integration

### 2.4 FinTech Regulatory Framework
- **Banking Proclamation No. 1360/2024**: Enables regulatory sandbox for innovation
- **Mobile Money Directive**: Revised framework for mobile money providers
- **Data Protection**: User data must be stored locally per Ethiopian data residency requirements
- **Foreign Participation**: Recent reforms allow limited foreign participation

### 2.5 App Compliance Implementation
1. KYC verification required before trading
2. All transactions in ETB (with exchange rate display)
3. Trade license verification for commercial users
4. Transaction limits per NBE directives
5. Audit trail for all transactions
6. Data residency compliance (local storage)

---

## 3. Combined Compliance Matrix

| Feature | Sharia Requirement | Ethiopian Requirement | Implementation |
|---------|-------------------|----------------------|----------------|
| Asset Screening | AAOIFI 30% thresholds | ECX approved list | Dual screening engine |
| Fees | No interest; flat fees only | NBE fee guidelines | Fixed commission model |
| KYC | Islamic identity verification | NBE KYC/AML rules | Multi-tier KYC system |
| Transactions | Real asset-backed only | ECX settlement rules | Spot trading with delivery |
| Currency | Halal currency pairs | ETB primary | ETB-based with halal FX |
| Data | Transparent records | Local data residency | SQLite local + encrypted |
| Audit | Sharia board review | ECEA oversight | Full audit logging |
| Trading Hours | No restriction | ECX session times | Session-aware trading |
