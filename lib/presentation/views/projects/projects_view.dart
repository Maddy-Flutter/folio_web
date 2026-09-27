import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:follio/presentation/widgets/footer/app_footer.dart';
import 'package:follio/presentation/widgets/nav/sticky_navbar.dart';
import 'package:follio/presentation/widgets/work/compact_project_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final PortfolioViewModel vm = context.watch<PortfolioViewModel>();
    final List<ProjectModel> filtered = vm.filteredProjects;
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDesktop = ResponsiveUtils.isDesktop(context);

    final List<Map<String, String>> filterOptions = <Map<String, String>>[
      <String, String>{'label': AppStrings.filterAll, 'val': 'all'},
      <String, String>{'label': AppStrings.filterSaaS, 'val': 'saas'},
      <String, String>{'label': AppStrings.filterFintech, 'val': 'fintech'},
      <String, String>{'label': AppStrings.filterAgency, 'val': 'agency'},
      <String, String>{'label': AppStrings.filterMobile, 'val': 'mobile'},
      <String, String>{'label': AppStrings.filterEcommerce, 'val': 'ecommerce'},
    ];

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SelectionArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: DesignTokens.navHeight),

                  // Header section
                  ResponsiveContainer(
                    padding: const EdgeInsets.only(
                      top: DesignTokens.space48,
                      bottom: DesignTokens.space24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeSlideReveal(
                          child: Text(
                            AppStrings.workCategory.toUpperCase(),
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.accent,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.space12),
                        FadeSlideReveal(
                          delay: const Duration(milliseconds: 100),
                          child: Text(
                            AppStrings.projectsPageTitle,
                            style: textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.space16),
                        FadeSlideReveal(
                          delay: const Duration(milliseconds: 200),
                          child: Text(
                            AppStrings.projectsPageSubtitle,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.space32),

                        // Filter chips
                        FadeSlideReveal(
                          delay: const Duration(milliseconds: 300),
                          child: Wrap(
                            spacing: DesignTokens.space8,
                            runSpacing: DesignTokens.space8,
                            children: filterOptions.map((Map<String, String> f) {
                              final bool isSelected = vm.projectFilter == f['val'];
                              return GestureDetector(
                                onTap: () => vm.setProjectFilter(f['val']!),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: DesignTokens.space16,
                                    vertical: DesignTokens.space8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colors.accent
                                        : colorScheme.surface,
                                    borderRadius: DesignTokens.borderPill,
                                    border: Border.all(
                                      color: isSelected
                                          ? colors.accent
                                          : colorScheme.outline,
                                    ),
                                  ),
                                  child: Text(
                                    f['label']!,
                                    style: textTheme.labelMedium?.copyWith(
                                      color: isSelected
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Projects Grid
                  ResponsiveContainer(
                    padding: const EdgeInsets.only(bottom: DesignTokens.space64),
                    child: filtered.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(DesignTokens.space64),
                              child: Text(
                                AppStrings.noProjectsFound,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colors.textMuted,
                                ),
                              ),
                            ),
                          )
                        : LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              final int crossAxisCount = isDesktop ? 3 : (constraints.maxWidth > 640 ? 2 : 1);
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filtered.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: DesignTokens.space24,
                                  mainAxisSpacing: DesignTokens.space24,
                                  childAspectRatio: 0.85,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return CompactProjectCard(project: filtered[index]);
                                },
                              );
                            },
                          ),
                  ),

                  // CTA Banner: Want your project here?
                  ResponsiveContainer(
                    padding: const EdgeInsets.only(bottom: DesignTokens.space64),
                    child: Container(
                      padding: const EdgeInsets.all(DesignTokens.space48),
                      decoration: BoxDecoration(
                        color: colors.featuredCardBackground,
                        borderRadius: DesignTokens.border3Xl,
                        border: Border.all(color: colors.featuredCardBorder),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'READY TO START?',
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.accent,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.space12),
                          Text(
                            'Want your project here?',
                            style: textTheme.displaySmall?.copyWith(
                              color: colorScheme.onSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: DesignTokens.space16),
                          Text(
                            "I'm available for new projects. Tell me about what you're building and let's see if we're a good fit.",
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.textMuted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: DesignTokens.space24),
                          ShimmerButton(
                            label: 'Start a project →',
                            onPressed: () => context.go('/#contact'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const AppFooter(),
                ],
              ),
            ),
          ),

          // Sticky Top Navigation
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StickyNavbar(),
          ),
        ],
      ),
    );
  }
}
