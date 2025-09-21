import 'dart:math' as math;
import 'package:flutter/material.dart';

// ===================================================================
// القسم 6: أدوات الحركة (Motion Tools)
// ===================================================================

/// لتحديد جهة الدخول في حركة الانزلاق
enum AppMotionDirection { left, right, top, bottom }

class AppMotion extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final bool repeat;
  final Curve curve;
  final double? fadeFrom;
  final double? scaleFrom;
  final AppMotionDirection? enterFrom;
  final Offset? slideFrom;
  final double? rotateFrom;

  const AppMotion({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.repeat = false,
    this.curve = Curves.easeInOut,
    this.fadeFrom,
    this.scaleFrom,
    this.enterFrom,
    this.slideFrom,
    this.rotateFrom,
  });

  /// دالة ثابتة لتحريك القوائم بشكل متتابع
  static Widget list({
    Key? key,
    required List<Widget> children,
    Duration initialDelay = Duration.zero,
    Duration staggerDuration = const Duration(milliseconds: 100),
    // نفس خصائص AppMotion لتمريرها إلى الأبناء
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
    double? fadeFrom,
    double? scaleFrom,
    AppMotionDirection? enterFrom,
    Offset? slideFrom,
    double? rotateFrom,
  }) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(children.length, (index) {
        return AppMotion(
          delay: initialDelay + (staggerDuration * index),
          duration: duration,
          curve: curve,
          fadeFrom: fadeFrom,
          scaleFrom: scaleFrom,
          enterFrom: enterFrom,
          slideFrom: slideFrom,
          rotateFrom: rotateFrom,
          child: children[index],
        );
      }),
    );
  }


  @override
  State<AppMotion> createState() => _AppMotionState();
}

class _AppMotionState extends State<AppMotion> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    Future.delayed(widget.delay, () {
      if (mounted) {
        if (widget.repeat) {
          _controller.repeat(reverse: true);
        } else {
          _controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _animation,
          child: widget.child,
          builder: (context, child) {
            Widget current = child!;
            if (widget.rotateFrom != null) {
              final rotateTween = Tween<double>(begin: widget.rotateFrom, end: 0.0);
              current = Transform.rotate(
                angle: rotateTween.transform(_animation.value) * math.pi / 180,
                child: current,
              );
            }
            if (widget.scaleFrom != null) {
              final scaleTween = Tween<double>(begin: widget.scaleFrom, end: 1.0);
              current = Transform.scale(
                scale: scaleTween.transform(_animation.value),
                child: current,
              );
            }
            Offset startOffset = Offset.zero;
            bool doSlide = false;
            if (widget.slideFrom != null) {
              startOffset = widget.slideFrom!;
              doSlide = true;
            } else if (widget.enterFrom != null) {
              switch (widget.enterFrom!) {
                case AppMotionDirection.left:
                  startOffset = Offset(-constraints.maxWidth, 0);
                  break;
                case AppMotionDirection.right:
                  startOffset = Offset(constraints.maxWidth, 0);
                  break;
                case AppMotionDirection.top:
                  startOffset = Offset(0, -constraints.maxHeight);
                  break;
                case AppMotionDirection.bottom:
                  startOffset = Offset(0, constraints.maxHeight);
                  break;
              }
              doSlide = true;
            }
            if (doSlide) {
              final slideTween = Tween<Offset>(begin: startOffset, end: Offset.zero);
              current = Transform.translate(
                offset: slideTween.transform(_animation.value),
                child: current,
              );
            }
            if (widget.fadeFrom != null) {
              final fadeTween = Tween<double>(begin: widget.fadeFrom, end: 1.0);
              current = Opacity(
                opacity: fadeTween.transform(_animation.value),
                child: current,
              );
            }
            return current;
          },
        );
      },
    );
  }
}
