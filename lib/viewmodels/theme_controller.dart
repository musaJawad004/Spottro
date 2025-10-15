import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(themeMode);
  }

  void setDarkMode(bool value) {
    _isDarkMode.value = value;
    Get.changeThemeMode(themeMode);
  }
}
