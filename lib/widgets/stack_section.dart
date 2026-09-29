import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/skill.dart';
import '../presentation/cubit/resume_cubit.dart';
import '../theme/hn_theme.dart';
import 'hn_widgets.dart';

/// Skills as a two-column table: category and depth, then the tools.
class StackSection extends StatelessWidget {
  const StackSection({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DitherRule(),
            const SizedBox(height: 28),
            SectionHead(title: state.stackTitle, subtitle: state.stackSubtitle),
            const SizedBox(height: 36),
            for (final s in state.skills) _SkillRow(skill: s, desktop: desktop),
            Container(height: 1, color: p.hair),
          ],
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final Skill skill;
  final bool desktop;

  const _SkillRow({required this.skill, required this.desktop});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final head = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(skill.name, style: HnType.body(p.ink, size: 15, weight: FontWeight.w700).copyWith(height: 1.4)),
        const SizedBox(height: 4),
        Caption(skill.level, color: skill.level == 'Advanced' ? p.accent : p.mute),
      ],
    );
    final tools = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final t in skill.technologies)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(border: Border.all(color: p.hair), borderRadius: BorderRadius.circular(4)),
            child: Text(t, style: HnType.body(p.ink, size: 12.5).copyWith(height: 1.3)),
          ),
      ],
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: p.hair))),
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(width: 280, child: head), Expanded(child: tools)],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [head, const SizedBox(height: 14), tools],
            ),
    );
  }
}
