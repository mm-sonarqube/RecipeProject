import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class GetThemeMode {
  final SettingsRepository repository;

  const GetThemeMode(this.repository);

  Future<ThemeMode> call() async {
    return await repository.getThemeMode();
  }
}
