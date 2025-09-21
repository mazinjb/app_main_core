import 'package:flutter/material.dart';

import '../all_core.dart';

/// كلاس مساعد لإنشاء مكونات بتدرج لوني متوافق مع الثيم.
class AppGradients {
  AppGradients._(); // لمنع إنشاء نسخ من هذا الكلاس

  /// يوفر التدرج اللوني الأساسي من الثيم الحالي
  static LinearGradient primary(BuildContext context, {
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    final themeController = AppTheme.to;
    final palette = themeController.isDarkMode
        ? themeController.currentThemeSetting.darkPalette
        : themeController.currentThemeSetting.lightPalette;

    return LinearGradient(
      colors: palette.gradientColors,
      begin: begin,
      end: end,
    );
  }

  /// يقوم بإنشاء حاوية مع تدرج لوني جاهز من الثيم
  static Widget container({
    Key? key,
    required Widget child,
    List<Color>? colors,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding = const EdgeInsets.all(16.0),
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
  }) {
    // نستخدم `Builder` للحصول على `context` بشكل صحيح
    return Builder(
        builder: (context) {
          return Container(
            key: key,
            width: width,
            height: height,
            margin: margin,
            padding: padding,
            alignment: alignment,
            constraints: constraints,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: colors != null
                  ? LinearGradient(colors: colors, begin: begin, end: end)
                  : primary(context, begin: begin, end: end), // استخدام التدرج من الثيم
            ),
            child: child,
          );
        }
    );
  }
}