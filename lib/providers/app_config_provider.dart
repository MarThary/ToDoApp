import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigProvider extends ChangeNotifier {
  String appLanguage = 'en';
  ThemeMode appMode = ThemeMode.light;

  AppConfigProvider() {
    _loadPreferences();
  }

  void changeLanguage(String language) async {
    appLanguage = language;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('appLanguage', language); // Save language preference
  }

  void changeTheme(ThemeMode theme) async {
    appMode = theme;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('appMode',
        theme == ThemeMode.dark ? 'dark' : 'light'); // Save theme preference
  }

  bool isDarkMode() {
    return appMode == ThemeMode.dark;
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    appLanguage = prefs.getString('appLanguage') ?? 'en';
    appMode = (prefs.getString('appMode') == 'dark')
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
