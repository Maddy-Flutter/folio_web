import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/blog_post_model.dart';
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
import 'package:url_launcher/url_launcher.dart';

class BlogArticleView extends StatefulWidget {
  const BlogArticleView({super.key, required this.slug});

  final String slug;

  @override
  State<BlogArticleView> createState() => _BlogArticleViewState();
}

class _BlogArticleViewState extends State<BlogArticleView> {
  late final ScrollController _scrollController;
  double _readingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PortfolioViewModel>().loadBlogPostBySlug(widget.slug);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final double maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent > 0) {
      final double progress =
          (_scrollController.offset / maxExtent).clamp(0.0, 1.0);
      if ((progress - _readingProgress).abs() > 0.005) {
        setState(() {
          _readingProgress = progress;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant BlogArticleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slug != widget.slug) {
      setState(() {
        _readingProgress = 0.0;
      });
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      context.read<PortfolioViewModel>().loadBlogPostBySlug(widget.slug);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _shareOnTwitter(String title) async {
    final Uri url = Uri.parse(
      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(title)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareOnLinkedIn() async {
    final Uri url = Uri.parse(
      'https://www.linkedin.com/sharing/share-offsite/',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
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
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: DesignTokens.navHeight),

                  if (vm.detailState == ViewState.loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: DesignTokens.space96),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (vm.detailState == ViewState.error || vm.selectedBlogPost == null)
                    ResponsiveContainer(
                      padding: const EdgeInsets.symmetric(vertical: DesignTokens.space96),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Article Not Found',
                              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: DesignTokens.space16),
                            ShimmerButton(
                              label: AppStrings.backToArticles,
                              onPressed: () => context.go('/blog'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: <Widget>[
                        _buildArticleContent(
                          context,
                          vm.selectedBlogPost!,
                          colors,
                          textTheme,
                          colorScheme,
                          isDesktop,
                        ),
                        _buildRelatedPostsSection(
                          context,
                          vm.blogPosts,
                          colors,
                          textTheme,
                          colorScheme,
                          isDesktop,
                        ),
                      ],
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

          // Reading Progress Bar at the very top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 3.0,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _readingProgress,
              child: Container(
                color: colors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent(
    BuildContext context,
    BlogPostModel post,
    PortfolioColors colors,
    TextTheme textTheme,
    ColorScheme colorScheme,
    bool isDesktop,
  ) {
    return Column(
      children: <Widget>[
        ResponsiveContainer(
          maxWidth: DesignTokens.maxArticleWidth,
          padding: const EdgeInsets.only(
            top: DesignTokens.space48,
            bottom: DesignTokens.space24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Back link
              FadeSlideReveal(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go('/blog'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.arrow_back_rounded, size: 16.0, color: colors.accent),
                        const SizedBox(width: DesignTokens.space8),
                        Text(
                          AppStrings.backToArticles,
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

              // Metadata pill
              FadeSlideReveal(
                delay: const Duration(milliseconds: 100),
                child: Row(
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
              ),
              const SizedBox(height: DesignTokens.space16),

              // Title
              FadeSlideReveal(
                delay: const Duration(milliseconds: 150),
                child: Text(
                  post.title,
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
                  post.excerpt,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textMuted,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.space24),

              // Author & Social Share Header Row
              FadeSlideReveal(
                delay: const Duration(milliseconds: 220),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: DesignTokens.space16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colors.cardBorder),
                      bottom: BorderSide(color: colors.cardBorder),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      const PhotoFrame(
                        imageUrl:
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
                        altText: 'Eliott',
                        width: 44.0,
                        height: 44.0,
                        borderRadius: DesignTokens.borderPill,
                      ),
                      const SizedBox(width: DesignTokens.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Eliott',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'UI/UX Designer & Frontend Developer',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.textSubtle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildShareButton(
                        context: context,
                        icon: Icons.share_rounded,
                        tooltip: 'Share on X',
                        onTap: () => _shareOnTwitter(post.title),
                        colors: colors,
                      ),
                      const SizedBox(width: DesignTokens.space8),
                      _buildShareButton(
                        context: context,
                        icon: Icons.link_rounded,
                        tooltip: 'Share on LinkedIn',
                        onTap: _shareOnLinkedIn,
                        colors: colors,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hero Image
        ResponsiveContainer(
          maxWidth: DesignTokens.maxArticleWidth,
          padding: const EdgeInsets.only(bottom: DesignTokens.space40),
          child: FadeSlideReveal(
            delay: const Duration(milliseconds: 250),
            child: PhotoFrame(
              imageUrl: post.coverImage,
              altText: post.title,
              width: double.infinity,
              height: isDesktop ? 400.0 : 240.0,
            ),
          ),
        ),

        // Prose Content
        ResponsiveContainer(
          maxWidth: DesignTokens.maxArticleWidth,
          padding: const EdgeInsets.only(bottom: DesignTokens.space48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: post.content.split('\n\n').map((String block) {
              final String trimmed = block.trim();

              // Heading 2
              if (trimmed.startsWith('## ')) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.space36,
                    bottom: DesignTokens.space16,
                  ),
                  child: Text(
                    trimmed.substring(3),
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }

              // Heading 3
              if (trimmed.startsWith('### ')) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: DesignTokens.space32,
                    bottom: DesignTokens.space12,
                  ),
                  child: Text(
                    trimmed.substring(4),
                    style: textTheme.headlineSmall?.copyWith(
                      color: colors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }

              // Blockquotes
              if (trimmed.startsWith('> ') || trimmed.startsWith('"')) {
                final String quoteText = trimmed.startsWith('> ')
                    ? trimmed.substring(2)
                    : trimmed;
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: DesignTokens.space12,
                    bottom: DesignTokens.space24,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space20,
                    vertical: DesignTokens.space16,
                  ),
                  decoration: BoxDecoration(
                    color: colors.activeTagBackground,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(DesignTokens.radiusMd),
                      bottomRight: Radius.circular(DesignTokens.radiusMd),
                    ),
                    border: Border(
                      left: BorderSide(
                        color: colors.accent,
                        width: 3.5,
                      ),
                    ),
                  ),
                  child: Text(
                    quoteText,
                    style: textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: textTheme.bodyLarge?.color,
                      height: 1.6,
                    ),
                  ),
                );
              }

              // Bullet items
              if (trimmed.startsWith('- ')) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.space8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 8.0, right: 10.0),
                        width: 5.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.accent,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          trimmed.substring(2),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textMuted,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Code block
              if (trimmed.startsWith('```')) {
                final String code = trimmed.replaceAll('```', '').trim();
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: DesignTokens.space8,
                    bottom: DesignTokens.space20,
                  ),
                  padding: const EdgeInsets.all(DesignTokens.space16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF18181B),
                    borderRadius: DesignTokens.borderLg,
                  ),
                  child: SelectableText(
                    code,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13.0,
                      color: Color(0xFFE4E4E7),
                      height: 1.6,
                    ),
                  ),
                );
              }

              // Standard Paragraph
              return Padding(
                padding: const EdgeInsets.only(bottom: DesignTokens.space16),
                child: Text(
                  trimmed,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textMuted,
                    height: 1.75,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Author bio card
        ResponsiveContainer(
          maxWidth: DesignTokens.maxArticleWidth,
          padding: const EdgeInsets.only(bottom: DesignTokens.space64),
          child: Container(
            padding: const EdgeInsets.all(DesignTokens.space28),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: DesignTokens.border2Xl,
            ),
            child: Row(
              children: <Widget>[
                const PhotoFrame(
                  imageUrl:
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
                  altText: 'Eliott',
                  width: 60.0,
                  height: 60.0,
                  borderRadius: DesignTokens.borderPill,
                ),
                const SizedBox(width: DesignTokens.space20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Written by Eliott',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space4),
                      Text(
                        'Freelance UI/UX Designer & Frontend Developer based in Paris. Writing about craft, systems, and product strategy.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    required PortfolioColors colors,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: DesignTokens.borderPill,
        child: Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.cardBorder),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 16.0,
              color: colors.textSubtle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedPostsSection(
    BuildContext context,
    List<BlogPostModel> allPosts,
    PortfolioColors colors,
    TextTheme textTheme,
    ColorScheme colorScheme,
    bool isDesktop,
  ) {
    final List<BlogPostModel> related = allPosts
        .where((BlogPostModel p) => p.slug != widget.slug)
        .take(3)
        .toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: colors.sectionAlternateBackground,
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.space64),
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'More from the blog',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: DesignTokens.space32),
            LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
                if (isDesktop && constraints.maxWidth >= 768.0) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: related.map((BlogPostModel post) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.space12,
                          ),
                          child: _buildRelatedCard(
                            context,
                            post,
                            colors,
                            textTheme,
                            colorScheme,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return Column(
                  children: related.map((BlogPostModel post) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: DesignTokens.space20,
                      ),
                      child: _buildRelatedCard(
                        context,
                        post,
                        colors,
                        textTheme,
                        colorScheme,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedCard(
    BuildContext context,
    BlogPostModel post,
    PortfolioColors colors,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return InkWell(
      onTap: () => context.go('/blog/${post.slug}'),
      borderRadius: DesignTokens.border2Xl,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: DesignTokens.border2Xl,
          border: Border.all(color: colors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PhotoFrame(
              imageUrl: post.coverImage,
              altText: post.title,
              width: double.infinity,
              height: 160.0,
            ),
            Padding(
              padding: const EdgeInsets.all(DesignTokens.space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${post.date} · ${post.category}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.textSubtle,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space8),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Read →',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.accent,
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
