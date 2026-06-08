import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark research analytics design system.
/// High-contrast surfaces, restrained glow colors, and dense data hierarchy.
class AppTheme {
  static const Color brandGreen = Color(0xFF34D399);
  static const Color darkGreen = Color(0xFF10B981);
  static const Color interactiveBlue = Color(0xFF38BDF8);
  static const Color indigo = Color(0xFFA78BFA);
  static const Color dashboardBlue = Color(0xFF60A5FA);

  static const Color textPrimary = Color(0xFFE5EEF9);
  static const Color textSecondary = Color(0xFF9FB0C7);
  static const Color textDisabled = Color(0xFF64748B);

  static const Color pageBg = Color(0xFF08111F);
  static const Color surface = Color(0xFF0F1B2D);
  static const Color surfaceMuted = Color(0xFF17263B);
  static const Color borderColor = Color(0xFF2A3A52);
  static const Color borderSubdued = Color(0xFF1E2D42);

  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color critical = Color(0xFFF87171);
  static const Color highlight = Color(0xFF102A43);

  static const Color greenSoft = Color(0x2634D399);
  static const Color blueSoft = Color(0x2638BDF8);
  static const Color amberSoft = Color(0x26F59E0B);

  static ThemeData get lightTheme {
    final base = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: pageBg,
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(
          color: textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.2,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.3,
        ),
        titleLarge: base.titleLarge?.copyWith(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.4,
        ),
        titleMedium: base.titleMedium?.copyWith(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.6,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          color: textSecondary,
          fontSize: 13,
          letterSpacing: 0,
          height: 1.5,
        ),
        labelLarge: base.labelLarge?.copyWith(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          color: textDisabled,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: dashboardBlue,
        secondary: brandGreen,
        error: critical,
        surface: surface,
        surfaceContainerHighest: surfaceMuted,
        onSurface: textPrimary,
        outline: borderColor,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: borderSubdued, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 22),
        shape: const Border(
          bottom: BorderSide(color: borderSubdued, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceMuted,
        prefixIconColor: textDisabled,
        suffixIconColor: textDisabled,
        hintStyle: GoogleFonts.inter(color: textDisabled, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: dashboardBlue, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: critical, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: dashboardBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: dashboardBlue,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderSubdued,
        thickness: 1,
        space: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: dashboardBlue,
        unselectedItemColor: textDisabled,
        selectedLabelStyle:
            GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
