import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/presentation/viewmodels/navigation_viewmodel.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:follio/presentation/widgets/nav/mobile_menu_drawer.dart';
import 'package:follio/presentation/widgets/nav/nav_link_button.dart';
import 'package:follio/presentation/widgets/nav/theme_toggle_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StickyNavbar extends StatelessWidget {
  const StickyNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isScrolled = context.select<NavigationViewModel, bool>(
      (NavigationViewModel vm) => vm.isScrolled,
    );
    final String activeSection = context.select<NavigationViewModel, String>(
      (NavigationViewModel vm) => vm.activeSection,
    );
    final bool isMobileMenuOpen = context.select<NavigationViewModel, bool>(
      (NavigationViewModel vm) => vm.isMobileMenuOpen,
    );

    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool collapseNav = ResponsiveUtils.shouldCollapseNav(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: AnimatedContainer(
              duration: DesignTokens.durationNormal,
              height: DesignTokens.navHeight,
              decoration: BoxDecoration(
                color: isScrolled ? colors.navBackground : colorScheme.surface.withValues(alpha: 0.0),
                border: Border(
                  bottom: BorderSide(
                    color: isScrolled ? colors.navBorder : colorScheme.outlineVariant.withValues(alpha: 0.0),
                  ),
                ),
                boxShadow: isScrolled
                    ? <BoxShadow>[
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.04),
                          blurRadius: 8.0,
                          offset: const Offset(0.0, 2.0),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: DesignTokens.maxContentWidth),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.horizontalPadding(context),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Logo
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => _handleNav(context, 'hero'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  AppStrings.logoFirst,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                      ),
                                ),
                                Text(
                                  AppStrings.logoAccent,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: colors.accent,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Desktop Navigation Links
                        if (!collapseNav)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              NavLinkButton(
                                label: AppStrings.navServices,
                                isActive: activeSection == 'services',
                                onTap: () => _handleNav(context, 'services'),
                              ),
                              const SizedBox(width: DesignTokens.space12),
                              NavLinkButton(
                                label: AppStrings.navWork,
                                isActive: activeSection == 'work',
                                onTap: () => _handleNav(context, 'work'),
                              ),
                              const SizedBox(width: DesignTokens.space12),
                              NavLinkButton(
                                label: AppStrings.navAbout,
                                isActive: activeSection == 'about',
                                onTap: () => _handleNav(context, 'about'),
                              ),
                              const SizedBox(width: DesignTokens.space12),
                              NavLinkButton(
                                label: AppStrings.navReviews,
                                isActive: activeSection == 'reviews',
                                onTap: () => _handleNav(context, 'reviews'),
                              ),
                              const SizedBox(width: DesignTokens.space12),
                              NavLinkButton(
                                label: AppStrings.navBlog,
                                isActive: activeSection == 'blog',
                                onTap: () => _handleNav(context, 'blog'),
                              ),
                              const SizedBox(width: DesignTokens.space12),
                              NavLinkButton(
                                label: AppStrings.navContact,
                                isActive: activeSection == 'contact',
                                onTap: () => _handleNav(context, 'contact'),
                              ),
                            ],
                          ),

                        // Right actions (theme toggle + CTA / hamburger)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ThemeToggleButton(),
                            if (!collapseNav) ...<Widget>[
                              const SizedBox(width: DesignTokens.space12),
                              ShimmerButton(
                                label: AppStrings.navHireMe,
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14.0,
                                  color: colorScheme.onPrimary,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: DesignTokens.space20,
                                  vertical: DesignTokens.space8,
                                ),
                                onPressed: () => _handleNav(context, 'contact'),
                              ),
                            ],
                            if (collapseNav) ...<Widget>[
                              const SizedBox(width: DesignTokens.space8),
                              Semantics(
                                button: true,
                                label: AppStrings.toggleMenu,
                                child: Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.outline,
                                    ),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 18.0,
                                    icon: Icon(
                                      isMobileMenuOpen ? Icons.close : Icons.menu,
                                      color: colorScheme.onSurface,
                                    ),
                                    onPressed: () {
                                      context.read<NavigationViewModel>().toggleMobileMenu();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (collapseNav) const MobileMenuDrawer(),
      ],
    );
  }

  void _handleNav(BuildContext context, String sectionId) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location != '/' && location != '') {
      context.go('/#$sectionId');
    } else {
      context.read<NavigationViewModel>().navigateToSection(sectionId);
    }
  }
}
