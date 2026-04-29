import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

// Toggle between light and dark
class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}
