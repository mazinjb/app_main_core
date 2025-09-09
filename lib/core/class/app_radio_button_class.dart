import 'package:flutter/material.dart';
import 'package:get/get.dart';



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