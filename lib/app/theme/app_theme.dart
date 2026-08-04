import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Core Cinematic Dark Palette - Exact Prompt Spec
  static const Color primaryBg      = Color(0xFF0B0B0D); // Primary Background #0B0B0D
  static const Color secondaryBg    = Color(0xFF151515); // Secondary Background #151515
  static const Color cardBg         = Color(0xFF1D1D1F); // Card Background #1D1D1F
  
  static const Color primaryAccent  = Color(0xFFC41E2F); // Deep Cinema Red
  static const Color secondaryAccent= Color(0xFF6E0F1A); // Dark Crimson
  static const Color textPrimary    = Color(0xFFFFFFFF); // Pure White
  static const Color textSecondary  = Color(0xFFA0A0A0); // Soft Grey
  static const Color textDisabled   = Color(0xFF55555A); // Soft Muted Grey
  
  static const Color divider        = Color(0x1AFFFFFF); // Almost Invisible (10% White)
  
  // Legacy aliases for backward compatibility across existing widgets
  static const Color deepBlack    = primaryBg;
  static const Color darkGraphite = secondaryBg;
  static const Color cardSurface  = cardBg;
  static const Color elevated     = Color(0xFF242428);
  static const Color deepRed      = primaryAccent;
  static const Color red          = Color(0xFFE50914);
  static const Color redFaded     = Color(0x33C41E2F);

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
  static const Color gold         = Color(0xFFD4AF37);
  static const Color goldLight    = Color(0xFFE8C84A);
  static const Color goldDark     = Color(0xFFAA8C2A);
  static const Color goldFaded    = Color(0x33D4AF37);

  // Glassmorphism
  static const Color glass        = Color(0x1AFFFFFF);
  static const Color glassBorder  = Color(0x26FFFFFF);
}

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    final outfitText = GoogleFonts.outfitTextTheme(base.textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primaryBg,
      primaryColor: AppColors.primaryAccent,

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

      appBarTheme: const AppBarTheme(
        backgroundColor:        Colors.transparent,
        elevation:              0,
        scrolledUnderElevation: 0,
        centerTitle:            false,
        iconTheme:              IconThemeData(color: AppColors.white),
        titleTextStyle:         TextStyle(
          fontFamily: 'Outfit',
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

      textTheme: outfitText.copyWith(
        displayLarge: outfitText.displayLarge?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        displayMedium: outfitText.displayMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: outfitText.headlineLarge?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineMedium: outfitText.headlineMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: outfitText.titleLarge?.copyWith(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: outfitText.titleMedium?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: outfitText.bodyLarge?.copyWith(color: AppColors.white90),
        bodyMedium: outfitText.bodyMedium?.copyWith(color: AppColors.textSecondary),
        bodySmall: outfitText.bodySmall?.copyWith(color: AppColors.textSecondary),
        labelLarge: outfitText.labelLarge?.copyWith(
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
