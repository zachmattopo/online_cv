import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Me',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Professional Summary',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Versatile mobile developer with 7 years of experience specialising in Flutter/Dart development, with proven track record of delivering high-performance, user-centric apps serving millions of users in telecoms, HR, oil & gas, and healthcare sectors; in both startup and established enterprise environments.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 32),
                      InfoGrid(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoGrid extends StatelessWidget {
  const InfoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 600;

    final infoItems = [
      {'label': 'Location', 'value': 'United Kingdom'},
      {'label': 'Availability', 'value': 'Immediate'},
      {'label': 'UK Visa Sponsorship', 'value': 'Not needed'},
      {'label': 'Visa Type', 'value': 'Dependent visa'},
    ];

    // Use LayoutBuilder + Wrap so each child width is controlled (2 cols on desktop, 1 on mobile)
    return LayoutBuilder(builder: (context, constraints) {
      final spacing = 16.0;
      final columnCount = isDesktop ? 2 : 1;
      final itemWidth = (constraints.maxWidth - spacing * (columnCount - 1)) / columnCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: infoItems.map((item) {
          return SizedBox(
            width: itemWidth,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // height is based on content
                children: [
                  Text(
                    item['label']!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['value']!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
