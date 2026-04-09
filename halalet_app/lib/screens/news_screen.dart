import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';

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

  final _categories = [
    {'label': 'All', 'value': null},
    {'label': 'Ethiopia', 'value': 'ethiopia'},
    {'label': 'Islamic Finance', 'value': 'islamic'},
    {'label': 'Global', 'value': 'global'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadNews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final cat = _categories[_tabController.index]['value'];
    if (cat != _currentCategory) {
      _currentCategory = cat;
      _loadNews();
    }
  }

  Future<void> _loadNews() async {
    setState(() { _loading = true; _error = null; });
    try {
      final api = context.read<AppProvider>().api;
      _articles = await api.getNews(category: _currentCategory);
    } catch (e) {
      _error = 'Failed to load news';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _copyUrl(String url) {
    Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Link copied to clipboard'),
          backgroundColor: HalalEtTheme.positive,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);

    final content = Container(
      decoration: BoxDecoration(gradient: HalalEtTheme.bgGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(wide ? 32 : 20, wide ? 24 : 16, wide ? 32 : 20, 0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('News Feed', style: TextStyle(fontSize: 28,
                      fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
                  Text('ዜና • Financial & Islamic Finance News',
                      style: TextStyle(fontSize: 13, color: HalalEtTheme.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Category tabs
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: HalalEtTheme.positive,
              unselectedLabelColor: HalalEtTheme.textMuted,
              indicatorColor: HalalEtTheme.positive,
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.symmetric(horizontal: wide ? 24 : 12),
              tabs: _categories.map((c) => Tab(text: c['label'] as String)).toList(),
            ),
            const SizedBox(height: 8),

            // Articles list
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: HalalEtTheme.positive))
                  : _error != null
                      ? Center(child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off, color: HalalEtTheme.textMuted, size: 48),
                            const SizedBox(height: 12),
                            Text(_error!, style: const TextStyle(color: HalalEtTheme.textMuted)),
                            const SizedBox(height: 12),
                            TextButton(onPressed: _loadNews,
                                child: const Text('Retry')),
                          ],
                        ))
                      : _articles.isEmpty
                          ? const Center(child: Text('No news available',
                              style: TextStyle(color: HalalEtTheme.textMuted)))
                          : RefreshIndicator(
                              onRefresh: _loadNews,
                              color: HalalEtTheme.positive,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 16),
                                itemCount: _articles.length,
                                itemBuilder: (ctx, i) => _buildArticleCard(_articles[i]),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );

    if (wide) return WebContentWrapper(maxWidth: 900, child: content);
    return content;
  }

  Widget _buildArticleCard(NewsArticle article) {
    final categoryColor = switch (article.category) {
      'ethiopia' => const Color(0xFF60A5FA),
      'islamic' => HalalEtTheme.accent,
      _ => HalalEtTheme.positive,
    };

    return GestureDetector(
      onTap: () => _copyUrl(article.link),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: HalalEtTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
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
                    style: const TextStyle(fontSize: 10, color: HalalEtTheme.textMuted)),
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
                  style: const TextStyle(fontSize: 12, color: HalalEtTheme.textSecondary,
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
                Icon(Icons.open_in_new, size: 14, color: HalalEtTheme.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
