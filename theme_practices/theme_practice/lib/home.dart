import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_practice/theme_bloc/theme_bloc.dart';
import 'package:theme_practice/theme_bloc/theme_event.dart';
import 'package:theme_practice/theme_bloc/theme_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My App',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: IconButton(
                    key: ValueKey(isDark),
                    onPressed: () {
                      context.read<ThemeBloc>().add(
                        ChangeThemeEvent(
                          isDark ? ThemeMode.light : ThemeMode.dark,
                        ),
                      );
                    },
                    icon: Icon(
                      isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      size: 26,
                      color: isDark ? Colors.amber : colorScheme.primary,
                    ),
                    tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
                  ),
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroCard(isDark: isDark),

                const SizedBox(height: 28),

                Text(
                  'Quick Stats',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.bar_chart_rounded,
                        label: 'Revenue',
                        value: '\$12.4K',
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.people_alt_rounded,
                        label: 'Users',
                        value: '3,280',
                        color: Colors.blueAccent.shade200,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.trending_up_rounded,
                        label: 'Growth',
                        value: '+18%',
                        color: Colors.purpleAccent.shade200,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.task_alt_rounded,
                        label: 'Tasks',
                        value: '94',
                        color: Colors.orangeAccent.shade200,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Text(
                  'Recent Activity',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),

                _ActivityTile(
                  icon: Icons.upload_rounded,
                  title: 'Report Uploaded',
                  subtitle: '2 minutes ago',
                  iconColor: Colors.greenAccent.shade400,
                ),
                _ActivityTile(
                  icon: Icons.person_add_rounded,
                  title: 'New User Joined',
                  subtitle: '15 minutes ago',
                  iconColor: Colors.blueAccent.shade200,
                ),
                _ActivityTile(
                  icon: Icons.payment_rounded,
                  title: 'Payment Received',
                  subtitle: '1 hour ago',
                  iconColor: Colors.purpleAccent.shade200,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  final bool isDark;
  const _HeroCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF6750A4), const Color(0xFF3700B3)]
              : [const Color(0xFF7B61FF), const Color(0xFF6750A4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                  Text(
                    'Arslan Ahmed',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isDark ? 'Dark' : 'Light',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Dashboard Overview',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Everything looks great today 🚀',
            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// 🔹 Activity Tile
// ─────────────────────────────────────────────────────────
class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
