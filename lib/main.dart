import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/core/constants/app_constants.dart';
import 'app/features/auth/data/datasources/auth_local_data_source.dart';
import 'app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'app/features/auth/data/repositories/auth_repository_impl.dart';
import 'app/features/auth/domain/usecases/get_current_user.dart';
import 'app/features/auth/domain/usecases/login.dart';
import 'app/features/auth/domain/usecases/logout.dart';
import 'app/features/auth/domain/usecases/update_profile_photo.dart';
import 'app/features/auth/presentation/cubit/auth_cubit.dart';
import 'app/features/auth/presentation/cubit/auth_state.dart';
import 'app/features/auth/presentation/pages/login_page.dart';

import 'app/features/recipes/data/datasources/recipe_local_data_source.dart';
import 'app/features/recipes/data/datasources/recipe_remote_data_source.dart';
import 'app/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'app/features/recipes/domain/usecases/get_recipes.dart';
import 'app/features/recipes/domain/usecases/toggle_bookmark.dart';
import 'app/features/recipes/presentation/cubit/recipe_list_cubit.dart';
import 'app/features/recipes/presentation/pages/recipe_list_page.dart';

import 'app/features/settings/data/datasources/settings_local_data_source.dart';
import 'app/features/settings/data/repositories/settings_repository_impl.dart';
import 'app/features/settings/domain/usecases/get_about_you.dart';
import 'app/features/settings/domain/usecases/get_theme_mode.dart';
import 'app/features/settings/domain/usecases/save_about_you.dart';
import 'app/features/settings/domain/usecases/set_theme_mode.dart';
import 'app/features/settings/presentation/cubit/settings_cubit.dart';
import 'app/features/settings/presentation/cubit/settings_state.dart';

void main({Dio? authDio, Dio? recipeDio}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  // Auth — Dio client for remote auth calls
  final actualAuthDio = authDio ?? Dio();

  // Auth Clean Architecture wiring
  final authRemoteDataSource = AuthRemoteDataSourceImpl(dio: actualAuthDio);
  final authLocalDataSource =
      AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );
  final login = Login(authRepository);
  final logout = Logout(authRepository);
  final getCurrentUser = GetCurrentUser(authRepository);
  final updateProfilePhoto = UpdateProfilePhoto(authRepository);

  // Recipes — separate Dio client for recipe calls
  final actualRecipeDio = recipeDio ?? Dio();
  final remoteDataSource = RecipeRemoteDataSourceImpl(client: actualRecipeDio);
  final localDataSource =
      RecipeLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final recipeRepository = RecipeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
  final getRecipes = GetRecipes(recipeRepository);
  final toggleBookmark = ToggleBookmark(recipeRepository);

  // Settings Clean Architecture wiring
  final settingsLocalDataSource =
      SettingsLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final settingsRepository =
      SettingsRepositoryImpl(localDataSource: settingsLocalDataSource);
  final getThemeMode = GetThemeMode(settingsRepository);
  final setThemeMode = SetThemeMode(settingsRepository);
  final getAboutYou = GetAboutYou(settingsRepository);
  final saveAboutYou = SaveAboutYou(settingsRepository);

  runApp(
    MyApp(
      login: login,
      logout: logout,
      getCurrentUser: getCurrentUser,
      updateProfilePhoto: updateProfilePhoto,
      getRecipes: getRecipes,
      toggleBookmark: toggleBookmark,
      getThemeMode: getThemeMode,
      setThemeMode: setThemeMode,
      getAboutYou: getAboutYou,
      saveAboutYou: saveAboutYou,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Login login;
  final Logout logout;
  final GetCurrentUser getCurrentUser;
  final UpdateProfilePhoto updateProfilePhoto;
  final GetRecipes getRecipes;
  final ToggleBookmark toggleBookmark;
  final GetThemeMode getThemeMode;
  final SetThemeMode setThemeMode;
  final GetAboutYou getAboutYou;
  final SaveAboutYou saveAboutYou;

  const MyApp({
    super.key,
    required this.login,
    required this.logout,
    required this.getCurrentUser,
    required this.updateProfilePhoto,
    required this.getRecipes,
    required this.toggleBookmark,
    required this.getThemeMode,
    required this.setThemeMode,
    required this.getAboutYou,
    required this.saveAboutYou,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            loginUseCase: login,
            logoutUseCase: logout,
            getCurrentUserUseCase: getCurrentUser,
            updateProfilePhotoUseCase: updateProfilePhoto,
          )..checkSession(),
        ),
        BlocProvider<RecipeListCubit>(
          create: (context) => RecipeListCubit(
            getRecipesUseCase: getRecipes,
            toggleBookmarkUseCase: toggleBookmark,
            
          ),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(
            getThemeModeUseCase: getThemeMode,
            setThemeModeUseCase: setThemeMode,
            getAboutYouUseCase: getAboutYou,
            saveAboutYouUseCase: saveAboutYou,
          )..loadSettings(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          ThemeMode currentThemeMode = ThemeMode.system;
          if (settingsState is SettingsLoaded) {
            currentThemeMode = settingsState.themeMode;
          }
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            themeMode: currentThemeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFFF7A59),
                primary: const Color(0xFFFF7A59),
                brightness: Brightness.light,
              ),
              fontFamily: 'Outfit',
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFFF7A59),
                primary: const Color(0xFFFF7A59),
                brightness: Brightness.dark,
              ),
              fontFamily: 'Outfit',
            ),
            home: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return const RecipeListPage();
                } else {
                  // Return LoginPage directly for Initial, Unauthenticated, AuthError, and AuthLoading states
                  // This ensures that when the user logs in and the state transitions to AuthLoading,
                  // the screen remains on LoginPage and doesn't get replaced by a full-screen loading spinner.
                  return const LoginPage();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
