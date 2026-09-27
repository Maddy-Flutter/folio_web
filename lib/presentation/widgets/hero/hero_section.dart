import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:follio/presentation/viewmodels/navigation_viewmodel.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/widgets/common/animated_counter.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/photo_frame.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:provider/provider.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveUtils.isMobile(context);
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: <Widget>[
        // Ambient soft radial gradient blurs matching the reference
        Positioned(
          top: 80.0,
          right: -40.0,
          child: IgnorePointer(
            child: Container(
              width: 320.0,
              height: 320.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    colors.accent.withValues(alpha: 0.12),
                    colors.accent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40.0,
          left: -40.0,
          child: IgnorePointer(
            child: Container(
              width: 240.0,
              height: 240.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    colorScheme.outline.withValues(alpha: 0.2),
                    colorScheme.outline.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),

        ResponsiveContainer(
          padding: EdgeInsets.only(
            left: ResponsiveUtils.horizontalPadding(context),
            right: ResponsiveUtils.horizontalPadding(context),
            top: DesignTokens.space64,
            bottom: DesignTokens.space72,
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildContent(context, colors, textTheme, colorScheme),
                    const SizedBox(height: DesignTokens.space48),
                    Center(child: _buildPortrait(context, colors, textTheme)),
                  ],
                )
              : Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: _buildContent(context, colors, textTheme, colorScheme),
                    ),
                    const SizedBox(width: DesignTokens.space48),
                    Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _buildPortrait(context, colors, textTheme),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    PortfolioColors colors,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final PortfolioViewModel portfolioVm = context.watch<PortfolioViewModel>();
    final ProfileDraft? profile = portfolioVm.profileContent;
    final String heroName =
        (profile != null && profile.name.isNotEmpty) ? profile.name : AppStrings.heroName;
    const int projectsDone = 34;
    const int happyClients = 21;
    const int experienceYears = 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // "Available for work" pill badge
        FadeSlideReveal(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.space14,
              vertical: DesignTokens.space6,
            ),
            decoration: BoxDecoration(
              color: colors.activeTagBackground,
              borderRadius: DesignTokens.borderPill,
              border: Border.all(color: colors.activeTagBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 7.0,
                  height: 7.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.statusAvailable,
                  ),
                ),
                const SizedBox(width: DesignTokens.space8),
                Text(
                  AppStrings.heroAvailableBadge.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.space24),

        // Main Headline: "Hi, I'm Eliott"
        FadeSlideReveal(
          delay: const Duration(milliseconds: 100),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: AppStrings.heroGreeting,
                  style: textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: heroName,
                  style: textTheme.displayLarge?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.space20),

        // Subtitle
        FadeSlideReveal(
          delay: const Duration(milliseconds: 200),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: AppStrings.heroSubtitlePrefix,
                  style: textTheme.bodyLarge,
                ),
                TextSpan(
                  text: AppStrings.heroSubtitleHighlight,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: AppStrings.heroSubtitleSuffix,
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.space32),

        // Two CTAs
        FadeSlideReveal(
          delay: const Duration(milliseconds: 300),
          child: Wrap(
            spacing: DesignTokens.space16,
            runSpacing: DesignTokens.space12,
            children: <Widget>[
              ShimmerButton(
                label: AppStrings.heroCtaWork,
                icon: Icon(
                  Icons.arrow_downward_rounded,
                  size: 16.0,
                  color: colorScheme.onPrimary,
                ),
                onPressed: () {
                  context.read<NavigationViewModel>().navigateToSection('work');
                },
              ),
              OutlinedButton(
                onPressed: () {
                  context.read<NavigationViewModel>().navigateToSection('contact');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space24,
                    vertical: DesignTokens.space14,
                  ),
                  side: BorderSide(color: colorScheme.outline),
                  shape: const RoundedRectangleBorder(
                    borderRadius: DesignTokens.borderPill,
                  ),
                ),
                child: Text(
                  AppStrings.heroCtaContact,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.space48),

        // Animated Stat Counters
        FadeSlideReveal(
          delay: const Duration(milliseconds: 400),
          child: Container(
            padding: const EdgeInsets.only(top: DesignTokens.space28),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: const Wrap(
              spacing: DesignTokens.space40,
              runSpacing: DesignTokens.space16,
              children: <Widget>[
                AnimatedCounter(
                  value: projectsDone,
                  suffix: '+',
                  label: AppStrings.statProjectsDoneLabel,
                ),
                AnimatedCounter(
                  value: happyClients,
                  suffix: '+',
                  label: AppStrings.statHappyClientsLabel,
                ),
                AnimatedCounter(
                  value: experienceYears,
                  suffix: 'y',
                  label: AppStrings.statExperienceLabel,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortrait(
    BuildContext context,
    PortfolioColors colors,
    TextTheme textTheme,
  ) {
    final PortfolioViewModel portfolioVm = context.watch<PortfolioViewModel>();
    final String avatarUrl = (portfolioVm.profileContent?.avatarUrl?.isNotEmpty ?? false)
        ? portfolioVm.profileContent!.avatarUrl!
        : ProfileDraft.defaultAvatarUrl;

    return FadeSlideReveal(
      delay: const Duration(milliseconds: 200),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          PhotoFrame(
            imageUrl: avatarUrl,
            altText: 'Eliott Portrait',
            width: 320.0,
            height: 340.0,
            borderRadius: DesignTokens.border3Xl,
          ),
          // "Open to projects" floating badge
          Positioned(
            bottom: -14.0,
            left: -14.0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.space16,
                vertical: DesignTokens.space10,
              ),
              decoration: BoxDecoration(
                color: colors.accent,
                borderRadius: DesignTokens.borderLg,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.accent.withValues(alpha: 0.35),
                    blurRadius: 14.0,
                    offset: const Offset(0.0, 6.0),
                  ),
                ],
              ),
              child: Text(
                AppStrings.heroOpenToProjects,
                style: textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
