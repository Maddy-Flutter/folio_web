import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/data/models/testimonial_model.dart';
import 'package:follio/presentation/widgets/common/hover_builder.dart';
import 'package:follio/presentation/widgets/common/photo_frame.dart';
import 'package:follio/presentation/widgets/testimonials/star_rating.dart';

class TestimonialCard extends StatelessWidget {
  const TestimonialCard({
    super.key,
    required this.testimonial,
    this.isHighlighted = false,
  });

  final TestimonialModel testimonial;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final Color cardBg = isHighlighted ? colors.featuredCardBackground : colors.cardBackground;
    final Color cardBorder = isHighlighted ? colors.featuredCardBorder : colors.cardBorder;
    final Color quoteColor = isHighlighted ? colors.textMuted : colors.textMuted;
    final Color nameColor = isHighlighted ? colorScheme.onSecondary : colorScheme.onSurface;

    return HoverTranslate(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(DesignTokens.space28),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: DesignTokens.border2Xl,
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 5 stars
            StarRating(rating: testimonial.rating),
            const SizedBox(height: DesignTokens.space20),

            // Quote
            Expanded(
              child: Text(
                '"${testimonial.quote}"',
                style: textTheme.bodyMedium?.copyWith(
                  color: quoteColor,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.space24),

            // Author metadata
            Row(
              children: <Widget>[
                PhotoFrame(
                  imageUrl: testimonial.avatarUrl,
                  altText: testimonial.name,
                  width: 42.0,
                  height: 42.0,
                  borderRadius: DesignTokens.borderPill,
                ),
                const SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        testimonial.name,
                        style: textTheme.labelLarge?.copyWith(
                          color: nameColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space2),
                      Text(
                        '${testimonial.role}, ${testimonial.company}',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
