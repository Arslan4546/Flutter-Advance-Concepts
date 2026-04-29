import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isSystemMode; // Track if following system theme

  const ThemeState({required this.themeMode, required this.isSystemMode});

  // Initial state - follows device theme
  factory ThemeState.initial() =>
      const ThemeState(themeMode: ThemeMode.system, isSystemMode: true);

  @override
  List<Object> get props => [themeMode, isSystemMode];
}
