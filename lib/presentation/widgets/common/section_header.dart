import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.category,
    required this.title,
    this.actionWidget,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String category;
  final String title;
  final Widget? actionWidget;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  category.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: DesignTokens.space12),
                Text(
                  title,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (actionWidget != null) ...<Widget>[
            const SizedBox(width: DesignTokens.space16),
            actionWidget!,
          ],
        ],
      ),
    );
  }
}
