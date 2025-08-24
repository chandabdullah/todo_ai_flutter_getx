import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/theme_service.dart';

class SettingsController extends GetxController {
  final ThemeService _themeService = ThemeService();
  bool isDarkMode = false;

  @override
  void onInit() {
    super.onInit();
    isDarkMode = _themeService.getThemeMode() == ThemeMode.dark;
  }

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    _themeService.saveThemeMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    update();
  }
}
