import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SystemThemeChangedEvent>(_onSystemThemeChanged);
  }

  // Toggle between light and dark (exits system mode)
  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    // If in system mode, switch to manual mode
    if (state.isSystemMode) {
      // Toggle to opposite of current system theme
      final newMode = state.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
      emit(ThemeState(themeMode: newMode, isSystemMode: false));
    } else {
      // Already in manual mode, just toggle
      final newMode = state.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
      emit(ThemeState(themeMode: newMode, isSystemMode: false));
    }
  }

  // System theme changed - only update if still in system mode
  void _onSystemThemeChanged(
    SystemThemeChangedEvent event,
    Emitter<ThemeState> emit,
  ) {
    if (state.isSystemMode) {
      // Still following system, update theme
      emit(ThemeState(themeMode: ThemeMode.system, isSystemMode: true));
    }
    // If not in system mode, ignore system changes
  }
}
