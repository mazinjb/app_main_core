import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../all_core.dart';




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