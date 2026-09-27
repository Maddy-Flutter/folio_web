import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';

class ShimmerButton extends StatefulWidget {
  const ShimmerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(
      horizontal: DesignTokens.space24,
      vertical: DesignTokens.space14,
    ),
    this.borderRadius = DesignTokens.borderPill,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  @override
  State<ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<ShimmerButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: DesignTokens.curveStandard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    if (!widget.isLoading && widget.onPressed != null) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color bg = widget.backgroundColor ?? colors.accent;
    final Color fg = widget.foregroundColor ?? colorScheme.onPrimary;

    return MouseRegion(
      cursor: widget.onPressed == null || widget.isLoading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: _onEnter,
      child: Semantics(
        button: true,
        label: widget.label,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: Material(
            color: bg,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: widget.borderRadius,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: widget.padding,
                    child: widget.isLoading
                        ? SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(fg),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.label,
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: fg,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              if (widget.icon != null) ...<Widget>[
                                const SizedBox(width: DesignTokens.space8),
                                widget.icon!,
                              ],
                            ],
                          ),
                  ),
                  // Animated shimmer sweep overlay on hover
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _shimmerAnim,
                      builder: (BuildContext context, Widget? child) {
                        if (_controller.value == 0.0 || _controller.value == 1.0) {
                          return const SizedBox.shrink();
                        }
                        return FractionalTranslation(
                          translation: Offset(_shimmerAnim.value, 0.0),
                          child: Transform(
                            transform: Matrix4.skewX(-0.3),
                            child: Container(
                              width: 60.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    colorScheme.onPrimary.withValues(alpha: 0.0),
                                    colorScheme.onPrimary.withValues(alpha: 0.25),
                                    colorScheme.onPrimary.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
