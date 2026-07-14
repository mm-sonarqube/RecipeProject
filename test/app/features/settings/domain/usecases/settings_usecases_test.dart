import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/settings/domain/repositories/settings_repository.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/get_about_you.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/save_about_you.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/set_theme_mode.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
  });

  group('GetThemeMode', () {
    test('should call getThemeMode on repository and return ThemeMode', () async {
      when(() => mockRepository.getThemeMode()).thenAnswer((_) async => ThemeMode.dark);
      final useCase = GetThemeMode(mockRepository);
      final result = await useCase();
      expect(result, equals(ThemeMode.dark));
      verify(() => mockRepository.getThemeMode()).called(1);
    });
  });

  group('SetThemeMode', () {
    test('should call setThemeMode on repository with the given ThemeMode', () async {
      when(() => mockRepository.setThemeMode(ThemeMode.light)).thenAnswer((_) async {});
      final useCase = SetThemeMode(mockRepository);
      await useCase(ThemeMode.light);
      verify(() => mockRepository.setThemeMode(ThemeMode.light)).called(1);
    });
  });

  group('GetAboutYou', () {
    test('should call getAboutYou on repository and return bio string', () async {
      when(() => mockRepository.getAboutYou()).thenAnswer((_) async => 'Chef bio');
      final useCase = GetAboutYou(mockRepository);
      final result = await useCase();
      expect(result, equals('Chef bio'));
      verify(() => mockRepository.getAboutYou()).called(1);
    });
  });

  group('SaveAboutYou', () {
    test('should call saveAboutYou on repository with the given bio', () async {
      when(() => mockRepository.saveAboutYou(any())).thenAnswer((_) async {});
      final useCase = SaveAboutYou(mockRepository);
      await useCase('Updated bio');
      verify(() => mockRepository.saveAboutYou('Updated bio')).called(1);
    });
  });
}
