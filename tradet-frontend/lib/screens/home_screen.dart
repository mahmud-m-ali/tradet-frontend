import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../white_label.dart';
import '../widgets/language_selector.dart';
import '../widgets/responsive_layout.dart';
import 'dashboard_screen.dart';
import 'market_screen.dart';
import 'portfolio_screen.dart';
import 'orders_screen.dart';
import 'watchlist_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'news_screen.dart';
import 'zakat_screen.dart';
import 'alerts_screen.dart';
import 'converter_screen.dart';
import 'analytics_screen.dart';
import 'transactions_screen.dart';
import 'corporate_events_screen.dart';

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
  _NavItem(Icons.star_outline_rounded, Icons.star_rounded, l.watchlist),
  _NavItem(Icons.notifications_outlined, Icons.notifications, l.priceAlertsTitle),
  _NavItem(Icons.newspaper_outlined, Icons.newspaper, l.newsFeedTitle),
  _NavItem(Icons.volunteer_activism_outlined, Icons.volunteer_activism, l.zakatCalculatorTitle),
  _NavItem(Icons.currency_exchange_outlined, Icons.currency_exchange, l.currencyConverter),
  _NavItem(Icons.bar_chart_outlined, Icons.bar_chart, l.analytics),
  _NavItem(Icons.swap_horiz_outlined, Icons.swap_horiz, l.transactions),
  _NavItem(Icons.person_outline, Icons.person, l.profile),
];

List<_NavItem> _mobileNavItems(AppLocalizations l) => [
  _NavItem(Icons.dashboard_outlined, Icons.dashboard, l.home),
  _NavItem(Icons.candlestick_chart_outlined, Icons.candlestick_chart, l.market),
  _NavItem(Icons.pie_chart_outline, Icons.pie_chart, l.portfolio),
  _NavItem(Icons.receipt_long_outlined, Icons.receipt_long, l.orders),
];

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    DashboardScreen(onNavigateTo: (i) => setState(() => _currentIndex = i)),
    const MarketScreen(),
    const PortfolioScreen(),
    const OrdersScreen(),
    const WatchlistScreen(),
    const AlertsScreen(),
    const NewsScreen(),
    const ZakatScreen(),
    const ConverterScreen(),
    const AnalyticsScreen(),
    const TransactionsScreen(),
    const ProfileScreen(),
    const CorporateEventsScreen(), // index 12 — accessed from dashboard card on desktop
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadAllData();
      context.read<AppProvider>().setGlobalNav((i) => setState(() => _currentIndex = i));
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

  // ─── Mobile: Bottom nav (4 items) ───
  Widget _buildMobileLayout() {
    final l = AppLocalizations.of(context);
    final navItems = _mobileNavItems(l);
    final navIndex = _currentIndex.clamp(0, 3);

    final isDemoMode = context.watch<AppProvider>().isDemoMode;
    return Scaffold(
      body: Column(
        children: [
          if (isDemoMode)
            Material(
              color: TradEtTheme.accent.withValues(alpha: 0.15),
              child: InkWell(
                onTap: () async {
                  await context.read<AppProvider>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (r) => false,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_circle_outline,
                          size: 14, color: TradEtTheme.accent),
                      const SizedBox(width: 6),
                      const Text('DEMO MODE — Data is simulated for presentation',
                          style: TextStyle(
                              color: TradEtTheme.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Text('Exit', style: TextStyle(color: TradEtTheme.accent, fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(child: _screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: TradEtTheme.primaryDark,
          border: Border(
            top: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.3)),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          destinations: navItems.map((item) => NavigationDestination(
            icon: Icon(item.icon, color: TradEtTheme.textMuted),
            selectedIcon: Icon(item.selectedIcon, color: TradEtTheme.positive),
            label: item.label,
          )).toList(),
        ),
      ),
    );
  }

  // ─── Web: Sidebar navigation (all 9 items) ───
  Widget _buildWebLayout() {
    final isDemoMode = context.watch<AppProvider>().isDemoMode;
    return Scaffold(
      body: Column(
        children: [
          if (isDemoMode)
            Material(
              color: TradEtTheme.accent.withValues(alpha: 0.15),
              child: InkWell(
                onTap: () async {
                  await context.read<AppProvider>().logout();
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                        appRoute(context, const LoginScreen()), (r) => false);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_circle_outline, size: 14, color: TradEtTheme.accent),
                      const SizedBox(width: 6),
                      const Text('DEMO MODE — All data is simulated for presentation purposes',
                          style: TextStyle(color: TradEtTheme.accent, fontSize: 11,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Text('Exit Demo →',
                          style: TextStyle(color: TradEtTheme.accent, fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sidebar
                AppWebSidebar(
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                  onLogout: () async {
                    await context.read<AppProvider>().logout();
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        appRoute(context, const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                ),
                // Vertical divider
                Container(width: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
                // Main content with top bar
                Expanded(
                  child: Column(
                    children: [
                      _WebTopBar(
                        onProfileTap: () => setState(() => _currentIndex = 11),
                      ),
                      Expanded(child: _screens[_currentIndex]),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

class AppWebSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onLogout;

  const AppWebSidebar({
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
      color: TradEtTheme.primaryDark,
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
                    gradient: TradEtTheme.heroGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.show_chart_rounded, size: 22, color: Colors.white),
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          WhiteLabel.appName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'by ${WhiteLabel.bankName} • ${WhiteLabel.appNameAmharic}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: TradEtTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Row(
                          children: [
                            Icon(Icons.verified_rounded,
                                size: 11, color: TradEtTheme.positive),
                            SizedBox(width: 3),
                            Text(
                              'Sharia Certified',
                              style: TextStyle(
                                fontSize: 10,
                                color: TradEtTheme.positive,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: TradEtTheme.divider.withValues(alpha: 0.3)),
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

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _SidebarItem(
              icon: Icons.logout_rounded,
              label: AppLocalizations.of(context).logout,
              selected: false,
              expanded: isExpanded,
              onTap: onLogout,
              color: TradEtTheme.negative,
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
        (widget.selected ? TradEtTheme.positive : TradEtTheme.textMuted);

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
                  ? TradEtTheme.primaryLight.withValues(alpha: 0.15)
                  : _hovering
                      ? TradEtTheme.surfaceLight.withValues(alpha: 0.5)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: widget.selected
                  ? Border.all(color: TradEtTheme.primaryLight.withValues(alpha: 0.2))
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

// ─── Desktop top bar (profile avatar + language selector) ───────────────────

class _WebTopBar extends StatelessWidget {
  final VoidCallback onProfileTap;

  const _WebTopBar({required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: TradEtTheme.primaryDark,
        border: Border(
          bottom: BorderSide(color: TradEtTheme.divider.withValues(alpha: 0.25)),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          // Language selector
          const LanguageSelector(),
          const SizedBox(width: 12),
          // Vertical divider
          Container(width: 1, height: 24,
              color: TradEtTheme.divider.withValues(alpha: 0.4)),
          const SizedBox(width: 12),
          // Profile avatar
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              final user = provider.user;
              final initials = (user?.fullName.isNotEmpty == true)
                  ? user!.fullName[0].toUpperCase()
                  : '?';
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: TradEtTheme.primaryLight.withValues(alpha: 0.35),
                    child: Text(initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
