import 'package:flutter/material.dart';
import 'package:theme_practice/controller/theme_controller.dart';
import 'package:theme_practice/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional UI"),
        actions: [
          // 🌗 TOGGLE BUTTON
          IconButton(
            onPressed: () {
              ThemeController.toggleTheme();
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
            // 🔹 TITLE
            Text("Welcome Back 👋", style: theme.textTheme.headlineLarge),

            const SizedBox(height: 10),

            Text(
              "This is a professional themed UI screen",
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            // 🔹 INPUT FIELD
            TextField(
              decoration: const InputDecoration(hintText: "Enter your name"),
            ),

            const SizedBox(height: 20),

            // 🔹 BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Primary Button"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Outline"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "User Profile Card",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 SWITCH + CHECKBOX
            Row(
              children: [
                Switch(value: true, onChanged: (_) {}),
                const SizedBox(width: 10),
                Checkbox(value: true, onChanged: (_) {}),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 CONTAINER USING AppColors
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Custom Color Box", style: theme.textTheme.bodyLarge),
            ),
          ],
        ),
      ),

      // 🔵 FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
