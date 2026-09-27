import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/photo_frame.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:follio/presentation/widgets/footer/app_footer.dart';
import 'package:follio/presentation/widgets/nav/sticky_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CaseStudyView extends StatefulWidget {
  const CaseStudyView({super.key, required this.slug});

  final String slug;

  @override
  State<CaseStudyView> createState() => _CaseStudyViewState();
}

class _CaseStudyViewState extends State<CaseStudyView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PortfolioViewModel>().loadProjectBySlug(widget.slug);
    });
  }

  @override
  void didUpdateWidget(covariant CaseStudyView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slug != widget.slug) {
      context.read<PortfolioViewModel>().loadProjectBySlug(widget.slug);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioViewModel vm = context.watch<PortfolioViewModel>();
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDesktop = ResponsiveUtils.isDesktop(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SelectionArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: DesignTokens.navHeight),

                  if (vm.detailState == ViewState.loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: DesignTokens.space96),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (vm.detailState == ViewState.error || vm.selectedProject == null)
                    ResponsiveContainer(
                      padding: const EdgeInsets.symmetric(vertical: DesignTokens.space96),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Case Study Not Found',
                              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: DesignTokens.space16),
                            ShimmerButton(
                              label: AppStrings.backToProjects,
                              onPressed: () => context.go('/projects'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    _buildCaseStudyContent(
                      context,
                      vm.selectedProject!,
                      vm,
                      colors,
                      textTheme,
                      colorScheme,
                      isDesktop,
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

  Widget _buildCaseStudyContent(
    BuildContext context,
    ProjectModel project,
    PortfolioViewModel vm,
    PortfolioColors colors,
    TextTheme textTheme,
    ColorScheme colorScheme,
    bool isDesktop,
  ) {
    return Column(
      children: <Widget>[
        // Header Section
        ResponsiveContainer(
          maxWidth: DesignTokens.maxNarrowContentWidth,
          padding: const EdgeInsets.only(
            top: DesignTokens.space48,
            bottom: DesignTokens.space24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Back to projects link
              FadeSlideReveal(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go('/projects'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.arrow_back_rounded, size: 16.0, color: colors.accent),
                        const SizedBox(width: DesignTokens.space8),
                        Text(
                          AppStrings.backToProjects,
                          style: textTheme.labelLarge?.copyWith(
                            color: colors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.space24),

              // Tags
              FadeSlideReveal(
                delay: const Duration(milliseconds: 100),
                child: Wrap(
                  spacing: DesignTokens.space8,
                  children: project.tags.map((String tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.space12,
                        vertical: DesignTokens.space4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.activeTagBackground,
                        borderRadius: DesignTokens.borderPill,
                        border: Border.all(color: colors.activeTagBorder),
                      ),
                      child: Text(
                        tag,
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: DesignTokens.space16),

              // Title
              FadeSlideReveal(
                delay: const Duration(milliseconds: 150),
                child: Text(
                  project.title,
                  style: textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.space16),

              // Excerpt
              FadeSlideReveal(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  project.excerpt,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textMuted,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.space32),

              // Metadata grid
              FadeSlideReveal(
                delay: const Duration(milliseconds: 250),
                child: Container(
                  padding: const EdgeInsets.all(DesignTokens.space24),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: DesignTokens.borderLg,
                  ),
                  child: Wrap(
                    spacing: DesignTokens.space32,
                    runSpacing: DesignTokens.space16,
                    children: <Widget>[
                      _buildMetaItem(AppStrings.clientLabel, project.client, textTheme, colors, colorScheme),
                      _buildMetaItem(AppStrings.roleLabel, project.role, textTheme, colors, colorScheme),
                      _buildMetaItem(AppStrings.timelineLabel, project.timeline, textTheme, colors, colorScheme),
                      _buildMetaItem(
                        AppStrings.deliverablesLabel,
                        project.deliverables.join(' · '),
                        textTheme,
                        colors,
                        colorScheme,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hero Cover Image
        ResponsiveContainer(
          maxWidth: DesignTokens.maxNarrowContentWidth,
          padding: const EdgeInsets.only(bottom: DesignTokens.space40),
          child: FadeSlideReveal(
            delay: const Duration(milliseconds: 300),
            child: PhotoFrame(
              imageUrl: project.coverImage,
              altText: project.title,
              width: double.infinity,
              height: isDesktop ? 480.0 : 280.0,
              borderRadius: DesignTokens.border3Xl,
            ),
          ),
        ),

        // Key Results / Metrics Cards
        if (project.stats.isNotEmpty)
          ResponsiveContainer(
            maxWidth: DesignTokens.maxNarrowContentWidth,
            padding: const EdgeInsets.only(bottom: DesignTokens.space40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.keyMetricsHeading,
                  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: DesignTokens.space16),
                Row(
                  children: project.stats.map((ProjectStatModel s) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: DesignTokens.space12),
                        padding: const EdgeInsets.all(DesignTokens.space20),
                        decoration: BoxDecoration(
                          color: colors.activeTagBackground,
                          borderRadius: DesignTokens.borderLg,
                          border: Border.all(color: colors.activeTagBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              s.value,
                              style: textTheme.headlineMedium?.copyWith(
                                color: colors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: DesignTokens.space4),
                            Text(
                              s.label,
                              style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        // Overview, Challenge & Solution Prose
        ResponsiveContainer(
          maxWidth: DesignTokens.maxNarrowContentWidth,
          padding: const EdgeInsets.only(bottom: DesignTokens.space48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.overviewHeading,
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: DesignTokens.space12),
              Text(
                project.fullDescription,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.textMuted,
                  height: 1.7,
                ),
              ),
              if (project.challenge.isNotEmpty) ...<Widget>[
                const SizedBox(height: DesignTokens.space32),
                Text(
                  AppStrings.challengeHeading,
                  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: DesignTokens.space12),
                Text(
                  project.challenge,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textMuted,
                    height: 1.7,
                  ),
                ),
              ],
              if (project.solution.isNotEmpty) ...<Widget>[
                const SizedBox(height: DesignTokens.space32),
                Text(
                  AppStrings.solutionHeading,
                  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: DesignTokens.space12),
                Text(
                  project.solution,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textMuted,
                    height: 1.7,
                  ),
                ),
              ],
              if (project.testimonialQuote.isNotEmpty) ...<Widget>[
                const SizedBox(height: DesignTokens.space40),
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space24),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: DesignTokens.borderLg,
                    border: Border(
                      left: BorderSide(color: colors.accent, width: 4.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '"${project.testimonialQuote}"',
                        style: textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space12),
                      Text(
                        '${project.testimonialAuthor} — ${project.testimonialRole}',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // Next Case Study CTA
        ResponsiveContainer(
          maxWidth: DesignTokens.maxNarrowContentWidth,
          padding: const EdgeInsets.only(bottom: DesignTokens.space64),
          child: Align(
            alignment: Alignment.centerRight,
            child: ShimmerButton(
              label: AppStrings.nextCaseStudy,
              onPressed: () {
                final List<ProjectModel> all = vm.projects;
                final int currentIdx = all.indexWhere((ProjectModel p) => p.slug == project.slug);
                final int nextIdx = (currentIdx + 1) % all.length;
                context.go('/case-study/${all[nextIdx].slug}');
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaItem(
    String label,
    String value,
    TextTheme textTheme,
    PortfolioColors colors,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(
            color: colors.textSubtle,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: DesignTokens.space4),
        Text(
          value,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
