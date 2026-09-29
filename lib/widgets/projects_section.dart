import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/project.dart';
import '../presentation/cubit/resume_cubit.dart';
import '../theme/hn_theme.dart';
import 'hn_widgets.dart';

/// Side projects as catalogue entries, on opaque paper that slides over the
/// globe once the journey ends.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= HnLayout.desktopBreakpoint;
    final gutter = HnLayout.gutter(width);

    return BlocBuilder<ResumeCubit, ResumeState>(
      builder: (context, state) {
        final cards = [for (final pr in state.projects) _ProjectCard(project: pr)];
        return Container(
          color: p.paper,
          padding: EdgeInsets.fromLTRB(gutter, desktop ? 104 : 84, gutter, desktop ? 40 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DitherRule(),
              const SizedBox(height: 28),
              SectionHead(title: state.projectsTitle, subtitle: state.projectsSubtitle),
              const SizedBox(height: 40),
              if (desktop)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < cards.length; i++) ...[
                        if (i > 0) const SizedBox(width: 24),
                        Expanded(child: cards[i]),
                      ],
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(height: 20),
                      cards[i],
                    ],
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final narrow = !HnLayout.isDesktop(context);
    final url = project.url;
    // Host plus path (no scheme), so sites that live under a path, like a
    // GitHub Pages project, show their full address.
    final uri = url == null ? null : Uri.tryParse(url);
    final host = uri == null
        ? null
        : '${uri.host.replaceFirst('www.', '')}${uri.path}'.replaceFirst(RegExp(r'/$'), '');
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      decoration: BoxDecoration(
        color: p.paper,
        border: Border.all(color: p.hair),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (project.imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  // No backing tile: each logo sits on the page's own paper, with a
                  // dark-background variant where the artwork needs one.
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? (project.darkImagePath ?? project.imagePath!)
                        : project.imagePath!,
                    // Height-led so wide wordmarks keep their proportions.
                    height: narrow ? 32 : 40,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  ),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name, style: TextStyle(fontFamily: HnType.serif, fontSize: 26, height: 1.1, color: p.ink)),
                    if (host != null) Text(host, style: HnType.body(p.mute, size: 12.5).copyWith(height: 1.5)),
                    if (narrow && project.period != null) ...[
                      const SizedBox(height: 6),
                      Caption(project.period!),
                    ],
                  ],
                ),
              ),
              if (!narrow && project.period != null) Caption(project.period!),
            ],
          ),
          const SizedBox(height: 16),
          MarkupText(project.description, size: 14),
          const SizedBox(height: 14),
          for (final h in project.highlights) _Highlight(text: h),
          if (url != null) ...[
            const SizedBox(height: 14),
            HnTextLink('Visit $host', url: url, size: 13),
          ],
        ],
      ),
    );
  }
}

/// `Label: detail` highlights get a label column; plain ones get a dash.
class _Highlight extends StatelessWidget {
  final String text;

  const _Highlight({required this.text});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final m = RegExp(r'^([A-Z][A-Za-z ]{1,18}):\s(.*)$').firstMatch(text);
    final style = HnType.body(p.ink.withValues(alpha: 0.86), size: 13).copyWith(height: 1.55);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: p.hair))),
      child: m != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 118, child: Padding(padding: const EdgeInsets.only(top: 2), child: Caption(m.group(1)!))),
                Expanded(child: Text(m.group(2)!, style: style)),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 18, child: Text('–', style: style.copyWith(color: p.mute))),
                Expanded(child: Text(text, style: style)),
              ],
            ),
    );
  }
}
