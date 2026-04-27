import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../theme.dart';
import '../utils/asset_emoji.dart';
import '../widgets/sharia_badge.dart';
import '../widgets/price_change.dart';
import '../widgets/mini_chart.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/data_source_badge.dart';
import 'trade_screen.dart';
import '../widgets/disclaimer_footer.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _filter = 'all';
  bool _shariaOnly = false;
  String? _selectedCategory; // when set, shows flat list for that category
  final _fmt = NumberFormat('#,##0.00', 'en');
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadWatchlist();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Asset> _filteredAssets(AppProvider provider) {
    return provider.assets.where((a) {
      // Hide foreign/global equities (frontend-only filter)
      if (a.categoryName?.toLowerCase().contains('global') == true) return false;
      if (_shariaOnly && !a.isShariaCompliant) return false;
      if (_selectedCategory != null && a.categoryName != _selectedCategory) return false;
      if (_filter != 'all' && _selectedCategory == null && a.categoryType != _filter) return false;
      if (_searchQuery.isNotEmpty) {
        return a.symbol.toLowerCase().contains(_searchQuery) ||
            a.name.toLowerCase().contains(_searchQuery) ||
            (a.nameAm?.toLowerCase().contains(_searchQuery) ?? false) ||
            (a.categoryName?.toLowerCase().contains(_searchQuery) ?? false);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);

    return Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                wide ? 32 : 20,
                wide ? 24 : 16,
                wide ? 32 : 20,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _shariaOnly
                              ? AppLocalizations.of(context).shariaCompliantStocks
                              : AppLocalizations.of(context).market,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Consumer<AppProvider>(
                          builder: (_, p, __) {
                            final l = AppLocalizations.of(context);
                            final invested = p.holdings.length;
                            return Text(
                              _shariaOnly && invested > 0
                                  ? '${l.investedIn} $invested assets'
                                  : 'ገበያ • ${_getFilterLabel()}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: TradEtTheme.textSecondary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _circleButton(Icons.refresh_rounded, () {
                    context.read<AppProvider>().loadAssets(
                      shariaOnly: _shariaOnly,
                      refresh: true,
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search + filters
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 20),
              child: wide ? _webSearchBar() : _mobileSearchBar(),
            ),
            const SizedBox(height: 12),

            if (!wide) ...[
              if (_selectedCategory != null)
                // Breadcrumb back button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = null),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.arrow_back_ios_rounded,
                          size: 14, color: TradEtTheme.positive),
                      const SizedBox(width: 4),
                      const Text('All Categories',
                          style: TextStyle(
                              fontSize: 13,
                              color: TradEtTheme.positive,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text('• $_selectedCategory',
                          style: const TextStyle(
                              fontSize: 13, color: TradEtTheme.textMuted)),
                    ]),
                  ),
                )
              else
                // Mobile filter pills
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _filterPill('All', 'all'),
                      _filterPill('Commodities', 'commodity'),
                      _filterPill('Sukuk', 'sukuk'),
                      _filterPill('Equities', 'equity'),
                      const SizedBox(width: 8),
                      _halalToggle(),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
            ],

            // Asset list / table
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, provider, _) {
                  if (provider.assetsLoading && provider.assets.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: TradEtTheme.positive,
                      ),
                    );
                  }

                  if (provider.assetsError != null && provider.assets.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_off_rounded,
                              size: 48,
                              color: TradEtTheme.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              provider.assetsError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: TradEtTheme.textMuted,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => provider.loadAssets(
                                shariaOnly: _shariaOnly,
                                refresh: true,
                              ),
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final filtered = _filteredAssets(provider);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: TradEtTheme.textMuted,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No assets found',
                            style: TextStyle(color: TradEtTheme.textMuted),
                          ),
                        ],
                      ),
                    );
                  }

                  if (wide) {
                    return _buildWebTable(filtered);
                  }
                  // Mobile: sections view when browsing all, flat list when searching/filtering
                  final showSections = _filter == 'all' &&
                      _searchQuery.isEmpty &&
                      !_shariaOnly &&
                      _selectedCategory == null;
                  if (showSections) {
                    return _buildMobileSections(provider, filtered);
                  }
                  return _buildMobileList(provider, filtered);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Web: Search bar with inline filters ───
  Widget _webSearchBar() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search stocks, commodities, sukuk...',
              prefixIcon: Icon(
                Icons.search,
                color: TradEtTheme.textMuted,
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: TradEtTheme.textMuted,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Inline filter chips
        _filterPill('All', 'all'),
        _filterPill('Commodities', 'commodity'),
        _filterPill('Sukuk', 'sukuk'),
        _filterPill('Equities', 'equity'),
        const SizedBox(width: 8),
        _halalToggle(),
      ],
    );
  }

  Widget _mobileSearchBar() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
      decoration: InputDecoration(
        hintText: 'Search stocks, commodities...',
        prefixIcon: Icon(Icons.search, color: TradEtTheme.textMuted, size: 20),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 18,
                  color: TradEtTheme.textMuted,
                ),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
      ),
    );
  }

  // ─── Web: Data table view — grouped by category when browsing all ───
  Widget _buildWebTable(List<Asset> filtered) {
    final showGrouped = _filter == 'all' &&
        _searchQuery.isEmpty &&
        !_shariaOnly &&
        _selectedCategory == null;

    // Build flat items list, inserting category headers when grouped
    final List<Widget> rows = [];
    if (showGrouped) {
      const categoryOrder = [
        'ECX Commodities', 'Islamic Banks', 'Ethiopian Equities',
        'Takaful & Insurance', 'Sukuk',
      ];
      final Map<String, List<Asset>> byCategory = {};
      for (final a in filtered) {
        byCategory.putIfAbsent(a.categoryName ?? 'Other', () => []).add(a);
      }
      final orderedKeys = [
        ...categoryOrder.where((c) => byCategory.containsKey(c)),
        ...byCategory.keys.where((c) => !categoryOrder.contains(c)),
      ];
      int globalIdx = 0;
      for (final cat in orderedKeys) {
        final assets = byCategory[cat]!;
        rows.add(_WebCategoryHeader(categoryName: cat, count: assets.length));
        for (final a in assets) {
          rows.add(_WebAssetRow(asset: a, fmt: _fmt, isEven: globalIdx.isEven));
          globalIdx++;
        }
      }
    } else {
      for (int i = 0; i < filtered.length; i++) {
        rows.add(_WebAssetRow(asset: filtered[i], fmt: _fmt, isEven: i.isEven));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Breadcrumb for category drill-down on web
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedCategory = null),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.arrow_back_ios_rounded,
                        size: 13, color: TradEtTheme.positive),
                    SizedBox(width: 4),
                    Text('All Categories',
                        style: TextStyle(
                            fontSize: 13,
                            color: TradEtTheme.positive,
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
                const SizedBox(width: 8),
                Text('› $_selectedCategory',
                    style: const TextStyle(
                        fontSize: 13, color: TradEtTheme.textMuted)),
              ]),
            ),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: TradEtTheme.primaryDark.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              border: Border.all(
                color: TradEtTheme.divider.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 44), // icon space
                SizedBox(width: 12),
                Expanded(flex: 2, child: _TableHeader('Asset')),
                Expanded(flex: 2, child: _TableHeader('Category')),
                Expanded(flex: 1, child: _TableHeader('Bid')),
                Expanded(flex: 1, child: _TableHeader('Ask')),
                SizedBox(width: 60, child: _TableHeader('Chart')),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _TableHeader('Price'),
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _TableHeader('24h Change'),
                  ),
                ),
                SizedBox(width: 160), // Buy/Sell + star + bell
              ],
            ),
          ),
          // Table body
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: TradEtTheme.divider.withValues(alpha: 0.3),
                  ),
                  right: BorderSide(
                    color: TradEtTheme.divider.withValues(alpha: 0.3),
                  ),
                  bottom: BorderSide(
                    color: TradEtTheme.divider.withValues(alpha: 0.3),
                  ),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
              ),
              child: ListView.builder(
                itemCount: rows.length + 1,
                itemBuilder: (context, index) {
                  if (index == rows.length) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: DisclaimerFooter(),
                    );
                  }
                  return rows[index];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Mobile: Categorized sections view (default) ───
  Widget _buildMobileSections(AppProvider provider, List<Asset> assets) {
    // Define the desired category display order
    const categoryOrder = [
      'ECX Commodities',
      'Islamic Banks',
      'Ethiopian Equities',
      'Takaful & Insurance',
      'Sukuk',
    ];
    final Map<String, List<Asset>> byCategory = {};
    for (final a in assets) {
      final cat = a.categoryName ?? 'Other';
      byCategory.putIfAbsent(cat, () => []).add(a);
    }
    // Sort categories: known order first, then any extras
    final orderedKeys = [
      ...categoryOrder.where((c) => byCategory.containsKey(c)),
      ...byCategory.keys.where((c) => !categoryOrder.contains(c)),
    ];

    return RefreshIndicator(
      color: TradEtTheme.positive,
      backgroundColor: TradEtTheme.cardBg,
      onRefresh: () => provider.loadAssets(shariaOnly: _shariaOnly, refresh: true),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
        children: [
          for (final cat in orderedKeys) ...[
            _buildCategorySection(cat, byCategory[cat]!),
            const SizedBox(height: 16),
          ],
          const DisclaimerFooter(),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String categoryName, List<Asset> assets) {
    final emoji = _categoryEmoji(categoryName);
    final sortedByChange = [...assets]
      ..sort((a, b) => (b.change24h ?? 0).compareTo(a.change24h ?? 0));
    final preview = sortedByChange.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        color: TradEtTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(categoryName,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
                Text('${assets.length} assets',
                    style: const TextStyle(
                        fontSize: 11, color: TradEtTheme.textMuted)),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => setState(() => _selectedCategory = categoryName),
                  child: const Text('See all →',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: TradEtTheme.positive)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x22FFFFFF)),
          // Asset rows
          ...preview.map((a) => _CategoryAssetRow(asset: a, fmt: _fmt)),
        ],
      ),
    );
  }

  // ─── Mobile: Flat card list (search / filter / category drill-down) ───
  Widget _buildMobileList(AppProvider provider, List<Asset> filtered) {
    return RefreshIndicator(
      color: TradEtTheme.positive,
      backgroundColor: TradEtTheme.cardBg,
      onRefresh: () =>
          provider.loadAssets(shariaOnly: _shariaOnly, refresh: true),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
        itemCount: filtered.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          if (index == filtered.length) {
            return const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 4),
              child: DisclaimerFooter(),
            );
          }
          return _AssetCard(asset: filtered[index], fmt: _fmt);
        },
      ),
    );
  }

  String _getFilterLabel() {
    switch (_filter) {
      case 'commodity':
        return 'ECX Commodities';
      case 'sukuk':
        return 'Sukuk Bonds';
      case 'equity':
        return 'Halal Equities';
      default:
        return '38 Halal Assets';
    }
  }

  Widget _filterPill(String label, String value) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? TradEtTheme.primaryLight : TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? TradEtTheme.primaryLight : TradEtTheme.divider,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : TradEtTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _halalToggle() {
    return GestureDetector(
      onTap: () {
        setState(() => _shariaOnly = !_shariaOnly);
        context.read<AppProvider>().loadAssets(shariaOnly: _shariaOnly);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _shariaOnly
                ? TradEtTheme.positive.withValues(alpha: 0.15)
                : TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _shariaOnly
                  ? TradEtTheme.positive.withValues(alpha: 0.3)
                  : TradEtTheme.divider,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              if (_shariaOnly)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: TradEtTheme.positive,
                  ),
                ),
              Text(
                'Halal Only',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _shariaOnly
                      ? TradEtTheme.positive
                      : TradEtTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: TradEtTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TradEtTheme.divider),
          ),
          child: Icon(icon, size: 20, color: TradEtTheme.textSecondary),
        ),
      ),
    );
  }
}

// Delegates to shared utilities in lib/utils/asset_emoji.dart
String _assetEmoji(String symbol, String? categoryName) =>
    assetEmoji(symbol, categoryName);

String _categoryEmoji(String category) => categoryEmoji(category);

// ─── Mobile: single asset row inside a category section ───
class _CategoryAssetRow extends StatelessWidget {
  final Asset asset;
  final NumberFormat fmt;
  const _CategoryAssetRow({required this.asset, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isUp = (asset.change24h ?? 0) >= 0;
    final emoji = _assetEmoji(asset.symbol, asset.categoryName);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(appRoute(context, TradeScreen(asset: asset))),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.12)),
            ),
          ),
          child: Row(
            children: [
              // Emoji circle
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: TradEtTheme.surfaceLight.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              // Symbol + name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(asset.symbol,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        const SizedBox(width: 4),
                        const Text('🇪🇹', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    Text(asset.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: TradEtTheme.textMuted)),
                  ],
                ),
              ),
              // Price + change
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    asset.price != null ? '${fmt.format(asset.price)} ETB' : '—',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  if (asset.change24h != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUp ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                          size: 14,
                          color: isUp ? TradEtTheme.positive : TradEtTheme.negative,
                        ),
                        Text(
                          '${asset.change24h!.abs().toStringAsFixed(2)}%',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isUp ? TradEtTheme.positive : TradEtTheme.negative),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(width: 8),
              // Trade icon button
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(appRoute(context, TradeScreen(asset: asset))),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: TradEtTheme.positive.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: TradEtTheme.positive.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.swap_horiz_rounded,
                        size: 18, color: TradEtTheme.positive),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Web: Category group header row in table ───
class _WebCategoryHeader extends StatelessWidget {
  final String categoryName;
  final int count;
  const _WebCategoryHeader({required this.categoryName, required this.count});

  @override
  Widget build(BuildContext context) {
    final emoji = _categoryEmoji(categoryName);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: TradEtTheme.primaryDark.withValues(alpha: 0.4),
        border: Border(
          top: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.2)),
          bottom: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Text(categoryName,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: TradEtTheme.textSecondary,
                  letterSpacing: 0.3)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: TradEtTheme.positive.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count',
                style: const TextStyle(
                    fontSize: 10,
                    color: TradEtTheme.positive,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─── Table header text ───
class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: TradEtTheme.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ─── Web asset row (table style) ───
class _WebAssetRow extends StatefulWidget {
  final Asset asset;
  final NumberFormat fmt;
  final bool isEven;

  const _WebAssetRow({
    required this.asset,
    required this.fmt,
    required this.isEven,
  });

  @override
  State<_WebAssetRow> createState() => _WebAssetRowState();
}

class _WebAssetRowState extends State<_WebAssetRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.of(
          context,
        ).push(appRoute(context, TradeScreen(asset: asset))),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hovering
                ? TradEtTheme.surfaceLight.withValues(alpha: 0.5)
                : widget.isEven
                ? TradEtTheme.cardBg.withValues(alpha: 0.3)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: TradEtTheme.divider.withValues(alpha: 0.15),
              ),
            ),
          ),
          child: Row(
            children: [
              // Emoji logo circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _categoryColor(asset).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _categoryColor(asset).withValues(alpha: 0.35)),
                ),
                alignment: Alignment.center,
                child: Text(
                  _assetEmoji(asset.symbol, asset.categoryName),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              // Asset name
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          asset.symbol,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('🇪🇹', style: TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                        ShariaBadge(
                          isCompliant: asset.isShariaCompliant,
                          complianceLevel: asset.complianceLevel,
                          compact: true,
                        ),
                        if (asset.isEcxListed) ...[
                          const SizedBox(width: 3),
                          const EcxBadge(),
                        ],
                      ],
                    ),
                    Text(
                      asset.name,
                      style: const TextStyle(
                        fontSize: 11,
                        color: TradEtTheme.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Category
              Expanded(
                flex: 2,
                child: Text(
                  asset.categoryName ?? '--',
                  style: const TextStyle(
                    fontSize: 12,
                    color: TradEtTheme.textSecondary,
                  ),
                ),
              ),
              // Bid
              Expanded(
                flex: 1,
                child: Text(
                  asset.bidPrice != null
                      ? widget.fmt.format(asset.bidPrice)
                      : '—',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              // Ask
              Expanded(
                flex: 1,
                child: Text(
                  asset.askPrice != null
                      ? widget.fmt.format(asset.askPrice)
                      : '—',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              // Sparkline
              SizedBox(
                width: 60,
                height: 28,
                child: asset.sparkline.length >= 2
                    ? MiniSparkline(
                        data: asset.sparkline,
                        height: 28,
                        width: 60,
                      )
                    : const SizedBox.shrink(),
              ),
              // Price
              Expanded(
                flex: 1,
                child: Text(
                  asset.price != null ? widget.fmt.format(asset.price) : '—',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              // 24h Change
              SizedBox(
                width: 110,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: asset.change24h != null
                      ? PriceChange(change: asset.change24h!, fontSize: 11)
                      : const Text(
                          '—',
                          style: TextStyle(
                            color: TradEtTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                ),
              ),
              // Quick actions: watchlist + alert
              _QuickActions(asset: asset),
            ],
          ),
        ),
      ),
    );
  }

  Color _categoryColor(Asset asset) {
    switch (asset.categoryName) {
      case 'Islamic Banks':
        return TradEtTheme.positive;
      case 'Halal Global Equities':
        return const Color(0xFF818CF8);
      case 'Takaful & Insurance':
        return TradEtTheme.accent;
      case 'Sukuk':
        return const Color(0xFF22D3EE);
      case 'Ethiopian Equities':
        return const Color(0xFFF472B6);
      default:
        return const Color(0xFFFBBF24);
    }
  }

  IconData _categoryIcon(Asset asset) {
    switch (asset.categoryName) {
      case 'Islamic Banks':
        return Icons.account_balance_rounded;
      case 'Halal Global Equities':
        return Icons.public_rounded;
      case 'Takaful & Insurance':
        return Icons.shield_rounded;
      case 'Sukuk':
        return Icons.receipt_rounded;
      case 'Ethiopian Equities':
        return Icons.business_rounded;
      default:
        return Icons.eco_rounded;
    }
  }
}

// ─── Compact trade button used in market list ───
class _MktBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MktBtn(this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ),
      ),
    );
  }
}

// ─── Mobile: Asset Card (fixed layout — no overlap) ───
class _AssetCard extends StatelessWidget {
  final Asset asset;
  final NumberFormat fmt;

  const _AssetCard({required this.asset, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(appRoute(context, TradeScreen(asset: asset))),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            // Emoji logo circle
            // Emoji logo circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _categoryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: _categoryColor.withValues(alpha: 0.35)),
              ),
              alignment: Alignment.center,
              child: Text(
                _assetEmoji(asset.symbol, asset.categoryName),
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(width: 10),
            // Name + badges
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        asset.symbol,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      const Text('🇪🇹', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    asset.name,
                    style: const TextStyle(
                      fontSize: 11,
                      color: TradEtTheme.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Price + change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  asset.price != null ? fmt.format(asset.price) : '—',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                if (asset.change24h != null) ...[
                  const SizedBox(height: 3),
                  PriceChange(change: asset.change24h!, fontSize: 11),
                ],
              ],
            ),
            const SizedBox(width: 10),
            // Trade icon button
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(appRoute(context, TradeScreen(asset: asset))),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: TradEtTheme.primaryLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: TradEtTheme.primaryLight.withValues(alpha: 0.35)),
                ),
                child: const Icon(Icons.swap_horiz_rounded,
                    size: 18, color: TradEtTheme.primaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _categoryColor {
    switch (asset.categoryName) {
      case 'Islamic Banks':
        return TradEtTheme.positive;
      case 'Halal Global Equities':
        return const Color(0xFF818CF8);
      case 'Takaful & Insurance':
        return TradEtTheme.accent;
      case 'Sukuk':
        return const Color(0xFF22D3EE);
      case 'Ethiopian Equities':
        return const Color(0xFFF472B6);
      default:
        return const Color(0xFFFBBF24);
    }
  }

  IconData get _categoryIcon {
    switch (asset.categoryName) {
      case 'Islamic Banks':
        return Icons.account_balance_rounded;
      case 'Halal Global Equities':
        return Icons.public_rounded;
      case 'Takaful & Insurance':
        return Icons.shield_rounded;
      case 'Sukuk':
        return Icons.receipt_rounded;
      case 'Ethiopian Equities':
        return Icons.business_rounded;
      default:
        return Icons.eco_rounded;
    }
  }
}

// ─── Quick actions: watchlist star + alert bell ───
class _QuickActions extends StatelessWidget {
  final Asset asset;
  const _QuickActions({required this.asset});

  void _showCreateAlert(BuildContext context) {
    final provider = context.read<AppProvider>();
    final priceCtrl = TextEditingController(
      text: asset.price?.toStringAsFixed(2) ?? '',
    );
    String condition = 'above';
    final fmt = NumberFormat('#,##0.00');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: TradEtTheme.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Alert: ${asset.symbol}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (asset.price != null)
                  Text(
                    'Current: ${fmt.format(asset.price)} ETB',
                    style: const TextStyle(
                      fontSize: 12,
                      color: TradEtTheme.textSecondary,
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Target Price (ETB)',
                    suffixText: 'ETB',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setDialogState(() => condition = 'above'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: condition == 'above'
                                ? TradEtTheme.positive.withValues(alpha: 0.2)
                                : TradEtTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: condition == 'above'
                                  ? TradEtTheme.positive
                                  : TradEtTheme.divider,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 16,
                                  color: condition == 'above'
                                      ? TradEtTheme.positive
                                      : TradEtTheme.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Above',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: condition == 'above'
                                        ? TradEtTheme.positive
                                        : TradEtTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setDialogState(() => condition = 'below'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: condition == 'below'
                                ? TradEtTheme.negative.withValues(alpha: 0.2)
                                : TradEtTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: condition == 'below'
                                  ? TradEtTheme.negative
                                  : TradEtTheme.divider,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_down,
                                  size: 16,
                                  color: condition == 'below'
                                      ? TradEtTheme.negative
                                      : TradEtTheme.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Below',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: condition == 'below'
                                        ? TradEtTheme.negative
                                        : TradEtTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(color: TradEtTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final price = double.tryParse(priceCtrl.text);
                if (price == null) return;
                Navigator.pop(ctx);
                try {
                  await provider.api.createAlert(
                    assetId: asset.id,
                    targetPrice: price,
                    condition: condition,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Alert set for ${asset.symbol}'),
                        backgroundColor: TradEtTheme.positive,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (_) {}
              },
              child: const Text('Create Alert'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 20.0;
    const padding = 6.0;

    // GestureDetector with empty onTap stops taps on icons from bubbling
    // up to the parent row GestureDetector (which would navigate to TradeScreen)
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final inWatchlist = provider.watchlist.any(
            (a) => a.id == asset.id || a.symbol == asset.symbol,
          );

          final hasCash = provider.availableCashBalance > 0;
          final hasHolding = provider.holdings.any(
              (h) => h.assetId == asset.id || h.symbol == asset.symbol);
          return SizedBox(
            width: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Sell button first
                if (hasHolding) ...[
                  _MktBtn('Sell', TradEtTheme.negative,
                      () => Navigator.of(context).push(
                          appRoute(context, TradeScreen(asset: asset, initialSell: true)))),
                  const SizedBox(width: 6),
                ],
                // Buy button after
                if (hasCash) ...[
                  _MktBtn('Buy', TradEtTheme.positive,
                      () => Navigator.of(context).push(
                          appRoute(context, TradeScreen(asset: asset)))),
                  const SizedBox(width: 4),
                ],
                // Watchlist star toggle — uses Listener to stop parent tap
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (inWatchlist) {
                        provider.removeFromWatchlist(asset.id);
                      } else {
                        provider.addToWatchlist(asset.id);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Icon(
                        inWatchlist
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: iconSize,
                        color: inWatchlist
                            ? const Color(0xFFFF8C00)
                            : TradEtTheme.textMuted,
                      ),
                    ),
                  ),
                ),
                // Alert bell
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _showCreateAlert(context),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Icon(
                        Icons.notifications_outlined,
                        size: iconSize,
                        color: TradEtTheme.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
