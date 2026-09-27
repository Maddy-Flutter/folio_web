import 'package:flutter/material.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = DesignTokens.maxContentWidth,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = ResponsiveUtils.horizontalPadding(context);
    final EdgeInsetsGeometry effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: DesignTokens.space48,
        );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: effectivePadding,
          child: child,
        ),
      ),
    );
  }
}
