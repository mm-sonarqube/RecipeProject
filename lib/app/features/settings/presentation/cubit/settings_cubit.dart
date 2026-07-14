import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_about_you.dart';
import '../../domain/usecases/get_theme_mode.dart';
import '../../domain/usecases/save_about_you.dart';
import '../../domain/usecases/set_theme_mode.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetThemeMode getThemeModeUseCase;
  final SetThemeMode setThemeModeUseCase;
  final GetAboutYou getAboutYouUseCase;
  final SaveAboutYou saveAboutYouUseCase;

  SettingsCubit({
    required this.getThemeModeUseCase,
    required this.setThemeModeUseCase,
    required this.getAboutYouUseCase,
    required this.saveAboutYouUseCase,
  }) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final themeMode = await getThemeModeUseCase();
      final aboutYou = await getAboutYouUseCase();
      emit(SettingsLoaded(themeMode: themeMode, aboutYou: aboutYou));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(SettingsLoading());
      try {
        await setThemeModeUseCase(themeMode);
        emit(SettingsLoaded(themeMode: themeMode, aboutYou: currentState.aboutYou));
      } catch (e) {
        emit(SettingsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> updateAboutYou(String aboutYou) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(SettingsLoading());
      try {
        await saveAboutYouUseCase(aboutYou);
        emit(SettingsLoaded(themeMode: currentState.themeMode, aboutYou: aboutYou));
      } catch (e) {
        emit(SettingsError(message: e.toString()));
        emit(currentState);
      }
    }
  }
}
