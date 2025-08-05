import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final Function(int) onNavigate;

  const AppBarWidget({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
        _buildNavButton(context, 'About', 1),
        _buildNavButton(context, 'Experience', 2),
        _buildNavButton(context, 'Skills', 3),
        _buildNavButton(context, 'Education', 4),
        _buildNavButton(context, 'Contact', 5),
        const SizedBox(width: 16),
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
