import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Core Cinematic Dark Palette - Lighter Glass Theme
  static const Color primaryBg      = Color(0xFF12141D); // Lighter Slate #12141D
  static const Color secondaryBg    = Color(0xFF191C28); // Secondary Background #191C28
  static const Color cardBg         = Color(0xFF222636); // Card Background #222636
  
  static const Color primaryAccent  = Color(0xFFE50914); // Netflix Crimson Red
  static const Color secondaryAccent= Color(0xFF9E0B16); // Deep Crimson
  static const Color textPrimary    = Color(0xFFFFFFFF); // Pure White
  static const Color textSecondary  = Color(0xFFB0B3C0); // Soft Slate Grey
  static const Color textDisabled   = Color(0xFF6B7082); // Soft Muted Grey
  
  static const Color divider        = Color(0x26FFFFFF); // Almost Invisible (15% White)
  
  // Legacy aliases for backward compatibility across existing widgets
  static const Color deepBlack    = primaryBg;
  static const Color darkGraphite = secondaryBg;
  static const Color cardSurface  = cardBg;
  static const Color elevated     = Color(0xFF2B3044);
  static const Color deepRed      = primaryAccent;
  static const Color red          = Color(0xFFE50914);
  static const Color redFaded     = Color(0x33E50914);

  // Core Light Palette
  static const Color lightBg        = Color(0xFFF5F5F7);
  static const Color lightSurface   = Color(0xFFFFFFFF);
  static const Color lightElevated  = Color(0xFFE8E8ED);
  static const Color lightDivider   = Color(0xFFD1D1D6);
  static const Color lightText      = Color(0xFF1C1C1E);
  static const Color lightSubtext   = Color(0xFF6E6E73);

  // White spectrum
  static const Color white        = Color(0xFFFFFFFF);
  static const Color white90      = Color(0xE6FFFFFF);
  static const Color white70      = Color(0xB3FFFFFF);
  static const Color white50      = Color(0x80FFFFFF);
  static const Color white30      = Color(0x4DFFFFFF);
  static const Color white15      = Color(0x26FFFFFF);

  // Signature Gold
  static const Color gold         = Color(0xFFF5C518);
  static const Color goldLight    = Color(0xFFFFD700);
  static const Color goldDark     = Color(0xFFC79A00);
  static const Color goldFaded    = Color(0x33F5C518);

  // Glassmorphism
  static const Color glass        = Color(0x2BFFFFFF);
  static const Color glassBorder  = Color(0x38FFFFFF);
}

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    final fontTheme = GoogleFonts.schibstedGroteskTextTheme(base.textTheme);
    final mainFontFamily = GoogleFonts.schibstedGrotesk().fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primaryBg,
      primaryColor: AppColors.primaryAccent,
      fontFamily: mainFontFamily,

      colorScheme: const ColorScheme.dark(
        primary:                 AppColors.primaryAccent,
        onPrimary:               AppColors.white,
        secondary:               AppColors.gold,
        onSecondary:             AppColors.primaryBg,
        surface:                 AppColors.secondaryBg,
        onSurface:               AppColors.textPrimary,
        surfaceContainerHighest: AppColors.cardBg,
        outline:                 AppColors.divider,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor:        Colors.transparent,
        elevation:              0,
        scrolledUnderElevation: 0,
        centerTitle:            false,
        iconTheme:              const IconThemeData(color: AppColors.white),
        titleTextStyle:         TextStyle(
          fontFamily: mainFontFamily,
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.secondaryBg,
        indicatorColor:  AppColors.primaryAccent.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryAccent, size: 26);
          }
          return const IconThemeData(color: AppColors.textSecondary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.primaryAccent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            );
          }
          return const TextStyle(color: AppColors.textSecondary, fontSize: 11);
        }),
        height: 68,
        elevation: 0,
      ),

      textTheme: fontTheme.copyWith(
        displayLarge: fontTheme.displayLarge?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        displayMedium: fontTheme.displayMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: fontTheme.headlineLarge?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineMedium: fontTheme.headlineMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: fontTheme.titleLarge?.copyWith(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: fontTheme.titleMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: fontTheme.bodyLarge?.copyWith(color: AppColors.white90),
        bodyMedium: fontTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        bodySmall: fontTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        labelLarge: fontTheme.labelLarge?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardBg,
        selectedColor:   AppColors.primaryAccent,
        side:            const BorderSide(color: AppColors.divider),
        labelStyle:      const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        padding:         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cardBg,
        contentTextStyle: const TextStyle(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.textSecondary),
      ),
    );
  }

  static ThemeData get lightTheme => darkTheme; // Default to dark aesthetic
}

/// Shared styling helpers
class AppStyles {
  static BoxDecoration get glassCard => BoxDecoration(
    color: AppColors.glass,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.glassBorder, width: 1),
  );

  static BoxDecoration glassCardRounded(double radius) => BoxDecoration(
    color: AppColors.glass,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: AppColors.glassBorder, width: 1),
  );

  static BoxDecoration get goldBadge => BoxDecoration(
    color: AppColors.goldFaded,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
  );

  static TextStyle get sectionTitle => const TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static TextStyle get goldLabel => const TextStyle(
    color: AppColors.gold,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
}
