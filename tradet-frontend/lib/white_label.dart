/// White-label configuration for TradEt.
/// Change these values to rebrand the app for a specific bank partner.
///
/// To activate a bank preset: fill in the fields below and rebuild.
library;

import 'package:flutter/material.dart';

/// Active brand configuration — edit these values to rebrand.
class WhiteLabel {
  static const String appName = 'TradEt';
  static const String appNameAmharic = 'ትሬድኢት';
  static const String bankName = 'Amber';
  static const String tagline = 'Sharia-Compliant Trading';
  static const String taglineAmharic = 'ሸሪዓ-ተኳሃኝ ንግድ';
  static const Color brandColor = Color(0xFF1B8A5A); // Primary green
  static const Color brandAccent = Color(0xFFD4AF37); // Gold
  static const String supportEmail = 'support@tradet.et';
  static const String websiteUrl = 'https://tradet.amber.et';

  // Compliance badges shown in sidebar and PDF footer
  static const List<String> complianceBadges = [
    'AAOIFI Certified',
    'ECX Licensed',
    'NBE Regulated',
  ];

  // PDF export header
  static const String pdfHeaderTitle = 'TradEt — Sharia-Compliant Trading Platform';
  static const String pdfComplianceFooter =
      'Sharia Board Compliance Certified — AAOIFI Standard No. 21 Applied\n'
      'Regulated by Ethiopia Commodity Exchange Authority (ECEA) & National Bank of Ethiopia (NBE)';

  // Research tab label in News screen — shown as "[bankName] Research"
  // Keywords used to filter research-relevant articles
  static const List<String> researchKeywords = [
    'ecx', 'ethiopia commodity', 'nbe', 'national bank of ethiopia',
    'investment', 'capital market', 'ecea', 'securities', 'equity',
    'commodity', 'coffee', 'sesame', 'sharia', 'islamic finance',
    'trade finance', 'privatization', 'ipo', 'listing',
  ];
}
