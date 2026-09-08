import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 48.0;
  static const double xxl = 64.0;
}

class AppRadius {
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double pill = 999.0;
}

class LightModeColors {
  // Warm ivory and cream background
  static const lightBackground = Color(0xFFFCFAF5); // Ivory
  static const lightSurface = Color(0xFFFFFFFF); // Clean white for cards
  
  // Deep forest-charcoal / muted green text
  static const lightOnSurface = Color(0xFF2C362F);
  
  // Muted sage green primary
  static const lightPrimary = Color(0xFF7A9681);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFE4EDE7);
  static const lightOnPrimaryContainer = Color(0xFF2C362F);

  // Soft lavender accent
  static const lightSecondary = Color(0xFFD4CBE5);
  static const lightOnSecondary = Color(0xFF332B32);
  static const lightSecondaryContainer = Color(0xFFEBE6F2);
  static const lightOnSecondaryContainer = Color(0xFF332B32);

  // Dusty blue accent (used as tertiary)
  static const lightTertiary = Color(0xFFA8B9C8);
  static const lightOnTertiary = Color(0xFF1E262B);
  static const lightTertiaryContainer = Color(0xFFDDE6ED);
  static const lightOnTertiaryContainer = Color(0xFF1E262B);

  static const lightSurfaceVariant = Color(0xFFF3EFE9);
  static const lightOutline = Color(0xFFD0CCC7);
}

// Dark mode preserved mostly as-is, adjusted to match new hues
class DarkModeColors {
  static const darkBackground = Color(0xFF1E211F);
  static const darkSurface = Color(0xFF272B28);
  static const darkOnSurface = Color(0xFFE8E9E7);
  
  static const darkPrimary = Color(0xFF90AE98);
  static const darkOnPrimary = Color(0xFF1E2B22);
  static const darkPrimaryContainer = Color(0xFF374D3E);
  static const darkOnPrimaryContainer = Color(0xFFE4EDE7);

  static const darkSecondary = Color(0xFFBDB2D1);
  static const darkOnSecondary = Color(0xFF2B2233);
  
  static const darkTertiary = Color(0xFF8FA1B0);
  static const darkOnTertiary = Color(0xFF162028);

  static const darkSurfaceVariant = Color(0xFF3A3E3B);
  static const darkOutline = Color(0xFF868A87);
}

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    primaryContainer: LightModeColors.lightPrimaryContainer,
    onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    secondaryContainer: LightModeColors.lightSecondaryContainer,
    onSecondaryContainer: LightModeColors.lightOnSecondaryContainer,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    tertiaryContainer: LightModeColors.lightTertiaryContainer,
    onTertiaryContainer: LightModeColors.lightOnTertiaryContainer,
    surface: LightModeColors.lightSurface,
    onSurface: LightModeColors.lightOnSurface,
    surfaceContainerHighest: LightModeColors.lightSurfaceVariant,
    outline: LightModeColors.lightOutline,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: LightModeColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: LightModeColors.lightOnSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    color: LightModeColors.lightSurface,
    elevation: 4,
    shadowColor: Colors.black.withValues(alpha: 0.05),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: BorderSide.none,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: LightModeColors.lightPrimary,
      foregroundColor: LightModeColors.lightOnPrimary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),
  textTheme: _buildTextTheme(),
);

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
    surface: DarkModeColors.darkSurface,
    onSurface: DarkModeColors.darkOnSurface,
    surfaceContainerHighest: DarkModeColors.darkSurfaceVariant,
    outline: DarkModeColors.darkOutline,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DarkModeColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: DarkModeColors.darkOnSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    color: DarkModeColors.darkSurface,
    elevation: 4,
    shadowColor: Colors.black.withValues(alpha: 0.2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: BorderSide.none,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: DarkModeColors.darkPrimary,
      foregroundColor: DarkModeColors.darkOnPrimary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),
  textTheme: _buildTextTheme(),
);

TextTheme _buildTextTheme() {
  // Elegant serif for headings
  final headingFont = GoogleFonts.playfairDisplayTextTheme().copyWith(
    displayLarge: GoogleFonts.playfairDisplay(fontSize: 48, fontWeight: FontWeight.w500, letterSpacing: -0.5),
    displayMedium: GoogleFonts.playfairDisplay(fontSize: 36, fontWeight: FontWeight.w500),
    displaySmall: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.w500),
    headlineLarge: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w600),
    headlineMedium: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w600),
    headlineSmall: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w600),
  );

  // Very readable sans-serif for body
  return headingFont.copyWith(
    titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.2),
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2),
    labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2),
  );
}
