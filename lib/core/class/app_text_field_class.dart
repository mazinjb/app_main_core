import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


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
    super.key,
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
  });

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
  static String? required(dynamic value) {
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
    super.key,
    required this.textFields,
    required this.builder,
    required this.onSubmit,
  });

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