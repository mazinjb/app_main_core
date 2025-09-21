import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  final double thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const AppDivider({
    Key? key,
    this.thickness = 1,
    this.color,
    this.indent,
    this.endIndent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      // ✅ التعديل هنا: استخدام لون الفاصل من الثيم الحالي كقيمة افتراضية
      color: color ?? Theme.of(context).dividerColor,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
