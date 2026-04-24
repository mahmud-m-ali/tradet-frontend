import 'package:flutter/material.dart';
import '../services/app_lock_service.dart';
import '../theme.dart';

/// Shown when the app returns from background (60s+ backgrounded) or on first
/// launch if a PIN has been set. User must authenticate to continue.
class AppLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;

  const AppLockScreen({super.key, required this.onUnlocked});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final List<String> _entered = [];
  bool _hasError = false;
  bool _loading = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final bio = await AppLockService.isBiometricAvailable();
    if (mounted) {
      setState(() => _biometricAvailable = bio);
      if (bio) _tryBiometric();
    }
  }

  Future<void> _tryBiometric() async {
    setState(() => _loading = true);
    final ok = await AppLockService.authenticateWithBiometric();
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) widget.onUnlocked();
  }

  void _onKey(String digit) {
    if (_entered.length >= 4) return;
    setState(() {
      _entered.add(digit);
      _hasError = false;
    });
    if (_entered.length == 4) _verify();
  }

  void _onDelete() {
    if (_entered.isEmpty) return;
    setState(() {
      _entered.removeLast();
      _hasError = false;
    });
  }

  Future<void> _verify() async {
    setState(() => _loading = true);
    final pin = _entered.join();
    final ok = await AppLockService.verifyPin(pin);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      widget.onUnlocked();
    } else {
      setState(() {
        _hasError = true;
        _entered.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TradEtTheme.primaryDark,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: TradEtTheme.heroGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.lock_rounded,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 20),
                  const Text('TradEt',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  const Text('Enter your PIN to continue',
                      style: TextStyle(
                          fontSize: 13, color: TradEtTheme.textSecondary)),
                  const SizedBox(height: 36),

                  // PIN dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      final filled = i < _entered.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _hasError
                                ? TradEtTheme.negative
                                : filled
                                    ? TradEtTheme.accent
                                    : TradEtTheme.divider,
                            border: Border.all(
                              color: _hasError
                                  ? TradEtTheme.negative
                                  : filled
                                      ? TradEtTheme.accent
                                      : TradEtTheme.textMuted,
                              width: 1.5,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  if (_hasError) ...[
                    const SizedBox(height: 12),
                    const Text('Incorrect PIN. Try again.',
                        style: TextStyle(
                            color: TradEtTheme.negative, fontSize: 13)),
                  ],

                  const SizedBox(height: 36),

                  if (_loading)
                    const CircularProgressIndicator(
                        color: TradEtTheme.accent, strokeWidth: 2)
                  else
                    _NumPad(onKey: _onKey, onDelete: _onDelete),

                  if (_biometricAvailable && !_loading) ...[
                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: _tryBiometric,
                      icon: const Icon(Icons.fingerprint_rounded,
                          color: TradEtTheme.accent, size: 22),
                      label: const Text('Use Biometric',
                          style: TextStyle(
                              color: TradEtTheme.accent, fontSize: 13)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumPad extends StatelessWidget {
  final void Function(String) onKey;
  final VoidCallback onDelete;

  const _NumPad({required this.onKey, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: keys.length,
      itemBuilder: (_, i) {
        final k = keys[i];
        if (k.isEmpty) return const SizedBox.shrink();
        final isDelete = k == '⌫';
        return GestureDetector(
          onTap: () => isDelete ? onDelete() : onKey(k),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: BoxDecoration(
                color: TradEtTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: TradEtTheme.divider.withValues(alpha: 0.3)),
              ),
              alignment: Alignment.center,
              child: Text(
                k,
                style: TextStyle(
                  color: isDelete ? TradEtTheme.textSecondary : Colors.white,
                  fontSize: isDelete ? 18 : 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
