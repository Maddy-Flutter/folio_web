import 'dart:async';
import 'package:flutter/material.dart';
import 'package:follio/core/tokens/design_tokens.dart';

class FadeSlideReveal extends StatefulWidget {
  const FadeSlideReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offsetY = 24.0,
    this.duration = DesignTokens.durationReveal,
  });

  final Widget child;
  final Duration delay;
  final double offsetY;
  final Duration duration;

  @override
  State<FadeSlideReveal> createState() => _FadeSlideRevealState();
}

class _FadeSlideRevealState extends State<FadeSlideReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: DesignTokens.curveStandard,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, widget.offsetY),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: DesignTokens.curveStandard),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
