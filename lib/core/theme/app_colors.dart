import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand accents
  static const Color accent = Color(0xFFFF6B2B);
  static const Color accentLight = Color(0xFFFF8F5C);
  static const Color accentSubtleLight = Color(0xFFFFF7F4);
  static const Color accentSubtleBorderLight = Color(0xFFFED7AA);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);

  // Zinc scale
  static const Color zinc50 = Color(0xFFFAFAFA);
  static const Color zinc100 = Color(0xFFF4F4F5);
  static const Color zinc200 = Color(0xFFE4E4E7);
  static const Color zinc300 = Color(0xFFD4D4D8);
  static const Color zinc400 = Color(0xFFA1A1AA);
  static const Color zinc500 = Color(0xFF71717A);
  static const Color zinc600 = Color(0xFF52525B);
  static const Color zinc700 = Color(0xFF3F3F46);
  static const Color zinc800 = Color(0xFF27272A);
  static const Color zinc900 = Color(0xFF18181B);
  static const Color zinc950 = Color(0xFF09090B);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

@immutable
class PortfolioColors extends ThemeExtension<PortfolioColors> {
  const PortfolioColors({
    required this.accent,
    required this.accentLight,
    required this.cardBackground,
    required this.cardBorder,
    required this.cardBorderHover,
    required this.featuredCardBackground,
    required this.featuredCardBorder,
    required this.sectionAlternateBackground,
    required this.tagBackground,
    required this.tagText,
    required this.tagBorder,
    required this.activeTagBackground,
    required this.activeTagText,
    required this.activeTagBorder,
    required this.navBackground,
    required this.navBorder,
    required this.photoPlaceholder,
    required this.textMuted,
    required this.textSubtle,
    required this.statusAvailable,
    required this.inputBackground,
    required this.inputBorder,
    required this.inputBorderFocus,
  });

  final Color accent;
  final Color accentLight;
  final Color cardBackground;
  final Color cardBorder;
  final Color cardBorderHover;
  final Color featuredCardBackground;
  final Color featuredCardBorder;
  final Color sectionAlternateBackground;
  final Color tagBackground;
  final Color tagText;
  final Color tagBorder;
  final Color activeTagBackground;
  final Color activeTagText;
  final Color activeTagBorder;
  final Color navBackground;
  final Color navBorder;
  final Color photoPlaceholder;
  final Color textMuted;
  final Color textSubtle;
  final Color statusAvailable;
  final Color inputBackground;
  final Color inputBorder;
  final Color inputBorderFocus;

  static const PortfolioColors light = PortfolioColors(
    accent: AppColors.accent,
    accentLight: AppColors.accentLight,
    cardBackground: AppColors.white,
    cardBorder: AppColors.zinc100,
    cardBorderHover: AppColors.accent,
    featuredCardBackground: AppColors.zinc900,
    featuredCardBorder: AppColors.zinc800,
    sectionAlternateBackground: AppColors.zinc50,
    tagBackground: AppColors.zinc200,
    tagText: AppColors.zinc600,
    tagBorder: AppColors.zinc300,
    activeTagBackground: AppColors.accentSubtleLight,
    activeTagText: AppColors.accent,
    activeTagBorder: AppColors.accentSubtleBorderLight,
    navBackground: Color(0xE6FFFFFF), // white 90%
    navBorder: AppColors.zinc100,
    photoPlaceholder: AppColors.zinc200,
    textMuted: AppColors.zinc500,
    textSubtle: AppColors.zinc400,
    statusAvailable: AppColors.success,
    inputBackground: AppColors.zinc100,
    inputBorder: AppColors.zinc200,
    inputBorderFocus: AppColors.accent,
  );

  static const PortfolioColors dark = PortfolioColors(
    accent: AppColors.accent,
    accentLight: AppColors.accentLight,
    cardBackground: AppColors.zinc900,
    cardBorder: AppColors.zinc800,
    cardBorderHover: AppColors.accent,
    featuredCardBackground: AppColors.zinc800,
    featuredCardBorder: AppColors.zinc700,
    sectionAlternateBackground: Color(0x6618181B), // zinc900 with 40%
    tagBackground: AppColors.zinc800,
    tagText: AppColors.zinc400,
    tagBorder: AppColors.zinc700,
    activeTagBackground: Color(0x33FF6B2B), // accent 20%
    activeTagText: AppColors.accentLight,
    activeTagBorder: Color(0x66FF6B2B),
    navBackground: Color(0xE609090B), // zinc950 90%
    navBorder: AppColors.zinc900,
    photoPlaceholder: AppColors.zinc800,
    textMuted: AppColors.zinc400,
    textSubtle: AppColors.zinc500,
    statusAvailable: AppColors.success,
    inputBackground: AppColors.zinc800,
    inputBorder: AppColors.zinc700,
    inputBorderFocus: AppColors.accent,
  );

  @override
  PortfolioColors copyWith({
    Color? accent,
    Color? accentLight,
    Color? cardBackground,
    Color? cardBorder,
    Color? cardBorderHover,
    Color? featuredCardBackground,
    Color? featuredCardBorder,
    Color? sectionAlternateBackground,
    Color? tagBackground,
    Color? tagText,
    Color? tagBorder,
    Color? activeTagBackground,
    Color? activeTagText,
    Color? activeTagBorder,
    Color? navBackground,
    Color? navBorder,
    Color? photoPlaceholder,
    Color? textMuted,
    Color? textSubtle,
    Color? statusAvailable,
    Color? inputBackground,
    Color? inputBorder,
    Color? inputBorderFocus,
  }) {
    return PortfolioColors(
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      cardBorderHover: cardBorderHover ?? this.cardBorderHover,
      featuredCardBackground: featuredCardBackground ?? this.featuredCardBackground,
      featuredCardBorder: featuredCardBorder ?? this.featuredCardBorder,
      sectionAlternateBackground: sectionAlternateBackground ?? this.sectionAlternateBackground,
      tagBackground: tagBackground ?? this.tagBackground,
      tagText: tagText ?? this.tagText,
      tagBorder: tagBorder ?? this.tagBorder,
      activeTagBackground: activeTagBackground ?? this.activeTagBackground,
      activeTagText: activeTagText ?? this.activeTagText,
      activeTagBorder: activeTagBorder ?? this.activeTagBorder,
      navBackground: navBackground ?? this.navBackground,
      navBorder: navBorder ?? this.navBorder,
      photoPlaceholder: photoPlaceholder ?? this.photoPlaceholder,
      textMuted: textMuted ?? this.textMuted,
      textSubtle: textSubtle ?? this.textSubtle,
      statusAvailable: statusAvailable ?? this.statusAvailable,
      inputBackground: inputBackground ?? this.inputBackground,
      inputBorder: inputBorder ?? this.inputBorder,
      inputBorderFocus: inputBorderFocus ?? this.inputBorderFocus,
    );
  }

  @override
  PortfolioColors lerp(ThemeExtension<PortfolioColors>? other, double t) {
    if (other is! PortfolioColors) return this;
    return PortfolioColors(
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      accentLight: Color.lerp(accentLight, other.accentLight, t) ?? accentLight,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t) ?? cardBorder,
      cardBorderHover: Color.lerp(cardBorderHover, other.cardBorderHover, t) ?? cardBorderHover,
      featuredCardBackground:
          Color.lerp(featuredCardBackground, other.featuredCardBackground, t) ?? featuredCardBackground,
      featuredCardBorder:
          Color.lerp(featuredCardBorder, other.featuredCardBorder, t) ?? featuredCardBorder,
      sectionAlternateBackground:
          Color.lerp(sectionAlternateBackground, other.sectionAlternateBackground, t) ??
              sectionAlternateBackground,
      tagBackground: Color.lerp(tagBackground, other.tagBackground, t) ?? tagBackground,
      tagText: Color.lerp(tagText, other.tagText, t) ?? tagText,
      tagBorder: Color.lerp(tagBorder, other.tagBorder, t) ?? tagBorder,
      activeTagBackground:
          Color.lerp(activeTagBackground, other.activeTagBackground, t) ?? activeTagBackground,
      activeTagText: Color.lerp(activeTagText, other.activeTagText, t) ?? activeTagText,
      activeTagBorder: Color.lerp(activeTagBorder, other.activeTagBorder, t) ?? activeTagBorder,
      navBackground: Color.lerp(navBackground, other.navBackground, t) ?? navBackground,
      navBorder: Color.lerp(navBorder, other.navBorder, t) ?? navBorder,
      photoPlaceholder: Color.lerp(photoPlaceholder, other.photoPlaceholder, t) ?? photoPlaceholder,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t) ?? textSubtle,
      statusAvailable: Color.lerp(statusAvailable, other.statusAvailable, t) ?? statusAvailable,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t) ?? inputBackground,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t) ?? inputBorder,
      inputBorderFocus: Color.lerp(inputBorderFocus, other.inputBorderFocus, t) ?? inputBorderFocus,
    );
  }
}

extension BuildContextPortfolioColors on BuildContext {
  PortfolioColors get portfolioColors =>
      Theme.of(this).extension<PortfolioColors>() ?? PortfolioColors.light;
}
