import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../globe/globe_math.dart';
import '../models/journey_stop.dart';
import '../presentation/cubit/resume_cubit.dart';
import '../theme/hn_theme.dart';
import 'hn_widgets.dart';
import 'pixel_text.dart';

/// First viewport: name, what he does, availability and the way in. The
/// globe itself is drawn behind (desktop) or above (mobile) this section.
class HeroSection extends StatelessWidget {
  final ValueListenable<DateTime> clock;
  final double topInset;
  final VoidCallback onContact;
  final VoidCallback onPlainCv;

  const HeroSection({
    super.key,
    required this.clock,
    required this.topInset,
    required this.onContact,
    required this.onPlainCv,
  });

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final size = MediaQuery.sizeOf(context);
    final desktop = size.width >= HnLayout.desktopBreakpoint;
    final gutter = HnLayout.gutter(size.width);
    final column = desktop ? HnLayout.column(size.width) : size.width - gutter * 2;

    return BlocBuilder<ResumeCubit, ResumeState>(
      builder: (context, state) {
        final content = SizedBox(
          width: column,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              PixelText(
                state.name,
                size: desktop ? (size.width * 0.078).clamp(72.0, 124.0) : 64,
                scale: desktop ? 4 : 3,
                header: true,
                fitOneLine: true,
              ),
              const SizedBox(height: 18),
              PixelText(state.heroTagline, size: desktop ? 32 : 28, scale: 2, color: p.mute),
              const SizedBox(height: 26),
              MarkupText(state.heroLede),
              const SizedBox(height: 30),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  HnButton('Get in touch →', onTap: onContact),
                  HnButton('Plain CV', filled: false, onTap: onPlainCv),
                ],
              ),
              const SizedBox(height: 28),
              _LiveLine(clock: clock, city: state.homeCity, stateZone: state.homeZone),
            ],
          ),
        );

        if (!desktop) {
          return Padding(
            padding: EdgeInsets.fromLTRB(gutter, topInset + 28, gutter, 72),
            child: content,
          );
        }
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height.clamp(640.0, 1400.0)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(gutter, topInset + 24, gutter, HnLayout.laneHeight + 56),
            child: Align(alignment: Alignment.centerLeft, child: content),
          ),
        );
      },
    );
  }
}

class _LiveLine extends StatelessWidget {
  final ValueListenable<DateTime> clock;
  final String city;
  final StopZone stateZone;

  const _LiveLine({required this.clock, required this.city, required this.stateZone});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return ValueListenableBuilder<DateTime>(
      valueListenable: clock,
      builder: (context, now, _) {
        final utc = now.toUtc();
        final t = localTime(stateZone, utc);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(top: 7), child: Container(width: 14, height: 2, color: p.accent)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'It’s ${hhmm(t.time)} in $city. The slate line on the globe marks where the sun is rising and setting right now.',
                style: HnType.body(p.mute, size: 12.5).copyWith(height: 1.55),
              ),
            ),
          ],
        );
      },
    );
  }
}
