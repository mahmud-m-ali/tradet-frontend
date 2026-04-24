// Shared emoji logo helpers — single source of truth for asset and category icons.
// Import this wherever you need to display asset/category emojis.

String assetEmoji(String symbol, String? categoryName) {
  final s = symbol.toUpperCase();
  final cat = categoryName?.toLowerCase() ?? '';

  // ── Specific bank / Islamic symbols ───────────────────────────────────────
  if (s == 'ZAMZAM' || s.contains('ZAMZAM')) return '🕌';
  if (s == 'HIJRA' || s.contains('HIJRA')) return '🕌';
  if (s == 'BUNNA' || s.startsWith('BUNNA')) return '☕';
  if (s == 'COOP' || s.contains('COOP')) return '🏛️';
  if (s == 'CBE' || s == 'CBEBANK') return '🏦';
  if (s == 'SHABELLE' || s.contains('SHABELLE')) return '🏦';
  if (s == 'RAMMIS' || s.contains('RAMMIS')) return '🏦';
  if (s == 'ENAT' || s.contains('ENAT')) return '🏦';
  if (s == 'ABAY' || s.contains('ABAY')) return '🏦';
  if (s == 'NIBE' || s == 'NIB' || s.contains('NIB')) return '🏦';
  if (s == 'OROMIA' || s.contains('OROMIA')) return '🌍';
  if (s == 'WEGAGEN' || s.contains('WEGAGEN')) return '🏦';
  if (s == 'DASHEN' || s.contains('DASHEN')) return '🏦';
  if (s == 'AWASH' || s.contains('AWASH')) return '🏦';
  if (s == 'BERHAN' || s.contains('BERHAN')) return '🏦';
  if (s == 'ZEMEN' || s.contains('ZEMEN')) return '🏦';

  // ── Takaful / Insurance ────────────────────────────────────────────────────
  if (s == 'EIC' || s.contains('EIC')) return '🛡️';
  if (s.contains('TAKAFUL') || s.contains('INSUR')) return '🛡️';

  // ── Sukuk / Bonds ──────────────────────────────────────────────────────────
  if (s.contains('SUKUK') || s.contains('GOV') || s.contains('BOND')) return '📜';

  // ── ECX Commodities ────────────────────────────────────────────────────────
  if (s.contains('COFFEE') || s.contains('CFEX')) return '☕';
  if (s.contains('SESAME') || s == 'SESAME-R' || s == 'SESAME-W') return '🌾';
  if (s.contains('NOOG') || s.contains('NIGER')) return '🌿';
  if (s.contains('MAIZE') || s.contains('CORN')) return '🌽';
  if (s.contains('BEAN') || s.contains('HARICOT')) return '🫘';
  if (s.contains('SOY') || s.contains('SOYA')) return '🌱';
  if (s.contains('CHICKPEA') || s.contains('PEA')) return '🥜';
  if (s.contains('WHEAT')) return '🌾';
  if (s.contains('SORGHUM') || s.contains('SORGH') || s.contains('TEFF')) return '🌾';
  if (s.contains('WGBX') || s.contains('GRAIN')) return '🌾';
  if (s.contains('GOLD')) return '🥇';
  if (s.contains('HALAL') || s.contains('FOOD') || s.contains('FD')) return '🍃';
  if (s.contains('GDAX') || s.contains('INDEX')) return '📊';
  if (s.contains('ETHA') || s.contains('ETH')) return '🌍';

  // ── Category fallbacks ─────────────────────────────────────────────────────
  if (cat.contains('islamic bank') || cat.contains('islamic')) return '🕌';
  if (cat.contains('bank')) return '🏦';
  if (cat.contains('insurance') || cat.contains('takaful')) return '🛡️';
  if (cat.contains('sukuk')) return '📜';
  if (cat.contains('equity') || cat.contains('equities')) return '📈';
  if (cat.contains('commodity') || cat.contains('ecx')) return '🌿';
  return '🌿';
}

String categoryEmoji(String category) {
  final c = category.toLowerCase();
  if (c.contains('commodity') || c.contains('ecx')) return '🌾';
  if (c.contains('islamic bank') || c.contains('bank')) return '🏦';
  if (c.contains('insurance') || c.contains('takaful')) return '🛡️';
  if (c.contains('sukuk')) return '📜';
  if (c.contains('equity') || c.contains('equit')) return '📈';
  if (c.contains('halal') || c.contains('food')) return '🍃';
  return '🌿';
}
