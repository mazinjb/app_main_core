
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../all_core.dart';


// ===================================================================
// القسم 1: كلاس النمط (Style Class)
// ===================================================================

/// كلاس لتغليف خصائص التصميم القابلة للتخصيص للحوار.
class AppDialogStyle {
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Color? backgroundColor;
  final double? borderRadius;
  // يمكن إضافة المزيد من الخصائص هنا مستقبلاً

  const AppDialogStyle({
    this.titleStyle,
    this.contentStyle,
    this.backgroundColor,
    this.borderRadius,
  });
}

// ===================================================================
// القسم 2: الويدجت الرئيسي (AppDialog)
// ===================================================================

class AppDialog {
  /// يعرض حوار تأكيد قياسي.
  static void confirm({
    required BuildContext context, // مطلوب للوصول إلى الثيم
    required String titleKey,
    required String contentKey,
    required VoidCallback onConfirm,
    String confirmTextKey = 'dialog_confirm', // مفاتيح ترجمة افتراضية
    String cancelTextKey = 'dialog_cancel',
    AppDialogStyle? style,
    bool isDestructive = false, // لتحديد ما إذا كان الإجراء "حذف" مثلاً
  }) {
    final theme = Theme.of(context);

    // إعدادات النمط الافتراضية من الثيم
    final effectiveStyle = AppDialogStyle(
      titleStyle: style?.titleStyle ?? theme.textTheme.headlineSmall,
      contentStyle: style?.contentStyle ?? theme.textTheme.bodyMedium,
      backgroundColor: style?.backgroundColor ?? theme.dialogTheme.backgroundColor ?? theme.cardColor,
      borderRadius: style?.borderRadius ?? 16.0,
    );

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(effectiveStyle.borderRadius!),
        ),
        backgroundColor: effectiveStyle.backgroundColor,
        title: Text(titleKey.tr, style: effectiveStyle.titleStyle),
        content: Text(contentKey.tr, style: effectiveStyle.contentStyle),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          // زر الإلغاء
          AppButton(
            text: cancelTextKey.tr,
            type: AppButtonType.text,
            style: AppButtonStyle(textColor: theme.colorScheme.onBackground.withOpacity(0.7)),
            onPressed: () {
              Get.back();
            },
          ),

          // زر التأكيد
          AppButton(
            text: confirmTextKey.tr,
            // استخدام نمط الحذف إذا كان الإجراء خطيرًا
            style: isDestructive
                ? AppButtonStyle.destructive(context)
                : AppButtonStyle.primary(context),
            onPressed: () {
              Get.back(); // إغلاق الحوار أولاً
              onConfirm(); // ثم تنفيذ الإجراء
            },
          ),
        ],
      ),
      barrierDismissible: false, // منع الإغلاق بالضغط خارج الحوار
    );
  }
}
/*
```

**كيف تستخدمه الآن؟**
ستحتاج إلى إضافة مفاتيح الترجمة الجديدة (`dialog_confirm`, `dialog_cancel`)، ثم يمكنك استدعاؤه هكذا:

```dart
// مثال على حوار عادي
AppDialog.confirm(
context: context,
titleKey: 'logout_title',
contentKey: 'logout_confirmation',
onConfirm: () {
// ... تنفيذ الخروج
},
);

// مثال على حوار "حذف" خطير
AppDialog.confirm(
context: context,
titleKey: 'delete_title',
contentKey: 'delete_confirmation',
onConfirm: () {
// ... تنفيذ الحذف
},
isDestructive: true,
);
*/