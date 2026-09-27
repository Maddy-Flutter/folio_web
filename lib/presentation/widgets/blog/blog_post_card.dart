import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/presentation/widgets/common/hover_builder.dart';
import 'package:follio/presentation/widgets/common/photo_frame.dart';
import 'package:go_router/go_router.dart';

class BlogPostCard extends StatelessWidget {
  const BlogPostCard({
    super.key,
    required this.post,
  });

  final BlogPostModel post;

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return HoverTranslate(
      onTap: () => context.go('/blog/${post.slug}'),
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
              imageUrl: post.coverImage,
              altText: post.title,
              height: 180.0,
              width: double.infinity,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(DesignTokens.radius2Xl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DesignTokens.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Category & Date metadata
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.space10,
                          vertical: DesignTokens.space4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.activeTagBackground,
                          borderRadius: DesignTokens.borderPill,
                          border: Border.all(color: colors.activeTagBorder),
                        ),
                        child: Text(
                          post.category,
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.space10),
                      Text(
                        post.date,
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.space12),

                  // Title
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space8),

                  // Excerpt
                  Text(
                    post.excerpt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space16),

                  // Read more link
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        AppStrings.blogReadMore,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
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
