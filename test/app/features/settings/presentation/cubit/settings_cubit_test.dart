import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/get_about_you.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/save_about_you.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/set_theme_mode.dart';
import 'package:unit_testing/app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:unit_testing/app/features/settings/presentation/cubit/settings_state.dart';

class MockGetThemeMode extends Mock implements GetThemeMode {}
class MockSetThemeMode extends Mock implements SetThemeMode {}
class MockGetAboutYou extends Mock implements GetAboutYou {}
class MockSaveAboutYou extends Mock implements SaveAboutYou {}

void main() {
  late SettingsCubit cubit;
  late MockGetThemeMode mockGetThemeMode;
  late MockSetThemeMode mockSetThemeMode;
  late MockGetAboutYou mockGetAboutYou;
  late MockSaveAboutYou mockSaveAboutYou;

  setUpAll(() {
    // ThemeMode is a non-nullable enum — register a fallback value for mocktail's `any()` matcher.
    registerFallbackValue(ThemeMode.system);
  });

  setUp(() {
    mockGetThemeMode = MockGetThemeMode();
    mockSetThemeMode = MockSetThemeMode();
    mockGetAboutYou = MockGetAboutYou();
    mockSaveAboutYou = MockSaveAboutYou();

    cubit = SettingsCubit(
      getThemeModeUseCase: mockGetThemeMode,
      setThemeModeUseCase: mockSetThemeMode,
      getAboutYouUseCase: mockGetAboutYou,
      saveAboutYouUseCase: mockSaveAboutYou,
    );
  });

  tearDown(() => cubit.close());

  test('initial state should be SettingsInitial', () {
    expect(cubit.state, isA<SettingsInitial>());
  });

  group('loadSettings', () {
    test('should emit [SettingsLoading, SettingsLoaded] on success', () async {
      when(() => mockGetThemeMode()).thenAnswer((_) async => ThemeMode.dark);
      when(() => mockGetAboutYou()).thenAnswer((_) async => 'My bio');

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SettingsLoading>(),
          predicate<SettingsLoaded>(
            (s) => s.themeMode == ThemeMode.dark && s.aboutYou == 'My bio',
          ),
        ]),
      );

      await cubit.loadSettings();
    });

    test('should emit [SettingsLoading, SettingsError] on failure', () async {
      when(() => mockGetThemeMode()).thenThrow(Exception('Storage error'));
      when(() => mockGetAboutYou()).thenAnswer((_) async => '');

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SettingsLoading>(),
          isA<SettingsError>(),
        ]),
      );

      await cubit.loadSettings();
    });
  });

  group('updateThemeMode', () {
    test('should emit [SettingsLoading, SettingsLoaded] with new ThemeMode when in SettingsLoaded state',
        () async {
      cubit.emit(const SettingsLoaded(themeMode: ThemeMode.light, aboutYou: 'bio'));
      when(() => mockSetThemeMode(ThemeMode.dark)).thenAnswer((_) async {});

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SettingsLoading>(),
          predicate<SettingsLoaded>(
            (s) => s.themeMode == ThemeMode.dark && s.aboutYou == 'bio',
          ),
        ]),
      );

      await cubit.updateThemeMode(ThemeMode.dark);
    });

    test('should not call setThemeMode when not in SettingsLoaded state', () async {
      // starts at SettingsInitial — guard should prevent any work
      await cubit.updateThemeMode(ThemeMode.dark);
      expect(cubit.state, isA<SettingsInitial>());
      verifyNever(() => mockSetThemeMode(ThemeMode.dark));
    });
  });

  group('updateAboutYou', () {
    test('should emit [SettingsLoading, SettingsLoaded] with new bio text', () async {
      cubit.emit(const SettingsLoaded(themeMode: ThemeMode.system, aboutYou: 'Old bio'));
      when(() => mockSaveAboutYou('New bio')).thenAnswer((_) async {});

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SettingsLoading>(),
          predicate<SettingsLoaded>(
            (s) => s.aboutYou == 'New bio' && s.themeMode == ThemeMode.system,
          ),
        ]),
      );

      await cubit.updateAboutYou('New bio');
    });

    test('should not call saveAboutYou when not in SettingsLoaded state', () async {
      // starts at SettingsInitial — guard should prevent any work
      await cubit.updateAboutYou('New bio');
      expect(cubit.state, isA<SettingsInitial>());
      verifyNever(() => mockSaveAboutYou('New bio'));
    });
  });
}
