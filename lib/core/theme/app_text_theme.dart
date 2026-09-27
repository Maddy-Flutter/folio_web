import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextTheme {
  static TextTheme create(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color textColor = isDark ? const Color(0xFFF4F4F5) : const Color(0xFF18181B);
    final Color textMutedColor = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A);

    return TextTheme(
      displayLarge: GoogleFonts.ptSans(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.05,
        color: textColor,
      ),
      displayMedium: GoogleFonts.ptSans(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.1,
        color: textColor,
      ),
      displaySmall: GoogleFonts.ptSans(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.15,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.ptSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.ptSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.ptSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.3,
        color: textColor,
      ),
      titleLarge: GoogleFonts.ptSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.35,
        color: textColor,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: textColor,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        height: 1.6,
        color: textMutedColor,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: textMutedColor,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textMutedColor,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: textColor,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textMutedColor,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: textMutedColor,
      ),
    );
  }
}
