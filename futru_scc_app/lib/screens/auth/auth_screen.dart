import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/auth/brand_button.dart';
import '../../main.dart';
import '../../theme/theme.dart';

// =============================================================================
// AUTH
// =============================================================================

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _loading = false;
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    appState.login(email: _email.text);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (rect) => AppGradients.primary(context)
                        .createShader(rect),
                    child: const Icon(Icons.church, size: 56, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _isLogin ? 'Welcome back' : 'Create account',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Parish Connect • Church Administration',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              ToggleButtons(
                isSelected: [_isLogin, !_isLogin],
                onPressed: (i) => setState(() => _isLogin = i == 0),
                constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
                selectedColor: cs.onPrimary,
                fillColor: cs.primary,
                borderRadius: BorderRadius.circular(20),
                children: const [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Login')),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Sign up')),
                ],
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (v) =>
                          v != null && v.contains('@') ? null : 'Enter a valid email',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) =>
                          v != null && v.length >= 6 ? null : 'Min 6 characters',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation(Colors.white)))
                            : Text(_isLogin ? 'Login' : 'Create account'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot password?'),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Divider(color: cs.onSurfaceVariant.withValues(alpha: 0.3))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or continue with', style: Theme.of(context).textTheme.labelMedium),
                ),
                Expanded(child: Divider(color: cs.onSurfaceVariant.withValues(alpha: 0.3))),
              ]),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: BrandButton(
                      color: const Color(0xFF4285F4),
                      icon: Icons.g_mobiledata,
                      label: 'Google',
                      onTap: () => appState.login(email: 'google@user.com'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BrandButton(
                      color: const Color(0xFF1877F2),
                      icon: Icons.facebook,
                      label: 'Facebook',
                      onTap: () => appState.login(email: 'fb@user.com'),
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
                      onTap: () => appState.login(email: 'apple@user.com'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _BackendNote(cs: cs),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackendNote extends StatelessWidget {
  const _BackendNote({required this.cs});
  final ColorScheme cs;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        const Icon(Icons.info_outline),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'No backend connected. To enable real auth, open the Firebase or Supabase panel in Dreamflow and complete setup.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
      ]),
    );
  }
}

