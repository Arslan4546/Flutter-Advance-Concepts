import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  // Initial state - follows device theme
  factory ThemeState.initial() => const ThemeState(themeMode: ThemeMode.system);

  @override
  List<Object> get props => [themeMode];
}
