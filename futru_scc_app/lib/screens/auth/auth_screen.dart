import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/auth/brand_button.dart';
import '../../main.dart';
import '../../constants.dart';
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
  // Added controllers for full name and username
  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  // --- Deanery and Parish List and Selection ---
  // Structured Map for Deanery (Key) and List of Parishes (Value)
  
  
  String? _selectedDeanery; // Variable to hold the selected deanery
  String? _selectedParish; // Variable to hold the selected parish

  // --- End Deanery and Parish List and Selection ---

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if both deanery and parish are selected during Sign up
    if (!_isLogin && (_selectedDeanery == null || _selectedParish == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your deanery and parish.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    if (_isLogin) {
      // Logic for Login
      print('Logging in with: ${_email.text} / ${_password.text}');
    } else {
      // Logic for Sign up
      print(
          'Signing up with: ${_fullName.text} / ${_username.text} / ${_email.text} / ${_password.text} / Deanery: $_selectedDeanery / Parish: $_selectedParish');
    }

    await Future.delayed(const Duration(milliseconds: 900));
    appState.login(email: _email.text);
  }

  @override
  void initState() {
    super.initState();
    // Initialize selected values to null
    _selectedDeanery = null;
    _selectedParish = null;
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
                onPressed: (i) {
                  // Reset selected deanery and parish when switching to Login
                  if (i == 0) {
                    _selectedDeanery = null;
                    _selectedParish = null;
                  }
                  setState(() => _isLogin = i == 0);
                },
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
                    // --- Full Name Field (Sign Up Only) ---
                    if (!_isLogin)
                      TextFormField(
                        controller: _fullName,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) =>
                            v != null && v.isNotEmpty ? null : 'Enter your full name',
                      ),

                    // Add a space after Full Name field if it is visible
                    if (!_isLogin) const SizedBox(height: 12),

                    // --- Username Field (Sign Up Only) ---
                    if (!_isLogin)
                      TextFormField(
                        controller: _username,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (v) =>
                            v != null && v.length >= 3 ? null : 'Min 3 characters',
                      ),

                    // Add a space after Username field if it is visible
                    if (!_isLogin) const SizedBox(height: 12),

                    // --- Deanery Dropdown Field (Sign Up Only) ---
                    if (!_isLogin)
                      DropdownButtonFormField<String>(
                        value: _selectedDeanery,
                        decoration: const InputDecoration(
                          labelText: 'Select Deanery',
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                        hint: const Text('Select your deanery'),
                        items: _deaneryParishMap.keys.map((String deanery) {
                          return DropdownMenuItem<String>(
                            value: deanery,
                            child: Text(deanery),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDeanery = newValue;
                            // Reset selected parish when deanery changes
                            _selectedParish = null; 
                          });
                        },
                        validator: (v) => v != null && v.isNotEmpty
                            ? null
                            : 'Please select a deanery',
                      ),

                    if (!_isLogin) const SizedBox(height: 12),

                    // --- Parish Dropdown Field (Sign Up Only) ---
                    if (!_isLogin)
                      DropdownButtonFormField<String>(
                        // Only enable if a Deanery is selected
                        value: _selectedParish,
                        decoration: const InputDecoration(
                          labelText: 'Select Parish',
                          // Keeping the prefix icon off to prevent overflow with long parish names
                          // prefixIcon: Icon(Icons.church_outlined), 
                        ),
                        hint: Text(_selectedDeanery == null 
                          ? 'Select a deanery first' 
                          : 'Select your parish'
                        ),
                        // Use the list of parishes corresponding to the selected deanery
                        items: deaneryParishMap[_selectedDeanery]?.map((String parish) {
                          return DropdownMenuItem<String>(
                            value: parish,
                            // Constrain the text in the menu overlay for long names
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.65, 
                              ),
                              child: Text(
                                parish,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          );
                        }).toList() ?? [], // Provide empty list if no deanery is selected
                        onChanged: _selectedDeanery == null
                            ? null // Disable onChanged if no deanery selected
                            : (String? newValue) {
                                setState(() {
                                  _selectedParish = newValue;
                                });
                              },
                        validator: (v) => v != null && v.isNotEmpty
                            ? null
                            : 'Please select a parish',
                      ),

                    // Add a space after Parish dropdown if it is visible
                    if (!_isLogin) const SizedBox(height: 12),
                    // --- End Parish Dropdown ---

                    // --- Email Field (Always visible) ---
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
                    // --- Password Field (Always visible) ---
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
                    // Show 'Forgot password?' only on the login screen
                    if (_isLogin)
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
              // --- Social Login Section ---
              Row(children: [
                Expanded(child: Divider(color: cs.onSurfaceVariant.withAlpha(76))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or continue with', style: Theme.of(context).textTheme.labelMedium),
                ),
                Expanded(child: Divider(color: cs.onSurfaceVariant.withAlpha(76))),
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
            ],
          ),
        ),
      ),
    );
  }
}