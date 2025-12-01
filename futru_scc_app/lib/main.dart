import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' as rive;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toastification/toastification.dart';
import 'theme.dart';

void main() {
  runApp(const ChurchAdminApp());
}

class ChurchAdminApp extends StatelessWidget {
  const ChurchAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return ToastificationWrapper(
          child: MaterialApp(
            title: 'Church Admin',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: appState.themeMode,
            home: const RootNavigator(),
          ),
        );
      },
    );
  }
}

// =============================================================================
// APP STATE (no Provider; plain Dart ChangeNotifier + global instance)
// =============================================================================

final AppState appState = AppState();

class AppState extends ChangeNotifier {
  bool _initialized = false;
  bool _showOnboarding = true;
  bool _loggedIn = false;
  bool _isAdmin = false;
  ThemeMode _themeMode = ThemeMode.system;

  bool get initialized => _initialized;
  bool get showOnboarding => _showOnboarding;
  bool get loggedIn => _loggedIn;
  bool get isAdmin => _isAdmin;
  ThemeMode get themeMode => _themeMode;

  void finishInit() {
    _initialized = true;
    notifyListeners();
  }

  void completeOnboarding() {
    _showOnboarding = false;
    notifyListeners();
  }

  void login({required String email}) {
    _loggedIn = true;
    _isAdmin = email.toLowerCase().contains('admin');
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    _isAdmin = false;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

// =============================================================================
// ROOT NAVIGATOR (Splash -> Onboarding -> Auth -> Main)
// =============================================================================

class RootNavigator extends StatefulWidget {
  const RootNavigator({super.key});

  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Simulate initialization delay (splash)
    Timer(const Duration(milliseconds: 1600), () {
      if (mounted) appState.finishInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (!appState.initialized) {
      child = const SplashScreen();
    } else if (appState.showOnboarding) {
      child = const OnboardingScreen();
    } else if (!appState.loggedIn) {
      child = const AuthScreen();
    } else {
      child = const MainShell();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
              .animate(anim),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

// =============================================================================
// SPLASH
// =============================================================================

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.primary(context)),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.surface.withValues(alpha: 0.0),
                    cs.surface.withValues(alpha: 0.15),
                    cs.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primary(context),
                    boxShadow: AppShadows.soft(context),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: const rive.RiveAnimation.network(
                    'https://cdn.rive.app/animations/vehicles.riv',
                    fit: BoxFit.cover,
                  ),
                ).animate().scale(duration: 450.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 18),
                Text('Parish Connect',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w800,
                        )),
                const SizedBox(height: 8),
                Text('Administer • Unite • Serve',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        )),
                const SizedBox(height: 24),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ONBOARDING
// =============================================================================

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  void _next() {
    if (_index < 2) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic);
    } else {
      appState.completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  _OnboardPage(
                    title: 'Welcome to Parish Connect',
                    subtitle:
                        'A beautiful, streamlined way to manage SCCs, Parishes, Missions and Deaneries.',
                    emoji: '⛪',
                  ),
                  _OnboardPage(
                    title: 'Powerful Admin Tools',
                    subtitle:
                        'Analytics, quick actions, and user management — all at your fingertips.',
                    emoji: '🛠️',
                  ),
                  _OnboardPage(
                    title: 'Stay in the Loop',
                    subtitle:
                        'Activities, documents, and updates — always organized, always accessible.',
                    emoji: '🗂️',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: cs.primary,
                      dotColor: cs.onSurfaceVariant.withValues(alpha: 0.3),
                      expansionFactor: 3,
                      spacing: 6,
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _next,
                    child: Text(_index < 2 ? 'Next' : 'Get Started'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage(
      {required this.title, required this.subtitle, required this.emoji});
  final String title;
  final String subtitle;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primary(context),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 88)),
          ),
          const SizedBox(height: 24),
          Text(title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

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
                    child: _BrandButton(
                      color: const Color(0xFF4285F4),
                      icon: Icons.g_mobiledata,
                      label: 'Google',
                      onTap: () => appState.login(email: 'google@user.com'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _BrandButton(
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
                    child: _BrandButton(
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

class _BrandButton extends StatelessWidget {
  const _BrandButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MAIN SHELL + ANIMATED BOTTOM NAV
// =============================================================================

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  int _index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final isAdmin = appState.isAdmin;
    _pages = [
      const HomeScreen(),
      const ActivitiesScreen(),
      if (isAdmin) const AdminDashboardScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = appState.isAdmin;
    final items = [
      _NavItem(icon: Icons.home_outlined, label: 'Home'),
      _NavItem(icon: Icons.event_outlined, label: 'Activities'),
      if (isAdmin) _NavItem(icon: Icons.dashboard_customize_outlined, label: 'Dashboard'),
      _NavItem(icon: Icons.person_outline, label: 'Profile'),
      _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
    ];

    // keep index within bounds if admin toggled state changed
    if (_index >= items.length) _index = items.length - 1;

    return Scaffold(
      extendBody: true,
      drawer: const _AppDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _pages[_index],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: AnimatedBottomNavBar(
          currentIndex: _index,
          items: items,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}

class AnimatedBottomNavBar extends StatelessWidget {
  const AnimatedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.soft(context),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++)
            _AnimatedNavItem(
              index: i,
              selected: i == currentIndex,
              item: items[i],
              onTap: () => onTap(i),
            ),
        ],
      ),
    );
  }
}

class _AnimatedNavItem extends StatelessWidget {
  const _AnimatedNavItem({
    required this.index,
    required this.selected,
    required this.item,
    required this.onTap,
  });
  final int index;
  final bool selected;
  final _NavItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? cs.primaryContainer.withValues(alpha: 0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon,
                  color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: SizedBox(width: selected ? 8 : 0),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: selected ? 1 : 0,
                child: Text(
                  selected ? item.label : '',
                  overflow: TextOverflow.fade,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HOME
// =============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAdmin = appState.isAdmin;
    return Scaffold(
      drawer: const _AppDrawer(),
      appBar: AppBar(
        title: const Text('Parish Connect'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.wb_sunny_outlined, color: Colors.amber),
            onPressed: () {
              appState.setThemeMode(appState.themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroHeader().animate().fadeIn(duration: 400.ms).move(begin: const Offset(0, 12)),
          const SizedBox(height: 16),
          Text('Quick Access', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 120,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            children: [
              _QuickCard(
                icon: Icons.groups_2_outlined,
                title: 'SCC',
                onTap: () => _openSection(context, 'SCC'),
              ).animate().fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
              _QuickCard(
                icon: Icons.church_outlined,
                title: 'Parish',
                onTap: () => _openSection(context, 'Parish'),
              ).animate(delay: 60.ms).fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
              _QuickCard(
                icon: Icons.location_city_outlined,
                title: 'Mission Station',
                onTap: () => _openSection(context, 'Mission Station'),
              ).animate(delay: 120.ms).fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
              _QuickCard(
                icon: Icons.account_balance_outlined,
                title: 'Deanery',
                onTap: () => _openSection(context, 'Deanery'),
              ).animate(delay: 180.ms).fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
              if (isAdmin)
                _QuickCard(
                  icon: Icons.dashboard_customize_outlined,
                  title: 'Admin',
                  onTap: () => Navigator.of(context).push(
                      _AnimatedRoute(const AdminDashboardScreen())),
                ).animate(delay: 240.ms).fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
            ],
          ),
          const SizedBox(height: 20),
          Text('Upcoming Activities', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
            4,
            (i) => _ActivityTile(
              title: 'Community Service Day',
              subtitle: 'Saturday 10:00 AM · Parish Grounds',
              onTap: () {},
            ).animate(delay: (i * 80).ms).fadeIn(duration: 350.ms).move(begin: const Offset(0, 10)),
          )
        ],
      ),
    );
  }

  void _openSection(BuildContext context, String title) {
    Navigator.of(context).push(_AnimatedRoute(SectionScreen(title: title)));
  }
}

class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppGradients.primary(context),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('St. Mary’s Parish',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('“One body, many parts.”',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.white.withValues(alpha: 0.2)),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  ),
                  child: const Text('View Bulletin'),
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.temple_buddhist, size: 96, color: Colors.white),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primaryContainer,
              ),
              child: Icon(icon, color: cs.onPrimaryContainer),
            ),
            const Spacer(),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.title, required this.subtitle, this.onTap});
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: CircleAvatar(
          backgroundColor: cs.tertiary.withValues(alpha: 0.18),
          child: Icon(Icons.event, color: cs.tertiary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}

// =============================================================================
// ACTIVITIES (placeholder list with pull-to-refresh)
// =============================================================================

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});
  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<String> items = List.generate(10, (i) => 'Activity ${i + 1}');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => items = List.from(items.reversed));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activities')),
      drawer: const _AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, i) => _ActivityTile(
            title: items[i],
            subtitle: 'Tap to view details',
            onTap: () {},
          ).animate(delay: (i * 40).ms).fadeIn().move(begin: const Offset(0, 8)),
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION SCREEN (SCC / Parish / Mission Station / Deanery)
// =============================================================================

class SectionScreen extends StatefulWidget {
  const SectionScreen({super.key, required this.title});
  final String title;
  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
              ),
              child: TabBar(
                controller: _tab,
                indicator: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
                unselectedLabelColor: cs.onSurfaceVariant,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'List'),
                  Tab(text: 'Add New'),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: const _AppDrawer(),
      body: TabBarView(
        controller: _tab,
        children: [
          _OverviewTab(title: widget.title),
          const _ListTab(),
          _AddNewForm(section: widget.title),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$title Snapshot',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatChip(icon: Icons.people_outline, label: 'Members', value: '124'),
                    const SizedBox(width: 12),
                    _StatChip(icon: Icons.description_outlined, label: 'Docs', value: '37'),
                    const SizedBox(width: 12),
                    _StatChip(icon: Icons.history, label: 'Activities', value: '12'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Documents', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...List.generate(
                  3,
                  (i) => ListTile(
                    leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text('Document ${i + 1}.pdf'),
                    trailing:
                        Icon(Icons.download_outlined, color: cs.onSurfaceVariant),
                    onTap: () => _showToast(context, 'Download started', type: ToastificationType.success),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: cs.tertiary.withValues(alpha: 0.15),
              child: Icon(icon, color: cs.tertiary),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(value,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ListTab extends StatelessWidget {
  const _ListTab();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, i) => Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: cs.secondary.withValues(alpha: 0.15),
            child: Icon(Icons.folder_open, color: cs.secondary),
          ),
          title: Text('Record ${i + 1}'),
          subtitle: const Text('Tap to view, edit or download PDF'),
          trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
          onTap: () => Navigator.of(context).push(_AnimatedRoute(
            DetailView(title: 'Record ${i + 1}'),
          )),
        ),
      ),
    );
  }
}

class _AddNewForm extends StatefulWidget {
  const _AddNewForm({required this.section});
  final String section;
  @override
  State<_AddNewForm> createState() => _AddNewFormState();
}

class _AddNewFormState extends State<_AddNewForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  DateTime? _date;
  String? _status;
  String? _location;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'Active', child: Text('Active')),
                DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
              ],
              onChanged: (v) => setState(() => _status = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _location,
              decoration: const InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.place_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'North', child: Text('North')),
                DropdownMenuItem(value: 'South', child: Text('South')),
                DropdownMenuItem(value: 'East', child: Text('East')),
                DropdownMenuItem(value: 'West', child: Text('West')),
              ],
              onChanged: (v) => setState(() => _location = v),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(_date == null
                  ? 'Pick a date'
                  : '${_date!.day}/${_date!.month}/${_date!.year}'),
              onTap: () async {
                final now = DateTime.now();
                final res = await showDatePicker(
                  context: context,
                  firstDate: DateTime(now.year - 5),
                  lastDate: DateTime(now.year + 5),
                  initialDate: now,
                );
                if (res != null) setState(() => _date = res);
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload related PDF'),
              subtitle: const Text('File picker opens here (stubbed in demo)'),
              onTap: () => _showToast(context, 'File picker not connected'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    _showToast(context, 'Submitted successfully', type: ToastificationType.success);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            const SizedBox(height: 12),
            _BackendNote(cs: cs),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DETAIL VIEW
// =============================================================================

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.folder, color: cs.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text('Status: Active • Location: North',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showToast(context, 'PDF downloaded', type: ToastificationType.success),
                  icon: const Icon(Icons.download),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Details', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text('Description about this item goes here.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Documents', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...List.generate(
                    3,
                    (i) => ListTile(
                      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text('Attachment ${i + 1}.pdf'),
                      trailing:
                          Icon(Icons.download_outlined, color: cs.onSurfaceVariant),
                      onTap: () => _showToast(context, 'PDF downloaded', type: ToastificationType.success),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity History',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...List.generate(
                    4,
                    (i) => ListTile(
                      leading: const Icon(Icons.history),
                      title: Text('Updated record ${i + 1}'),
                      subtitle: const Text('2d ago · by Admin'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ADMIN DASHBOARD
// =============================================================================

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 110,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            children: const [
              _MetricCard(icon: Icons.groups, label: 'SCCs', count: 18),
              _MetricCard(icon: Icons.church, label: 'Parishes', count: 6),
              _MetricCard(icon: Icons.location_city, label: 'Missions', count: 9),
              _MetricCard(icon: Icons.account_balance, label: 'Deaneries', count: 3),
              _MetricCard(icon: Icons.person, label: 'Users', count: 142),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
            ),
            alignment: Alignment.center,
            child: Text('Chart: Activities over time',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 16),
          Text('Recent Activities', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
            5,
            (i) => ListTile(
              leading: const Icon(Icons.notifications_none),
              title: Text('Updated Mission ${i + 1}'),
              subtitle: const Text('Today · by Admin'),
              trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 12),
          Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionChip(icon: Icons.group_add, label: 'Create SCC', onTap: () {}),
              _ActionChip(icon: Icons.add_business, label: 'Create Parish', onTap: () {}),
              _ActionChip(icon: Icons.picture_as_pdf, label: 'Upload PDF template', onTap: () {}),
              _ActionChip(icon: Icons.manage_accounts, label: 'Manage Users', onTap: () {}),
            ],
          ),
          const SizedBox(height: 20),
          _BackendNote(cs: cs),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.label, required this.count});
  final IconData icon;
  final String label;
  final int count;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: cs.primaryContainer,
            child: Icon(icon, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text('$count',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
            ],
          )
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: cs.primaryContainer,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: cs.onPrimaryContainer),
          const SizedBox(width: 8),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

// =============================================================================
// PROFILE
// =============================================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAdmin = appState.isAdmin;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      drawer: const _AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.person, size: 44, color: cs.onPrimaryContainer),
                ),
                const SizedBox(height: 12),
                Text('Alex Johnson',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
                Text(isAdmin ? 'Administrator · St. Mary’s Parish' : 'Member · St. Mary’s Parish',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Information',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const _KeyValueRow(icon: Icons.email, label: 'Email', value: 'alex@example.com'),
                  const _KeyValueRow(icon: Icons.phone, label: 'Phone', value: '+1 555 0101'),
                  const _KeyValueRow(icon: Icons.place, label: 'Parish', value: 'St. Mary’s'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Responsibilities', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...['Youth Ministry', 'Charity Committee', 'Music Team'].map(
                    (r) => ListTile(
                      leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                      title: Text(r),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: cs.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ]),
    );
  }
}

// =============================================================================
// SETTINGS
// =============================================================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = appState;
    final cs = Theme.of(context).colorScheme;
    ThemeMode mode = app.themeMode;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const _AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle between light and dark themes'),
                value: mode == ThemeMode.dark,
                onChanged: (v) => app.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Notifications'),
                subtitle: const Text('Manage preferences'),
                onTap: () => _showToast(context, 'Notifications preferences not connected'),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Language'),
                subtitle: const Text('English'),
                onTap: () {},
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout'),
                onTap: () => appState.logout(),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete/Disable Account'),
                onTap: () => _showToast(context, 'Account action requires backend', type: ToastificationType.warning),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          _BackendNote(cs: cs),
        ],
      ),
    );
  }
}

// =============================================================================
// HELPERS
// =============================================================================

Route _AnimatedRoute(Widget child) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}

void _showToast(BuildContext context, String msg, {ToastificationType type = ToastificationType.info}) {
  try {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(msg),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      showProgressBar: true,
    );
  } catch (_) {
    // Fallback to SnackBar in unlikely case toastification fails
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// =============================================================================
// APP DRAWER (Animated with Rive header)
// =============================================================================

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: const rive.RiveAnimation.network(
                        'https://cdn.rive.app/animations/vehicles.riv',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: cs.primaryContainer,
                          child: Icon(Icons.church, color: cs.onPrimaryContainer),
                        ),
                        const SizedBox(width: 10),
                        Text('Parish Connect',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: Icon(Icons.home_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Home'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.event_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Activities'),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.dashboard_customize_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Admin Dashboard'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.groups_2_outlined, color: cs.onSurfaceVariant),
                    title: const Text('SCC'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(_AnimatedRoute(const SectionScreen(title: 'SCC')));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.church_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Parish'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(_AnimatedRoute(const SectionScreen(title: 'Parish')));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.location_city_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Mission Station'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(_AnimatedRoute(const SectionScreen(title: 'Mission Station')));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Deanery'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(_AnimatedRoute(const SectionScreen(title: 'Deanery')));
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: appState.themeMode == ThemeMode.dark,
                    onChanged: (v) => appState.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    onTap: () {
                      appState.logout();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ).animate().fadeIn(duration: 250.ms),
            ),
          ],
        ),
      ),
    );
  }
}
