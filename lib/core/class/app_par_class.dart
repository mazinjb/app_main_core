import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ===================================================================
// القسم 1: كلاس النمط (Style Class)
// ===================================================================

/// كلاس لتغليف خصائص التصميم القابلة للتخصيص لشريط العنوان.
class AppAppBarStyle {
  final Color? backgroundColor;
  final Color? foregroundColor; // لون الأيقونات والنص
  final TextStyle? titleTextStyle;
  final double? elevation;
  final bool? centerTitle;

  const AppAppBarStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.titleTextStyle,
    this.elevation,
    this.centerTitle,
  });

  /// دالة لدمج التخصيصات مع الحفاظ على القيم الافتراضية من الثيم.
  AppAppBarStyle mergeWith(AppAppBarStyle? other) {
    if (other == null) return this;
    return AppAppBarStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      titleTextStyle: titleTextStyle?.merge(other.titleTextStyle) ?? other.titleTextStyle,
      elevation: other.elevation ?? elevation,
      centerTitle: other.centerTitle ?? centerTitle,
    );
  }
}

// ===================================================================
// القسم 2: الويدجت الرئيسي (AppAppBar)
// ===================================================================

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleKey;
  final List<Widget>? actions;
  final bool showBackButton;

  /// خاصية النمط الموحدة
  final AppAppBarStyle? style;

  const AppAppBar({
    Key? key,
    required this.titleKey,
    this.actions,
    this.showBackButton = true,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. جلب إعدادات AppBar الافتراضية من الثيم المركزي
    final themeAppBar = Theme.of(context).appBarTheme;

    // 2. إنشاء نمط افتراضي بناءً على الثيم
    final defaultStyle = AppAppBarStyle(
      backgroundColor: themeAppBar.backgroundColor,
      foregroundColor: themeAppBar.foregroundColor,
      titleTextStyle: themeAppBar.titleTextStyle,
      elevation: themeAppBar.elevation,
      centerTitle: themeAppBar.centerTitle,
    );

    // 3. دمج النمط الافتراضي مع أي تخصيصات يمررها المبرمج
    final effectiveStyle = defaultStyle.mergeWith(style);

    return AppBar(
      title: Text(
        titleKey.tr,
        style: effectiveStyle.titleTextStyle,
      ),
      backgroundColor: effectiveStyle.backgroundColor,
      foregroundColor: effectiveStyle.foregroundColor,
      elevation: effectiveStyle.elevation,
      centerTitle: effectiveStyle.centerTitle,
      automaticallyImplyLeading: showBackButton && Navigator.canPop(context),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
