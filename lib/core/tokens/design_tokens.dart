import 'package:flutter/material.dart';

abstract final class DesignTokens {
  // Spacing
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space18 = 18.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space28 = 28.0;
  static const double space32 = 32.0;
  static const double space36 = 36.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;
  static const double space72 = 72.0;
  static const double space80 = 80.0;
  static const double space96 = 96.0;
  static const double space120 = 120.0;

  // Border Radii
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2Xl = 24.0;
  static const double radius3Xl = 32.0;
  static const double radiusPill = 999.0;

  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius border2Xl = BorderRadius.all(Radius.circular(radius2Xl));
  static const BorderRadius border3Xl = BorderRadius.all(Radius.circular(radius3Xl));
  static const BorderRadius borderPill = BorderRadius.all(Radius.circular(radiusPill));

  // Breakpoints
  static const double breakpointMobile = 600.0;
  static const double breakpointNavCollapse = 900.0;
  static const double breakpointTablet = 1024.0;
  static const double breakpointDesktop = 1280.0;

  // Max Widths
  static const double maxContentWidth = 1152.0; // 6xl
  static const double maxNarrowContentWidth = 896.0; // 4xl
  static const double maxArticleWidth = 768.0; // 3xl

  // Navbar
  static const double navHeight = 64.0;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationReveal = Duration(milliseconds: 600);
  static const Duration durationCounter = Duration(milliseconds: 1400);

  // Animation Curves
  static const Curve curveStandard = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Curve curveEaseOut = Curves.easeOutCubic;
}
