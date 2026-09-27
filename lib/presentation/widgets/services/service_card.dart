import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/presentation/widgets/common/hover_builder.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
  });

  final ServiceModel service;

  IconData _getIconData(String iconKey) {
    return switch (iconKey) {
      'design' => Icons.devices_outlined,
      'code' => Icons.code_rounded,
      'layout' => Icons.pie_chart_outline_rounded,
      _ => Icons.design_services_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final bool isHighlighted = service.isHighlighted;
    final Color cardBg = isHighlighted ? colors.featuredCardBackground : colors.cardBackground;
    final Color cardBorder = isHighlighted ? colors.featuredCardBorder : colors.cardBorder;
    final Color titleColor = isHighlighted ? colorScheme.onSecondary : colorScheme.onSurface;
    final Color descColor = isHighlighted ? colors.textMuted : colors.textMuted;
    final Color iconBoxBg = isHighlighted
        ? colorScheme.surfaceContainerHighest
        : colors.activeTagBackground;

    return HoverTranslate(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(DesignTokens.space32),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: DesignTokens.border2Xl,
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Icon container
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: iconBoxBg,
                borderRadius: DesignTokens.borderMd,
              ),
              child: Center(
                child: Icon(
                  _getIconData(service.iconKey),
                  color: colors.accent,
                  size: 24.0,
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.space24),

            // Title
            Text(
              service.title,
              style: textTheme.headlineSmall?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: DesignTokens.space12),

            // Description
            Expanded(
              child: Text(
                service.description,
                style: textTheme.bodyMedium?.copyWith(
                  color: descColor,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
