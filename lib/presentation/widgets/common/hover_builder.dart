import 'package:flutter/material.dart';
import 'package:follio/core/tokens/design_tokens.dart';

class HoverTranslate extends StatefulWidget {
  const HoverTranslate({
    super.key,
    required this.child,
    this.translateY = -4.0,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
  });

  final Widget child;
  final double translateY;
  final VoidCallback? onTap;
  final MouseCursor cursor;

  @override
  State<HoverTranslate> createState() => _HoverTranslateState();
}

class _HoverTranslateState extends State<HoverTranslate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: DesignTokens.durationNormal,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.translateY).animate(
      CurvedAnimation(parent: _controller, curve: DesignTokens.curveStandard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent details) {
    _controller.forward();
  }

  void _onExit(PointerEvent details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
              offset: Offset(0.0, _animation.value),
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
