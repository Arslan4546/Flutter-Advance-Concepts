import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  // Initial state
  factory ThemeState.initial() => const ThemeState(themeMode: ThemeMode.light);

  @override
  List<Object> get props => [themeMode];
}
