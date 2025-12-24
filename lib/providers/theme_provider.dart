// providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  late Box _settingsBox;
  bool _isDarkMode = true;
  bool _isLoading = true;

  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      _settingsBox = Hive.box('settings');
      _isDarkMode = _settingsBox.get('isDarkMode', defaultValue: true);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _settingsBox.put('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}