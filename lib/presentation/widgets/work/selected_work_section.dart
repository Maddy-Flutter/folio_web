import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/section_header.dart';
import 'package:follio/presentation/widgets/work/compact_project_card.dart';
import 'package:follio/presentation/widgets/work/featured_project_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SelectedWorkSection extends StatelessWidget {
  const SelectedWorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProjectModel> projects = context.select<PortfolioViewModel, List<ProjectModel>>(
      (PortfolioViewModel vm) => vm.projects,
    );
    final bool isDesktop = ResponsiveUtils.isDesktop(context);
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final ProjectModel? featured = projects.isNotEmpty ? projects.first : null;
    final List<ProjectModel> compactProjects = projects.length > 1
        ? projects.sublist(1, projects.length > 3 ? 3 : projects.length)
        : <ProjectModel>[];

    return ResponsiveContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeSlideReveal(
            child: SectionHeader(
              category: AppStrings.workCategory,
              title: AppStrings.workTitle,
              actionWidget: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.go('/projects'),
                  child: Text(
                    AppStrings.workAllLink,
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (featured != null)
            if (isDesktop)
              FadeSlideReveal(
                delay: const Duration(milliseconds: 150),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Left: Large Featured Project Card
                    Expanded(
                      flex: 6,
                      child: FeaturedProjectCard(project: featured),
                    ),
                    const SizedBox(width: DesignTokens.space24),
                    // Right: 2 Smaller Cards stacked
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: compactProjects
                            .map(
                              (ProjectModel p) => Padding(
                                padding: const EdgeInsets.only(bottom: DesignTokens.space24),
                                child: CompactProjectCard(project: p),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              )
            else
              FadeSlideReveal(
                delay: const Duration(milliseconds: 150),
                child: Column(
                  children: <Widget>[
                    FeaturedProjectCard(project: featured),
                    const SizedBox(height: DesignTokens.space24),
                    ...compactProjects.map(
                      (ProjectModel p) => Padding(
                        padding: const EdgeInsets.only(bottom: DesignTokens.space24),
                        child: CompactProjectCard(project: p),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
