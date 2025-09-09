import 'package:flutter/material.dart';
import 'package:get/get.dart';


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
