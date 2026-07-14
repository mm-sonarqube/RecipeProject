import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unit_testing/app/features/settings/data/datasources/settings_local_data_source.dart';

void main() {
  late SettingsLocalDataSourceImpl dataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    dataSource = SettingsLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  });

  group('getThemeMode', () {
    test('should return ThemeMode.system when no value is stored', () async {
      final result = await dataSource.getThemeMode();
      expect(result, equals(ThemeMode.system));
    });

    test('should return ThemeMode.dark when dark index (2) is stored', () async {
      await sharedPreferences.setInt('THEME_MODE', ThemeMode.dark.index);
      final result = await dataSource.getThemeMode();
      expect(result, equals(ThemeMode.dark));
    });

    test('should return ThemeMode.light when light index (1) is stored', () async {
      await sharedPreferences.setInt('THEME_MODE', ThemeMode.light.index);
      final result = await dataSource.getThemeMode();
      expect(result, equals(ThemeMode.light));
    });

    test('should return ThemeMode.system for an invalid/out-of-range index', () async {
      await sharedPreferences.setInt('THEME_MODE', 99);
      final result = await dataSource.getThemeMode();
      expect(result, equals(ThemeMode.system));
    });
  });

  group('setThemeMode', () {
    test('should persist the ThemeMode.dark index to SharedPreferences', () async {
      await dataSource.setThemeMode(ThemeMode.dark);
      expect(sharedPreferences.getInt('THEME_MODE'), equals(ThemeMode.dark.index));
    });

    test('should persist the ThemeMode.light index to SharedPreferences', () async {
      await dataSource.setThemeMode(ThemeMode.light);
      expect(sharedPreferences.getInt('THEME_MODE'), equals(ThemeMode.light.index));
    });
  });

  group('getAboutYou', () {
    test('should return an empty string when no bio is stored', () async {
      final result = await dataSource.getAboutYou();
      expect(result, equals(''));
    });

    test('should return the stored bio string', () async {
      await sharedPreferences.setString('ABOUT_YOU', 'I love cooking pasta!');
      final result = await dataSource.getAboutYou();
      expect(result, equals('I love cooking pasta!'));
    });
  });

  group('saveAboutYou', () {
    test('should persist the bio string to SharedPreferences', () async {
      await dataSource.saveAboutYou('Proud home chef since 2015.');
      expect(
        sharedPreferences.getString('ABOUT_YOU'),
        equals('Proud home chef since 2015.'),
      );
    });
  });
}

// Required to satisfy mocktail setup even though this test file doesn't use mocks
class _Unused extends Mock {}
