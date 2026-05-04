import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../utils/asset_emoji.dart';
import '../widgets/price_change.dart';
import '../widgets/responsive_layout.dart';
import 'trade_screen.dart';
import '../widgets/disclaimer_footer.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AppProvider>();
      p.loadWatchlist();
      // Also ensure full asset data is loaded so TradeScreen has all fields
      if (p.assets.isEmpty) p.loadAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fmt = NumberFormat('#,##0.00', 'en');
    final wide = isWideScreen(context);
    final hPad = wide ? 32.0 : 20.0;
    final showBack = !wide && Navigator.of(context).canPop();

    return Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, wide ? 24 : 16, hPad, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (showBack)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: l.back,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      Text(l.watchlist,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: showBack ? 36 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<AppProvider>(
                          builder: (_, p, __) => Text(
                            '${p.watchlist.length} ${l.assetsTracked}',
                            style: const TextStyle(
                                fontSize: 13,
                                color: TradEtTheme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── List ──
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, provider, _) {
                  final watchlist = provider.watchlist;

                  if (watchlist.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_outline_rounded,
                              size: 64,
                              color: TradEtTheme.textMuted
                                  .withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text(l.watchlistEmpty,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(height: 8),
                          Text(l.tapStarToAdd,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: TradEtTheme.textSecondary)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 24),
                    itemCount: watchlist.length + 1,
                    itemBuilder: (context, i) {
                      if (i == watchlist.length) {
                        return const Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 12),
                          child: DisclaimerFooter(),
                        );
                      }
                      final asset = watchlist[i];
                      final change = asset.change24h ?? 0.0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: TradEtTheme.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            // Tappable left area — navigate to trade
                            Expanded(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.of(context).push(appRoute(context, TradeScreen(asset: asset))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    child: Row(
                                      children: [
                                        // Emoji logo
                                        Container(
                                          width: 44, height: 44,
                                          decoration: BoxDecoration(color: TradEtTheme.surfaceLight, shape: BoxShape.circle),
                                          alignment: Alignment.center,
                                          child: Text(assetEmoji(asset.symbol, asset.categoryName), style: const TextStyle(fontSize: 20)),
                                        ),
                                        const SizedBox(width: 12),
                                        // Name + symbol
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(asset.symbol, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                                              Text(asset.name, style: const TextStyle(fontSize: 12, color: TradEtTheme.textSecondary), overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                        // Price + change
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              asset.price != null ? '${fmt.format(asset.price!)} ETB' : '--',
                                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),
                                            ),
                                            PriceChange(change: change.toDouble(), fontSize: 11),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Star remove button — completely separate tap area
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => provider.removeFromWatchlist(asset.id),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                  child: Icon(Icons.star_rounded, color: Color(0xFFFF8C00), size: 22),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
