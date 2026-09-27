import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    this.rating = 5,
    this.starSize = 16.0,
  });

  final int rating;
  final double starSize;

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (int index) {
        return Padding(
          padding: const EdgeInsets.only(right: DesignTokens.space4),
          child: Icon(
            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
            size: starSize,
            color: colors.accent,
          ),
        );
      }),
    );
  }
}
