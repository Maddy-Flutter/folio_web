import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';

class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.label,
    required this.suffix,
  });

  final int value;
  final String label;
  final String suffix;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _countAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: DesignTokens.durationCounter,
    );
    _countAnimation = IntTween(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: DesignTokens.curveEaseOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final PortfolioColors colors = context.portfolioColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: _countAnimation,
          builder: (BuildContext context, Widget? child) {
            return Text(
              '${_countAnimation.value}${widget.suffix}',
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
        const SizedBox(height: DesignTokens.space4),
        Text(
          widget.label,
          style: textTheme.bodySmall?.copyWith(
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }
}
