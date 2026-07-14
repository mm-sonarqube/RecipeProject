import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<String> getAboutYou();
  Future<void> saveAboutYou(String aboutYou);
}
