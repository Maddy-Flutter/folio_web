import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/presentation/widgets/common/hover_builder.dart';
import 'package:follio/presentation/widgets/common/photo_frame.dart';
import 'package:go_router/go_router.dart';

class FeaturedProjectCard extends StatelessWidget {
  const FeaturedProjectCard({
    super.key,
    required this.project,
  });

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return HoverTranslate(
      onTap: () => context.go('/case-study/${project.slug}'),
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: DesignTokens.border2Xl,
          border: Border.all(color: colors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Cover Image
            PhotoFrame(
              imageUrl: project.coverImage,
              altText: project.title,
              height: 300.0,
              width: double.infinity,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(DesignTokens.radius2Xl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DesignTokens.space28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Tags row
                  Wrap(
                    spacing: DesignTokens.space8,
                    runSpacing: DesignTokens.space6,
                    children: project.tags.map((String tag) {
                      final bool isPrimary = tag.toLowerCase() == project.categoryLabel.toLowerCase();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.space12,
                          vertical: DesignTokens.space4,
                        ),
                        decoration: BoxDecoration(
                          color: isPrimary ? colors.activeTagBackground : colors.tagBackground,
                          borderRadius: DesignTokens.borderPill,
                          border: isPrimary ? Border.all(color: colors.activeTagBorder) : null,
                        ),
                        child: Text(
                          tag,
                          style: textTheme.labelSmall?.copyWith(
                            color: isPrimary ? colors.accent : colors.tagText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: DesignTokens.space16),

                  // Title
                  Text(
                    project.title,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space12),

                  // Excerpt
                  Text(
                    project.excerpt,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.textMuted,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space24),

                  // View case study link
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        AppStrings.workViewCaseStudy,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16.0,
                        color: colors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
