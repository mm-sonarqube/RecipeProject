import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<String> getAboutYou();
  Future<void> saveAboutYou(String aboutYou);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _themeModeKey = 'THEME_MODE';
  static const String _aboutYouKey = 'ABOUT_YOU';

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ThemeMode> getThemeMode() async {
    final index = sharedPreferences.getInt(_themeModeKey);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.system;
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await sharedPreferences.setInt(_themeModeKey, themeMode.index);
  }

  @override
  Future<String> getAboutYou() async {
    return sharedPreferences.getString(_aboutYouKey) ?? '';
  }

  @override
  Future<void> saveAboutYou(String aboutYou) async {
    await sharedPreferences.setString(_aboutYouKey, aboutYou);
  }
}
