import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// ===================================================================
// القسم 7: نظام الترجمة الديناميكي
// ===================================================================

class AppTranslator {
  static _AppTranslatorService get instance => Get.find<_AppTranslatorService>();

  static Future<void> init({
    String? supabaseUrl,
    String? supabaseAnonKey,
    required Locale initialLocale,
    Map<String, Map<String, String>>? specificTranslations,
  }) async {
    await Supabase.initialize(
      url: supabaseUrl ?? _AppTranslatorService._defaultSupabaseUrl,
      anonKey: supabaseAnonKey ?? _AppTranslatorService._defaultSupabaseAnonKey,
    );
    await Get.putAsync(() => _AppTranslatorService()._init(specificTranslations));
    instance.changeLocale(initialLocale);
  }
}

class _AppTranslatorService extends GetxService implements Translations {
  static const String _defaultSupabaseUrl = 'https://pfaijxjdlhnbsbruyidc.supabase.co';
  static const String _defaultSupabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmYWlqeGpkbGhuYnNicnV5aWRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcwNjQ4NDksImV4cCI6MjA3MjY0MDg0OX0.taU5H_DbwD9BJOs3kNDMUBXtd462gBpyVc6L01R1qDU';

  final supabase = Supabase.instance.client;
  final version = 0.obs;
  final translations = <String, Map<String, String>>{}.obs;

  @override
  Map<String, Map<String, String>> get keys => translations;

  Future<_AppTranslatorService> _init(Map<String, Map<String, String>>? specificTranslations) async {
    await _initialFetch(specificTranslations);
    return this;
  }

  void changeLocale(Locale locale) {
    if (Get.locale != locale) {
      Get.updateLocale(locale);
      version.value++;
    }
  }

  Future<void> _initialFetch(Map<String, Map<String, String>>? specificTranslations) async {
    try {
      final data = await supabase.from('translations').select();
      _processData(data, specificTranslations);
    } catch (e) {
      print("Error fetching translations: $e");
      translations.value = specificTranslations ?? {};
      version.value++;
    }
  }

  void _processData(List<Map<String, dynamic>> data, Map<String, Map<String, String>>? specificTranslations) {
    if (data.isEmpty) {
      translations.value = specificTranslations ?? {};
      version.value++;
      return;
    }
    final Map<String, Map<String, String>> supabaseTranslations = {};
    const ignoredColumns = {'id', 'created_at', 'key'};
    for (var row in data) {
      final currentKey = row['key'] as String;
      row.forEach((columnName, value) {
        if (!ignoredColumns.contains(columnName)) {
          supabaseTranslations.putIfAbsent(columnName, () => {});
          supabaseTranslations[columnName]![currentKey] = value?.toString() ?? '';
        }
      });
    }
    if (specificTranslations != null) {
      specificTranslations.forEach((langCode, translationsMap) {
        supabaseTranslations.putIfAbsent(langCode, () => {});
        supabaseTranslations[langCode]!.addAll(translationsMap);
      });
    }
    final Map<String, Map<String, String>> finalTranslations = {};
    final englishTranslations = supabaseTranslations['en_US'] ?? {};
    supabaseTranslations.forEach((langCode, translationsMap) {
      if (langCode == 'en_US') {
        finalTranslations[langCode] = Map.from(englishTranslations);
        return;
      }
      final currentLangMap = <String, String>{};
      englishTranslations.forEach((key, englishValue) {
        final translatedValue = translationsMap[key];
        currentLangMap[key] = (translatedValue != null && translatedValue.isNotEmpty)
            ? translatedValue
            : englishValue;
      });
      finalTranslations[langCode] = currentLangMap;
    });
    translations.value = finalTranslations;
    version.value++;
  }
}
