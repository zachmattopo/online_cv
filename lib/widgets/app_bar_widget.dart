import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../main.dart';
import '../presentation/cubit/resume_cubit.dart';

class AppBarWidget extends StatelessWidget {
  final Function(int) onNavigate;
  
  const AppBarWidget({
    required this.onNavigate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 600;

    return BlocBuilder<ResumeCubit, ResumeState>(
      builder: (context, state) {
        return SliverAppBar(
          backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
          elevation: 0,
          floating: true,
          snap: true,
          title: Text(
            state.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          actions: [
            if (isDesktop) ...[
              for (var i = 0; i < state.navLabels.length; i++)
                _buildNavButton(context, state.navLabels[i], i + 1),
            ] else
              PopupMenuButton(
                icon: const Icon(Icons.menu),
                itemBuilder: (context) => [
                  for (var i = 0; i < state.navLabels.length; i++)
                    _buildPopupMenuItem(state.navLabels[i], i + 1),
                ],
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
            const SizedBox(width: 16),
          ],
        );
      },
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

  PopupMenuItem _buildPopupMenuItem(String label, int index) {
    return PopupMenuItem(
      child: Text(label),
      onTap: () => onNavigate(index),
    );
  }
}
