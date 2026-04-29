import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_practice/theme_bloc/theme_bloc.dart';
import 'package:theme_practice/theme_bloc/theme_event.dart';
import 'package:theme_practice/theme_bloc/theme_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloc Theme UI"),
        actions: [
          // Theme toggle button
          IconButton(
            onPressed: () {
              context.read<ThemeBloc>().add(const ToggleThemeEvent());
            },
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello BLoC 👋", style: theme.textTheme.headlineLarge),
            const SizedBox(height: 20),

            // Current theme indicator
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          state.themeMode == ThemeMode.light
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Theme',
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.themeMode == ThemeMode.light
                                    ? 'Light Mode'
                                    : 'Dark Mode',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Sample Button"),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text("User Card", style: theme.textTheme.titleLarge),
                subtitle: const Text("This is a sample card"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
