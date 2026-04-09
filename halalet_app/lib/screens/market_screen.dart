import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../theme.dart';
import '../widgets/sharia_badge.dart';
import '../widgets/price_change.dart';
import '../widgets/mini_chart.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/data_source_badge.dart';
import 'trade_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _filter = 'all';
  bool _shariaOnly = false;
  final _fmt = NumberFormat('#,##0.00', 'en');
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Asset> _filteredAssets(AppProvider provider) {
    return provider.assets.where((a) {
      if (_filter != 'all' && a.categoryType != _filter) return false;
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
      decoration: BoxDecoration(gradient: HalalEtTheme.bgGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Market',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'ገበያ • ${_getFilterLabel()}',
                          style: const TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  _circleButton(Icons.refresh_rounded, () {
                    context.read<AppProvider>().loadAssets(shariaOnly: _shariaOnly);
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
                      child: CircularProgressIndicator(color: HalalEtTheme.positive),
                    );
                  }

                  if (provider.assetsError != null && provider.assets.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_off_rounded, size: 48, color: HalalEtTheme.textMuted),
                            const SizedBox(height: 12),
                            Text(provider.assetsError!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: HalalEtTheme.textMuted, fontSize: 14)),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => provider.loadAssets(shariaOnly: _shariaOnly),
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
                          Icon(Icons.search_off_rounded, size: 48, color: HalalEtTheme.textMuted),
                          const SizedBox(height: 12),
                          const Text('No assets found', style: TextStyle(color: HalalEtTheme.textMuted)),
                        ],
                      ),
                    );
                  }

                  if (wide) {
                    return _buildWebTable(filtered);
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
              prefixIcon: Icon(Icons.search, color: HalalEtTheme.textMuted, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18, color: HalalEtTheme.textMuted),
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
        prefixIcon: Icon(Icons.search, color: HalalEtTheme.textMuted, size: 20),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, size: 18, color: HalalEtTheme.textMuted),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
      ),
    );
  }

  // ─── Web: Data table view ───
  Widget _buildWebTable(List<Asset> filtered) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: HalalEtTheme.primaryDark.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
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
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: _TableHeader('Price'))),
                SizedBox(width: 80, child: Align(alignment: Alignment.centerRight, child: _TableHeader('24h Change'))),
                SizedBox(width: 80, child: Align(alignment: Alignment.center, child: _TableHeader('Compliance'))),
              ],
            ),
          ),
          // Table body
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
                  right: BorderSide(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
                  bottom: BorderSide(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final asset = filtered[index];
                  return _WebAssetRow(asset: asset, fmt: _fmt, isEven: index.isEven);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Mobile: Card list (unchanged) ───
  Widget _buildMobileList(AppProvider provider, List<Asset> filtered) {
    return RefreshIndicator(
      color: HalalEtTheme.positive,
      backgroundColor: HalalEtTheme.cardBg,
      onRefresh: () => provider.loadAssets(shariaOnly: _shariaOnly),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) => _AssetCard(asset: filtered[index], fmt: _fmt),
      ),
    );
  }

  String _getFilterLabel() {
    switch (_filter) {
      case 'commodity': return 'ECX Commodities';
      case 'sukuk': return 'Sukuk Bonds';
      case 'equity': return 'Halal Equities';
      default: return '38 Halal Assets';
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
            color: selected ? HalalEtTheme.primaryLight : HalalEtTheme.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? HalalEtTheme.primaryLight : HalalEtTheme.divider,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : HalalEtTheme.textSecondary,
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
                ? HalalEtTheme.positive.withValues(alpha: 0.15)
                : HalalEtTheme.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _shariaOnly
                  ? HalalEtTheme.positive.withValues(alpha: 0.3)
                  : HalalEtTheme.divider,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              if (_shariaOnly)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.check, size: 14, color: HalalEtTheme.positive),
                ),
              Text(
                'Halal Only',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _shariaOnly ? HalalEtTheme.positive : HalalEtTheme.textSecondary,
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
            color: HalalEtTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: HalalEtTheme.divider),
          ),
          child: Icon(icon, size: 20, color: HalalEtTheme.textSecondary),
        ),
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
        color: HalalEtTheme.textMuted,
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

  const _WebAssetRow({required this.asset, required this.fmt, required this.isEven});

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
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TradeScreen(asset: asset)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hovering
                ? HalalEtTheme.surfaceLight.withValues(alpha: 0.5)
                : widget.isEven
                    ? HalalEtTheme.cardBg.withValues(alpha: 0.3)
                    : Colors.transparent,
            border: Border(
              bottom: BorderSide(color: HalalEtTheme.divider.withValues(alpha: 0.15)),
            ),
          ),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _categoryColor(asset).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_categoryIcon(asset), color: _categoryColor(asset), size: 20),
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
                        Text(asset.symbol,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
                        const SizedBox(width: 4),
                        DataSourceBadge(dataSource: asset.dataSource),
                      ],
                    ),
                    Text(asset.name,
                        style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              // Category
              Expanded(
                flex: 2,
                child: Text(
                  asset.categoryName ?? '--',
                  style: const TextStyle(fontSize: 12, color: HalalEtTheme.textSecondary),
                ),
              ),
              // Bid
              Expanded(
                flex: 1,
                child: Text(
                  asset.bidPrice != null ? widget.fmt.format(asset.bidPrice) : '—',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              // Ask
              Expanded(
                flex: 1,
                child: Text(
                  asset.askPrice != null ? widget.fmt.format(asset.askPrice) : '—',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              // Sparkline
              SizedBox(
                width: 60,
                height: 28,
                child: asset.sparkline.length >= 2
                    ? MiniSparkline(data: asset.sparkline, height: 28, width: 60)
                    : const SizedBox.shrink(),
              ),
              // Price
              Expanded(
                flex: 1,
                child: Text(
                  asset.price != null ? widget.fmt.format(asset.price) : '—',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
              // 24h Change
              SizedBox(
                width: 80,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: asset.change24h != null
                      ? PriceChange(change: asset.change24h!, fontSize: 11)
                      : const Text('—', style: TextStyle(color: HalalEtTheme.textMuted, fontSize: 11)),
                ),
              ),
              // Compliance badges
              SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShariaBadge(isCompliant: asset.isShariaCompliant, compact: true),
                    if (asset.isEcxListed) ...[
                      const SizedBox(width: 3),
                      const EcxBadge(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _categoryColor(Asset asset) {
    switch (asset.categoryName) {
      case 'Islamic Banks': return HalalEtTheme.positive;
      case 'Halal Global Equities': return const Color(0xFF818CF8);
      case 'Takaful & Insurance': return HalalEtTheme.accent;
      case 'Sukuk': return const Color(0xFF22D3EE);
      case 'Ethiopian Equities': return const Color(0xFFF472B6);
      default: return const Color(0xFFFBBF24);
    }
  }

  IconData _categoryIcon(Asset asset) {
    switch (asset.categoryName) {
      case 'Islamic Banks': return Icons.account_balance_rounded;
      case 'Halal Global Equities': return Icons.public_rounded;
      case 'Takaful & Insurance': return Icons.shield_rounded;
      case 'Sukuk': return Icons.receipt_rounded;
      case 'Ethiopian Equities': return Icons.business_rounded;
      default: return Icons.eco_rounded;
    }
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
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TradeScreen(asset: asset)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: HalalEtTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_categoryIcon, color: _categoryColor, size: 20),
            ),
            const SizedBox(width: 10),
            // Name + badges (separate rows to avoid overlap)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.symbol,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(asset.name,
                      style: const TextStyle(fontSize: 11, color: HalalEtTheme.textMuted),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  // Badges on their own row
                  Row(
                    children: [
                      DataSourceBadge(dataSource: asset.dataSource),
                      const SizedBox(width: 4),
                      ShariaBadge(isCompliant: asset.isShariaCompliant, compact: true),
                      if (asset.isEcxListed) ...[
                        const SizedBox(width: 3),
                        const EcxBadge(),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Price + change (right side)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  asset.price != null ? fmt.format(asset.price) : '—',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 4),
                if (asset.change24h != null) PriceChange(change: asset.change24h!, fontSize: 11),
                if (asset.sparkline.length >= 2) ...[
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 40,
                    height: 16,
                    child: MiniSparkline(data: asset.sparkline, height: 16, width: 40),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color get _categoryColor {
    switch (asset.categoryName) {
      case 'Islamic Banks': return HalalEtTheme.positive;
      case 'Halal Global Equities': return const Color(0xFF818CF8);
      case 'Takaful & Insurance': return HalalEtTheme.accent;
      case 'Sukuk': return const Color(0xFF22D3EE);
      case 'Ethiopian Equities': return const Color(0xFFF472B6);
      default: return const Color(0xFFFBBF24);
    }
  }

  IconData get _categoryIcon {
    switch (asset.categoryName) {
      case 'Islamic Banks': return Icons.account_balance_rounded;
      case 'Halal Global Equities': return Icons.public_rounded;
      case 'Takaful & Insurance': return Icons.shield_rounded;
      case 'Sukuk': return Icons.receipt_rounded;
      case 'Ethiopian Equities': return Icons.business_rounded;
      default: return Icons.eco_rounded;
    }
  }
}
