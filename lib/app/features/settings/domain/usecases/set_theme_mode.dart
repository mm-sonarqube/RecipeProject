import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class SetThemeMode {
  final SettingsRepository repository;

  const SetThemeMode(this.repository);

  Future<void> call(ThemeMode themeMode) async {
    await repository.setThemeMode(themeMode);
  }
}
