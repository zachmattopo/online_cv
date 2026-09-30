import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/journey_stop.dart';
import '../theme/hn_theme.dart';
import 'hn_widgets.dart';
import 'pixel_icon.dart';

/// The skim path: search any stop, company, stack or year, or jump
/// straight to a stop. Pinned to the bottom of every section.
class FastLane extends StatefulWidget {
  final List<JourneyStop> stops;
  final ValueListenable<int> active;
  final ValueChanged<int> onJump;
  final VoidCallback onPlainCv;

  /// Easter egg: fired when someone tries `sudo` in the search.
  final VoidCallback onSudo;

  const FastLane({
    super.key,
    required this.stops,
    required this.active,
    required this.onJump,
    required this.onPlainCv,
    required this.onSudo,
  });

  @override
  State<FastLane> createState() => _FastLaneState();
}

class _FastLaneState extends State<FastLane> {
  final TextEditingController _query = TextEditingController();
  final ScrollController _chipScroll = ScrollController();
  late List<GlobalKey> _chipKeys = _keys();

  List<GlobalKey> _keys() => [for (final _ in widget.stops) GlobalKey()];

  @override
  void initState() {
    super.initState();
    widget.active.addListener(_revealActive);
  }

  @override
  void didUpdateWidget(FastLane old) {
    super.didUpdateWidget(old);
    if (old.active != widget.active) {
      old.active.removeListener(_revealActive);
      widget.active.addListener(_revealActive);
    }
    if (old.stops.length != widget.stops.length) _chipKeys = _keys();
  }

  @override
  void dispose() {
    widget.active.removeListener(_revealActive);
    _query.dispose();
    _chipScroll.dispose();
    super.dispose();
  }

  /// Keeps the active stop's chip in view as the camera moves on.
  void _revealActive() {
    final i = widget.active.value;
    if (i < 0 || i >= _chipKeys.length) return;
    final ctx = _chipKeys[i].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.5,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  List<int> get _matches {
    final q = _query.text.trim().toLowerCase();
    if (q.isEmpty) return [for (var i = 0; i < widget.stops.length; i++) i];
    final terms = q.split(RegExp(r'\s+'));
    return [
      for (var i = 0; i < widget.stops.length; i++)
        if (terms.every(widget.stops[i].searchText.contains)) i,
    ];
  }

  /// `sudo` or `sudo anything`: permission denied, the classic way.
  bool get _isSudo {
    final q = _query.text.trim().toLowerCase();
    return q == 'sudo' || q.startsWith('sudo ');
  }

  bool _wasSudo = false;

  void _changed(String _) {
    // Shake once on entering the command, not on every keystroke after it.
    if (_isSudo && !_wasSudo) widget.onSudo();
    _wasSudo = _isSudo;
    setState(() {});
  }

  void _submit(String _) {
    if (_isSudo) {
      widget.onSudo();
      return;
    }
    final m = _matches;
    if (m.isNotEmpty) widget.onJump(m.first);
  }

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= HnLayout.desktopBreakpoint;
    final matches = _matches.toSet();
    final query = _query.text.trim();

    final chips = ValueListenableBuilder<int>(
      valueListenable: widget.active,
      builder: (context, active, _) => _EdgeFade(
        controller: _chipScroll,
        child: SingleChildScrollView(
          controller: _chipScroll,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < widget.stops.length; i++)
                Padding(
                  key: _chipKeys[i],
                  padding: const EdgeInsets.only(right: 8),
                  child: _StopChip(
                    stop: widget.stops[i],
                    active: i == active,
                    dimmed: !matches.contains(i),
                    onTap: () => widget.onJump(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (!desktop) {
      return Container(
        height: 56,
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(color: p.paper, border: Border(top: BorderSide(color: p.hair))),
        child: Row(
          children: [
            Expanded(child: chips),
            Pressable(
              onTap: widget.onPlainCv,
              semanticLabel: 'Plain CV',
              builder: (context, hover, focus) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(border: Border(left: BorderSide(color: p.hair))),
                child: Text('CV ↓', style: HnType.label(p.ink)),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
      child: Container(
        height: HnLayout.laneHeight,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: p.paper,
          border: Border.all(color: Color.lerp(p.hair, p.ink, 0.12)!),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            PixelIcon(PixelGlyph.search, color: p.accent, cell: 1.5),
            const SizedBox(width: 8),
            SizedBox(
              width: (width * 0.16 - 40).clamp(160.0, 260.0),
              child: TextField(
                controller: _query,
                onChanged: _changed,
                onSubmitted: _submit,
                cursorColor: p.accent,
                style: HnType.body(p.ink, size: 13.5).copyWith(height: 1.3),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'City, company, year',
                  hintStyle: HnType.body(p.mute, size: 13.5).copyWith(height: 1.3),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _isSudo
                  ? Text(
                      'hafiz is not in the sudoers file. This incident will be reported.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HnType.body(p.ink, size: 12.5, weight: FontWeight.w500).copyWith(height: 1.3),
                    )
                  : query.isNotEmpty && matches.isEmpty
                  ? Text('No stop matches “$query”. Try a company or a year.',
                      style: HnType.body(p.mute, size: 12.5).copyWith(height: 1.3))
                  : chips,
            ),
            const SizedBox(width: 12),
            HnTextLink('Plain CV ↓', onTap: widget.onPlainCv, arrow: false, size: 12),
          ],
        ),
      ),
    );
  }
}

/// Fades an edge of the chip scroller only while chips are hidden past
/// it, so a fully visible row is never washed out.
class _EdgeFade extends StatefulWidget {
  final ScrollController controller;
  final Widget child;

  const _EdgeFade({required this.controller, required this.child});

  @override
  State<_EdgeFade> createState() => _EdgeFadeState();
}

class _EdgeFadeState extends State<_EdgeFade> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        var lead = false, trail = false;
        if (controller.hasClients && controller.position.hasContentDimensions) {
          final pos = controller.position;
          lead = pos.pixels > 1;
          trail = pos.pixels < pos.maxScrollExtent - 1;
        }
        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (rect) => LinearGradient(
            colors: [
              lead ? const Color(0x00000000) : const Color(0xFF000000),
              const Color(0xFF000000),
              const Color(0xFF000000),
              trail ? const Color(0x00000000) : const Color(0xFF000000),
            ],
            stops: const [0, 0.06, 0.92, 1],
          ).createShader(rect),
          child: child,
        );
      },
      // Re-evaluate once the row lays out or the lane resizes.
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (_) {
          setState(() {});
          return false;
        },
        child: widget.child,
      ),
    );
  }
}

class _StopChip extends StatelessWidget {
  final JourneyStop stop;
  final bool active;
  final bool dimmed;
  final VoidCallback onTap;

  const _StopChip({required this.stop, required this.active, required this.dimmed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return Pressable(
      onTap: onTap,
      semanticLabel: 'Fly to ${stop.city}, ${stop.year}',
      builder: (context, hover, focus) {
        final fg = active ? p.onAccent : p.ink;
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          opacity: dimmed ? 0.35 : 1,
          // Instant, so text and fill always change together.
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: active ? p.accent : (hover ? p.wash : p.paper),
              border: Border.all(color: active ? p.accent : p.hair),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: stop.city.toLowerCase()),
                TextSpan(
                  text: '  ${stop.year}',
                  style: TextStyle(color: active ? p.onAccent.withValues(alpha: 0.75) : p.mute, fontSize: 11.5),
                ),
              ]),
              style: HnType.body(fg, size: 12.5).copyWith(height: 1.2),
            ),
          ),
        );
      },
    );
  }
}
