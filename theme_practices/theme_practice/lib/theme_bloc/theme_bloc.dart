import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _key = 'theme_mode';

  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ChangeThemeEvent>(_onChangeTheme);
  }

  // 🔹 App start par: SharedPreferences check karo
  // → Pehli baar? Phone ki system theme save karo
  // → Pehle se saved? Wahi theme load karo
  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_key);

    if (savedTheme != null) {
      // ✅ Pehle se saved theme hai → directly load karo
      emit(ThemeState(themeMode: _stringToTheme(savedTheme)));
    } else {
      // 🆕 Pehli baar app khuli → phone ki system theme detect karo
      final systemBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;

      final systemTheme = systemBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;

      // 💾 System theme ko SharedPreferences mein save karo
      await prefs.setString(_key, systemTheme.name);

      emit(ThemeState(themeMode: systemTheme));
    }
  }

  // 🔹 User ne manually theme change ki → save + emit
  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, event.themeMode.name);
    emit(ThemeState(themeMode: event.themeMode));
  }

  // 🔹 Helper: String → ThemeMode
  ThemeMode _stringToTheme(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
