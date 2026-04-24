import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/language_selector.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Account lockout (INSA CSMS §8a)
  int _failedAttempts = 0;
  DateTime? _lockedUntil;
  Timer? _lockCountdownTimer;
  int _lockSecondsRemaining = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _lockCountdownTimer?.cancel();
    super.dispose();
  }

  bool get _isLocked =>
      _lockedUntil != null && DateTime.now().isBefore(_lockedUntil!);

  void _startLockCountdown() {
    _lockCountdownTimer?.cancel();
    _lockSecondsRemaining =
        _lockedUntil!.difference(DateTime.now()).inSeconds;
    _lockCountdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      final remaining = _lockedUntil!.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        t.cancel();
        setState(() { _lockSecondsRemaining = 0; _lockedUntil = null; });
      } else {
        setState(() => _lockSecondsRemaining = remaining);
      }
    });
  }

  Future<void> _login() async {
    if (_isLocked) return;
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AppProvider>();
    final success = await provider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      _failedAttempts = 0;
      Navigator.of(context).pushReplacement(
        appRoute(context, const HomeScreen()),
      );
    } else {
      setState(() => _failedAttempts++);
      if (_failedAttempts >= 5) {
        setState(() {
          _lockedUntil = DateTime.now().add(const Duration(minutes: 15));
        });
        _startLockCountdown();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B2E1A), Color(0xFF0D3B20), Color(0xFF134A2C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Centered login card
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: TradEtTheme.heroGradient,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: TradEtTheme.primaryLight.withValues(alpha: 0.35),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.show_chart_rounded,
                                  size: 40, color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'ትሬድኢት',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'TradEt',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: TradEtTheme.textSecondary,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'by Amber',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: TradEtTheme.textMuted,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 36),

                            // Login card
                            Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: TradEtTheme.cardBg.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: TradEtTheme.divider.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    l.welcomeBack,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l.signInToContinue,
                                    style: const TextStyle(
                                        fontSize: 13, color: TradEtTheme.textSecondary),
                                  ),
                                  const SizedBox(height: 24),

                                  // Error message
                                  Consumer<AppProvider>(
                                    builder: (context, provider, _) {
                                      if (provider.error != null) {
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 16),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: TradEtTheme.negative.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.error_outline,
                                                  color: TradEtTheme.negative, size: 18),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(provider.error!,
                                                    style: const TextStyle(
                                                        color: TradEtTheme.negative,
                                                        fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),

                                  // Email
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: l.email,
                                      hintText: 'you@example.com',
                                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                                    ),
                                    validator: (v) =>
                                        v == null || v.isEmpty ? l.emailRequired : null,
                                  ),
                                  const SizedBox(height: 16),

                                  // Password
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _login(),
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: l.password,
                                      prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          size: 20,
                                          color: TradEtTheme.textMuted,
                                        ),
                                        onPressed: () => setState(
                                            () => _obscurePassword = !_obscurePassword),
                                      ),
                                    ),
                                    validator: (v) =>
                                        v == null || v.isEmpty ? l.passwordRequired : null,
                                  ),
                                  const SizedBox(height: 28),

                                  // Account lockout banner
                                  if (_isLocked)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: TradEtTheme.negative.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: TradEtTheme.negative.withValues(alpha: 0.3)),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.lock_outlined,
                                              color: TradEtTheme.negative, size: 18),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'Account locked. Too many failed attempts.\nTry again in ${_lockSecondsRemaining ~/ 60}m ${_lockSecondsRemaining % 60}s',
                                              style: const TextStyle(
                                                  color: TradEtTheme.negative,
                                                  fontSize: 12,
                                                  height: 1.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else if (_failedAttempts > 0 && _failedAttempts < 5)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: TradEtTheme.warning.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${5 - _failedAttempts} attempt(s) remaining before lockout',
                                        style: const TextStyle(
                                            color: TradEtTheme.warning, fontSize: 12),
                                      ),
                                    ),

                                  // Sign in button
                                  Consumer<AppProvider>(
                                    builder: (context, provider, _) {
                                      return SizedBox(
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: (provider.isLoading || _isLocked) ? null : _login,
                                          child: provider.isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                      strokeWidth: 2, color: Colors.white))
                                              : Text(l.signIn,
                                                  style: const TextStyle(fontSize: 15)),
                                        ),
                                      );
                                    },
                                  ),

                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Try Demo — outside card to avoid any clipping by BoxDecoration
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  await context.read<AppProvider>().loginDemo();
                                  if (context.mounted) {
                                    Navigator.of(context).pushReplacement(
                                        appRoute(context, const HomeScreen()));
                                  }
                                },
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: TradEtTheme.accent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: TradEtTheme.accent, width: 2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_circle_outline,
                                          size: 20, color: TradEtTheme.accent),
                                      const SizedBox(width: 8),
                                      Text('Try Demo',
                                          style: TextStyle(
                                              color: TradEtTheme.accent,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Register link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l.dontHaveAccount + ' ',
                                    style: const TextStyle(
                                        color: TradEtTheme.textSecondary, fontSize: 14)),
                                GestureDetector(
                                  onTap: () {
                                    context.read<AppProvider>().clearError();
                                    Navigator.of(context).push(appRoute(context, const RegisterScreen()));
                                  },
                                  child: Text(
                                    l.register,
                                    style: TextStyle(
                                      color: TradEtTheme.positive,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Language selector on top — must be last in Stack to receive touches
              const Positioned(
                top: 12,
                right: 16,
                child: LanguageSelector(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
