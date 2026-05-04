import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../white_label.dart';
import '../widgets/disclaimer_footer.dart';
import '../widgets/responsive_layout.dart';
import '../l10n/app_localizations.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NewsArticle> _articles = [];
  bool _loading = true;
  String? _error;
  String? _currentCategory;

  // Static values used for tab logic (initState, _onTabChanged) — no l10n needed
  static const _categoryValues = <String?>[null, 'research', 'ethiopia', 'islamic', 'global'];

  List<Map<String, String?>> _getCategories(AppLocalizations l) => [
    {'label': l.newsAll, 'value': null},
    {'label': l.newsResearch, 'value': 'research'},
    {'label': l.newsEthiopia, 'value': 'ethiopia'},
    {'label': l.newsIslamicFinance, 'value': 'islamic'},
    {'label': l.newsGlobal, 'value': 'global'},
  ];

  List<NewsArticle> _filterArticles(List<NewsArticle> all) {
    if (_currentCategory == 'research') {
      return all.where((a) {
        final text = '${a.title} ${a.description} ${a.source}'.toLowerCase();
        return WhiteLabel.researchKeywords.any((kw) => text.contains(kw));
      }).toList();
    }
    return all;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categoryValues.length, vsync: this);
    _allArticles = [];
    _tabController.addListener(_onTabChanged);
    _loadNews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NewsArticle> _allArticles = [];

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final cat = _categoryValues[_tabController.index];
    if (cat != _currentCategory) {
      _currentCategory = cat;
      // fab_research filters locally — no network call needed
      if (cat == 'research') {
        setState(() { _articles = _filterArticles(_allArticles); });
      } else {
        _loadNews();
      }
    }
  }

  Future<void> _loadNews() async {
    setState(() { _loading = true; _error = null; });
    try {
      final api = context.read<AppProvider>().api;
      // fetch all articles for local filtering
      final fetchCat = _currentCategory == 'research' ? null : _currentCategory;
      final fetched = await api.getNews(category: fetchCat);
      _allArticles = fetched;
      _articles = _filterArticles(fetched);
    } catch (e) {
      _error = 'error'; // non-null sentinel; message resolved via l10n in build
    }
    if (mounted) setState(() => _loading = false);
  }

  void _copyUrl(String url) {
    Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).linkCopied),
          backgroundColor: TradEtTheme.positive,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final wide = isWideScreen(context);

    final content = Container(
      decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!wide && Navigator.of(context).canPop())
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: l.back,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      Expanded(
                        child: Text(l.newsFeedTitle, style: const TextStyle(fontSize: 22,
                            fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: !wide && Navigator.of(context).canPop() ? 36 : 0),
                    child: Text(l.financialIslamicNews,
                        style: const TextStyle(fontSize: 13, color: TradEtTheme.textSecondary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Category tabs
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: TradEtTheme.positive,
              unselectedLabelColor: TradEtTheme.textMuted,
              indicatorColor: TradEtTheme.positive,
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.symmetric(horizontal: wide ? 24 : 12),
              tabs: _getCategories(l).map((c) => Tab(text: c['label'] as String)).toList(),
            ),
            const SizedBox(height: 8),

            // Articles list
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: TradEtTheme.positive))
                  : _error != null
                      ? Center(child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off, color: TradEtTheme.textMuted, size: 48),
                            const SizedBox(height: 12),
                            Text(l.failedToLoadNews, style: const TextStyle(color: TradEtTheme.textMuted)),
                            const SizedBox(height: 12),
                            TextButton(onPressed: _loadNews,
                                child: Text(l.retry)),
                          ],
                        ))
                      : _articles.isEmpty
                          ? Center(child: Text(l.noNewsAvailable,
                              style: const TextStyle(color: TradEtTheme.textMuted)))
                          : RefreshIndicator(
                              onRefresh: _loadNews,
                              color: TradEtTheme.positive,
                              child: ListView.builder(
                                padding: EdgeInsets.fromLTRB(
                                    wide ? 32 : 16, 0, wide ? 32 : 16, 16),
                                itemCount: _articles.length + 1,
                                itemBuilder: (ctx, i) {
                                  if (i == _articles.length) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: DisclaimerFooter(),
                                    );
                                  }
                                  return _buildArticleCard(_articles[i]);
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );

    return content;
  }

  Widget _buildArticleCard(NewsArticle article) {
    final isResearch = _currentCategory == 'research';
    final categoryColor = isResearch
        ? WhiteLabel.brandAccent
        : switch (article.category) {
            'ethiopia' => const Color(0xFF60A5FA),
            'islamic' => TradEtTheme.accent,
            _ => TradEtTheme.positive,
          };

    return GestureDetector(
      onTap: () => _copyUrl(article.link),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TradEtTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(article.source,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                          color: categoryColor)),
                ),
                const Spacer(),
                Text(article.publishedAt.length > 16
                    ? article.publishedAt.substring(0, 16) : article.publishedAt,
                    style: const TextStyle(fontSize: 10, color: TradEtTheme.textMuted)),
              ],
            ),
            const SizedBox(height: 10),
            Text(article.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: Colors.white, height: 1.3),
                maxLines: 3, overflow: TextOverflow.ellipsis),
            if (article.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(article.description,
                  style: const TextStyle(fontSize: 12, color: TradEtTheme.textSecondary,
                      height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(article.category.toUpperCase(),
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                          color: categoryColor, letterSpacing: 0.5)),
                ),
                const Spacer(),
                Icon(Icons.open_in_new, size: 14, color: TradEtTheme.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
