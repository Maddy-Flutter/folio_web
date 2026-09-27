import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/photo_frame.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:provider/provider.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDesktop = ResponsiveUtils.isDesktop(context);
    final PortfolioViewModel portfolioVm = context.watch<PortfolioViewModel>();
    final ProfileDraft? profile = portfolioVm.profileContent;
    final String avatarUrl = (profile?.avatarUrl?.isNotEmpty ?? false)
        ? profile!.avatarUrl!
        : ProfileDraft.defaultAvatarUrl;

    return Container(
      width: double.infinity,
      color: colors.sectionAlternateBackground,
      child: ResponsiveContainer(
        child: isDesktop
            ? Row(
                children: <Widget>[
                  // Left: Square Portrait Image
                  Expanded(
                    flex: 5,
                    child: FadeSlideReveal(
                      child: Center(
                        child: PhotoFrame(
                          imageUrl: avatarUrl,
                          altText: 'Eliott — Freelance Designer & Developer',
                          width: 380.0,
                          height: 380.0,
                          borderRadius: DesignTokens.border3Xl,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.space56),
                  // Right: Bio copy and stack chips
                  Expanded(
                    flex: 6,
                    child: _buildBioContent(context, colors, textTheme, colorScheme),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildBioContent(context, colors, textTheme, colorScheme),
                  const SizedBox(height: DesignTokens.space40),
                  Center(
                    child: PhotoFrame(
                      imageUrl: avatarUrl,
                      altText: 'Eliott — Freelance Designer & Developer',
                      width: 320.0,
                      height: 320.0,
                      borderRadius: DesignTokens.border3Xl,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBioContent(
    BuildContext context,
    PortfolioColors colors,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final PortfolioViewModel portfolioVm = context.watch<PortfolioViewModel>();
    final ProfileDraft? profile = portfolioVm.profileContent;
    final String bio1 = (profile != null && profile.bioPara1.isNotEmpty)
        ? profile.bioPara1
        : AppStrings.aboutPara1;
    final String bio2 = (profile != null && profile.bioPara2.isNotEmpty)
        ? profile.bioPara2
        : AppStrings.aboutPara2;
    final List<String> tools =
        (profile != null && profile.tools.isNotEmpty) ? profile.tools : AppStrings.aboutTools;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FadeSlideReveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.aboutCategory.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: DesignTokens.space12),
              Text(
                AppStrings.aboutTitle,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.space24),

        FadeSlideReveal(
          delay: const Duration(milliseconds: 100),
          child: Text(
            bio1,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.textMuted,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.space16),

        FadeSlideReveal(
          delay: const Duration(milliseconds: 200),
          child: Text(
            bio2,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.textMuted,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.space32),

        // Stack & Tools
        FadeSlideReveal(
          delay: const Duration(milliseconds: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.aboutStackTitle.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textSubtle,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: DesignTokens.space16),
              Wrap(
                spacing: DesignTokens.space8,
                runSpacing: DesignTokens.space10,
                children: tools.map((String tool) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.space14,
                      vertical: DesignTokens.space8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: DesignTokens.borderPill,
                      border: Border.all(color: colors.tagBorder),
                    ),
                    child: Text(
                      tool,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
