import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/widgets/blog/blog_post_card.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/hover_builder.dart';
import 'package:follio/presentation/widgets/common/photo_frame.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/footer/app_footer.dart';
import 'package:follio/presentation/widgets/nav/sticky_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    final PortfolioViewModel vm = context.watch<PortfolioViewModel>();
    final List<BlogPostModel> filtered = vm.filteredBlogPosts;
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDesktop = ResponsiveUtils.isDesktop(context);

    final List<Map<String, String>> filterOptions = <Map<String, String>>[
      <String, String>{'label': AppStrings.filterAll, 'val': 'all'},
      <String, String>{'label': AppStrings.filterDesign, 'val': 'design'},
      <String, String>{'label': AppStrings.filterDev, 'val': 'dev'},
      <String, String>{'label': AppStrings.filterFreelance, 'val': 'freelance'},
    ];

    final BlogPostModel? featured = filtered.isNotEmpty ? filtered.first : null;
    final List<BlogPostModel> rest = filtered.length > 1 ? filtered.sublist(1) : <BlogPostModel>[];

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
                            AppStrings.blogCategory.toUpperCase(),
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
                            AppStrings.blogPageTitle,
                            style: textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.space16),
                        FadeSlideReveal(
                          delay: const Duration(milliseconds: 200),
                          child: Text(
                            AppStrings.blogPageSubtitle,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.space32),

                        // Filters
                        FadeSlideReveal(
                          delay: const Duration(milliseconds: 300),
                          child: Wrap(
                            spacing: DesignTokens.space8,
                            runSpacing: DesignTokens.space8,
                            children: filterOptions.map((Map<String, String> f) {
                              final bool isSelected = vm.blogFilter == f['val'];
                              return GestureDetector(
                                onTap: () => vm.setBlogFilter(f['val']!),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: DesignTokens.space16,
                                    vertical: DesignTokens.space8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected ? colors.accent : colorScheme.surface,
                                    borderRadius: DesignTokens.borderPill,
                                    border: Border.all(
                                      color: isSelected ? colors.accent : colorScheme.outline,
                                    ),
                                  ),
                                  child: Text(
                                    f['label']!,
                                    style: textTheme.labelMedium?.copyWith(
                                      color: isSelected
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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

                  // Featured Article
                  if (featured != null)
                    ResponsiveContainer(
                      padding: const EdgeInsets.only(bottom: DesignTokens.space32),
                      child: HoverTranslate(
                        onTap: () => context.go('/blog/${featured.slug}'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.cardBackground,
                            borderRadius: DesignTokens.border3Xl,
                            border: Border.all(color: colors.cardBorder),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: isDesktop
                              ? Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: PhotoFrame(
                                        imageUrl: featured.coverImage,
                                        altText: featured.title,
                                        height: 320.0,
                                        borderRadius: const BorderRadius.horizontal(
                                          left: Radius.circular(DesignTokens.radius3Xl),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(DesignTokens.space40),
                                        child: _buildFeaturedMeta(context, featured, colors, textTheme, colorScheme),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    PhotoFrame(
                                      imageUrl: featured.coverImage,
                                      altText: featured.title,
                                      height: 220.0,
                                      width: double.infinity,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(DesignTokens.radius3Xl),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(DesignTokens.space24),
                                      child: _buildFeaturedMeta(context, featured, colors, textTheme, colorScheme),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                  // Articles Grid
                  ResponsiveContainer(
                    padding: const EdgeInsets.only(bottom: DesignTokens.space64),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final int crossAxisCount = isDesktop ? 3 : (constraints.maxWidth > 640 ? 2 : 1);
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rest.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: DesignTokens.space24,
                            mainAxisSpacing: DesignTokens.space24,
                            childAspectRatio: 0.85,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return BlogPostCard(post: rest[index]);
                          },
                        );
                      },
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

  Widget _buildFeaturedMeta(
    BuildContext context,
    BlogPostModel post,
    PortfolioColors colors,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
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
                post.category,
                style: textTheme.labelSmall?.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.space12),
            Text(
              '${post.date} · ${post.readTime}',
              style: textTheme.labelMedium?.copyWith(
                color: colors.textSubtle,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.space16),
        Text(
          post.title,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
        const SizedBox(height: DesignTokens.space12),
        Text(
          post.excerpt,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.textMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: DesignTokens.space20),
        Text(
          AppStrings.blogReadMore,
          style: textTheme.labelLarge?.copyWith(
            color: colors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
