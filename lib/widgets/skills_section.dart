import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/skill.dart';
import '../presentation/cubit/resume_cubit.dart';

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
      color: theme.colorScheme.surfaceContainerLowest,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: BlocBuilder<ResumeCubit, ResumeState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.sectionSkills,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Masonry layout: cards alternate between independent columns so
                  // shorter cards don't leave gaps next to taller ones (2 cols on wide screens, 1 on narrow)
                  Builder(
                    builder: (context) {
                      const spacing = 24.0;
                      final columnCount = screenWidth > 900 ? 2 : 1;
                      final columns = List.generate(columnCount, (_) => <Widget>[]);

                      for (var i = 0; i < state.skills.length; i++) {
                        final column = columns[i % columnCount];
                        if (column.isNotEmpty) column.add(const SizedBox(height: spacing));
                        column.add(SkillCard(skill: state.skills[i]));
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var c = 0; c < columnCount; c++) ...[
                            if (c > 0) const SizedBox(width: spacing),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: columns[c],
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SkillCard extends StatelessWidget {
  final Skill skill;

  const SkillCard({
    super.key,
    required this.skill,
  });

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
