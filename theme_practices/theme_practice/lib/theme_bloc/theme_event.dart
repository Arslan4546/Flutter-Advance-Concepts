import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

// Toggle between light and dark (manual override)
class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}

// System theme changed - update if in system mode
class SystemThemeChangedEvent extends ThemeEvent {
  final bool isDark;

  const SystemThemeChangedEvent(this.isDark);

  @override
  List<Object> get props => [isDark];
}
