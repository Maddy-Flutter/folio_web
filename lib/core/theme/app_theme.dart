import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/theme/app_text_theme.dart';
import 'package:follio/core/tokens/design_tokens.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    final TextTheme textTheme = AppTextTheme.create(Brightness.light);
    const ColorScheme colorScheme = ColorScheme.light(
      primary: AppColors.accent,
      primaryContainer: AppColors.accentLight,
      onPrimaryContainer: AppColors.zinc900,
      secondary: AppColors.zinc900,
      onSecondary: AppColors.white,
      onSurface: AppColors.zinc900,
      surfaceContainerHighest: AppColors.zinc100,
      surfaceContainer: AppColors.zinc50,
      outline: AppColors.zinc200,
      outlineVariant: AppColors.zinc100,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: textTheme,
      dividerColor: AppColors.zinc100,
      extensions: const <ThemeExtension<dynamic>>[
        PortfolioColors.light,
      ],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.zinc50,
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.zinc400),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space16,
          vertical: DesignTokens.space14,
        ),
        border: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.zinc200),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.zinc200),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final TextTheme textTheme = AppTextTheme.create(Brightness.dark);
    const ColorScheme colorScheme = ColorScheme.dark(
      primary: AppColors.accent,
      primaryContainer: AppColors.accentLight,
      onPrimaryContainer: AppColors.zinc950,
      secondary: AppColors.white,
      onSecondary: AppColors.zinc900,
      surface: AppColors.zinc950,
      onSurface: AppColors.zinc100,
      surfaceContainerHighest: AppColors.zinc800,
      surfaceContainer: AppColors.zinc900,
      outline: AppColors.zinc800,
      outlineVariant: AppColors.zinc900,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.zinc950,
      textTheme: textTheme,
      dividerColor: AppColors.zinc900,
      extensions: const <ThemeExtension<dynamic>>[
        PortfolioColors.dark,
      ],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.zinc800,
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.zinc500),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space16,
          vertical: DesignTokens.space14,
        ),
        border: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.zinc700),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.zinc700),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: DesignTokens.borderMd,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}
