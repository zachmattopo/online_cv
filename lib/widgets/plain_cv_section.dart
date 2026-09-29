import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/cubit/resume_cubit.dart';
import '../theme/hn_theme.dart';
import 'hn_widgets.dart';

/// The whole record in one scannable column: summary, facts, every role
/// with every highlight, education and certifications.
class PlainCvSection extends StatelessWidget {
  const PlainCvSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= HnLayout.desktopBreakpoint;
    final gutter = HnLayout.gutter(width);

    return BlocBuilder<ResumeCubit, ResumeState>(
      builder: (context, state) => Container(
        color: p.paper,
        padding: EdgeInsets.fromLTRB(gutter, desktop ? 96 : 80, gutter, desktop ? 40 : 32),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DitherRule(),
                const SizedBox(height: 28),
                SectionHead(title: state.plainCvTitle, subtitle: state.plainCvSubtitle),
                const SizedBox(height: 36),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: MarkupText(state.aboutSummary, size: 14.5),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 32,
                  runSpacing: 18,
                  children: [
                    for (final item in state.aboutInfoItems)
                      SizedBox(
                        width: desktop ? 230 : double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Caption(item['label'] ?? ''),
                            const SizedBox(height: 4),
                            Text(item['value'] ?? '', style: HnType.body(p.ink, size: 14).copyWith(height: 1.45)),
                          ],
                        ),
                      ),
                  ],
                ),
                _CvGroup(
                  title: 'Experience',
                  rows: [
                    for (final e in state.experiences)
                      _CvRow(
                        meta: '${e.date}\n${e.location}',
                        title: '${e.position}, ${e.company}',
                        bullets: e.highlights,
                        desktop: desktop,
                      ),
                  ],
                ),
                _CvGroup(
                  title: 'Education',
                  rows: [
                    for (final ed in state.educations)
                      _CvRow(
                        meta: '${ed.date}\n${ed.location}',
                        title: '${ed.qualification}, ${ed.institution}',
                        subtitle: ed.grade,
                        bullets: [ed.description],
                        desktop: desktop,
                      ),
                  ],
                ),
                _CvGroup(
                  title: 'Certifications',
                  rows: [
                    for (final c in state.certifications)
                      _CvRow(
                        meta: c['date'] ?? '',
                        title: c['name'] ?? '',
                        subtitle: c['issuer'],
                        bullets: [if ((c['description'] ?? '').isNotEmpty) c['description']!],
                        desktop: desktop,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CvGroup extends StatelessWidget {
  final String title;
  final List<Widget> rows;

  const _CvGroup({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontFamily: HnType.serif, fontSize: 30, height: 1.2, color: p.ink)),
          const SizedBox(height: 12),
          ...rows,
          Container(height: 1, color: p.hair),
        ],
      ),
    );
  }
}

class _CvRow extends StatelessWidget {
  final String meta;
  final String title;
  final String? subtitle;
  final List<String> bullets;
  final bool desktop;

  const _CvRow({
    required this.meta,
    required this.title,
    this.subtitle,
    required this.bullets,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final metaText = Text(meta, style: HnType.body(p.mute, size: 12.5).copyWith(height: 1.6));
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: HnType.body(p.ink, size: 15, weight: FontWeight.w700).copyWith(height: 1.45)),
        if (subtitle != null) Text(subtitle!, style: HnType.body(p.mute, size: 13).copyWith(height: 1.6)),
        const SizedBox(height: 6),
        for (final b in bullets)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 18, child: Text('–', style: HnType.body(p.mute, size: 13.5))),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Text(b, style: HnType.body(p.ink.withValues(alpha: 0.86), size: 13.5).copyWith(height: 1.6)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: p.hair))),
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(width: 240, child: metaText), Expanded(child: body)],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [metaText, const SizedBox(height: 6), body],
            ),
    );
  }
}
