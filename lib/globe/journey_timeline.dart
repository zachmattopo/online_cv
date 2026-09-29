import 'dart:math' as math;

import 'package:flutter/animation.dart';

import '../models/journey_stop.dart';
import '../theme/hn_theme.dart';
import 'globe_math.dart';

/// Maps a scroll offset to the globe's camera. The camera holds on a stop
/// while its section is read, then flies to the next one along the great
/// circle; it never rests between stops.
class JourneyTimeline {
  final Size viewport;
  final List<JourneyStop> stops;

  /// Scroll offset at which each list item's top meets the viewport top.
  final List<double> offsets;

  /// Extent of each list item.
  final List<double> extents;

  /// Index of the first stop item in the list (the hero is item 0).
  final int firstStopItem;
  final bool reduceMotion;

  /// Where the hero globe faces: the idle spin plus any drag by the reader.
  final double heroLon;
  final double heroLat;

  const JourneyTimeline({
    required this.viewport,
    required this.stops,
    required this.offsets,
    required this.extents,
    required this.firstStopItem,
    required this.reduceMotion,
    required this.heroLon,
    this.heroLat = 24,
  });

  bool get desktop => viewport.width >= HnLayout.desktopBreakpoint;

  /// Height of the globe band on narrow screens.
  static double bandHeight(Size viewport) => (viewport.height * 0.42).clamp(260.0, 420.0);

  // How much closer each stop sits, tuned to the size of the land around it.
  static const Map<String, double> _zoom = {
    'ABZ': 1.0,
    'BHX': 1.0,
    'KUL': 1.3,
    'PEN': 1.4,
    'BNA': 0.85,
    'KBR': 1.35,
  };

  GlobeFrame heroFrame() {
    final w = viewport.width, h = viewport.height;
    if (desktop) {
      final colRight = HnLayout.gutter(w) + HnLayout.column(w);
      final r = math.min(w * 0.29, h * 0.40);
      final x = math.min(w * 0.71, w - r - 40);
      return GlobeFrame(
        camera: GlobeCamera(focusLon: heroLon, focusLat: heroLat, radius: r, anchor: Offset(x, h * 0.53)),
        fadeX0: colRight - 140,
        fadeX1: colRight - 40,
      );
    }
    final band = bandHeight(viewport);
    final r = math.min(w * 0.40, band * 0.44);
    return GlobeFrame(
      camera: GlobeCamera(
        focusLon: heroLon,
        focusLat: heroLat,
        radius: r,
        anchor: Offset(w / 2, HnLayout.navHeight + band * 0.52),
      ),
      fadeY0: HnLayout.navHeight + band - 36,
      fadeY1: HnLayout.navHeight + band,
    );
  }

  GlobeFrame stopFrame(int i) {
    final s = stops[i], w = viewport.width, h = viewport.height, zoom = _zoom[s.code] ?? 1.0;
    if (desktop) {
      final colRight = HnLayout.gutter(w) + HnLayout.column(w);
      final anchor = Offset(colRight + (w - colRight) * 0.45, h * 0.62);
      return GlobeFrame(
        camera: GlobeCamera.stop(
          lon: s.lon,
          lat: s.lat,
          radius: (w * 0.95).clamp(900.0, 2200.0) * zoom,
          anchor: anchor,
          horizonY: HnLayout.navHeight + 14,
        ),
        fadeX0: colRight + 8,
        fadeX1: colRight + 230,
        activeStop: i,
      );
    }
    final band = bandHeight(viewport);
    return GlobeFrame(
      camera: GlobeCamera.stop(
        lon: s.lon,
        lat: s.lat,
        radius: w * 2.1 * zoom,
        anchor: Offset(w * 0.5, HnLayout.navHeight + band * 0.64),
        horizonY: HnLayout.navHeight + 10,
      ),
      fadeY0: HnLayout.navHeight + band - 36,
      fadeY1: HnLayout.navHeight + band,
      activeStop: i,
    );
  }

  double _ease(double t) {
    final c = t.clamp(0.0, 1.0);
    if (reduceMotion) return c < 0.5 ? 0 : 1;
    return Curves.easeInOutCubic.transform(c);
  }

  double _arrive(int i) => offsets[firstStopItem + i] - viewport.height * 0.15;

  double _depart(int i) {
    final item = firstStopItem + i;
    return offsets[item] + extents[item] - viewport.height * 0.75;
  }

  /// Scroll offset that lands the camera on stop [i].
  double stopScrollOffset(int i) => offsets[firstStopItem + i];

  GlobeFrame frameAt(double scroll) {
    final hero = heroFrame();
    if (stops.isEmpty || offsets.length <= firstStopItem + stops.length - 1) return hero;
    final h = viewport.height;
    final a0 = _arrive(0), heroLeave = math.max(0.0, a0 - h * 0.7);

    if (scroll <= heroLeave) return hero;
    if (scroll < a0) {
      final raw = (scroll - heroLeave) / (a0 - heroLeave), t = _ease(raw), to = stopFrame(0);
      final cam = GlobeCamera.fly(hero.camera, to.camera, t);
      return GlobeFrame.lerpFade(hero, to, t, cam, t < 0.5 ? -1 : 0, math.sin(math.pi * raw));
    }
    for (var i = 0; i < stops.length; i++) {
      if (scroll <= _depart(i)) return stopFrame(i);
      if (i + 1 < stops.length && scroll < _arrive(i + 1)) {
        final d = _depart(i), a = _arrive(i + 1);
        final raw = (scroll - d) / (a - d), t = _ease(raw);
        final from = stopFrame(i), to = stopFrame(i + 1);
        final horizon = HnLayout.navHeight + (desktop ? 14.0 : 10.0);
        final cam = GlobeCamera.fly(from.camera, to.camera, t, horizonY: horizon);
        return GlobeFrame.lerpFade(from, to, t, cam, t < 0.5 ? i : i + 1, math.sin(math.pi * raw));
      }
    }
    // After the last stop the camera pulls back out to the whole planet.
    final last = stopFrame(stops.length - 1), d = _depart(stops.length - 1);
    final raw = ((scroll - d) / (h * 0.6)).clamp(0.0, 1.0), t = _ease(raw);
    final cam = GlobeCamera.fly(last.camera, hero.camera, t);
    return GlobeFrame.lerpFade(last, hero, t, cam, t < 0.5 ? stops.length - 1 : -1, math.sin(math.pi * raw));
  }

  /// The stop a reader is looking at, for the fast-lane chips (-1 in the hero).
  int activeStopAt(double scroll) {
    if (stops.isEmpty || offsets.length <= firstStopItem) return -1;
    final probe = scroll + viewport.height * 0.45;
    if (probe < offsets[firstStopItem] || probe >= journeyEnd) return -1;
    for (var i = stops.length - 1; i >= 0; i--) {
      if (probe >= offsets[firstStopItem + i]) return i;
    }
    return -1;
  }

  /// Offset of the first item after the journey.
  double get journeyEnd {
    final last = firstStopItem + stops.length - 1;
    if (offsets.length <= last) return double.infinity;
    return offsets[last] + extents[last];
  }
}
