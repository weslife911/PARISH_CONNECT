import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  // Spacing values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Edge insets shortcuts
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
}

/// Border radius constants for consistent rounded corners
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

// =============================================================================
// TEXT STYLE EXTENSIONS
// =============================================================================

/// Extension to add text style utilities to BuildContext
/// Access via context.textStyles
extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

/// Helper methods for common text style modifications
extension TextStyleExtensions on TextStyle {
  /// Make text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Make text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Make text medium weight
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Make text normal weight
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);

  /// Make text light
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  /// Add custom color
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Add custom size
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

// =============================================================================
// COLORS
// =============================================================================

/// Brand palettes (Royal purple primary, gold accent)
class LightModeColors {
  // Primary: Royal purple
  static const lightPrimary = Color(0xFF4B2E83);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFE5D9FF);
  static const lightOnPrimaryContainer = Color(0xFF2A1456);

  // Secondary: Amber/Gold
  static const lightSecondary = Color(0xFFFFC107);
  static const lightOnSecondary = Color(0xFF1C1400);

  // Tertiary: Deep church blue
  static const lightTertiary = Color(0xFF183153);
  static const lightOnTertiary = Color(0xFFDEECFF);

  // Error
  static const lightError = Color(0xFFBA1A1A);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFDAD6);
  static const lightOnErrorContainer = Color(0xFF410002);

  // Surfaces
  static const lightSurface = Color(0xFFF8F7F3); // soft off-white
  static const lightOnSurface = Color(0xFF141519);
  static const lightBackground = Color(0xFFFAF9F6);
  static const lightSurfaceVariant = Color(0xFFEAE6F5);
  static const lightOnSurfaceVariant = Color(0xFF47464F);

  // Outline and shadow
  static const lightOutline = Color(0xFF8C8899);
  static const lightShadow = Color(0xFF000000);
  static const lightInversePrimary = Color(0xFFD7C9FF);
}

class DarkModeColors {
  // Primary on dark
  static const darkPrimary = Color(0xFFD7C9FF);
  static const darkOnPrimary = Color(0xFF2A1456);
  static const darkPrimaryContainer = Color(0xFF3A236D);
  static const darkOnPrimaryContainer = Color(0xFFE5D9FF);

  // Secondary
  static const darkSecondary = Color(0xFFFFE081);
  static const darkOnSecondary = Color(0xFF201500);

  // Tertiary
  static const darkTertiary = Color(0xFFB4D2FF);
  static const darkOnTertiary = Color(0xFF0F2440);

  // Error
  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);

  // Surfaces: deep navy/charcoal
  static const darkSurface = Color(0xFF0B1220);
  static const darkOnSurface = Color(0xFFE7EAF3);
  static const darkSurfaceVariant = Color(0xFF2A2F3C);
  static const darkOnSurfaceVariant = Color(0xFFBFC4D1);

  // Outline and shadow
  static const darkOutline = Color(0xFF8E90A0);
  static const darkShadow = Color(0xFF000000);
  static const darkInversePrimary = Color(0xFF4B2E83);
}

/// Font size constants
class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

// =============================================================================
// THEMES
// =============================================================================

/// Light theme: modern, high-contrast, rounded, church brand
ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    primaryContainer: LightModeColors.lightPrimaryContainer,
    onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    error: LightModeColors.lightError,
    onError: LightModeColors.lightOnError,
    errorContainer: LightModeColors.lightErrorContainer,
    onErrorContainer: LightModeColors.lightOnErrorContainer,
    surface: LightModeColors.lightSurface,
    onSurface: LightModeColors.lightOnSurface,
    surfaceContainerHighest: LightModeColors.lightSurfaceVariant,
    onSurfaceVariant: LightModeColors.lightOnSurfaceVariant,
    outline: LightModeColors.lightOutline,
    shadow: LightModeColors.lightShadow,
    inversePrimary: LightModeColors.lightInversePrimary,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: LightModeColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: LightModeColors.lightOnSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: LightModeColors.lightOutline.withValues(alpha: 0.2),
        width: 1,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: LightModeColors.lightOnSurface),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(LightModeColors.lightPrimary),
      overlayColor: WidgetStatePropertyAll(
        LightModeColors.lightPrimaryContainer,
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      backgroundColor: const WidgetStatePropertyAll(LightModeColors.lightPrimary),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
  ),
  textTheme: _buildTextTheme(Brightness.light),
);

/// Dark theme with brand colors
ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: DarkModeColors.darkPrimary,
    onPrimary: DarkModeColors.darkOnPrimary,
    primaryContainer: DarkModeColors.darkPrimaryContainer,
    onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
    secondary: DarkModeColors.darkSecondary,
    onSecondary: DarkModeColors.darkOnSecondary,
    tertiary: DarkModeColors.darkTertiary,
    onTertiary: DarkModeColors.darkOnTertiary,
    error: DarkModeColors.darkError,
    onError: DarkModeColors.darkOnError,
    errorContainer: DarkModeColors.darkErrorContainer,
    onErrorContainer: DarkModeColors.darkOnErrorContainer,
    surface: DarkModeColors.darkSurface,
    onSurface: DarkModeColors.darkOnSurface,
    surfaceContainerHighest: DarkModeColors.darkSurfaceVariant,
    onSurfaceVariant: DarkModeColors.darkOnSurfaceVariant,
    outline: DarkModeColors.darkOutline,
    shadow: DarkModeColors.darkShadow,
    inversePrimary: DarkModeColors.darkInversePrimary,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DarkModeColors.darkSurface,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: DarkModeColors.darkOnSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: DarkModeColors.darkOutline.withValues(alpha: 0.2),
        width: 1,
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: DarkModeColors.darkOnSurface),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      backgroundColor: const WidgetStatePropertyAll(DarkModeColors.darkPrimaryContainer),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
  ),
  textTheme: _buildTextTheme(Brightness.dark),
);

/// Build text theme using a slightly rounded, friendly font (Nunito)
TextTheme _buildTextTheme(Brightness brightness) {
  return TextTheme(
    displayLarge: GoogleFonts.nunito(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: GoogleFonts.nunito(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: GoogleFonts.nunito(
      fontSize: FontSizes.displaySmall,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: GoogleFonts.nunito(
      fontSize: FontSizes.headlineLarge,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.nunito(
      fontSize: FontSizes.headlineSmall,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.nunito(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.nunito(
      fontSize: FontSizes.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.nunito(
      fontSize: FontSizes.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.nunito(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.nunito(
      fontSize: FontSizes.labelMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.nunito(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    bodyLarge: GoogleFonts.nunito(
      fontSize: FontSizes.bodyLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: GoogleFonts.nunito(
      fontSize: FontSizes.bodySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
  );
}

// =============================================================================
// APP GRADIENTS & COMPONENT HELPERS
// =============================================================================

class AppGradients {
  static Gradient primary(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LinearGradient(
      colors: [cs.primary, cs.tertiary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static Gradient glow(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RadialGradient(
      colors: [cs.secondary.withValues(alpha: 0.25), Colors.transparent],
      radius: 1.2,
    );
  }
}

class AppShadows {
  static List<BoxShadow> soft(BuildContext context) {
    return [
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }
}
