import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/widgets/blog/blog_post_card.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/section_header.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BlogPostModel> blogPosts = context.select<PortfolioViewModel, List<BlogPostModel>>(
      (PortfolioViewModel vm) => vm.blogPosts,
    );
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDesktop = ResponsiveUtils.isDesktop(context);

    final List<BlogPostModel> displayPosts =
        blogPosts.length > 3 ? blogPosts.sublist(0, 3) : blogPosts;

    return Container(
      width: double.infinity,
      color: colors.sectionAlternateBackground,
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeSlideReveal(
              child: SectionHeader(
                category: AppStrings.blogCategory,
                title: AppStrings.blogTitle,
                actionWidget: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go('/blog'),
                    child: Text(
                      AppStrings.blogAllLink,
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isDesktop)
              FadeSlideReveal(
                delay: const Duration(milliseconds: 150),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayPosts.map((BlogPostModel post) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.space12,
                        ),
                        child: BlogPostCard(post: post),
                      ),
                    );
                  }).toList(),
                ),
              )
            else
              FadeSlideReveal(
                delay: const Duration(milliseconds: 150),
                child: Column(
                  children: displayPosts.map((BlogPostModel post) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: DesignTokens.space24),
                      child: BlogPostCard(post: post),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
