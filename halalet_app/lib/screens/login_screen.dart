import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import '../theme.dart';
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

  @override
  void initState() {
    super.initState();
    ApiService.loadServerUrl().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showServerSettings() {
    final urlController = TextEditingController(
      text: ApiService.currentServerDisplay,
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0A3D2A),
        title: const Text('Server Settings',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter the backend server URL:',
                style: TextStyle(color: HalalEtTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'https://your-server.com',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                prefixIcon: const Icon(Icons.dns_outlined, size: 18),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: HalalEtTheme.primaryLight.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: HalalEtTheme.primaryLight.withValues(alpha: 0.3)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current: ${ApiService.baseUrl}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: HalalEtTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: HalalEtTheme.primaryLight,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await ApiService.setServerUrl(urlController.text.trim());
              if (mounted) {
                Navigator.pop(ctx);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Server updated: ${ApiService.baseUrl}'),
                    backgroundColor: HalalEtTheme.positive,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AppProvider>();
    final success = await provider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Settings button - top right
              Positioned(
                top: 12,
                right: 16,
                child: IconButton(
                  onPressed: _showServerSettings,
                  icon: const Icon(Icons.settings_outlined,
                      color: HalalEtTheme.textMuted, size: 22),
                  tooltip: 'Server Settings',
                ),
              ),

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
                                gradient: HalalEtTheme.heroGradient,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: HalalEtTheme.primaryLight.withValues(alpha: 0.35),
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
                              'ሃላልኢት',
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
                                color: HalalEtTheme.textSecondary,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'by Amber',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: HalalEtTheme.textMuted,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 36),

                            // Login card
                            Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: HalalEtTheme.cardBg.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: HalalEtTheme.divider.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Welcome back',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Sign in to continue / ለመቀጠል ይግቡ',
                                    style: TextStyle(
                                        fontSize: 13, color: HalalEtTheme.textSecondary),
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
                                            color: HalalEtTheme.negative.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.error_outline,
                                                  color: HalalEtTheme.negative, size: 18),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(provider.error!,
                                                    style: const TextStyle(
                                                        color: HalalEtTheme.negative,
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
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'you@example.com',
                                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                                    ),
                                    validator: (v) =>
                                        v == null || v.isEmpty ? 'Email is required' : null,
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
                                      labelText: 'Password / የይለፍ ቃል',
                                      prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          size: 20,
                                          color: HalalEtTheme.textMuted,
                                        ),
                                        onPressed: () => setState(
                                            () => _obscurePassword = !_obscurePassword),
                                      ),
                                    ),
                                    validator: (v) =>
                                        v == null || v.isEmpty ? 'Password is required' : null,
                                  ),
                                  const SizedBox(height: 28),

                                  // Sign in button
                                  Consumer<AppProvider>(
                                    builder: (context, provider, _) {
                                      return SizedBox(
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: provider.isLoading ? null : _login,
                                          child: provider.isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                      strokeWidth: 2, color: Colors.white))
                                              : const Text('Sign In / ግባ',
                                                  style: TextStyle(fontSize: 15)),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Register link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? ",
                                    style: TextStyle(
                                        color: HalalEtTheme.textSecondary, fontSize: 14)),
                                GestureDetector(
                                  onTap: () {
                                    context.read<AppProvider>().clearError();
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => const RegisterScreen()));
                                  },
                                  child: const Text(
                                    'Register / ይመዝገቡ',
                                    style: TextStyle(
                                      color: HalalEtTheme.positive,
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
            ],
          ),
        ),
      ),
    );
  }
}
