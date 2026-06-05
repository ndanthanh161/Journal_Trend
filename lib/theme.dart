import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system inspired by Shopify Polaris.
/// Light theme, forest green primary, flat cards, tight radius.
class AppTheme {
  // ── Primary ──
  static const Color brandGreen = Color(0xFF008060);
  static const Color darkGreen = Color(0xFF004C3F);

  // ── Accent ──
  static const Color interactiveBlue = Color(0xFF0070D9);

  // ── Neutral / Text ──
  static const Color textPrimary = Color(0xFF202223);
  static const Color textSecondary = Color(0xFF6D7175);
  static const Color textDisabled = Color(0xFF8C9196);

  // ── Surfaces & Borders ──
  static const Color pageBg = Color(0xFFF6F6F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFC9CCCF);
  static const Color borderSubdued = Color(0xFFE4E5E7);

  // ── Semantic ──
  static const Color success = Color(0xFF008060);
  static const Color warning = Color(0xFFFFC453);
  static const Color critical = Color(0xFFD72C0D);
  static const Color highlight = Color(0xFFEAF4FB);

  // ── Helpers ──
  static const Color greenSoft = Color(0x1A008060); // 10%
  static const Color blueSoft = Color(0x1A0070D9);

  static ThemeData get lightTheme {
    final base = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: pageBg,
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          height: 1.2,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        titleLarge: base.titleLarge?.copyWith(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleMedium: base.titleMedium?.copyWith(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          color: textSecondary,
          fontSize: 13,
          height: 1.5,
        ),
        labelLarge: base.labelLarge?.copyWith(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.01,
        ),
        labelSmall: base.labelSmall?.copyWith(
          color: textDisabled,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.01,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: brandGreen,
        secondary: interactiveBlue,
        error: critical,
        surface: surface,
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
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 22),
        shape: const Border(
          bottom: BorderSide(color: borderSubdued, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: GoogleFonts.inter(color: textDisabled, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: brandGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: critical, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brandGreen,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderSubdued,
        thickness: 1,
        space: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: brandGreen,
        unselectedItemColor: textDisabled,
        selectedLabelStyle:
            GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
