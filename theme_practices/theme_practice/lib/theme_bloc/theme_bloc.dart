import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  // Toggle between system, light and dark
  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    ThemeMode newMode;

    // Cycle: system → light → dark → system
    switch (state.themeMode) {
      case ThemeMode.system:
        newMode = ThemeMode.light;
        break;
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.system;
        break;
    }

    emit(ThemeState(themeMode: newMode));
  }
}
