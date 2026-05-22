import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _accentColorKey = 'accent_color';
  static const String _localeKey = 'locale_code';
  late final SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Color _accentColor = const Color.fromARGB(255, 36, 175, 177);
  Color get accentColor => _accentColor;

  String? _localeCode;
  String? get localeCode => _localeCode;
  Locale? get locale => _localeCode == null ? null : Locale(_localeCode!);

  bool get isDarkMode {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final themeString = _prefs.getString(_themeKey);
    if (themeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeMode.system,
      );
    } else {
      _themeMode = ThemeMode.system;
    }

    final accentColorInt = _prefs.getInt(_accentColorKey);
    if (accentColorInt != null) {
      _accentColor = Color(accentColorInt);
    }

    _localeCode = _prefs.getString(_localeKey);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setString(_themeKey, mode.toString());
    notifyListeners();
  }

  Future<void> setAccentColor(Color color) async {
    if (_accentColor == color) return;
    _accentColor = color;
    await _prefs.setInt(_accentColorKey, color.value);
    notifyListeners();
  }

  Future<void> setLocaleCode(String? localeCode) async {
    if (_localeCode == localeCode) return;
    _localeCode = localeCode;
    if (localeCode == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, localeCode);
    }
    notifyListeners();
  }
}
