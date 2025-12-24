import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LocaleService {
  static const String _boxName = 'settings';
  static const String _localeKey = 'app_locale';
  static const String _defaultLocale = 'vi';
  
  // Các ngôn ngữ được hỗ trợ
  static const List<String> supportedLanguages = ['vi', 'en'];

  // Get settings box
  static Box get _box => Hive.box(_boxName);

  // Lưu locale
  static Future<bool> saveLocale(String languageCode) async {
    try {
      if (!supportedLanguages.contains(languageCode)) {
        debugPrint('Unsupported language: $languageCode');
        return false;
      }
      
      await _box.put(_localeKey, languageCode);
      return true;
    } catch (e) {
      debugPrint('Error saving locale: $e');
      return false;
    }
  }

  // Load locale dưới dạng String
  static String loadLocaleString() {
    try {
      final locale = _box.get(_localeKey, defaultValue: _defaultLocale);
      
      // Validate locale
      if (!supportedLanguages.contains(locale)) {
        return _defaultLocale;
      }
      
      return locale as String;
    } catch (e) {
      debugPrint('Error loading locale: $e');
      return _defaultLocale;
    }
  }

  // Load locale dưới dạng Locale object
  static Locale loadLocale() {
    final languageCode = loadLocaleString();
    return Locale(languageCode);
  }

  // Clear locale (về mặc định)
  static Future<bool> clearLocale() async {
    try {
      await _box.delete(_localeKey);
      return true;
    } catch (e) {
      debugPrint('Error clearing locale: $e');
      return false;
    }
  }

  // Kiểm tra xem có locale đã lưu chưa
  static bool hasStoredLocale() {
    try {
      return _box.containsKey(_localeKey);
    } catch (e) {
      debugPrint('Error checking stored locale: $e');
      return false;
    }
  }

  // Get current locale (synchronous)
  static String getCurrentLocale() {
    return loadLocaleString();
  }

  // Check if a language is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLanguages.contains(languageCode);
  }

  // Get all supported languages with display names
  static Map<String, String> getSupportedLanguagesMap() {
    return {
      'vi': 'Tiếng Việt',
      'en': 'English',
    };
  }
}