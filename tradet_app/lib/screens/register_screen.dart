import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../widgets/language_selector.dart';
import '../widgets/responsive_layout.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '+251');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _tosAccepted = false;
  String _passwordStrength = '';
  Color _strengthColor = TradEtTheme.textMuted;

  static String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Min 8 characters';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Must contain an uppercase letter';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Must contain a number';
    if (!v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) return 'Must contain a special character';
    return null;
  }

  void _updateStrength(String v) {
    int score = 0;
    if (v.length >= 8) score++;
    if (v.contains(RegExp(r'[A-Z]'))) score++;
    if (v.contains(RegExp(r'[0-9]'))) score++;
    if (v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) score++;
    setState(() {
      if (score <= 1) { _passwordStrength = 'Weak'; _strengthColor = TradEtTheme.negative; }
      else if (score == 2) { _passwordStrength = 'Fair'; _strengthColor = TradEtTheme.warning; }
      else if (score == 3) { _passwordStrength = 'Good'; _strengthColor = TradEtTheme.positive; }
      else { _passwordStrength = 'Strong'; _strengthColor = TradEtTheme.positive; }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_tosAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms of Service and Privacy Policy to continue.'),
          backgroundColor: TradEtTheme.warning,
        ),
      );
      return;
    }
    final provider = context.read<AppProvider>();
    final success = await provider.register(
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      fullName: _nameController.text.trim(),
    );
    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        appRoute(context, const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: TradEtTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: 20, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Join ትሬድኢት to start trading',
                          style: TextStyle(
                              fontSize: 14, color: TradEtTheme.textSecondary),
                        ),
                        const SizedBox(height: 32),

                        Consumer<AppProvider>(
                          builder: (context, provider, _) {
                            if (provider.error != null) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: TradEtTheme.negative.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(provider.error!,
                                    style: const TextStyle(
                                        color: TradEtTheme.negative,
                                        fontSize: 13)),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        _field(_nameController, l.fullName,
                            Icons.person_outlined),
                        const SizedBox(height: 14),
                        _field(_emailController, l.email,
                            Icons.email_outlined,
                            keyboard: TextInputType.emailAddress),
                        const SizedBox(height: 14),
                        _field(_phoneController, l.phone,
                            Icons.phone_outlined,
                            keyboard: TextInputType.phone),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          onChanged: _updateStrength,
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
                          validator: _validatePassword,
                        ),
                        if (_passwordStrength.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.security_outlined, size: 13, color: TradEtTheme.textMuted),
                              const SizedBox(width: 5),
                              const Text('Strength: ',
                                  style: TextStyle(fontSize: 11, color: TradEtTheme.textMuted)),
                              Text(_passwordStrength,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _strengthColor)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 14),

                        // Confirm password
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _register(),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: l.confirmPassword,
                            prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: TradEtTheme.textMuted,
                              ),
                              onPressed: () => setState(
                                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return l.passwordRequired;
                            if (v != _passwordController.text) return l.passwordsDoNotMatch;
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Compliance
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: TradEtTheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: TradEtTheme.positive.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.verified_rounded,
                                    color: TradEtTheme.positive, size: 18),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'AAOIFI Sharia compliant • ECX regulated\nNBE supervised • Riba-free fees',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: TradEtTheme.textSecondary,
                                      height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Terms of Service & Privacy Policy (INSA People Pillar)
                        GestureDetector(
                          onTap: () => setState(() => _tosAccepted = !_tosAccepted),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: _tosAccepted,
                                  onChanged: (v) => setState(() => _tosAccepted = v ?? false),
                                  activeColor: TradEtTheme.positive,
                                  side: const BorderSide(color: TradEtTheme.textMuted),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: TradEtTheme.textSecondary,
                                        height: 1.5),
                                    children: [
                                      TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: TextStyle(
                                            color: TradEtTheme.positive,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline),
                                      ),
                                      TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                            color: TradEtTheme.positive,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline),
                                      ),
                                      TextSpan(
                                          text:
                                              '. My data will be processed in accordance with NBE data residency requirements and INSA CSMS guidelines.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Consumer<AppProvider>(
                          builder: (context, provider, _) {
                            return ElevatedButton(
                              onPressed: (provider.isLoading || !_tosAccepted) ? null : _register,
                              child: provider.isLoading
                                  ? const SizedBox(
                                      height: 20, width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : Text(l.createAccount),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
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

  Widget _field(TextEditingController c, String label, IconData icon,
      {TextInputType? keyboard}) {
    return TextFormField(
      controller: c,
      keyboardType: keyboard,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }
}
