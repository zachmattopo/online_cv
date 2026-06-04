import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/project.dart';
import '../presentation/cubit/resume_cubit.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
          child: BlocBuilder<ResumeCubit, ResumeState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.sectionProjects,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...state.projects.map((proj) => ProjectCard(project: proj)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 768;

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: isWide ? _buildWideLayout(theme) : _buildNarrowLayout(theme),
      ),
    );
  }

  Widget _buildWideLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(theme, width: 160),
        const SizedBox(width: 24),
        Expanded(child: _buildContent(theme)),
      ],
    );
  }

  Widget _buildNarrowLayout(ThemeData theme) {
    return Column(
      children: [
        _buildImage(theme, width: 160),
        const SizedBox(height: 16),
        _buildContent(theme),
      ],
    );
  }

  Widget _buildImage(ThemeData theme, {required double width}) {
    if (project.imagePath == null) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        project.imagePath!,
        width: width,
        height: width,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.folder_outlined,
            size: width * 0.4,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                project.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (project.period != null)
              Container(
                margin: const EdgeInsets.only(left: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  project.period!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          project.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
        if (project.highlights.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...project.highlights.map((highlight) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        highlight,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
        if (project.url != null) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _launchUrl(project.url!),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('View Website'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
