import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/components/auth/brand_button.dart';
import 'package:parish_connect/repositories/auth/auth_repository.dart';
import 'package:parish_connect/widgets/helpers.dart';
import 'package:toastification/toastification.dart';
import '../../constants.dart';
import '../../theme/theme.dart';
import "package:parish_connect/main.dart";

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLoading = false;
  bool _obscurePassword = true; // State for password visibility
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  String? _selectedDeanery;
  String? _selectedParish;

  @override
  void dispose() {
    _fullName.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() => _isLoading = true);
    try {
      final response = await ref
          .read(authRepositoryProvider)
          .loginUser(_email.text.trim(), _password.text.trim());

      if (!mounted) return;

      showToast(
        context,
        response.message ?? (response.success ? "Welcome!" : "Error"),
        type: response.success
            ? ToastificationType.success
            : ToastificationType.error,
      );

      if (response.success) {
        ref.read(appStateProvider.notifier).setLoggedIn(true);
      }
    } catch (e) {
      if (mounted) {
        showToast(
          context,
          "An unexpected error occurred",
          type: ToastificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void signupUser() async {
    setState(() => _isLoading = true);
    try {
      final response = await ref
          .read(authRepositoryProvider)
          .signupUser(
            _fullName.text.trim(),
            _username.text.trim(),
            _selectedDeanery!,
            _selectedParish!,
            _email.text.trim(),
            _password.text.trim(),
          );

      if (!mounted) return;

      showToast(
        context,
        response.message ?? (response.success ? "Account created!" : "Error"),
        type: response.success
            ? ToastificationType.success
            : ToastificationType.error,
      );

      if (response.success) {
        ref.read(appStateProvider.notifier).setLoggedIn(true);
      }
    } catch (e) {
      if (mounted) {
        showToast(context, "Signup failed", type: ToastificationType.error);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submitAuthForm() {
    if (_formKey.currentState!.validate()) {
      if (_isLogin) {
        loginUser();
      } else {
        signupUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              ShaderMask(
                shaderCallback: (rect) =>
                    AppGradients.primary(context).createShader(rect),
                child: const Icon(Icons.church, size: 56, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                _isLogin ? 'Welcome back' : 'Create account',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),
              ToggleButtons(
                isSelected: [_isLogin, !_isLogin],
                onPressed: (i) {
                  setState(() {
                    _isLogin = i == 0;
                    _formKey.currentState?.reset();
                    _selectedDeanery = null;
                    _selectedParish = null;
                  });
                },
                constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
                selectedColor: cs.onPrimary,
                fillColor: cs.primary,
                borderRadius: BorderRadius.circular(20),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Login'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Sign up'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!_isLogin) ...[
                      TextFormField(
                        controller: _fullName,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) =>
                            v != null && v.isNotEmpty ? null : 'Required',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _username,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (v) =>
                            v != null && v.length >= 3 ? null : 'Min 3 chars',
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedDeanery,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Deanery',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        items: deaneryParishMap.keys
                            .map(
                              (d) => DropdownMenuItem(
                                value: d,
                                child: Text(d, overflow: TextOverflow.ellipsis),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() {
                          _selectedDeanery = v;
                          _selectedParish = null;
                        }),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedParish,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Parish',
                          prefixIcon: Icon(Icons.church_outlined),
                        ),
                        hint: const Text('Select Parish'),
                        items: (_selectedDeanery == null)
                            ? []
                            : deaneryParishMap[_selectedDeanery]!
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(
                                        p,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        onChanged: (v) => setState(() => _selectedParish = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (v) =>
                          v != null && v.contains('@') ? null : 'Invalid email',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscurePassword, // Use state here
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: cs.onSurfaceVariant,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: (v) => v != null && v.length >= 8
                          ? null
                          : 'Min 8 characters',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _submitAuthForm,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_isLogin ? 'Login' : 'Create Account'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Divider(color: cs.onSurfaceVariant.withAlpha(76)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Or continue with",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Expanded(
                    child: Divider(color: cs.onSurfaceVariant.withAlpha(76)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: BrandButton(
                      color: const Color(0xFF4285F4),
                      icon: Icons.g_mobiledata,
                      label: 'Google',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BrandButton(
                      color: const Color(0xFF1877F2),
                      icon: Icons.facebook,
                      label: 'Facebook',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: BrandButton(
                      color: Colors.black,
                      icon: Icons.apple,
                      label: 'Apple',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
