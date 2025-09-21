import 'package:flutter/material.dart';

// ===================================================================
// القسم 1: كلاسات النمط والأنواع
// ===================================================================

/// كلاس لتغليف جميع خصائص التصميم المتعلقة بشاشة البداية.
class AppSplashScreenStyle {
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Widget? loader; // ويدجت مؤشر التحميل القابل للتخصيص

  const AppSplashScreenStyle({
    this.backgroundColor,
    this.backgroundGradient,
    this.loader,
  });

  /// قالب افتراضي يعتمد على الثيم الحالي للتطبيق.
  static AppSplashScreenStyle fromTheme(BuildContext context) {
    final theme = Theme.of(context);
    return AppSplashScreenStyle(
      backgroundColor: theme.scaffoldBackgroundColor,
      // مؤشر التحميل يأخذ لونه من اللون الأساسي للثيم
      loader: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    );
  }

  /// دالة لدمج التخصيصات مع الحفاظ على القيم الافتراضية.
  AppSplashScreenStyle copyWith({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Widget? loader,
  }) {
    return AppSplashScreenStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      loader: loader ?? this.loader,
    );
  }
}

/// أنواع الحركات المتاحة للشعار.
enum LogoAnimation {
  none,
  topToBottom,
  bottomToTop,
  leftToRight,
  rightToLeft,
}


// ===================================================================
// القسم 2: الويدجت الرئيسي (AppSplashScreen)
// ===================================================================

class AppSplashScreen extends StatefulWidget {
  final Widget logo;
  final Widget? title;
  final Widget nextScreen;
  final Duration duration;

  // خصائص الحركة والمحاذاة
  final LogoAnimation logoAnimation;
  final Duration logoAnimationDuration;
  final Duration titleFadeDuration;
  final Alignment? logoFinalAlignment;
  final Alignment? titleAlignment;

  // خاصية النمط الموحدة
  final AppSplashScreenStyle? style;

  const AppSplashScreen({
    super.key,
    required this.logo,
    required this.nextScreen,
    this.title,
    this.duration = const Duration(seconds: 3),
    this.logoAnimation = LogoAnimation.none,
    this.logoAnimationDuration = const Duration(milliseconds: 1200),
    this.titleFadeDuration = const Duration(milliseconds: 1500),
    this.logoFinalAlignment,
    this.titleAlignment,
    this.style,
  });

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _titleController;
  late final Animation<Alignment> _logoAnimation;
  late final Animation<double> _titleFade;
  late final Alignment _logoFinalAlignment;

  @override
  void initState() {
    super.initState();

    _logoFinalAlignment = widget.logoFinalAlignment ?? Alignment.center;

    // تهيئة متحكمات الحركة
    _logoController = AnimationController(vsync: this, duration: widget.logoAnimationDuration);
    _titleController = AnimationController(vsync: this, duration: widget.titleFadeDuration);

    // بناء الحركات
    _logoAnimation = _buildLogoAnimation();
    _titleFade = CurvedAnimation(parent: _titleController, curve: Curves.easeInOut);

    // تشغيل الحركات بالتسلسل
    _logoController.forward().whenComplete(() {
      if (widget.title != null) {
        _titleController.forward();
      }
    });

    // الانتقال للشاشة التالية بعد انتهاء المدة
    Future.delayed(widget.duration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => widget.nextScreen),
        );
      }
    });
  }

  Animation<Alignment> _buildLogoAnimation() {
    switch (widget.logoAnimation) {
      case LogoAnimation.topToBottom:
        return AlignmentTween(begin: Alignment.topCenter, end: _logoFinalAlignment).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
      case LogoAnimation.bottomToTop:
        return AlignmentTween(begin: Alignment.bottomCenter, end: _logoFinalAlignment).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
      case LogoAnimation.leftToRight:
        return AlignmentTween(begin: Alignment.centerLeft, end: _logoFinalAlignment).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
      case LogoAnimation.rightToLeft:
        return AlignmentTween(begin: Alignment.centerRight, end: _logoFinalAlignment).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
      case LogoAnimation.none:
      default:
        return AlignmentTween(begin: _logoFinalAlignment, end: _logoFinalAlignment).animate(_logoController);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // دمج النمط الافتراضي (من الثيم) مع أي تخصيصات من المبرمج
    final effectiveStyle = AppSplashScreenStyle.fromTheme(context).copyWith(
      backgroundColor: widget.style?.backgroundColor,
      backgroundGradient: widget.style?.backgroundGradient,
      loader: widget.style?.loader,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: effectiveStyle.backgroundGradient,
          color: effectiveStyle.backgroundGradient == null
              ? effectiveStyle.backgroundColor
              : null,
        ),
        child: Stack(
          children: [
            // اللوغو
            AlignTransition(
              alignment: _logoAnimation,
              child: widget.logo,
            ),

            // العنوان
            if (widget.title != null)
              FadeTransition(
                opacity: _titleFade,
                child: Align(
                  alignment: widget.titleAlignment ??
                      Alignment(_logoFinalAlignment.x, _logoFinalAlignment.y + 0.3),
                  child: widget.title!,
                ),
              ),

            // مؤشر التحميل
            if (effectiveStyle.loader != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: effectiveStyle.loader,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
