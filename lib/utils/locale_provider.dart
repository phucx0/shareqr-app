import 'package:flutter/material.dart';
import 'package:quick_app/services/locale_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi');
  bool _isLoading = true;

  Locale get locale => _locale;
  bool get isLoading => _isLoading;

  LocaleProvider() {
    _loadLocale();
  }

  // Load locale khi khởi tạo
  Future<void> _loadLocale() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedLocale = await LocaleService.loadLocale();
      _locale = savedLocale;
    } catch (e) {
      print('Error loading locale: $e');
      _locale = const Locale('vi'); // Fallback
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Đổi ngôn ngữ
  Future<void> setLocale(Locale newLocale) async {
    if (!LocaleService.supportedLanguages.contains(newLocale.languageCode)) {
      print('Unsupported language: ${newLocale.languageCode}');
      return;
    }

    // Update UI ngay lập tức
    _locale = newLocale;
    notifyListeners();

    // Lưu vào storage
    await LocaleService.saveLocale(newLocale.languageCode);
  }

  // Đổi ngôn ngữ bằng language code
  Future<void> setLocaleFromCode(String languageCode) async {
    await setLocale(Locale(languageCode));
  }

  // Reset về mặc định
  Future<void> resetToDefault() async {
    await LocaleService.clearLocale();
    _locale = const Locale('vi');
    notifyListeners();
  }
}