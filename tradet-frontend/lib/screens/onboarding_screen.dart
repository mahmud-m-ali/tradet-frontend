/// First-launch onboarding — 3 swipeable screens explaining ECX, Sharia, and KYC.
/// Shown once on fresh install; stored in SharedPreferences as 'onboarding_shown'.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();

  /// Marks onboarding as seen and should not be shown again.
  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_shown', true);
  }

  /// Returns true if onboarding has already been shown.
  static Future<bool> hasBeenShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_shown') ?? false;
  }
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.account_balance_outlined,
      iconColor: TradEtTheme.positive,
      badge: 'ECX',
      title: 'Ethiopian Commodity\nExchange (ECX)',
      subtitle: 'Trade real commodities on\nEthiopia\'s official exchange',
      bullets: [
        ('Coffee, Sesame, Wheat, Gold', Icons.grain),
        ('ECX trading sessions: 9:00 AM – 3:00 PM EAT', Icons.access_time),
        ('Regulated by ECEA & National Bank of Ethiopia', Icons.verified_outlined),
        ('Prices updated in real-time from ECX floor', Icons.show_chart),
      ],
    ),
    _OnboardingPage(
      icon: Icons.stars_outlined,
      iconColor: TradEtTheme.accent,
      badge: 'AAOIFI',
      title: 'Sharia-Compliant\nTrading Platform',
      subtitle: 'Every trade meets AAOIFI\nIslamic finance standards',
      bullets: [
        ('No Riba (interest) — flat 1.5% commission only', Icons.money_off),
        ('No Gharar (uncertainty) — transparent pricing', Icons.visibility),
        ('Haram screening: debt <30%, haram revenue <5%', Icons.shield_outlined),
        ('AAOIFI Standard No. 21 compliance on all assets', Icons.workspace_premium),
      ],
    ),
    _OnboardingPage(
      icon: Icons.badge_outlined,
      iconColor: TradEtTheme.indigo,
      badge: 'KYC',
      title: 'Identity Verification\nRequired',
      subtitle: 'Required by Ethiopian law\nbefore you can start trading',
      bullets: [
        ('National ID, Passport, or Kebele ID accepted', Icons.perm_identity),
        ('Verified in minutes — no branch visit needed', Icons.timer_outlined),
        ('Data encrypted & stored securely (AES-256)', Icons.lock_outline),
        ('One-time verification — trade freely after', Icons.check_circle_outline),
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await OnboardingScreen.markSeen();
    if (mounted) {
      Navigator.of(context).pushReplacement(
          appRoute(context, const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = isWideScreen(context);
    return Scaffold(
      backgroundColor: TradEtTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text('Skip',
                    style: TextStyle(
                        color: TradEtTheme.textMuted, fontSize: 13)),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _buildPage(_pages[i], isWide),
              ),
            ),

            // Dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  // Page dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final active = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active
                              ? TradEtTheme.primary
                              : TradEtTheme.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Next / Get Started button
                  SizedBox(
                    width: isWide ? 320 : double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TradEtTheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        _currentPage < _pages.length - 1
                            ? 'Next →'
                            : 'Get Started',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page, bool isWide) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: isWide ? 120 : 28, vertical: 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: page.iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: page.iconColor.withValues(alpha: 0.3)),
                    ),
                    child: Icon(page.icon, size: 40, color: page.iconColor),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: page.iconColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: page.iconColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(page.badge,
                        style: TextStyle(
                            color: page.iconColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 1.2)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title
              Text(page.title,
                  style: const TextStyle(
                      color: TradEtTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.2)),
              const SizedBox(height: 10),

              // Subtitle
              Text(page.subtitle,
                  style: const TextStyle(
                      color: TradEtTheme.textSecondary,
                      fontSize: 15,
                      height: 1.5)),
              const SizedBox(height: 28),

              // Bullets
              ...page.bullets.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: page.iconColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(b.$2, size: 18, color: page.iconColor),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(b.$1,
                                style: const TextStyle(
                                    color: TradEtTheme.textSecondary,
                                    fontSize: 14,
                                    height: 1.4)),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String badge;
  final String title;
  final String subtitle;
  final List<(String, IconData)> bullets;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.bullets,
  });
}
