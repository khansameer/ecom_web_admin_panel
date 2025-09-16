import 'package:flutter/material.dart';

import '../core/hive/theme_cache.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() {
    _isDark = !_isDark;
    ThemeCache.saveTheme(_isDark);
    notifyListeners();
  }

  void _loadTheme() async {
    _isDark = await ThemeCache.getTheme();
    notifyListeners();
  }


  bool _isNotification = false;

  bool get isNotification => _isNotification;
  void setNotification() {
    _isNotification = !_isNotification;

    notifyListeners();
  }

}