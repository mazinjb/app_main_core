import 'package:flutter/material.dart';
import 'package:get/get.dart';


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