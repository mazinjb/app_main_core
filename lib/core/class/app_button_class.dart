import 'package:flutter/material.dart';

import '../all_core.dart';


// ===================================================================
// القسم 1: كلاسات الأزرار المخصصة (AppButton)
// ===================================================================

/// يحتوي هذا الكلاس على جميع الخصائص المتعلقة بمظهر وتنسيق AppButton.

/*
class AppButtonStyle {
  final Color? buttonColor;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? height;
  final BorderSide? borderSide;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry? padding;

  const AppButtonStyle({
    this.buttonColor,
    this.textColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.height,
    this.borderSide,
    this.shape,
    this.padding,
  });

  /// --- القوالب الجاهزة (Presets) ---

  // القالب الأساسي (Elevated)
  static AppButtonStyle primary(BuildContext context) {
    return AppButtonStyle(
      buttonColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
      borderRadius: 12.0,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  // القالب الثانوي (Outlined)
  static AppButtonStyle secondary(BuildContext context) {
    return AppButtonStyle(
      textColor: Theme.of(context).colorScheme.primary,
      borderRadius: 12.0,
      fontWeight: FontWeight.bold,
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  // قالب النجاح (Success)
  static AppButtonStyle success(BuildContext context) {
    return AppButtonStyle(
      buttonColor: Colors.green[600],
      textColor: Colors.white,
      borderRadius: 12.0,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  // قالب الحذف (Destructive)
  static AppButtonStyle destructive(BuildContext context) {
    return AppButtonStyle(
      buttonColor: Colors.red[700],
      textColor: Colors.white,
      borderRadius: 12.0,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  AppButtonStyle copyWith({
    Color? buttonColor,
    Color? textColor,
    double? borderRadius,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    BorderSide? borderSide,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButtonStyle(
      buttonColor: buttonColor ?? this.buttonColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      height: height ?? this.height,
      borderSide: borderSide ?? this.borderSide,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
    );
  }
}
*/

class AppButtonStyle {
  final Color? buttonColor;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? height;
  final BorderSide? borderSide;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient; // ✅ الخاصية الجديدة لدعم التدرج اللوني

  const AppButtonStyle({
    this.buttonColor,
    this.textColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.height,
    this.borderSide,
    this.shape,
    this.padding,
    this.gradient, // ✅
  });

  /// قالب جديد جاهز للزر ذو التدرج اللوني
  static AppButtonStyle primaryGradient(BuildContext context) {
    final theme = Theme.of(context);
    return AppButtonStyle(
      gradient: AppGradients.primary(context),
      textColor: theme.colorScheme.onPrimary,
      borderRadius: 12.0,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  // ... باقي القوالب الجاهزة ...
  static AppButtonStyle primary(BuildContext context) {
    return AppButtonStyle(
      buttonColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
      borderRadius: 12.0,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  // ✅ تمت إعادة إضافة القوالب المفقودة هنا
  static AppButtonStyle secondary(BuildContext context) {
    return AppButtonStyle(
      textColor: Theme.of(context).colorScheme.primary,
      borderRadius: 12.0,
      fontWeight: FontWeight.bold,
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  static AppButtonStyle success(BuildContext context) {
    return AppButtonStyle(
      buttonColor: Colors.green[600],
      textColor: Colors.white,
      borderRadius: 12.0,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  static AppButtonStyle destructive(BuildContext context) {
    return AppButtonStyle(
      buttonColor: Colors.red[700],
      textColor: Colors.white,
      borderRadius: 12.0,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  AppButtonStyle copyWith({
    Color? buttonColor,
    Color? textColor,
    double? borderRadius,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    BorderSide? borderSide,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? padding,
    Gradient? gradient,
  }) {
    return AppButtonStyle(
      buttonColor: buttonColor ?? this.buttonColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      height: height ?? this.height,
      borderSide: borderSide ?? this.borderSide,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
      gradient: gradient ?? this.gradient,
    );
  }
}

// Enum to define the structural type of the button
enum AppButtonType { elevated, outlined, text }


class AppButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final AppButtonType type;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.style = const AppButtonStyle(),
    this.type = AppButtonType.elevated,
  }) : assert(text != null || icon != null, 'Cannot create a button with no text and no icon.');

  @override
  Widget build(BuildContext context) {
    final bool isIconOnly = text == null && icon != null;

    Widget buildChild() {
      if (isIconOnly) {
        return Icon(icon, size: style.fontSize ?? 18);
      } else if (text != null && icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: style.fontSize ?? 18),
            const SizedBox(width: 8),
            Text(text!),
          ],
        );
      } else {
        return Text(text!);
      }
    }

    ButtonStyle buildStyle() {
      OutlinedBorder? finalShape = style.shape;
      if (isIconOnly && style.shape == null && style.borderRadius == null) {
        finalShape = const CircleBorder();
      }

      EdgeInsetsGeometry? finalPadding = style.padding;
      if (isIconOnly && style.padding == null) {
        finalPadding = const EdgeInsets.all(12);
      }

      return ButtonStyle(
        // ✅ تعديل: جعل الخلفية شفافة إذا كان هناك تدرج لوني
        backgroundColor: MaterialStateProperty.all<Color?>(
          style.gradient != null ? Colors.transparent : style.buttonColor,
        ),
        foregroundColor: MaterialStateProperty.all<Color?>(style.textColor),
        shadowColor: MaterialStateProperty.all<Color?>(
          style.gradient != null ? Colors.transparent : null,
        ),
        overlayColor: MaterialStateProperty.all<Color?>(
            style.textColor?.withOpacity(0.1)),
        minimumSize: MaterialStateProperty.all<Size?>(
          style.height != null ? Size(0, style.height!) : null,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(finalPadding),
        textStyle: MaterialStateProperty.all<TextStyle?>(
          TextStyle(
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
          ),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          finalShape ??
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(style.borderRadius ?? 12.0),
              ),
        ),
        side: MaterialStateProperty.all<BorderSide?>(style.borderSide),
      );
    }

    Widget buttonWidget;
    switch (type) {
      case AppButtonType.outlined:
        buttonWidget = OutlinedButton(onPressed: onPressed, style: buildStyle(), child: buildChild());
        break;
      case AppButtonType.text:
        buttonWidget = TextButton(onPressed: onPressed, style: buildStyle(), child: buildChild());
        break;
      case AppButtonType.elevated:
      default:
        buttonWidget = ElevatedButton(onPressed: onPressed, style: buildStyle(), child: buildChild());
    }

    // ✅ تعديل: تغليف الزر بحاوية التدرج اللوني إذا لزم الأمر
    if (style.gradient != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: style.gradient,
          borderRadius: BorderRadius.circular(style.borderRadius ?? 12.0),
        ),
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
/*
class AppButton extends StatelessWidget {
  /// The text to display on the button. If null, an icon-only button will be created.
  final String? text;

  /// The icon to display on the button.
  final IconData? icon;

  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// The visual style of the button.
  final AppButtonStyle style;

  /// The structural type of the button (e.g., elevated, outlined).
  final AppButtonType type;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.style = const AppButtonStyle(),
    this.type = AppButtonType.elevated,
  }) : assert(text != null || icon != null,
  'Cannot create a button with no text and no icon.');

  @override
  Widget build(BuildContext context) {
    final bool isIconOnly = text == null && icon != null;

    Widget buildChild() {
      if (isIconOnly) {
        return Icon(icon, size: style.fontSize ?? 18);
      } else if (text != null && icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: style.fontSize ?? 18),
            const SizedBox(width: 8),
            Text(text!),
          ],
        );
      } else {
        return Text(text!);
      }
    }

    ButtonStyle buildStyle() {
      OutlinedBorder? finalShape = style.shape;
      if (isIconOnly && style.shape == null && style.borderRadius == null) {
        finalShape = const CircleBorder();
      }

      EdgeInsetsGeometry? finalPadding = style.padding;
      if (isIconOnly && style.padding == null) {
        finalPadding = const EdgeInsets.all(12);
      }

      return ButtonStyle(
        backgroundColor:
        WidgetStateProperty.all<Color?>(style.buttonColor),
        foregroundColor:
        WidgetStateProperty.all<Color?>(style.textColor),
        overlayColor: WidgetStateProperty.all<Color?>(
            style.textColor?.withOpacity(0.1)),
        minimumSize: WidgetStateProperty.all<Size?>(
          style.height != null ? Size(0, style.height!) : null,
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(finalPadding),
        textStyle: WidgetStateProperty.all<TextStyle?>(
          TextStyle(
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
          ),
        ),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          finalShape ??
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(style.borderRadius ?? 0),
              ),
        ),
        side: WidgetStateProperty.all<BorderSide?>(style.borderSide),
      );
    }

    switch (type) {
      case AppButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: buildStyle(),
          child: buildChild(),
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: buildStyle(),
          child: buildChild(),
        );
      case AppButtonType.elevated:
      return ElevatedButton(
          onPressed: onPressed,
          style: buildStyle(),
          child: buildChild(),
        );
    }
  }
}

 */