# TradEt — Claude Code Project Guide

## Project Identity
- **Product name:** TradEt (ትሬድኢት) — never rename this
- **Company:** Amber (`by Amber` in UI)
- **Purpose:** Sharia-compliant Ethiopian commodity trading platform, B2B for Islamic banks
- **Live URL:** https://tradet.amber.et

## Repository Layout

```
TradEt/
  tradet_app/          ← Flutter app (web + mobile)
    lib/
      main.dart        ← Entry point, session timeout, app lock wrappers
      white_label.dart ← Branding config — change here to white-label for a bank
      theme.dart       ← Colors, typography
      providers/app_provider.dart   ← Global state (AppProvider)
      services/api_service.dart     ← REST API calls to tradet.amber.et/api
      services/security_log_service.dart  ← Tamper-evident audit log (chained hash)
      services/demo_service.dart    ← Demo mode data
      screens/         ← One file per screen (see Screen Index below)
      widgets/         ← Reusable components
      models/models.dart
      l10n/app_localizations.dart  ← Amharic + English strings
```

## Flutter Binary

```bash
/Users/mahmud/development/flutter/bin/flutter
```

Flutter is NOT in PATH. Always use the full path, or prefix commands:

```bash
alias fl=/Users/mahmud/development/flutter/bin/flutter
```

## Common Commands

```bash
# Run web (dev)
/Users/mahmud/development/flutter/bin/flutter run -d chrome --web-port 8080

# Build for production web
/Users/mahmud/development/flutter/bin/flutter build web --release --base-href /

# Get dependencies
/Users/mahmud/development/flutter/bin/flutter pub get

# Analyze
/Users/mahmud/development/flutter/bin/flutter analyze
```

## Screen Index (12 screens)

| # | Screen | File |
|---|--------|------|
| 0 | Dashboard | `screens/dashboard_screen.dart` |
| 1 | Market | `screens/market_screen.dart` |
| 2 | Portfolio | `screens/portfolio_screen.dart` |
| 3 | Orders | `screens/orders_screen.dart` |
| 4 | Watchlist | `screens/watchlist_screen.dart` |
| 5 | Alerts | `screens/alerts_screen.dart` |
| 6 | News | `screens/news_screen.dart` |
| 7 | Zakat | `screens/zakat_screen.dart` |
| 8 | Converter | `screens/converter_screen.dart` |
| 9 | Analytics | `screens/analytics_screen.dart` |
| 10 | Transactions | `screens/transactions_screen.dart` |
| 11 | Profile | `screens/profile_screen.dart` |

Other screens: `login_screen.dart`, `register_screen.dart`, `onboarding_screen.dart`, `trade_screen.dart`, `app_lock_screen.dart`

## Key Architecture Rules

- **State:** Use `AppProvider` (provider package) — do not introduce new state management
- **API:** All backend calls go through `ApiService` — never call `http` directly from screens
- **Currency:** Use the async USD helper for all USD display — never chain `.then()` directly
- **White-label:** All branding (name, colors, tagline, email) lives in `white_label.dart` — never hardcode these in screens
- **Localization:** All user-facing strings must be in `l10n/app_localizations.dart` (Amharic + English)
- **Sharia badge:** Show `ShariaScoreCard` / `ShariaBadge` widget on all asset-facing screens

## Sharia & Regulatory Compliance (non-negotiable)

- No Riba (interest): flat 1.5% commission only — never suggest interest-bearing logic
- No short selling, no futures/options
- AAOIFI 30% screening thresholds enforced on all assets
- ECX trading session hours enforced in `trade_screen.dart`
- KYC gate required before any trade (NBE requirement)
- Compliance badges in UI: `AAOIFI Certified`, `ECX Licensed`, `NBE Regulated`

When adding any new feature, ask:
1. Does this need a KYC check?
2. Should this be logged via `SecurityLogService`?
3. Does it handle PII that needs encryption?
4. Does a new API endpoint need rate limiting + input validation?

## INSA CSMS Security Controls (must not regress)

| Control | Implementation |
|---------|----------------|
| Account lockout | 5 attempts → 15 min (`login_screen.dart`) |
| Session timeout | 10 min inactivity (`_InactivityWrapper` in `main.dart`) |
| App lock | PIN/biometric after 60s background (`_AppLockWrapper` in `main.dart`) |
| Password policy | Min 8 chars, uppercase, digit, special char |
| Audit log | Tamper-evident chained hash (`security_log_service.dart`) |
| PII encryption | `full_name`, `phone`, `kyc_id_number` encrypted via Fernet (backend) |
| Security headers | HSTS, X-Frame-Options, CSP, Referrer-Policy (backend `app.py`) |
| CORS | Restricted to known origins |
| No hardcoded secrets | Never commit API keys or credentials |

Target maturity: **Advanced (91–100)** on INSA Cyber Security Audit and Evaluation Guideline v1.0.

## Web Deployment (tradet.amber.et)

Server runs Nginx. Key config requirement:

```nginx
location / {
    try_files $uri $uri/ /index.html;  # required for Flutter web routing
}
```

Deploy steps:
```bash
flutter build web --release
rsync -avz --delete tradet_app/build/web/ user@tradet.amber.et:/var/www/tradet/
```

## Dependencies (pubspec.yaml highlights)

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `http` | REST API calls |
| `fl_chart` | Charts (candlestick, mini charts) |
| `pdf` + `printing` | CSMS PDF export |
| `local_auth` | Biometric app lock |
| `flutter_secure_storage` | Secure token storage |
| `google_fonts` | Typography |
| `intl` | Date/number formatting + localization |
