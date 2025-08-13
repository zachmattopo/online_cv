import 'package:flutter/material.dart';
import '../main.dart';

class AppBarWidget extends StatelessWidget {
  final Function(int) onNavigate;

  const AppBarWidget({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return SliverAppBar(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      elevation: 0,
      floating: true,
      snap: true,
      title: Text(
        'Hafiz Nordin',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
      actions: [
        if (isDesktop) ...[
          _buildNavButton(context, 'About', 1),
          _buildNavButton(context, 'Experience', 2),
          _buildNavButton(context, 'Skills', 3),
          _buildNavButton(context, 'Education', 4),
          _buildNavButton(context, 'Contact', 5)
        ] else
          PopupMenuButton(
            icon: const Icon(Icons.menu),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text('About'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Experience'),
              ),
              PopupMenuItem(
                value: 3,
                child: Text('Skills'),
              ),
              PopupMenuItem(
                value: 4,
                child: Text('Education'),
              ),
              PopupMenuItem(
                value: 5,
                child: Text('Contact'),
              ),
            ],
            onSelected: onNavigate,
          ),
        const SizedBox(width: 16),
        IconButton(
          tooltip: 'Toggle dark/light mode',
          icon: Icon(
            theme.brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () {
            themeNotifier.value =
                theme.brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
          },
        ),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String label, int index) {
    return TextButton(
      onPressed: () => onNavigate(index),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
