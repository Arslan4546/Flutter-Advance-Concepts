import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_practice/home.dart';
import 'package:theme_practice/theme/app_theme.dart';
import 'package:theme_practice/theme_bloc/theme_bloc.dart';
import 'package:theme_practice/theme_bloc/theme_event.dart';
import 'package:theme_practice/theme_bloc/theme_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: SystemThemeListener(child: const HomeScreen()),
          );
        },
      ),
    );
  }
}

// Widget to listen to system theme changes
class SystemThemeListener extends StatefulWidget {
  final Widget child;

  const SystemThemeListener({super.key, required this.child});

  @override
  State<SystemThemeListener> createState() => _SystemThemeListenerState();
}

class _SystemThemeListenerState extends State<SystemThemeListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // System theme changed
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDark = brightness == Brightness.dark;

    // Notify bloc about system theme change
    context.read<ThemeBloc>().add(SystemThemeChangedEvent(isDark));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
