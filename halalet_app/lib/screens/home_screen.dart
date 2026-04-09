import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/language_selector.dart';
import '../widgets/responsive_layout.dart';
import 'dashboard_screen.dart';
import 'market_screen.dart';
import 'portfolio_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'news_screen.dart';
import 'zakat_screen.dart';
import 'alerts_screen.dart';
import 'converter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<_NavItem> _navItems(AppLocalizations l) => [
  _NavItem(Icons.dashboard_outlined, Icons.dashboard, l.dashboard),
  _NavItem(Icons.candlestick_chart_outlined, Icons.candlestick_chart, l.market),
  _NavItem(Icons.pie_chart_outline, Icons.pie_chart, l.portfolio),
  _NavItem(Icons.receipt_long_outlined, Icons.receipt_long, l.orders),
  _NavItem(Icons.notifications_outlined, Icons.notifications, l.priceAlertsTitle),
  _NavItem(Icons.newspaper_outlined, Icons.newspaper, l.newsFeedTitle),
  _NavItem(Icons.volunteer_activism_outlined, Icons.volunteer_activism, l.zakatCalculatorTitle),
  _NavItem(Icons.currency_exchange_outlined, Icons.currency_exchange, l.currencyConverter),
  _NavItem(Icons.person_outline, Icons.person, l.profile),
];

List<_NavItem> _mobileNavItems(AppLocalizations l) => [
  _NavItem(Icons.dashboard_outlined, Icons.dashboard, l.home),
  _NavItem(Icons.candlestick_chart_outlined, Icons.candlestick_chart, l.market),
  _NavItem(Icons.pie_chart_outline, Icons.pie_chart, l.portfolio),
  _NavItem(Icons.receipt_long_outlined, Icons.receipt_long, l.orders),
  _NavItem(Icons.more_horiz, Icons.more_horiz, l.more),
];

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    DashboardScreen(onNavigateTo: (i) => setState(() => _currentIndex = i)),
    const MarketScreen(),
    const PortfolioScreen(),
    const OrdersScreen(),
    const AlertsScreen(),
    const NewsScreen(),
    const ZakatScreen(),
    const ConverterScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWideScreen(context);

    if (wide) {
      return _buildWebLayout();
    }
    return _buildMobileLayout();
  }

  // ─── Mobile: Bottom nav (5 items) + "More" bottom sheet ───
  Widget _buildMobileLayout() {
    final l = AppLocalizations.of(context);
    final navItems = _mobileNavItems(l);
    // If current index is beyond the 4 core tabs, show the screen but highlight "More"
    final navIndex = _currentIndex < 4 ? _currentIndex : 4;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: HalalEtTheme.primaryDark,
          border: Border(
            top: BorderSide(color: HalalEtTheme.divider.withValues(alpha: 0.3)),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navIndex,
          onDestinationSelected: (i) {
            if (i == 4) {
              _showMoreSheet();
            } else {
              setState(() => _currentIndex = i);
            }
          },
          destinations: navItems.map((item) => NavigationDestination(
            icon: Icon(item.icon, color: HalalEtTheme.textMuted),
            selectedIcon: Icon(item.selectedIcon, color: HalalEtTheme.positive),
            label: item.label,
          )).toList(),
        ),
      ),
    );
  }

  void _showMoreSheet() {
    final l = AppLocalizations.of(context);
    final moreItems = [
      _MoreItem(Icons.notifications, l.priceAlertsTitle, 4),
      _MoreItem(Icons.newspaper, l.newsFeedTitle, 5),
      _MoreItem(Icons.volunteer_activism, l.zakatCalculatorTitle, 6),
      _MoreItem(Icons.currency_exchange, l.currencyConverter, 7),
      _MoreItem(Icons.person, l.profile, 8),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: HalalEtTheme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: HalalEtTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l.moreFeatures, style: const TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(width: 12),
                const LanguageSelector(),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: moreItems.map((item) => _buildMoreTile(item)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreTile(_MoreItem item) {
    final isSelected = _currentIndex == item.index;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        setState(() => _currentIndex = item.index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? HalalEtTheme.primaryLight.withValues(alpha: 0.15)
              : HalalEtTheme.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: HalalEtTheme.primaryLight.withValues(alpha: 0.3))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 26,
                color: isSelected ? HalalEtTheme.positive : HalalEtTheme.textSecondary),
            const SizedBox(height: 6),
            Text(item.label, style: TextStyle(fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? HalalEtTheme.positive : HalalEtTheme.textSecondary),
                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  // ─── Web: Sidebar navigation (all 9 items) ───
  Widget _buildWebLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          _WebSidebar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            onLogout: () async {
              await context.read<AppProvider>().logout();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
          // Vertical divider
          Container(width: 1, color: HalalEtTheme.divider.withValues(alpha: 0.3)),
          // Main content
          Expanded(child: _screens[_currentIndex]),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _NavItem(this.icon, this.selectedIcon, this.label);
}

class _MoreItem {
  final IconData icon;
  final String label;
  final int index;
  const _MoreItem(this.icon, this.label, this.index);
}

class _WebSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onLogout;

  const _WebSidebar({
    required this.currentIndex,
    required this.onTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = MediaQuery.of(context).size.width >= Breakpoints.desktop;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 220 : 72,
      color: HalalEtTheme.primaryDark,
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: HalalEtTheme.heroGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.show_chart_rounded, size: 22, color: Colors.white),
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TradEt',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'by Amber • ትሬዴት',
                          style: TextStyle(
                            fontSize: 11,
                            color: HalalEtTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Language selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: isExpanded
                ? const LanguageSelector(showLabel: true)
                : const LanguageSelector(),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: HalalEtTheme.divider.withValues(alpha: 0.3)),
          const SizedBox(height: 12),

          // Nav items (scrollable for all 9)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(_navItems(AppLocalizations.of(context)).length, (index) {
                    final item = _navItems(AppLocalizations.of(context))[index];
                    final selected = currentIndex == index;
                    return _SidebarItem(
                      icon: selected ? item.selectedIcon : item.icon,
                      label: item.label,
                      selected: selected,
                      expanded: isExpanded,
                      onTap: () => onTap(index),
                    );
                  }),
                ],
              ),
            ),
          ),

          // User info
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              final user = provider.user;
              if (user == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: EdgeInsets.all(isExpanded ? 12 : 8),
                  decoration: BoxDecoration(
                    color: HalalEtTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: HalalEtTheme.primaryLight.withValues(alpha: 0.3),
                        child: Text(
                          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (isExpanded) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName.split(' ').first,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  color: HalalEtTheme.textMuted,
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _SidebarItem(
              icon: Icons.logout_rounded,
              label: AppLocalizations.of(context).logout,
              selected: false,
              expanded: isExpanded,
              onTap: onLogout,
              color: HalalEtTheme.negative,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool expanded;
  final VoidCallback onTap;
  final Color? color;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.expanded,
    required this.onTap,
    this.color,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ??
        (widget.selected ? HalalEtTheme.positive : HalalEtTheme.textMuted);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: widget.expanded ? 14 : 0,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: widget.selected
                  ? HalalEtTheme.primaryLight.withValues(alpha: 0.15)
                  : _hovering
                      ? HalalEtTheme.surfaceLight.withValues(alpha: 0.5)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: widget.selected
                  ? Border.all(color: HalalEtTheme.primaryLight.withValues(alpha: 0.2))
                  : null,
            ),
            child: Row(
              mainAxisAlignment:
                  widget.expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 22, color: effectiveColor),
                if (widget.expanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: effectiveColor,
                      fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
