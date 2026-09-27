import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';

class NavLinkButton extends StatefulWidget {
  const NavLinkButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<NavLinkButton> createState() => _NavLinkButtonState();
}

class _NavLinkButtonState extends State<NavLinkButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _underlineAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: DesignTokens.durationNormal,
      value: widget.isActive ? 1.0 : 0.0,
    );
    _underlineAnimation = CurvedAnimation(
      parent: _controller,
      curve: DesignTokens.curveStandard,
    );
  }

  @override
  void didUpdateWidget(covariant NavLinkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.animateTo(1.0);
      } else {
        _controller.animateTo(0.0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    if (!widget.isActive) {
      _controller.forward();
    }
  }

  void _onExit(PointerEvent details) {
    if (!widget.isActive) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color textColor = widget.isActive ? colorScheme.onSurface : colors.textMuted;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.space8,
            vertical: DesignTokens.space6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: textColor,
                      fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
              const SizedBox(height: DesignTokens.space2),
              AnimatedBuilder(
                animation: _underlineAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Container(
                    height: 1.5,
                    width: 24.0 * _underlineAnimation.value,
                    color: widget.isActive ? colors.accent : colorScheme.onSurface,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
