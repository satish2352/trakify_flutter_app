import 'package:flutter/material.dart';

enum ThemeModeType { light, dark, system }
class ThemeProvider extends ChangeNotifier {
  ThemeModeType _themeMode = ThemeModeType.system;
  ThemeModeType get themeMode => _themeMode;

  ThemeMode getCurrentTheme() {
    if (_themeMode == ThemeModeType.system) {
      return ThemeMode.system;
    } else {
      return _themeMode == ThemeModeType.light ? ThemeMode.light : ThemeMode.dark;
    }
  }

  void setThemeMode(ThemeModeType mode) {
    _themeMode = mode;
    notifyListeners();
  }
}