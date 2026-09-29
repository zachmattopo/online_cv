import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../globe/globe_math.dart';
import '../presentation/cubit/resume_cubit.dart';
import '../theme/hn_theme.dart';
import 'hn_widgets.dart';
import 'pixel_icon.dart';
import 'pixel_text.dart';

/// The close: three ways to reach out, set large, with the local time.
class ContactSection extends StatelessWidget {
  final ValueListenable<DateTime> clock;

  const ContactSection({super.key, required this.clock});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= HnLayout.desktopBreakpoint;
    final gutter = HnLayout.gutter(width);

    return BlocBuilder<ResumeCubit, ResumeState>(
      builder: (context, state) {
        final socials = state.socialLinks.where((s) => s.label != 'LinkedIn').toList();
        return Container(
          color: p.paper,
          padding: EdgeInsets.fromLTRB(gutter, desktop ? 96 : 80, gutter, desktop ? 80 : 56),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DitherRule(),
                const SizedBox(height: 28),
                PixelText(state.contactTitle, size: desktop ? 120 : 72, scale: desktop ? 4 : 3, header: true, fitOneLine: true),
                const SizedBox(height: 14),
                PixelText(state.contactSubtitle, size: desktop ? 32 : 28, scale: 2, color: p.mute),
                const SizedBox(height: 40),
                for (final b in state.contactButtons)
                  _ContactRow(
                    label: b['label'] ?? '',
                    value: b['subtitle'] ?? '',
                    url: b['url'] ?? '',
                    desktop: desktop,
                  ),
                Container(height: 1, color: p.hair),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final s in socials) HnTextLink(s.label, url: s.url, size: 13),
                    ValueListenableBuilder<DateTime>(
                      valueListenable: clock,
                      builder: (context, now, _) {
                        final t = localTime(state.homeZone, now.toUtc());
                        return Text(
                          'It’s ${hhmm(t.time)} ${t.zone} in ${state.homeCity}.',
                          style: HnType.body(p.mute, size: 13).copyWith(height: 1.4),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String label;
  final String value;
  final String url;
  final bool desktop;

  const _ContactRow({required this.label, required this.value, required this.url, required this.desktop});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return HnExternal(
      url: url,
      builder: (context, hover, focus) {
        final valueText = Text(
          value,
          style: HnType.body(hover ? p.accent : p.ink, size: desktop ? 22 : 17, weight: FontWeight.w500).copyWith(height: 1.3),
        );
        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: EdgeInsets.symmetric(vertical: desktop ? 22 : 16, horizontal: 4),
          decoration: BoxDecoration(
            color: hover ? p.wash : null,
            border: Border(top: BorderSide(color: p.hair)),
          ),
          child: desktop
              ? Row(
                  children: [
                    SizedBox(width: 200, child: Caption(label)),
                    Expanded(child: valueText),
                    PixelIcon(PixelGlyph.arrowUpRight, color: hover ? p.accent : p.mute, cell: 1.5),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Caption(label), const SizedBox(height: 6), valueText],
                ),
        );
      },
    );
  }
}
