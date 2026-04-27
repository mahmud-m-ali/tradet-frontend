/// App entry point — bootstraps Flutter, sets status bar style, and launches TradEtApp.
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/app_lock_screen.dart';
import 'screens/onboarding_screen.dart';
import 'white_label.dart';
import 'services/app_lock_service.dart';
import 'theme.dart';

/// Locales that Flutter's GlobalMaterialLocalizations actually supports.
/// For others, we fall back to English material strings.
const _materialSupportedLangs = {'en', 'am'}; // only en, am have Flutter material support

/// Initializes system UI chrome and starts the app.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TradEtApp());
}

/// Root widget — provides [AppProvider] and builds the [MaterialApp] with theme
/// and locale resolved from persisted user preferences.
class TradEtApp extends StatelessWidget {
  const TradEtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = AppProvider();
        provider.loadThemePreference();
        return provider;
      },
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: WhiteLabel.appName,
            debugShowCheckedModeBanner: false,
            themeMode: provider.themeMode,
            theme: TradEtTheme.lightTheme,
            darkTheme: TradEtTheme.darkTheme,
            locale: provider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              _FallbackMaterialLocalizationsDelegate(),
              _FallbackCupertinoLocalizationsDelegate(),
              GlobalWidgetsLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supported) {
              // Always honour the user's chosen locale for our own strings
              return provider.locale;
            },
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

/// Decides whether to show [LoginScreen] or [HomeScreen] based on stored token.
/// Displays an animated splash while the auth check is in progress.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with SingleTickerProviderStateMixin {
  bool _checking = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _checkAuth();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  bool _showOnboarding = false;

  Future<void> _checkAuth() async {
    final onboardingShown = await OnboardingScreen.hasBeenShown();
    await context.read<AppProvider>().checkAuthStatus();
    if (mounted) {
      setState(() {
        _showOnboarding = !onboardingShown;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [TradEtTheme.primary, TradEtTheme.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: TradEtTheme.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'ትኢ',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                WhiteLabel.appName,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: TradEtTheme.primaryDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'by ${WhiteLabel.bankName}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                WhiteLabel.tagline,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_showOnboarding) return const OnboardingScreen();

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return provider.isLoggedIn
            ? const _InactivityWrapper(
                child: _AppLockWrapper(child: HomeScreen()))
            : const LoginScreen();
      },
    );
  }
}

/// Auto-logout after 10 minutes of inactivity (INSA CSMS §8a session timeout).
class _InactivityWrapper extends StatefulWidget {
  final Widget child;
  const _InactivityWrapper({required this.child});

  @override
  State<_InactivityWrapper> createState() => _InactivityWrapperState();
}

class _InactivityWrapperState extends State<_InactivityWrapper> {
  /// Session timeout — loaded from AppLockService (default 10 min, INSA max 15 min).
  Duration _timeoutDuration = const Duration(minutes: 10);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadAndStart();
  }

  Future<void> _loadAndStart() async {
    final mins = await AppLockService.getSessionTimeoutMinutes();
    if (mounted) {
      _timeoutDuration = Duration(minutes: mins);
      _resetTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Restarts the inactivity countdown on each user interaction.
  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(_timeoutDuration, _onTimeout);
  }

  /// Logs the user out and navigates to [LoginScreen] after timeout.
  Future<void> _onTimeout() async {
    if (!mounted) return;
    final provider = context.read<AppProvider>();
    await provider.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).sessionExpired),
          backgroundColor: TradEtTheme.warning,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}

/// App lock wrapper — shows PIN/biometric screen when app returns from background
/// after 60+ seconds (INSA CSMS §6.1(c) technology security control).
class _AppLockWrapper extends StatefulWidget {
  final Widget child;
  const _AppLockWrapper({required this.child});

  @override
  State<_AppLockWrapper> createState() => _AppLockWrapperState();
}

class _AppLockWrapperState extends State<_AppLockWrapper>
    with WidgetsBindingObserver {
  /// Background threshold — loaded from AppLockService (default 60s).
  Duration _backgroundThreshold = const Duration(seconds: 60);
  DateTime? _backgroundedAt;
  bool _locked = false;
  bool _pinEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadSettings() async {
    if (kIsWeb) return;
    final enabled = await AppLockService.isEnabled();
    final secs = await AppLockService.getAppLockDelaySecs();
    if (mounted) {
      setState(() {
        _pinEnabled = enabled;
        _backgroundThreshold = Duration(seconds: secs);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kIsWeb || !_pinEnabled) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final bg = _backgroundedAt;
      if (bg != null &&
          DateTime.now().difference(bg) >= _backgroundThreshold) {
        setState(() => _locked = true);
      }
      _backgroundedAt = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_locked) {
      return AppLockScreen(onUnlocked: () => setState(() => _locked = false));
    }
    return widget.child;
  }
}

/// Delegates Material localizations — falls back to English for unsupported locales.
class _FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true; // accept all

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    // Use the locale if Flutter supports it, otherwise fall back to English
    final effectiveLocale =
        _materialSupportedLangs.contains(locale.languageCode)
            ? locale
            : const Locale('en');
    return GlobalMaterialLocalizations.delegate.load(effectiveLocale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<MaterialLocalizations> old) => false;
}

/// Delegates Cupertino localizations — falls back to English for unsupported locales.
class _FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    final effectiveLocale =
        _materialSupportedLangs.contains(locale.languageCode)
            ? locale
            : const Locale('en');
    return GlobalCupertinoLocalizations.delegate.load(effectiveLocale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<CupertinoLocalizations> old) => false;
}
