import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// أنواع رسائل الـ Snackbar المتاحة.
enum AppSnackbarType {
  success,
  error,
  info, // يمكن إضافة أنواع أخرى مستقبلاً
}

class AppSnackbar {
  /// يعرض رسالة Snackbar بتصميم متوافق مع الثيم.
  static void show({
    required BuildContext context,
    required String messageKey,
    String? titleKey,
    AppSnackbarType type = AppSnackbarType.info,
  }) {
    final theme = Theme.of(context);

    // تحديد لون الخلفية بناءً على نوع الرسالة والثيم الحالي
    Color backgroundColor;
    switch (type) {
      case AppSnackbarType.success:
        backgroundColor = Colors.green.shade600; // يمكن تخصيص هذا اللون في الثيم لاحقًا
        break;
      case AppSnackbarType.error:
        backgroundColor = theme.colorScheme.error;
        break;
      case AppSnackbarType.info:
      default:
        backgroundColor = theme.colorScheme.secondary;
        break;
    }

    // تحديد لون النص تلقائيًا لضمان الوضوح
    final textColor = ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
        ? Colors.white
        : Colors.black;

    // تحديد لون أيقونة الإغلاق
    final iconColor = textColor.withOpacity(0.8);

    Get.snackbar(
      titleKey?.tr ?? _getDefaultTitle(type).tr,
      messageKey.tr,
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Icon(Icons.close, color: iconColor),
      ),
    );
  }

  /// دالة مساعدة لجلب عنوان افتراضي بناءً على النوع
  static String _getDefaultTitle(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return 'snackbar_success_title'; // يجب إضافة هذه المفاتيح للترجمة
      case AppSnackbarType.error:
        return 'snackbar_error_title';
      case AppSnackbarType.info:
      default:
        return 'snackbar_info_title';
    }
  }
}
/*
```

**كيف تستخدمه الآن؟**
1.  أضف مفاتيح الترجمة الجديدة (`snackbar_success_title`, `snackbar_error_title`, `snackbar_info_title`) إلى ملف `main.dart`.
2.  يمكنك استدعاؤه هكذا:
```dart
// رسالة نجاح
AppSnackbar.show(
context: context,
messageKey: 'profile_saved_successfully',
type: AppSnackbarType.success,
);

// رسالة خطأ
AppSnackbar.show(
context: context,
messageKey: 'network_error_message',
type: AppSnackbarType.error,
);
    */
