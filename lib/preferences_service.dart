import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String themeKey = 'theme';
  static const String languageKey = 'language';

  Future<void> saveTheme(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDark);
  }

  Future<void> saveLanguage(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, languageCode);
  }

  Future<bool?> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool(themeKey) ?? false;
    return null;
  }

  Future<String?> loadLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(languageKey) ?? 'en';
    return null;
  }
}
