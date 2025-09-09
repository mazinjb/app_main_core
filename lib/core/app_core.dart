import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ===================================================================
// القسم 1: كلاسات الأزرار المخصصة (AppButton)
// ===================================================================

/// يحتوي هذا الكلاس على جميع الخصائص المتعلقة بمظهر وتنسيق AppButton.
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

// Enum to define the structural type of the button
enum AppButtonType { elevated, outlined, text }

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
        MaterialStateProperty.all<Color?>(style.buttonColor),
        foregroundColor:
        MaterialStateProperty.all<Color?>(style.textColor),
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
                BorderRadius.circular(style.borderRadius ?? 0),
              ),
        ),
        side: MaterialStateProperty.all<BorderSide?>(style.borderSide),
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
      default:
        return ElevatedButton(
          onPressed: onPressed,
          style: buildStyle(),
          child: buildChild(),
        );
    }
  }
}

// ===================================================================
// القسم 2: كلاسات الحقول والنماذج المخصصة
// ===================================================================

/// enum لتعريف أنماط التصميم المتاحة لحقل الإدخال
enum AppTextFieldTheme {
  modern,
  underlined,
  outlined,
  inset,
}

/// كلاس لتغليف جميع خصائص التصميم المتعلقة بحقل الإدخال
class AppTextFieldThemeSettings {
  final AppTextFieldTheme type;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double? borderRadius;
  final TextStyle? textStyle;
  final Color? cursorColor;

  const AppTextFieldThemeSettings({
    this.type = AppTextFieldTheme.modern,
    this.fillColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderRadius,
    this.textStyle,
    this.cursorColor,
  });

  AppTextFieldThemeSettings _mergeWithDefaults(AppTextFieldThemeSettings defaults) {
    return AppTextFieldThemeSettings(
      type: type,
      fillColor: fillColor ?? defaults.fillColor,
      enabledBorderColor: enabledBorderColor ?? defaults.enabledBorderColor,
      focusedBorderColor: focusedBorderColor ?? defaults.focusedBorderColor,
      errorBorderColor: errorBorderColor ?? defaults.errorBorderColor,
      borderRadius: borderRadius ?? defaults.borderRadius,
      textStyle: textStyle ?? defaults.textStyle,
      cursorColor: cursorColor ?? defaults.cursorColor,
    );
  }
}

class AppTextField extends StatefulWidget {
  // الخصائص الأساسية
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  // خصائص التصميم المجمعة
  final AppTextFieldThemeSettings theme;

  // الخصائص الوظيفية المضافة
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final int? maxLength;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final int maxLines;
  final bool enabled;
  final TextCapitalization textCapitalization;


  const AppTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isPassword = false,
    this.theme = const AppTextFieldThemeSettings(),
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.autofocus = false,
    this.maxLength,
    this.onTap,
    this.onChanged,
    this.onSaved,
    this.maxLines = 1,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  AppTextFieldThemeSettings _getDefaultsForTheme(AppTextFieldTheme type, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case AppTextFieldTheme.underlined:
        return AppTextFieldThemeSettings(fillColor: Colors.transparent, enabledBorderColor: Colors.grey[700]!, focusedBorderColor: theme.primaryColor, errorBorderColor: theme.colorScheme.error, cursorColor: theme.primaryColor);
      case AppTextFieldTheme.outlined:
        return AppTextFieldThemeSettings(
            fillColor: theme.colorScheme.surface,
            enabledBorderColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            focusedBorderColor: theme.primaryColor,
            errorBorderColor: theme.colorScheme.error,
            borderRadius: 12.0,
            cursorColor: theme.primaryColor,
            textStyle: TextStyle(color: theme.colorScheme.onSurface)
        );
      case AppTextFieldTheme.inset:
        return AppTextFieldThemeSettings(fillColor: const Color(0xFFE0E5EC), borderRadius: 12.0, cursorColor: theme.primaryColor);
      case AppTextFieldTheme.modern:
      default:
        return AppTextFieldThemeSettings(
            fillColor: theme.colorScheme.surface.withOpacity(isDark ? 0.5 : 1.0),
            focusedBorderColor: theme.primaryColor,
            errorBorderColor: theme.colorScheme.error,
            borderRadius: 12.0,
            cursorColor: theme.primaryColor,
            textStyle: TextStyle(color: theme.colorScheme.onSurface)
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeDefaults = _getDefaultsForTheme(widget.theme.type, context);
    final finalTheme = widget.theme._mergeWithDefaults(themeDefaults);

    Widget? currentSuffixIcon = widget.suffixIcon;
    if (widget.isPassword) {
      currentSuffixIcon = IconButton(icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: _togglePasswordVisibility);
    }

    InputDecoration decoration;

    switch (finalTheme.type) {
      case AppTextFieldTheme.underlined:
        decoration = InputDecoration(filled: true, fillColor: finalTheme.fillColor, enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: finalTheme.enabledBorderColor!, width: 1.0)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: finalTheme.focusedBorderColor!, width: 2.0)), errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: finalTheme.errorBorderColor!, width: 1.5)), focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: finalTheme.errorBorderColor!, width: 2.0)));
        break;
      case AppTextFieldTheme.outlined:
        decoration = InputDecoration(filled: true, fillColor: finalTheme.fillColor, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(finalTheme.borderRadius!), borderSide: BorderSide(color: finalTheme.enabledBorderColor!, width: 1.0)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(finalTheme.borderRadius!), borderSide: BorderSide(color: finalTheme.focusedBorderColor!, width: 2.0)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(finalTheme.borderRadius!), borderSide: BorderSide(color: finalTheme.errorBorderColor!, width: 1.5)), focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(finalTheme.borderRadius!), borderSide: BorderSide(color: finalTheme.errorBorderColor!, width: 2.0)));
        break;
      case AppTextFieldTheme.inset:
        decoration = const InputDecoration(border: InputBorder.none);
        break;
      case AppTextFieldTheme.modern:
      default:
        decoration = InputDecoration(filled: true, fillColor: finalTheme.fillColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(finalTheme.borderRadius!), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(finalTheme.borderRadius!), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(finalTheme.borderRadius!), borderSide: BorderSide(color: finalTheme.focusedBorderColor!, width: 2.0)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(finalTheme.borderRadius!), borderSide: BorderSide(color: finalTheme.errorBorderColor!, width: 1.5)), focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(finalTheme.borderRadius!), borderSide: BorderSide(color: finalTheme.errorBorderColor!, width: 2.0)));
        break;
    }

    decoration = decoration.copyWith(labelText: widget.labelText, labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)), hintText: widget.hintText, hintStyle: TextStyle(color: Colors.grey), prefixIcon: widget.prefixIcon, suffixIcon: currentSuffixIcon, contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0));

    final defaultTextStyle = TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface);
    final finalTextStyle = defaultTextStyle.merge(finalTheme.textStyle);

    final textField = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: widget.inputFormatters,
      autofocus: widget.autofocus,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      cursorColor: finalTheme.cursorColor,
      validator: widget.validator,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      maxLines: widget.maxLines,
      enabled: widget.enabled,
      style: finalTextStyle,
      decoration: decoration,
      textCapitalization: widget.textCapitalization,
    );

    if (finalTheme.type == AppTextFieldTheme.inset) {
      return Container(decoration: BoxDecoration(color: finalTheme.fillColor, borderRadius: BorderRadius.circular(finalTheme.borderRadius!), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), offset: const Offset(2, 2), blurRadius: 4), BoxShadow(color: Colors.white.withOpacity(0.8), offset: const Offset(-2, -2), blurRadius: 3)]), child: textField);
    }
    return textField;
  }
}

class AppValidators {
  /// Validator to ensure the field is not empty or null.
  static String? required(dynamic? value) {
    if (value == null) {
      return 'error_required'.tr;
    }
    if (value is String && value.trim().isEmpty) {
      return 'error_required'.tr;
    }
    return null;
  }

  /// Validator for email format.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Should be handled by 'required' validator
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'error_email_format'.tr;
    }
    return null;
  }

  /// Validator for strong password.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 8) {
      return 'error_password_length'.tr;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'error_password_uppercase'.tr;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'error_password_number'.tr;
    }
    return null;
  }

  /// A utility to compose multiple validators into one.
  static String? Function(T?) compose<T>(List<String? Function(T?)> validators) {
    return (T? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}

class AppForm extends StatefulWidget {
  final List<String> textFields;
  final Widget Function(Map<String, TextEditingController> controllers) builder;
  final void Function(Map<String, String> data) onSubmit;

  const AppForm({
    Key? key,
    required this.textFields,
    required this.builder,
    required this.onSubmit,
  }) : super(key: key);

  @override
  AppFormState createState() => AppFormState();
}

class AppFormState extends State<AppForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (var fieldName in widget.textFields) fieldName: TextEditingController()
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Public method to trigger form validation and submission.
  void submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        for (var entry in _controllers.entries) entry.key: entry.value.text
      };
      widget.onSubmit(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.builder(_controllers),
    );
  }
}

// ===================================================================
// القسم 3: كلاسات القائمة المنسدلة المخصصة (AppDropdown)
// ===================================================================

enum AppDropdownType {
  primary,
  secondary,
  searchable,
  bottomSheet,
}

class AppDropdownStyle {
  final AppDropdownType? type;
  final AppDropdownInputDecoration? decoration;
  final Color? dropdownColor;
  final TextStyle? itemTextStyle;
  final Color? iconColor;
  final double? iconSize;
  final Alignment? dropdownAlignment;
  final bool? isExpanded;
  final Widget? hint;

  const AppDropdownStyle({
    this.type,
    this.decoration,
    this.dropdownColor,
    this.itemTextStyle,
    this.iconColor,
    this.iconSize,
    this.dropdownAlignment,
    this.isExpanded,
    this.hint,
  });

  AppDropdownStyle merge(AppDropdownStyle other) {
    return AppDropdownStyle(
      type: other.type ?? type,
      decoration: other.decoration?.merge(decoration) ?? decoration,
      dropdownColor: other.dropdownColor ?? dropdownColor,
      itemTextStyle: other.itemTextStyle ?? itemTextStyle,
      iconColor: other.iconColor ?? iconColor,
      iconSize: other.iconSize ?? iconSize,
      dropdownAlignment: other.dropdownAlignment ?? dropdownAlignment,
      isExpanded: other.isExpanded ?? isExpanded,
      hint: other.hint ?? hint,
    );
  }
}

class AppDropdownInputDecoration {
  final Color? fillColor;
  final InputBorder? border;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final double? borderRadius;

  const AppDropdownInputDecoration({
    this.fillColor,
    this.border,
    this.labelStyle,
    this.prefixIcon,
    this.borderRadius,
  });

  AppDropdownInputDecoration merge(AppDropdownInputDecoration? other) {
    if (other == null) return this;
    return AppDropdownInputDecoration(
      fillColor: other.fillColor ?? fillColor,
      border: other.border ?? border,
      labelStyle: other.labelStyle ?? labelStyle,
      prefixIcon: other.prefixIcon ?? prefixIcon,
      borderRadius: other.borderRadius ?? borderRadius,
    );
  }
}

class AppDropdown extends StatefulWidget {
  final String labelText;
  final List<String> options;
  final Function(String?) onChanged;
  final AppDropdownStyle? style;
  final String? value;
  final bool isRequired;

  const AppDropdown({
    super.key,
    required this.labelText,
    required this.options,
    required this.onChanged,
    this.style,
    this.value,
    this.isRequired = false,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  String? _selectedValue;
  late final TextEditingController _searchController;
  late List<String> _filteredOptions;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _searchController = TextEditingController();
    _filteredOptions = widget.options;
  }

  @override
  void didUpdateWidget(covariant AppDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _selectedValue = widget.value;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AppDropdownStyle _getStyleByType(AppDropdownType type, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case AppDropdownType.primary:
        return AppDropdownStyle(
          decoration: AppDropdownInputDecoration(
            fillColor: theme.colorScheme.primary.withOpacity(0.05),
            labelStyle: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
          dropdownColor: theme.colorScheme.surface,
          itemTextStyle: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
          iconColor: theme.colorScheme.primary,
        );
      case AppDropdownType.secondary:
        return AppDropdownStyle(
          decoration: AppDropdownInputDecoration(
            fillColor: theme.colorScheme.secondary.withOpacity(0.05),
            labelStyle: TextStyle(color: theme.colorScheme.secondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: theme.colorScheme.secondary),
            ),
          ),
          dropdownColor: theme.colorScheme.surface,
          itemTextStyle: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
          iconColor: theme.colorScheme.secondary,
        );
      case AppDropdownType.searchable:
        return AppDropdownStyle(
          decoration: AppDropdownInputDecoration(
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            labelStyle: TextStyle(color: theme.colorScheme.onSurface),
          ),
          dropdownColor: theme.cardColor,
          iconColor: theme.colorScheme.onSurface,
        );
      case AppDropdownType.bottomSheet:
        return AppDropdownStyle(
          decoration: AppDropdownInputDecoration(
            fillColor: theme.colorScheme.primary.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            labelStyle: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
          iconColor: theme.colorScheme.primary,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    AppDropdownStyle effectiveStyle = const AppDropdownStyle();
    if (widget.style?.type != null) {
      effectiveStyle = _getStyleByType(widget.style!.type!, context).merge(widget.style!);
    } else {
      effectiveStyle = _getStyleByType(AppDropdownType.primary, context).merge(widget.style ?? const AppDropdownStyle());
    }

    Widget buildLabel() {
      if (widget.isRequired) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.labelText,
                style: effectiveStyle.decoration?.labelStyle ?? TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 16),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: (effectiveStyle.decoration?.labelStyle?.fontSize ?? 16) * 1.2,
                ),
              ),
            ],
          ),
        );
      } else {
        return Text(widget.labelText, style: effectiveStyle.decoration?.labelStyle);
      }
    }

    if (effectiveStyle.type == AppDropdownType.bottomSheet) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveStyle.decoration?.fillColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveStyle.decoration?.borderRadius ?? 12.0),
            side: BorderSide(color: effectiveStyle.decoration?.border?.borderSide.color ?? Colors.grey),
          ),
        ),
        onPressed: () => _showBottomSheetDialog(context, effectiveStyle),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (effectiveStyle.decoration?.prefixIcon != null) effectiveStyle.decoration!.prefixIcon!,
                  if (effectiveStyle.decoration?.prefixIcon != null) const SizedBox(width: 8),
                  Text(
                    _selectedValue?.tr ?? widget.labelText,
                    style: effectiveStyle.itemTextStyle ?? TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  if (widget.isRequired) Text(' *', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              Icon(Icons.arrow_drop_down, color: effectiveStyle.iconColor),
            ],
          ),
        ),
      );
    } else if (effectiveStyle.type == AppDropdownType.searchable) {
      return GestureDetector(
        onTap: () {
          _showSearchableDialog(context, effectiveStyle);
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: TextEditingController(text: _selectedValue?.tr),
            decoration: InputDecoration(
              border: effectiveStyle.decoration?.border,
              label: buildLabel(),
              filled: effectiveStyle.decoration?.fillColor != null,
              fillColor: effectiveStyle.decoration?.fillColor,
              prefixIcon: effectiveStyle.decoration?.prefixIcon,
              suffixIcon: Icon(Icons.arrow_drop_down, color: effectiveStyle.iconColor),
            ),
            readOnly: true,
            style: effectiveStyle.itemTextStyle,
            validator: (value) {
              if (widget.isRequired && (value == null || value.isEmpty)) {
                return 'error_required'.tr;
              }
              return null;
            },
          ),
        ),
      );
    } else {
      return DropdownButtonFormField<String>(
        isExpanded: effectiveStyle.isExpanded ?? true,
        decoration: InputDecoration(
          border: effectiveStyle.decoration?.border,
          label: buildLabel(),
          filled: effectiveStyle.decoration?.fillColor != null,
          fillColor: effectiveStyle.decoration?.fillColor,
          prefixIcon: effectiveStyle.decoration?.prefixIcon,
        ),
        value: _selectedValue,
        items: widget.options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: effectiveStyle.dropdownAlignment ?? AlignmentDirectional.centerStart,
            child: Text(
              value.tr,
              style: effectiveStyle.itemTextStyle,
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue;
          });
          widget.onChanged(newValue);
        },
        hint: effectiveStyle.hint ?? Text('select_option'.tr),
        dropdownColor: effectiveStyle.dropdownColor,
        iconEnabledColor: effectiveStyle.iconColor,
        iconSize: effectiveStyle.iconSize ?? 24.0,
        style: effectiveStyle.itemTextStyle,
        validator: (value) {
          if (widget.isRequired && value == null) {
            return 'error_required'.tr;
          }
          return null;
        },
      );
    }
  }

  void _showSearchableDialog(BuildContext context, AppDropdownStyle effectiveStyle) {
    _searchController.clear();
    _filteredOptions = widget.options;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.labelText, style: effectiveStyle.decoration?.labelStyle),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'search'.tr,
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        setDialogState(() {
                          _filteredOptions = widget.options.where((option) {
                            return option.tr.toLowerCase().contains(query.toLowerCase());
                          }).toList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredOptions.length,
                        itemBuilder: (context, index) {
                          final optionKey = _filteredOptions[index];
                          return ListTile(
                            title: Text(optionKey.tr, style: effectiveStyle.itemTextStyle),
                            onTap: () {
                              setState(() {
                                _selectedValue = optionKey;
                              });
                              widget.onChanged(optionKey);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'.tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheetDialog(BuildContext context, AppDropdownStyle effectiveStyle) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.labelText,
                style: effectiveStyle.decoration?.labelStyle,
              ),
            ),
            const Divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  return ListTile(
                    title: Text(
                      option.tr,
                      style: effectiveStyle.itemTextStyle,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedValue = option;
                      });
                      widget.onChanged(option);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ===================================================================
// القسم 4: كلاسات الراديو المخصصة (AppRadioButton)
// ===================================================================

/// Predefined types that alter appearance and/or layout.
enum AppRadioButtonType {
  primary,
  secondary,
  horizontal,
  vertical,
}

/// A lightweight, InputDecoration-like wrapper for extra decoration options.
/// Supports merging.
class AppRadioButtonInputDecoration {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputBorder? border;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? contentPadding;
  final String? helperText;
  final TextStyle? helperStyle;

  const AppRadioButtonInputDecoration({
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.labelStyle,
    this.contentPadding,
    this.helperText,
    this.helperStyle,
  });

  AppRadioButtonInputDecoration copyWith({
    Widget? prefixIcon,
    Widget? suffixIcon,
    InputBorder? border,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? contentPadding,
    String? helperText,
    TextStyle? helperStyle,
  }) {
    return AppRadioButtonInputDecoration(
      prefixIcon: prefixIcon ?? this.prefixIcon,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      border: border ?? this.border,
      labelStyle: labelStyle ?? this.labelStyle,
      contentPadding: contentPadding ?? this.contentPadding,
      helperText: helperText ?? this.helperText,
      helperStyle: helperStyle ?? this.helperStyle,
    );
  }

  AppRadioButtonInputDecoration merge(AppRadioButtonInputDecoration? other) {
    if (other == null) return this;
    return copyWith(
      prefixIcon: other.prefixIcon ?? prefixIcon,
      suffixIcon: other.suffixIcon ?? suffixIcon,
      border: other.border ?? border,
      labelStyle: other.labelStyle ?? labelStyle,
      contentPadding: other.contentPadding ?? contentPadding,
      helperText: other.helperText ?? helperText,
      helperStyle: other.helperStyle ?? helperStyle,
    );
  }
}

/// Styling container for AppRadioButton. Supports merging.
class AppRadioButtonStyle {
  final AppRadioButtonType type;
  final Color? activeColor;
  final Color? fillColor; // For wrapping containers/chips if needed.
  final TextStyle? labelTextStyle;
  final TextStyle? itemTextStyle;
  final double? spacing;
  final double? runSpacing;
  final Axis? direction; // Layout direction for options.
  final AppRadioButtonInputDecoration? inputDecoration;

  const AppRadioButtonStyle({
    this.type = AppRadioButtonType.primary,
    this.activeColor,
    this.fillColor,
    this.labelTextStyle,
    this.itemTextStyle,
    this.spacing,
    this.runSpacing,
    this.direction,
    this.inputDecoration,
  });

  AppRadioButtonStyle copyWith({
    AppRadioButtonType? type,
    Color? activeColor,
    Color? fillColor,
    TextStyle? labelTextStyle,
    TextStyle? itemTextStyle,
    double? spacing,
    double? runSpacing,
    Axis? direction,
    AppRadioButtonInputDecoration? inputDecoration,
  }) {
    return AppRadioButtonStyle(
      type: type ?? this.type,
      activeColor: activeColor ?? this.activeColor,
      fillColor: fillColor ?? this.fillColor,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      direction: direction ?? this.direction,
      inputDecoration: inputDecoration ?? this.inputDecoration,
    );
  }

  AppRadioButtonStyle merge(AppRadioButtonStyle? other) {
    if (other == null) return this;
    return copyWith(
      type: other.type,
      activeColor: other.activeColor ?? activeColor,
      fillColor: other.fillColor ?? fillColor,
      labelTextStyle: other.labelTextStyle ?? labelTextStyle,
      itemTextStyle: other.itemTextStyle ?? itemTextStyle,
      spacing: other.spacing ?? spacing,
      runSpacing: other.runSpacing ?? runSpacing,
      direction: other.direction ?? direction,
      inputDecoration: (inputDecoration ?? const AppRadioButtonInputDecoration())
          .merge(other.inputDecoration),
    );
  }

  /// Preset factory based on type.
  static AppRadioButtonStyle preset(AppRadioButtonType type, BuildContext ctx) {
    final theme = Theme.of(ctx);
    switch (type) {
      case AppRadioButtonType.primary:
        return AppRadioButtonStyle(
          type: type,
          activeColor: theme.colorScheme.primary,
          labelTextStyle: theme.textTheme.titleMedium,
          itemTextStyle: theme.textTheme.bodyMedium,
          spacing: 8,
          runSpacing: 4,
          direction: Axis.vertical,
          inputDecoration: AppRadioButtonInputDecoration(
            border: UnderlineInputBorder(borderSide: BorderSide(color: theme.dividerColor)),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        );
      case AppRadioButtonType.secondary:
        return AppRadioButtonStyle(
          type: type,
          activeColor: theme.colorScheme.secondary,
          labelTextStyle: theme.textTheme.titleMedium
              ?.copyWith(color: theme.colorScheme.secondary),
          itemTextStyle: theme.textTheme.bodyMedium,
          spacing: 10,
          runSpacing: 6,
          direction: Axis.vertical,
          inputDecoration: AppRadioButtonInputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        );
      case AppRadioButtonType.horizontal:
        return AppRadioButtonStyle(
          type: type,
          activeColor: theme.colorScheme.primary,
          direction: Axis.horizontal,
          spacing: 12,
          runSpacing: 8,
          labelTextStyle: theme.textTheme.titleMedium,
          itemTextStyle: theme.textTheme.bodyMedium,
          inputDecoration: AppRadioButtonInputDecoration(
            border: UnderlineInputBorder(borderSide: BorderSide(color: theme.dividerColor)),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        );
      case AppRadioButtonType.vertical:
        return AppRadioButtonStyle(
          type: type,
          activeColor: theme.colorScheme.primary,
          direction: Axis.vertical,
          spacing: 8,
          runSpacing: 4,
          labelTextStyle: theme.textTheme.titleMedium,
          itemTextStyle: theme.textTheme.bodyMedium,
          inputDecoration: AppRadioButtonInputDecoration(
            border: UnderlineInputBorder(borderSide: BorderSide(color: theme.dividerColor)),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        );
    }
  }
}

/// --- AppRadioButton Widget ---------------------------------------------------

class AppRadioButton extends StatefulWidget {
  final String labelText;
  final List<String> options; // Expect translation keys or plain text.
  final String? value; // Selected value (should match an item from options).
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final AppRadioButtonStyle? style;

  const AppRadioButton({
    super.key,
    required this.labelText,
    required this.options,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.style,
  });

  @override
  State<AppRadioButton> createState() => _AppRadioButtonState();
}

class _AppRadioButtonState extends State<AppRadioButton> {
  late AppRadioButtonStyle _effectiveStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final providedType = widget.style?.type ?? AppRadioButtonType.primary;
    _effectiveStyle =
        AppRadioButtonStyle.preset(providedType, context).merge(widget.style);
  }

  @override
  void didUpdateWidget(covariant AppRadioButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style) {
      final providedType = widget.style?.type ?? AppRadioButtonType.primary;
      _effectiveStyle =
          AppRadioButtonStyle.preset(providedType, context).merge(widget.style);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dir = _effectiveStyle.direction ?? Axis.vertical;
    final spacing = _effectiveStyle.spacing ?? 8;
    final runSpacing = _effectiveStyle.runSpacing ?? 4;

    final label = _buildLabel(context);

    final optionsWrap = Wrap(
      direction: dir,
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widget.options.map((opt) {
        final translated = opt.tr;
        return _RadioItem(
          label: translated,
          value: opt,
          groupValue: widget.value,
          onChanged: widget.onChanged,
          activeColor: _effectiveStyle.activeColor,
          itemTextStyle: _effectiveStyle.itemTextStyle,
        );
      }).toList(),
    );

    final inputDecoration =
    (_effectiveStyle.inputDecoration ?? const AppRadioButtonInputDecoration());

    final decorated = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (inputDecoration.prefixIcon != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: inputDecoration.prefixIcon!,
          ),
        label,
        const SizedBox(height: 8),
        optionsWrap,
        if (inputDecoration.helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              inputDecoration.helperText!,
              style: inputDecoration.helperStyle ??
                  Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (inputDecoration.suffixIcon != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: inputDecoration.suffixIcon!,
          ),
      ],
    );

    if (inputDecoration.border != null) {
      return Container(
        padding:
        inputDecoration.contentPadding ?? const EdgeInsets.all(12.0),
        decoration: ShapeDecoration(
          shape: _borderToShape(inputDecoration.border!),
        ),
        child: decorated,
      );
    }
    return Padding(
      padding: inputDecoration.contentPadding ?? EdgeInsets.zero,
      child: decorated,
    );
  }

  Widget _buildLabel(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = _effectiveStyle.inputDecoration?.labelStyle ??
        _effectiveStyle.labelTextStyle ??
        theme.textTheme.titleMedium;

    final textSpans = <TextSpan>[
      TextSpan(text: widget.labelText.tr, style: labelStyle),
    ];
    if (widget.isRequired) {
      textSpans.add(
        TextSpan(
          text: ' *',
          style: (labelStyle ?? const TextStyle())
              .copyWith(color: theme.colorScheme.error, fontWeight: FontWeight.w700, fontSize: (labelStyle?.fontSize ?? 16) + 4),
        ),
      );
    }
    return RichText(text: TextSpan(children: textSpans));
  }

  OutlinedBorder _borderToShape(InputBorder border) {
    if (border is OutlineInputBorder) {
      return RoundedRectangleBorder(
        borderRadius: border.borderRadius,
        side: border.borderSide,
      );
    }
    if (border is UnderlineInputBorder) {
      return RoundedRectangleBorder(
        borderRadius: border.borderRadius,
        side: border.borderSide,
      );
    }
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Colors.grey),
    );
  }
}

/// A single radio item (Radio + label) to keep AppRadioButton clean.
class _RadioItem extends StatelessWidget {
  final String label;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final Color? activeColor;
  final TextStyle? itemTextStyle;

  const _RadioItem({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.activeColor,
    this.itemTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            activeColor: activeColor,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 4),
          Text(label, style: itemTextStyle ?? Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// ===================================================================
// القسم 5: كلاسات مربع الاختيار المخصص (AppCheckBox)
// ===================================================================

enum AppCheckBoxType {
  primary,
  secondary,
  horizontal,
  vertical,
}

class AppCheckBoxStyle {
  final AppCheckBoxType type;
  final Color? fillColor;
  final Color? checkColor;
  final TextStyle? itemTextStyle;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  const AppCheckBoxStyle({
    this.type = AppCheckBoxType.primary,
    this.fillColor,
    this.checkColor,
    this.itemTextStyle,
    this.labelStyle,
    this.padding,
    this.spacing,
  });

  static AppCheckBoxStyle fromType(AppCheckBoxType type, BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case AppCheckBoxType.primary:
      case AppCheckBoxType.vertical:
        return AppCheckBoxStyle(
          type: type,
          fillColor: theme.colorScheme.primary,
          checkColor: theme.colorScheme.onPrimary,
          itemTextStyle: theme.textTheme.bodyMedium,
          labelStyle: theme.textTheme.titleMedium,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          spacing: 8.0,
        );
      case AppCheckBoxType.secondary:
        return AppCheckBoxStyle(
          type: type,
          fillColor: theme.colorScheme.secondary,
          checkColor: Colors.white,
          itemTextStyle: theme.textTheme.bodyMedium,
          labelStyle: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.secondary),
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          spacing: 6.0,
        );
      case AppCheckBoxType.horizontal:
        return AppCheckBoxStyle(
          type: type,
          fillColor: theme.colorScheme.primary,
          checkColor: theme.colorScheme.primary,
          itemTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
          labelStyle: theme.textTheme.titleMedium,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          spacing: 12.0,
        );
    }
  }

  AppCheckBoxStyle merge(AppCheckBoxStyle? other) {
    if (other == null) return this;
    return AppCheckBoxStyle(
      type: other.type,
      fillColor: other.fillColor ?? fillColor,
      checkColor: other.checkColor ?? checkColor,
      itemTextStyle: other.itemTextStyle ?? itemTextStyle,
      labelStyle: other.labelStyle ?? labelStyle,
      padding: other.padding ?? padding,
      spacing: other.spacing ?? spacing,
    );
  }
}

class AppCheckBox extends StatefulWidget {
  final String labelText;
  final List<String> options;
  final List<String> selectedValues;
  final Function(List<String>) onChanged;
  final bool isRequired;
  final AppCheckBoxStyle style;

  const AppCheckBox({
    Key? key,
    required this.labelText,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.isRequired = false,
    this.style = const AppCheckBoxStyle(),
  }) : super(key: key);

  @override
  _AppCheckBoxState createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {
  late List<String> _selectedValues;
  late AppCheckBoxStyle _effectiveStyle;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.selectedValues);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateEffectiveStyle();
  }

  @override
  void didUpdateWidget(AppCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValues != widget.selectedValues) {
      _selectedValues = List.from(widget.selectedValues);
    }
    if (oldWidget.style != widget.style) {
      _updateEffectiveStyle();
    }
  }

  void _updateEffectiveStyle() {
    _effectiveStyle = AppCheckBoxStyle.fromType(widget.style.type, context).merge(widget.style);
  }

  void _handleSelectionChange(String value, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        if (!_selectedValues.contains(value)) {
          _selectedValues.add(value);
        }
      } else {
        _selectedValues.remove(value);
      }
    });
    widget.onChanged(_selectedValues);
  }

  Widget _buildLabel() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            widget.labelText.tr,
            style: _effectiveStyle.labelStyle,
          ),
          if (widget.isRequired) ...[
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(color: theme.colorScheme.error, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String option) {
    final isSelected = _selectedValues.contains(option);

    return CheckboxListTile(
      title: Text(
        option.tr,
        style: _effectiveStyle.itemTextStyle,
      ),
      value: isSelected,
      onChanged: (bool? value) => _handleSelectionChange(option, value),
      activeColor: _effectiveStyle.fillColor,
      checkColor: _effectiveStyle.checkColor,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildHorizontalLayout() {
    final theme = Theme.of(context);
    return Wrap(
      spacing: _effectiveStyle.spacing ?? 8.0,
      runSpacing: 4.0,
      children: widget.options.map((option) {
        final isSelected = _selectedValues.contains(option);
        return FilterChip(
          label: Text(
            option.tr,
            style: _effectiveStyle.itemTextStyle,
          ),
          selected: isSelected,
          onSelected: (bool selected) => _handleSelectionChange(option, selected),
          selectedColor: _effectiveStyle.fillColor?.withOpacity(0.2),
          checkmarkColor: _effectiveStyle.checkColor,
          backgroundColor: theme.dividerColor.withOpacity(0.5),
        );
      }).toList(),
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.options.map((option) => _buildCheckboxItem(option)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _effectiveStyle.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(),
          if (_effectiveStyle.type == AppCheckBoxType.horizontal)
            _buildHorizontalLayout()
          else
            _buildVerticalLayout(),
        ],
      ),
    );
  }
}

// ===================================================================
// القسم 6: كلاسات التبويبات المخصصة (AppTab)
// ===================================================================
enum AppTabStyle {
  /// النمط الأول: شريط العنوان يتمرر مع المحتوى. مثالي للمحتوى الطويل.
  nestedScroll,

  /// النمط الثاني: شريط العنوان يبقى ثابتًا في الأعلى.
  fixedHeader,
}

class AppTab extends StatelessWidget {
  final String title;
  final List<Tab> tabs;
  final List<Widget> children;
  final AppTabStyle style;
  final bool pinned;
  final bool floating;

  const AppTab({
    super.key,
    required this.title,
    required this.tabs,
    required this.children,
    this.style = AppTabStyle.nestedScroll, // القيمة الافتراضية هي النمط المتمرر
    this.pinned = true,
    this.floating = true,
  }) : assert(tabs.length == children.length);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: _buildUI(context),
    );
  }

  /// دالة مساعدة لبناء الواجهة بناءً على النمط المختار
  Widget _buildUI(BuildContext context) {
    switch (style) {
      case AppTabStyle.nestedScroll:
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(title),
                  pinned: pinned,
                  floating: floating,
                  bottom: TabBar(tabs: tabs),
                ),
              ];
            },
            body: TabBarView(children: children),
          ),
        );
      case AppTabStyle.fixedHeader:
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: TabBar(tabs: tabs),
          ),
          body: TabBarView(children: children),
        );
    }
  }
}

// ===================================================================
// القسم 7: نظام الترجمة الديناميكي
// ===================================================================

class AppTranslator {
  static _AppTranslatorService get instance => Get.find<_AppTranslatorService>();

  static Future<void> init({
    String? supabaseUrl,
    String? supabaseAnonKey,
    required Locale initialLocale,
    Map<String, Map<String, String>>? specificTranslations,
  }) async {
    await Supabase.initialize(
      url: supabaseUrl ?? _AppTranslatorService._defaultSupabaseUrl,
      anonKey: supabaseAnonKey ?? _AppTranslatorService._defaultSupabaseAnonKey,
    );
    await Get.putAsync(() => _AppTranslatorService()._init(specificTranslations));
    instance.changeLocale(initialLocale);
  }
}

class _AppTranslatorService extends GetxService implements Translations {
  static const String _defaultSupabaseUrl = 'https://pfaijxjdlhnbsbruyidc.supabase.co';
  static const String _defaultSupabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmYWlqeGpkbGhuYnNicnV5aWRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcwNjQ4NDksImV4cCI6MjA3MjY0MDg0OX0.taU5H_DbwD9BJOs3kNDMUBXtd462gBpyVc6L01R1qDU';

  final supabase = Supabase.instance.client;
  final version = 0.obs;
  final translations = <String, Map<String, String>>{}.obs;

  @override
  Map<String, Map<String, String>> get keys => translations;

  Future<_AppTranslatorService> _init(Map<String, Map<String, String>>? specificTranslations) async {
    await _initialFetch(specificTranslations);
    return this;
  }

  void changeLocale(Locale locale) {
    if (Get.locale != locale) {
      Get.updateLocale(locale);
      version.value++;
    }
  }

  Future<void> _initialFetch(Map<String, Map<String, String>>? specificTranslations) async {
    try {
      final data = await supabase.from('translations').select();
      _processData(data, specificTranslations);
    } catch (e) {
      print("Error fetching translations: $e");
      translations.value = specificTranslations ?? {};
      version.value++;
    }
  }

  void _processData(List<Map<String, dynamic>> data, Map<String, Map<String, String>>? specificTranslations) {
    if (data.isEmpty) {
      translations.value = specificTranslations ?? {};
      version.value++;
      return;
    }
    final Map<String, Map<String, String>> supabaseTranslations = {};
    const ignoredColumns = {'id', 'created_at', 'key'};
    for (var row in data) {
      final currentKey = row['key'] as String;
      row.forEach((columnName, value) {
        if (!ignoredColumns.contains(columnName)) {
          supabaseTranslations.putIfAbsent(columnName, () => {});
          supabaseTranslations[columnName]![currentKey] = value?.toString() ?? '';
        }
      });
    }
    if (specificTranslations != null) {
      specificTranslations.forEach((langCode, translationsMap) {
        supabaseTranslations.putIfAbsent(langCode, () => {});
        supabaseTranslations[langCode]!.addAll(translationsMap);
      });
    }
    final Map<String, Map<String, String>> finalTranslations = {};
    final englishTranslations = supabaseTranslations['en_US'] ?? {};
    supabaseTranslations.forEach((langCode, translationsMap) {
      if (langCode == 'en_US') {
        finalTranslations[langCode] = Map.from(englishTranslations);
        return;
      }
      final currentLangMap = <String, String>{};
      englishTranslations.forEach((key, englishValue) {
        final translatedValue = translationsMap[key];
        currentLangMap[key] = (translatedValue != null && translatedValue.isNotEmpty)
            ? translatedValue
            : englishValue;
      });
      finalTranslations[langCode] = currentLangMap;
    });
    translations.value = finalTranslations;
    version.value++;
  }
}

// ===================================================================
// القسم 8: نظام الثيمات المتكامل
// ===================================================================

class AppColorPalette {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color onBackground;
  final Color onPrimary;

  const AppColorPalette({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.onBackground,
    required this.onPrimary,
  });

  AppColorPalette copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? onBackground,
    Color? onPrimary,
  }) {
    return AppColorPalette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onBackground: onBackground ?? this.onBackground,
      onPrimary: onPrimary ?? this.onPrimary,
    );
  }
}

class AppThemeSetting {
  final AppColorPalette lightPalette;
  final AppColorPalette darkPalette;
  final Map<String, String> languageFonts;
  final String defaultFont;

  const AppThemeSetting({
    required this.lightPalette,
    required this.darkPalette,
    required this.languageFonts,
    this.defaultFont = 'Poppins',
  });

  AppThemeSetting copyWith({
    AppColorPalette? lightPalette,
    AppColorPalette? darkPalette,
    Map<String, String>? languageFonts,
    String? defaultFont,
  }) {
    return AppThemeSetting(
      lightPalette: lightPalette ?? this.lightPalette,
      darkPalette: darkPalette ?? this.darkPalette,
      languageFonts: languageFonts ?? this.languageFonts,
      defaultFont: defaultFont ?? this.defaultFont,
    );
  }
}

class AppThemes {
  static AppThemeSetting professional({
    AppColorPalette? lightPalette,
    AppColorPalette? darkPalette,
    Map<String, String>? languageFonts,
    String? defaultFont,
  }) {
    final base = AppThemeSetting(
      lightPalette: const AppColorPalette(
          primary: Color(0xFF0A2540),
          secondary: Color(0xFF00D4FF),
          background: Color(0xFFF8F9FA),
          surface: Colors.white,
          onBackground: Color(0xFF333333),
          onPrimary: Colors.white),
      darkPalette: const AppColorPalette(
          primary: Color(0xFF4A90E2),
          secondary: Color(0xFF00D4FF),
          background: Color(0xFF1A1A2E),
          surface: Color(0xFF16213E),
          onBackground: Color(0xFFE0E0E0),
          onPrimary: Colors.white),
      languageFonts: {'ar': 'Cairo', 'en': 'Poppins', 'fr': 'Montserrat'},
    );
    return base.copyWith(
        lightPalette: lightPalette,
        darkPalette: darkPalette,
        languageFonts: languageFonts,
        defaultFont: defaultFont);
  }

  static AppThemeSetting vibrant({
    AppColorPalette? lightPalette,
    AppColorPalette? darkPalette,
    Map<String, String>? languageFonts,
    String? defaultFont,
  }) {
    final base = AppThemeSetting(
        lightPalette: const AppColorPalette(
            primary: Color(0xFF6A1B9A),
            secondary: Color(0xFFD81B60),
            background: Color(0xFFF3E5F5),
            surface: Colors.white,
            onBackground: Color(0xFF212121),
            onPrimary: Colors.white),
        darkPalette: const AppColorPalette(
            primary: Color(0xFFCE93D8),
            secondary: Color(0xFFF06292),
            background: Color(0xFF212121),
            surface: Color(0xFF373737),
            onBackground: Color(0xFFF5F5F5),
            onPrimary: Colors.black),
        languageFonts: {'ar': 'Tajawal', 'en': 'Roboto', 'fr': 'Montserrat'},
        defaultFont: 'Roboto');
    return base.copyWith(
        lightPalette: lightPalette,
        darkPalette: darkPalette,
        languageFonts: languageFonts,
        defaultFont: defaultFont);
  }
}

// ===================================================================
// القسم 9: المتحكم المركزي للثيم
// ===================================================================

class AppTheme extends GetxController {
  AppTheme({
    AppThemeSetting? initialSetting,
    ThemeMode initialThemeMode = ThemeMode.light,
  }) {
    _currentThemeSetting = (initialSetting ?? AppThemes.professional()).obs;
    _themeMode = initialThemeMode.obs;
  }

  static AppTheme get to => Get.find();

  late final Rx<AppThemeSetting> _currentThemeSetting;
  AppThemeSetting get currentThemeSetting => _currentThemeSetting.value;

  final Rxn<Color> buttonColorOverride = Rxn<Color>();

  void overrideButtonColor(Color? color) {
    buttonColorOverride.value = color;
    update();
  }

  late final Rx<ThemeMode> _themeMode;
  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  Locale get locale => Get.locale ?? const Locale('en', 'US');

  void updateLocale(Locale newLocale) {
    AppTranslator.instance.changeLocale(newLocale);
    update();
  }

  void toggleTheme() {
    _themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    update();
  }

  ThemeData get lightThemeData => _getTheme(isDarkMode: false);
  ThemeData get darkThemeData => _getTheme(isDarkMode: true);

  ThemeData _getTheme({required bool isDarkMode}) {
    final setting = currentThemeSetting;
    final palette = isDarkMode ? setting.darkPalette : setting.lightPalette;

    final langCode = locale.languageCode;
    final fontFamily = setting.languageFonts[langCode] ?? setting.defaultFont;

    final primaryColor = palette.primary;
    final onPrimaryColor = palette.onPrimary;
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;

    final appBarBackgroundColor = isDarkMode ? palette.surface : primaryColor;
    final appBarBrightness = ThemeData.estimateBrightnessForColor(appBarBackgroundColor);
    final appBarForegroundColor = appBarBrightness == Brightness.dark ? Colors.white : Colors.black;

    Color buttonBackgroundColor;
    Color buttonForegroundColor;

    if (buttonColorOverride.value != null) {
      buttonBackgroundColor = buttonColorOverride.value!;
      buttonForegroundColor = ThemeData.estimateBrightnessForColor(buttonBackgroundColor) == Brightness.dark
          ? Colors.white
          : Colors.black;
    } else {
      buttonBackgroundColor = primaryColor;
      buttonForegroundColor = onPrimaryColor;
    }

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: palette.background,
      fontFamily: fontFamily,
      colorScheme: ColorScheme(
          primary: primaryColor,
          secondary: palette.secondary,
          background: palette.background,
          surface: palette.surface,
          onBackground: palette.onBackground,
          onSurface: palette.onBackground,
          onPrimary: onPrimaryColor,
          onSecondary: Colors.black,
          error: isDarkMode ? const Color(0xFFCF6679) : const Color(0xFFB00020),
          onError: isDarkMode ? Colors.black : Colors.white,
          brightness: brightness),
      textTheme: _textTheme(palette.onBackground, fontFamily),
      appBarTheme: AppBarTheme(
          backgroundColor: appBarBackgroundColor,
          foregroundColor: appBarForegroundColor,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontFamily: fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: appBarForegroundColor)),
      elevatedButtonTheme: _elevatedButtonTheme(buttonBackgroundColor, buttonForegroundColor, fontFamily),
      inputDecorationTheme: _inputDecorationTheme(
          fillColor: palette.surface,
          borderColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
          focusColor: primaryColor,
          labelColor: palette.onBackground.withOpacity(0.7),
          fontFamily: fontFamily),
      cardTheme: _cardTheme(palette.surface),
    );
  }

  static TextTheme _textTheme(Color color, String fontFamily) {
    TextTheme baseTextTheme;
    switch (fontFamily) {
      case 'Cairo': baseTextTheme = GoogleFonts.cairoTextTheme(); break;
      case 'Tajawal': baseTextTheme = GoogleFonts.tajawalTextTheme(); break;
      case 'Lato': baseTextTheme = GoogleFonts.latoTextTheme(); break;
      case 'Roboto': baseTextTheme = GoogleFonts.robotoTextTheme(); break;
      case 'Montserrat': baseTextTheme = GoogleFonts.montserratTextTheme(); break;
      default: baseTextTheme = GoogleFonts.poppinsTextTheme();
    }

    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: color),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 22, fontWeight: FontWeight.w700, color: color),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, color: color),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, color: color.withOpacity(0.8)),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color backgroundColor, Color foregroundColor, String fontFamily) {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.bold)));
  }

  static InputDecorationTheme _inputDecorationTheme(
      {required Color fillColor, required Color borderColor, required Color focusColor, required Color labelColor, required String fontFamily}) {
    return InputDecorationTheme(
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: focusColor, width: 2)),
        labelStyle: TextStyle(fontFamily: fontFamily, color: labelColor));
  }

  static CardTheme _cardTheme(Color cardColor) => CardTheme(
      elevation: 2,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0));
}

// ===================================================================
// القسم 10: التطبيق الرئيسي (نقطة البداية)
// ===================================================================
/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppTranslator.init(
    initialLocale: const Locale('ar', 'SA'),
    specificTranslations: {
      'en_US': {
        'app_title': 'Theme & Translation Demo',
        'error_required': 'This field is required',
        'error_email_format': 'Invalid email format',
        'error_password_length': 'Password must be at least 8 characters',
        'error_password_uppercase': 'Password must contain an uppercase letter',
        'error_password_number': 'Password must contain a number',
        'login_success': 'Login Successful!',
        'select_option': 'Select an option',
        'search': 'Search',
        'cancel': 'Cancel',
        'user_role': 'User Role',
        'admin': 'Admin',
        'editor': 'Editor',
        'viewer': 'Viewer',
        'notification_preference': 'Notification Preference',
        'email_option': 'Email',
        'sms_option': 'SMS',
        'none_option': 'None',
        'hobbies_label': 'Hobbies',
        'reading_option': 'Reading',
        'sports_option': 'Sports',
        'music_option': 'Music',
      },
      'ar_SA': {
        'app_title': 'تجربة الثيم والترجمة',
        'error_required': 'هذا الحقل مطلوب',
        'error_email_format': 'صيغة البريد الإلكتروني غير صحيحة',
        'error_password_length': 'يجب أن تكون كلمة المرور 8 أحرف على الأقل',
        'error_password_uppercase': 'يجب أن تحتوي كلمة المرور على حرف كبير',
        'error_password_number': 'يجب أن تحتوي كلمة المرور على رقم',
        'login_success': 'تم تسجيل الدخول بنجاح!',
        'select_option': 'اختر',
        'search': 'بحث',
        'cancel': 'إلغاء',
        'user_role': 'الدور الوظيفي',
        'admin': 'مدير',
        'editor': 'محرر',
        'viewer': 'مشاهد',
        'notification_preference': 'تفضيلات الإشعارات',
        'email_option': 'البريد الإلكتروني',
        'sms_option': 'رسالة نصية',
        'none_option': 'لا شيء',
        'hobbies_label': 'الهوايات',
        'reading_option': 'القراءة',
        'sports_option': 'الرياضة',
        'music_option': 'الموسيقى',
      },
    },
  );

  Get.put(AppTheme(
      initialSetting: AppThemes.professional(),
      initialThemeMode: ThemeMode.system
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppTheme>(
      builder: (themeController) {
        return Obx(() => GetMaterialApp(
          key: ValueKey(AppTranslator.instance.version.value),
          debugShowCheckedModeBanner: false,
          title: 'app_title'.tr,
          translations: AppTranslator.instance,
          locale: Get.locale,
          fallbackLocale: const Locale('en', 'US'),
          theme: themeController.lightThemeData,
          darkTheme: themeController.darkThemeData,
          themeMode: themeController.themeMode,
          home: const HomeScreen(),
        ));
      },
    );
  }
}
*/
// ===================================================================
// القسم 11: الواجهات (Screens)
// ===================================================================
/*
class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper function to create a page view for the tabs
    Widget buildPage(List<Widget> children) {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: children,
      );
    }

    return AppTab(
      title: 'AppTheme Library Docs',
      style: AppTabStyle.fixedHeader,
      tabs: [
        Tab(text: 'docs_readme'.tr),
        Tab(text: 'docs_example'.tr),
        Tab(text: 'docs_installing'.tr),
      ],
      children: [
        buildPage([
          const DocHeader(title: 'AppTheme & Language Guide'),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              Chip(label: const Text('Version 2.0.0'), backgroundColor: Colors.blue.shade100),
              Chip(label: const Text('Integrated'), backgroundColor: Colors.green.shade100),
              Chip(label: const Text('GetX & Supabase'), backgroundColor: Colors.purple.shade100),
            ],
          ),
          const SizedBox(height: 16),
          const DocParagraph(
            text: 'Welcome to the integrated Theme and Language library guide...',
          ),
          DocSection(title: 'configuration_properties'.tr),
          const PropertiesTable(
            properties: [
              { 'property': 'initialSetting', 'type': 'AppThemeSetting', 'description': 'The complete theme configuration object.'},
              { 'property': 'initialThemeMode', 'type': 'ThemeMode', 'description': 'Sets the starting theme mode (light, dark, or system).'},
            ],
          ),
        ]),
        buildPage([
          const DocHeader(title: 'Usage Examples'),
          const DocSection(title: 'Method 1: Default Theme'),
          const CodeBlock(code: "Get.put(AppTheme());"),
          const DocSection(title: 'Method 2: Select a Pre-built Theme'),
          const CodeBlock(code: "Get.put(AppTheme(initialSetting: AppThemes.vibrant()));"),
        ]),
        buildPage([
          const DocHeader(title: 'Installing'),
          const DocParagraph(text: 'Add dependencies to your `pubspec.yaml` file:'),
          const CodeBlock(code: """
dependencies:
  get: ^4.6.6
  google_fonts: ^6.2.1
  supabase_flutter: ^2.5.0
"""),
        ]),
      ],
    );
  }
}

class TranslationLookupScreen extends StatefulWidget {
  const TranslationLookupScreen({Key? key}) : super(key: key);

  @override
  State<TranslationLookupScreen> createState() => _TranslationLookupScreenState();
}

class _TranslationLookupScreenState extends State<TranslationLookupScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _results = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTranslations);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTranslations);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTranslations() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final allTranslations = AppTranslator.instance.translations;
    final Set<String> foundKeys = {};

    allTranslations.forEach((langCode, translationsMap) {
      translationsMap.forEach((key, value) {
        if (key.toLowerCase().contains(query) || value.toLowerCase().contains(query)) {
          foundKeys.add(key);
        }
      });
    });

    final List<Map<String, String>> searchResults = [];
    for (var key in foundKeys) {
      final resultItem = <String, String>{'key': key};
      allTranslations.forEach((langCode, translationsMap) {
        resultItem[langCode] = translationsMap[key] ?? 'N/A';
      });
      searchResults.add(resultItem);
    }

    setState(() => _results = searchResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Translation Key Lookup"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search across all languages...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? Center(
              child: Text(_searchController.text.isEmpty
                  ? "Start typing to search..."
                  : "No results found."),
            )
                : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                final key = item['key']!;
                final languages = Map<String, String>.from(item)..remove('key');

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Key: $key", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.primary)),
                        const Divider(),
                        ...languages.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text("${entry.key}: ${entry.value}"),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/
// ===================================================================
// القسم 12: الويدجتات المساعدة (Helper Widgets)
// ===================================================================

class DocHeader extends StatelessWidget {
  final String title;
  const DocHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class DocSection extends StatelessWidget {
  final String title;
  const DocSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class DocParagraph extends StatelessWidget {
  final String text;
  const DocParagraph({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
      ),
    );
  }
}

class CodeBlock extends StatelessWidget {
  final String code;
  const CodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2B2B) : Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dart',
                  style: GoogleFonts.sourceCodePro(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_all_outlined, size: 20),
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                  tooltip: 'Copy Code',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code.trim()));
                    Get.snackbar(
                      'copied_to_clipboard'.tr, '',
                      titleText: Text('copied_to_clipboard'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      messageText: const SizedBox.shrink(),
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green.withOpacity(0.9),
                      margin: const EdgeInsets.all(12),
                      borderRadius: 8,
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                code.trim(),
                style: GoogleFonts.sourceCodePro(
                  color: isDark ? Colors.lightBlue[200] : Colors.deepPurple,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PropertiesTable extends StatelessWidget {
  final List<Map<String, String>> properties;
  const PropertiesTable({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    final cellStyle = Theme.of(context).textTheme.bodyMedium!;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade400;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(flex: 1.5),
          1: IntrinsicColumnWidth(flex: 1),
          2: FlexColumnWidth(2.5),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: borderColor, width: 1),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
            ),
            children: [
              Padding(padding: const EdgeInsets.all(12.0), child: Text('Property', style: headerStyle)),
              Padding(padding: const EdgeInsets.all(12.0), child: Text('Type', style: headerStyle)),
              Padding(padding: const EdgeInsets.all(12.0), child: Text('Description', style: headerStyle)),
            ],
          ),
          ...properties.map((prop) {
            return TableRow(
                children: [
                  Padding(padding: const EdgeInsets.all(12.0), child: Text(prop['property']!, style: GoogleFonts.sourceCodePro())),
                  Padding(padding: const EdgeInsets.all(12.0), child: Text(prop['type']!, style: cellStyle.copyWith(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500))),
                  Padding(padding: const EdgeInsets.all(12.0), child: Text(prop['description']!, style: cellStyle)),
                ]
            );
          }).toList(),
        ],
      ),
    );
  }
}

class AppColorSwatch extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const AppColorSwatch({super.key, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
      ),
    );
  }
}

