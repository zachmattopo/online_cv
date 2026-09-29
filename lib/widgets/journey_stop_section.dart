import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../globe/globe_math.dart';
import '../models/experience.dart';
import '../models/journey_stop.dart';
import '../theme/hn_theme.dart';
import 'hn_widgets.dart';
import 'pixel_text.dart';

/// One stop on the journey. The text sits in the left column while the
/// globe (behind it) holds on this place.
class JourneyStopSection extends StatelessWidget {
  final JourneyStop stop;
  final int index;
  final int total;
  final ValueListenable<DateTime> clock;
  final ValueListenable<int> activeStop;
  final bool reduceMotion;
  final double topInset;

  const JourneyStopSection({
    super.key,
    required this.stop,
    required this.index,
    required this.total,
    required this.clock,
    required this.activeStop,
    required this.reduceMotion,
    required this.topInset,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final desktop = size.width >= HnLayout.desktopBreakpoint;
    final gutter = HnLayout.gutter(size.width);
    final column = desktop ? HnLayout.column(size.width) : size.width - gutter * 2;
    final links = <UrlLink>[for (final r in stop.roles) ...r.urls].take(4).toList();

    final content = SizedBox(
      width: column,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PixelText(stop.city, size: desktop ? 96 : 60, scale: desktop ? 4 : 3, header: true, fitOneLine: true),
          const SizedBox(height: 14),
          PixelText(stop.subhead, size: desktop ? 32 : 28, scale: 2, color: HnPalette.of(context).mute),
          const SizedBox(height: 22),
          MarkupText(stop.summary),
          if (stop.roles.length > 1) ...[
            const SizedBox(height: 18),
            _RoleList(roles: stop.roles),
          ],
          const SizedBox(height: 22),
          _StopResponse(stop: stop, index: index, clock: clock, activeStop: activeStop, reduceMotion: reduceMotion),
          if (links.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 20,
              runSpacing: 2,
              children: [for (final l in links) HnTextLink(l.label, url: l.url)],
            ),
          ],
        ],
      ),
    );

    return Semantics(
      container: true,
      label: 'Stop ${index + 1} of $total: ${stop.city}, ${stop.region}',
      child: desktop
          ? ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, topInset + 40, gutter, HnLayout.laneHeight + 64),
                child: Align(alignment: Alignment.centerLeft, child: content),
              ),
            )
          : Padding(
              padding: EdgeInsets.fromLTRB(gutter, topInset + 28, gutter, 72),
              child: content,
            ),
    );
  }
}

class _RoleList extends StatelessWidget {
  final List<Experience> roles;

  const _RoleList({required this.roles});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return Column(
      children: [
        for (final r in roles)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: p.hair))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(text: r.company, style: const TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: '  ${r.position}', style: TextStyle(color: p.mute)),
                    ]),
                    style: HnType.body(p.ink, size: 13).copyWith(height: 1.45),
                  ),
                ),
                const SizedBox(width: 12),
                Text(_shortDate(r.date), style: HnType.body(p.mute, size: 12.5).copyWith(height: 1.5)),
              ],
            ),
          ),
      ],
    );
  }

  /// `July 2019 - July 2020` → `2019–20`.
  static String _shortDate(String date) {
    final years = RegExp(r'\d{4}').allMatches(date).map((m) => m.group(0)!).toList();
    if (years.isEmpty) return date;
    if (years.length == 1 || years.first == years.last) return years.first;
    return '${years.first}–${years.last.substring(2)}';
  }
}

/// The stop's response card. Its body types in once, the first time the
/// camera lands on this stop: evidence arriving as the place does.
class _StopResponse extends StatefulWidget {
  final JourneyStop stop;
  final int index;
  final ValueListenable<DateTime> clock;
  final ValueListenable<int> activeStop;
  final bool reduceMotion;

  const _StopResponse({
    required this.stop,
    required this.index,
    required this.clock,
    required this.activeStop,
    required this.reduceMotion,
  });

  @override
  State<_StopResponse> createState() => _StopResponseState();
}

class _StopResponseState extends State<_StopResponse> with SingleTickerProviderStateMixin {
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 180 + 110 * (widget.stop.facts.length + 2)),
  );

  @override
  void initState() {
    super.initState();
    widget.activeStop.addListener(_check);
    _check();
  }

  void _check() {
    if (widget.activeStop.value != widget.index || _reveal.isAnimating || _reveal.value > 0) return;
    if (widget.reduceMotion) {
      _reveal.value = 1;
    } else {
      _reveal.forward();
    }
  }

  @override
  void dispose() {
    widget.activeStop.removeListener(_check);
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_reveal, widget.clock]),
      builder: (context, _) {
        final utc = widget.clock.value.toUtc();
        final local = localTime(widget.stop.zone, utc);
        final time = '${hhmm(local.time)} ${local.zone}';
        return ResponseBlock(
          path: '/stops/${widget.stop.id}',
          status: '200 OK · $time',
          reveal: _reveal.value,
          body: {
            ...widget.stop.facts,
            'local_time': time,
            'sun': sunState(widget.stop.lon, widget.stop.lat, utc),
          },
        );
      },
    );
  }
}
