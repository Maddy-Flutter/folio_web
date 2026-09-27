import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:follio/presentation/widgets/footer/app_footer.dart';
import 'package:follio/presentation/widgets/nav/sticky_navbar.dart';
import 'package:go_router/go_router.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SelectionArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: DesignTokens.navHeight),
                  ResponsiveContainer(
                    padding: const EdgeInsets.symmetric(vertical: DesignTokens.space120),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            AppStrings.notFoundTitle,
                            style: textTheme.displayLarge?.copyWith(
                              color: colors.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 96.0,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.space16),
                          Text(
                            AppStrings.notFoundSubtitle,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.space12),
                          Text(
                            AppStrings.notFoundMessage,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colors.textMuted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: DesignTokens.space32),
                          ShimmerButton(
                            label: AppStrings.notFoundHomeButton,
                            onPressed: () => context.go('/'),
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
