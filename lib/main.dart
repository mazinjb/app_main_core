
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/app_core.dart';
import 'home.dart';

// ===================================================================
// القسم 10: التطبيق الرئيسي (نقطة البداية)
// ===================================================================

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