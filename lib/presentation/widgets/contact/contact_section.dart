import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_constants.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/presentation/viewmodels/contact_viewmodel.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/contact/contact_form.dart';
import 'package:follio/presentation/widgets/contact/contact_success_panel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDesktop = ResponsiveUtils.isDesktop(context);
    final bool isSuccess = context.select<ContactViewModel, bool>(
      (ContactViewModel vm) => vm.isSuccess,
    );

    return ResponsiveContainer(
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.featuredCardBackground,
              borderRadius: DesignTokens.border3Xl,
              border: Border.all(color: colors.featuredCardBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                // Radial accent glow top right
                Positioned(
                  top: -80.0,
                  right: -80.0,
                  child: IgnorePointer(
                    child: Container(
                      width: 320.0,
                      height: 320.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            colors.accent.withValues(alpha: 0.18),
                            colors.accent.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(
                    isDesktop ? DesignTokens.space64 : DesignTokens.space32,
                  ),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: _buildIntro(context, colors, textTheme, colorScheme),
                            ),
                            const SizedBox(width: DesignTokens.space56),
                            Expanded(
                              flex: 6,
                              child: isSuccess ? const ContactSuccessPanel() : const ContactForm(),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildIntro(context, colors, textTheme, colorScheme),
                            const SizedBox(height: DesignTokens.space40),
                            isSuccess ? const ContactSuccessPanel() : const ContactForm(),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntro(
    BuildContext context,
    PortfolioColors colors,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FadeSlideReveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.contactCategory.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: DesignTokens.space12),
              Text(
                AppStrings.contactTitle,
                style: textTheme.displaySmall?.copyWith(
                  color: colorScheme.onSecondary,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.space20),

        FadeSlideReveal(
          delay: const Duration(milliseconds: 100),
          child: Text(
            AppStrings.contactIntro,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textMuted,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.space32),

        // Direct contact links
        FadeSlideReveal(
          delay: const Duration(milliseconds: 200),
          child: Column(
            children: <Widget>[
              _ContactLinkTile(
                icon: Icons.mail_outline_rounded,
                label: AppConstants.contactEmail,
                onTap: () => _launchUrl('mailto:${AppConstants.contactEmail}'),
              ),
              const SizedBox(height: DesignTokens.space14),
              _ContactLinkTile(
                icon: Icons.business_center_outlined,
                label: 'linkedin.com/in/eliott-dev',
                onTap: () => _launchUrl(AppConstants.linkedInUrl),
              ),
              const SizedBox(height: DesignTokens.space14),
              _ContactLinkTile(
                icon: Icons.code_rounded,
                label: 'github.com/eliott-dev',
                onTap: () => _launchUrl(AppConstants.gitHubUrl),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactLinkTile extends StatelessWidget {
  const _ContactLinkTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Container(
              width: 38.0,
              height: 38.0,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: DesignTokens.borderMd,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18.0,
                  color: colors.accent,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.space14),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
