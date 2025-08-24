import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _key = "isDarkMode";
  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  ThemeMode getThemeMode() {
    bool isDark = _prefs?.getBool(_key) ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void saveThemeMode(bool isDark) {
    _prefs?.setBool(_key, isDark);
  }

  void switchTheme() {
    bool isDark = getThemeMode() == ThemeMode.dark;
    saveThemeMode(!isDark);
  }
}
