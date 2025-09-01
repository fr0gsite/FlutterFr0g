import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

/// Manages the current [ThemeMode] of the application.
///
/// The value is persisted using [SharedPreferences] so the chosen theme
/// survives app restarts.
class ThemeStatus extends ChangeNotifier {
  static const _storageKey = 'isDarkMode';

  ThemeMode _themeMode = ThemeMode.dark;

  ThemeStatus() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    AppColor.updateTheme(isDark);
    _saveTheme(isDark);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_storageKey) ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    AppColor.updateTheme(isDark);
    notifyListeners();
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, isDark);
  }
}

