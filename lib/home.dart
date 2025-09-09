import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'all_screens.dart';
import 'core/app_core.dart';


// ===================================================================
// الواجهة الرئيسية (مفصولة في ملف خاص)
// ===================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey<AppFormState>();
  String? _selectedRole;
  String? _selectedNotificationPreference;
  List<String> _selectedHobbies = [];

  @override
  Widget build(BuildContext context) {
    final controller = AppTheme.to;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
        actions: [
          IconButton(
            tooltip: 'theme_switcher_tooltip'.tr,
            icon: Icon(controller.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round),
            onPressed: () => controller.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('welcome_message'.tr, style: textTheme.displayLarge, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('card_example_title'.tr, style: textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text('card_example_content'.tr, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              AppForm(
                key: formKey,
                textFields: const ['username', 'password'],
                onSubmit: (data) {
                  Get.snackbar('login_success'.tr, 'Username: ${data['username']}');
                },
                builder: (controllers) {
                  return Column(
                    children: [
                      AppTextField(
                        controller: controllers['username'],
                        labelText: 'username_label'.tr,
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: AppValidators.required,
                        theme: const AppTextFieldThemeSettings(type: AppTextFieldTheme.outlined),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: controllers['password'],
                        labelText: 'password_label'.tr,
                        prefixIcon: const Icon(Icons.lock_outline),
                        isPassword: true,
                        validator: AppValidators.compose([
                          AppValidators.required,
                          AppValidators.password,
                        ]),
                        theme: const AppTextFieldThemeSettings(type: AppTextFieldTheme.outlined),
                        onFieldSubmitted: (_) => formKey.currentState?.submit(),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              AppDropdown(
                labelText: 'user_role'.tr,
                options: const ['admin', 'editor', 'viewer'],
                value: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                style: const AppDropdownStyle(type: AppDropdownType.searchable),
                isRequired: true,
              ),
              const SizedBox(height: 16),
              AppRadioButton(
                labelText: 'notification_preference'.tr,
                options: const ['email_option', 'sms_option', 'none_option'],
                value: _selectedNotificationPreference,
                onChanged: (newValue) {
                  setState(() {
                    _selectedNotificationPreference = newValue;
                  });
                },
                style: const AppRadioButtonStyle(type: AppRadioButtonType.secondary),
                isRequired: true,
              ),
              const SizedBox(height: 16),
              AppCheckBox(
                labelText: 'hobbies_label'.tr,
                options: const ['reading_option', 'sports_option', 'music_option'],
                selectedValues: _selectedHobbies,
                onChanged: (values) {
                  setState(() {
                    _selectedHobbies = values;
                  });
                },
                style: AppCheckBoxStyle.fromType(AppCheckBoxType.horizontal, context),
              ),

              const SizedBox(height: 32),

              AppButton(
                onPressed: () => formKey.currentState?.submit(),
                text: 'login_button'.tr,
                style: AppButtonStyle.primary(context),
              ),

              const SizedBox(height: 24),

              const Divider(),
              const SizedBox(height: 16),
              Text('language'.tr, style: textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  AppButton(
                    onPressed: () => controller.updateLocale(const Locale('en', 'US')),
                    text: 'English',
                    style: AppButtonStyle.secondary(context),
                    type: AppButtonType.outlined,
                  ),
                  AppButton(
                    onPressed: () => controller.updateLocale(const Locale('ar', 'SA')),
                    text: 'العربية',
                    style: AppButtonStyle.secondary(context),
                    type: AppButtonType.outlined,
                  ),
                  AppButton(
                    onPressed: () => controller.updateLocale(const Locale('fr', 'FR')),
                    text: 'Français',
                    style: AppButtonStyle.secondary(context),
                    type: AppButtonType.outlined,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              Text('customize_button_color'.tr, style: textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16.0,
                children: [

                  AppColorSwatch(color: Colors.red, onTap: () => controller.overrideButtonColor(Colors.red)),
                  AppColorSwatch(color: Colors.green, onTap: () => controller.overrideButtonColor(Colors.green)),
                  AppColorSwatch(color: Colors.blue, onTap: () => controller.overrideButtonColor(Colors.blue)),
                  AppButton(

                    onPressed: () => controller.overrideButtonColor(null),
                    text: 'reset_color'.tr,
                    type: AppButtonType.text,
                    style: AppButtonStyle(textColor: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              AppButton(
                icon: Icons.menu_book_outlined,
                text: 'view_documentation'.tr,
                onPressed: () => Get.to(() => const DocumentationScreen()),
                style: AppButtonStyle.primary(context),
              ),
              const SizedBox(height: 12),
              AppButton(
                icon: Icons.search,
                text: "Lookup Translation Key",
                style: AppButtonStyle.primary(context).copyWith(
                  buttonColor: Theme.of(context).colorScheme.secondary,
                  textColor: ThemeData.estimateBrightnessForColor(Theme.of(context).colorScheme.secondary) == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () => Get.to(() => const TranslationLookupScreen()),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        final fabBackgroundColor =
            controller.buttonColorOverride.value ?? Theme.of(context).colorScheme.secondary;

        final fabIconColor =
        ThemeData.estimateBrightnessForColor(fabBackgroundColor) == Brightness.dark ? Colors.white : Colors.black;

        return FloatingActionButton(
          onPressed: () {},
          backgroundColor: fabBackgroundColor,
          child: Icon(Icons.add, color: fabIconColor),
        );
      }),
    );
  }
}
