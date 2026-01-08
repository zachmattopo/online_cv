import 'package:flutter/material.dart';
import '../models/skill.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

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
                'Skills & Technologies',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              // Use LayoutBuilder + Wrap so each card gets a fixed width (2 cols on wide screens, 1 on narrow)
              LayoutBuilder(
                builder: (context, constraints) {
                  final spacing = 24.0;
                  final columnCount = screenWidth > 900 ? 2 : 1;
                  final itemWidth =
                      (constraints.maxWidth - spacing * (columnCount - 1)) / columnCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: skills.map((skill) {
                      return SizedBox(
                        width: itemWidth,
                        child: SkillCard(skill: skill),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkillCard extends StatelessWidget {
  const SkillCard({
    super.key,
    required this.skill,
  });

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // let card height wrap its content
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    skill.icon,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        skill.level,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Height of Wrap is based on content
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skill.technologies
                  .map(
                    (tech) => Chip(
                      label: Text(
                        tech,
                        style: theme.textTheme.bodySmall,
                      ),
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
