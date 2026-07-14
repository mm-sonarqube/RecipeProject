import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:unit_testing/app/features/settings/data/repositories/settings_repository_impl.dart';

class MockSettingsLocalDataSource extends Mock implements SettingsLocalDataSource {}

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(localDataSource: mockDataSource);
  });

  group('getThemeMode', () {
    test('should delegate to localDataSource.getThemeMode()', () async {
      when(() => mockDataSource.getThemeMode()).thenAnswer((_) async => ThemeMode.dark);
      final result = await repository.getThemeMode();
      expect(result, equals(ThemeMode.dark));
      verify(() => mockDataSource.getThemeMode()).called(1);
    });
  });

  group('setThemeMode', () {
    test('should delegate to localDataSource.setThemeMode()', () async {
      when(() => mockDataSource.setThemeMode(ThemeMode.light)).thenAnswer((_) async {});
      await repository.setThemeMode(ThemeMode.light);
      verify(() => mockDataSource.setThemeMode(ThemeMode.light)).called(1);
    });
  });

  group('getAboutYou', () {
    test('should delegate to localDataSource.getAboutYou()', () async {
      when(() => mockDataSource.getAboutYou()).thenAnswer((_) async => 'My chef bio');
      final result = await repository.getAboutYou();
      expect(result, equals('My chef bio'));
      verify(() => mockDataSource.getAboutYou()).called(1);
    });
  });

  group('saveAboutYou', () {
    test('should delegate to localDataSource.saveAboutYou()', () async {
      when(() => mockDataSource.saveAboutYou(any())).thenAnswer((_) async {});
      await repository.saveAboutYou('Updated bio');
      verify(() => mockDataSource.saveAboutYou('Updated bio')).called(1);
    });
  });
}
