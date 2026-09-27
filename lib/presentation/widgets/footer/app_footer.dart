import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: ResponsiveContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space24,
          vertical: DesignTokens.space32,
        ),
        child: isMobile
            ? Column(
                children: <Widget>[
                  Text(
                    AppStrings.footerCopyright,
                    style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignTokens.space4),
                  Text(
                    AppStrings.footerDevelopedBy,
                    style: textTheme.bodySmall?.copyWith(color: colors.textSubtle),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignTokens.space12),
                  Text(
                    AppStrings.footerBuiltWith,
                    style: textTheme.labelSmall?.copyWith(color: colors.accent),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        AppStrings.footerCopyright,
                        style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                      ),
                      const SizedBox(height: DesignTokens.space4),
                      Text(
                        AppStrings.footerDevelopedBy,
                        style: textTheme.bodySmall?.copyWith(color: colors.textSubtle),
                      ),
                    ],
                  ),
                  Text(
                    AppStrings.footerBuiltWith,
                    style: textTheme.labelSmall?.copyWith(color: colors.accent),
                  ),
                ],
              ),
      ),
    );
  }
}
