/// White-label configuration for TradEt.
/// Change these values to rebrand the app for a specific bank partner.
///
/// For FAB (First Addis Investment Bank) deployment, uncomment the FAB block below
/// and comment out the default TradEt block.
library;

import 'package:flutter/material.dart';

/// Active brand configuration — swap between presets below.
class WhiteLabel {
  // ── DEFAULT: TradEt by Amber ──────────────────────────────────────────────
  static const String appName = 'TradEt';
  static const String appNameAmharic = 'ትሬድኢት';
  static const String bankName = 'Amber';
  static const String tagline = 'Sharia-Compliant Trading';
  static const String taglineAmharic = 'ሸሪዓ-ተኳሃኝ ንግድ';
  static const Color brandColor = Color(0xFF1B8A5A); // TradEt green
  static const Color brandAccent = Color(0xFFD4AF37); // Gold
  static const String supportEmail = 'support@tradet.et';
  static const String websiteUrl = 'https://tradet.amber.et';

  // Compliance badges shown in sidebar and PDF footer
  static const List<String> complianceBadges = [
    'AAOIFI Certified',
    'ECX Licensed',
    'NBE Regulated',
  ];

  // PDF export header (used in Portfolio Statement and Security Report)
  static const String pdfHeaderTitle = 'TradEt — Sharia-Compliant Trading Platform';
  static const String pdfComplianceFooter =
      'Sharia Board Compliance Certified — AAOIFI Standard No. 21 Applied\n'
      'Regulated by Ethiopia Commodity Exchange Authority (ECEA) & National Bank of Ethiopia (NBE)';

  // ── PRESET: FAB (First Addis Investment Bank) ─────────────────────────────
  // Uncomment this block and comment the DEFAULT block above to activate FAB branding:
  //
  // static const String appName = 'FAB Digital Trading';
  // static const String appNameAmharic = 'FAB ዲጂታል ንግድ';
  // static const String bankName = 'First Addis Investment Bank';
  // static const String tagline = 'Ethiopia\'s First Investment Bank';
  // static const String taglineAmharic = 'የኢትዮጵያ መጀመሪያ ኢንቨስትመንት ባንክ';
  // static const Color brandColor = Color(0xFF1B3A6B);  // FAB navy blue
  // static const Color brandAccent = Color(0xFFE8B84B);  // FAB gold
  // static const String supportEmail = 'digital@fabinvestbank.com';
  // static const String websiteUrl = 'https://fabinvestbank.com';
  // static const List<String> complianceBadges = [
  //   'AAOIFI Certified', 'ECX Licensed', 'NBE Regulated', 'FAB Verified',
  // ];
  // static const String pdfHeaderTitle = 'FAB Digital Trading — Powered by TradEt';
  // static const String pdfComplianceFooter =
  //     'First Addis Investment Bank — Sharia Board Compliance Certified\n'
  //     'AAOIFI Standard No. 21 | ECEA Licensed | NBE Regulated';
}
