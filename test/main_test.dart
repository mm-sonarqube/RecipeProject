import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/get_current_user.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/login.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/logout.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/update_profile_photo.dart';
import 'package:unit_testing/app/features/recipes/domain/usecases/get_recipes.dart';
import 'package:unit_testing/app/features/recipes/domain/usecases/toggle_bookmark.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/get_about_you.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/save_about_you.dart';
import 'package:unit_testing/app/features/settings/domain/usecases/set_theme_mode.dart';
import 'package:unit_testing/main.dart';

class MockLogin extends Mock implements Login {}
class MockLogout extends Mock implements Logout {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}
class MockUpdateProfilePhoto extends Mock implements UpdateProfilePhoto {}
class MockGetRecipes extends Mock implements GetRecipes {}
class MockToggleBookmark extends Mock implements ToggleBookmark {}
class MockGetThemeMode extends Mock implements GetThemeMode {}
class MockSetThemeMode extends Mock implements SetThemeMode {}
class MockGetAboutYou extends Mock implements GetAboutYou {}
class MockSaveAboutYou extends Mock implements SaveAboutYou {}

void main() {
  testWidgets('MyApp should build successfully', (tester) async {
    final mockLogin = MockLogin();
    final mockLogout = MockLogout();
    final mockGetCurrentUser = MockGetCurrentUser();
    final mockUpdateProfilePhoto = MockUpdateProfilePhoto();
    final mockGetRecipes = MockGetRecipes();
    final mockToggleBookmark = MockToggleBookmark();
    final mockGetThemeMode = MockGetThemeMode();
    final mockSetThemeMode = MockSetThemeMode();
    final mockGetAboutYou = MockGetAboutYou();
    final mockSaveAboutYou = MockSaveAboutYou();

    // Stub checkSession + settings load
    when(() => mockGetCurrentUser()).thenAnswer((_) async => null);
    when(() => mockGetThemeMode()).thenAnswer((_) async => ThemeMode.system);
    when(() => mockGetAboutYou()).thenAnswer((_) async => '');

    await tester.pumpWidget(
      MyApp(
        login: mockLogin,
        logout: mockLogout,
        getCurrentUser: mockGetCurrentUser,
        updateProfilePhoto: mockUpdateProfilePhoto,
        getRecipes: mockGetRecipes,
        toggleBookmark: mockToggleBookmark,
        getThemeMode: mockGetThemeMode,
        setThemeMode: mockSetThemeMode,
        getAboutYou: mockGetAboutYou,
        saveAboutYou: mockSaveAboutYou,
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
  });
}
