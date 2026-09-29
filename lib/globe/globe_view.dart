import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/motion_prefs.dart';
import '../models/journey_stop.dart';
import '../theme/hn_theme.dart';
import 'globe_math.dart';

/// Shader program and baked textures, loaded once per session.
class GlobeAssets {
  final ui.FragmentProgram program;
  final ui.Image mask;
  final ui.Image aux;

  const GlobeAssets._(this.program, this.mask, this.aux);

  static Future<GlobeAssets>? _future;

  static Future<GlobeAssets> load() => _future ??= _load();

  static Future<GlobeAssets> _load() async {
    final results = await Future.wait<Object>([
      ui.FragmentProgram.fromAsset('shaders/globe.frag'),
      _image('assets/globe/land_mask.webp'),
      _image('assets/globe/earth_aux.webp'),
    ]);
    return GlobeAssets._(
      results[0] as ui.FragmentProgram,
      results[1] as ui.Image,
      results[2] as ui.Image,
    );
  }

  static Future<ui.Image> _image(String path) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    return (await codec.getNextFrame()).image;
  }
}

/// The dithered globe, its stop markers and labels. Repaints whenever
/// [frame] or [clock] changes, without rebuilding the widget tree.
class GlobeView extends StatefulWidget {
  final ValueListenable<GlobeFrame> frame;
  final ValueListenable<DateTime> clock;
  final List<JourneyStop> stops;

  const GlobeView({
    super.key,
    required this.frame,
    required this.clock,
    required this.stops,
  });

  @override
  State<GlobeView> createState() => _GlobeViewState();
}

class _GlobeViewState extends State<GlobeView> {
  GlobeAssets? _assets;
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    GlobeAssets.load().then((a) {
      if (!mounted) return;
      setState(() {
        _assets = a;
        _shader = a.program.fragmentShader();
      });
    });
  }

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = HnPalette.of(context);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final repaint = Listenable.merge([widget.frame, widget.clock]);
    final assets = _assets, shader = _shader;
    if (assets == null || shader == null) return const SizedBox.expand();
    // Markers and routes appear with the planet, never over an empty page;
    // it fades in unless the reader asked for reduced motion.
    final still = browserPrefersReducedMotion() || MediaQuery.disableAnimationsOf(context);
    return ExcludeSemantics(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: still ? 1 : 0, end: 1),
        duration: still ? Duration.zero : const Duration(milliseconds: 420),
        curve: Curves.easeOut,
        builder: (context, t, child) => Opacity(opacity: t, child: child),
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _GlobePainter(
              shader: shader,
              assets: assets,
              frame: widget.frame,
              clock: widget.clock,
              palette: palette,
              dpr: dpr,
              repaint: repaint,
            ),
            foregroundPainter: _MarksPainter(
              frame: widget.frame,
              clock: widget.clock,
              stops: widget.stops,
              palette: palette,
              repaint: repaint,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _GlobePainter extends CustomPainter {
  final ui.FragmentShader shader;
  final GlobeAssets assets;
  final ValueListenable<GlobeFrame> frame;
  final ValueListenable<DateTime> clock;
  final HnPalette palette;
  final double dpr;

  _GlobePainter({
    required this.shader,
    required this.assets,
    required this.frame,
    required this.clock,
    required this.palette,
    required this.dpr,
    required Listenable repaint,
  }) : super(repaint: repaint);

  static const double cell = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final f = frame.value, cam = f.camera, c = cam.center;
    final sun = subsolarPoint(clock.value.toUtc());
    final (sx, sy, sz) = cam.toView(sun.lon, sun.lat);
    var i = 0;
    void put(double v) => shader.setFloat(i++, v);
    void color(Color col) {
      put(col.r);
      put(col.g);
      put(col.b);
      put(col.a);
    }

    put(size.width);
    put(size.height);
    put(cell);
    put(c.dx);
    put(c.dy);
    put(cam.radius);
    put(cam.lon0 * math.pi / 180);
    put(cam.lat0 * math.pi / 180);
    put(sx);
    put(sy);
    put(sz);
    color(palette.ink);
    color(palette.paper);
    color(palette.accent);
    put(f.fadeX0);
    put(f.fadeX1);
    put(f.fadeY0);
    put(f.fadeY1);
    put(palette.paper.computeLuminance() < 0.5 ? 1 : 0);
    shader.setImageSampler(0, assets.mask, filterQuality: FilterQuality.low);
    shader.setImageSampler(1, assets.aux, filterQuality: FilterQuality.low);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_GlobePainter old) =>
      old.palette != palette || old.dpr != dpr || old.shader != shader;
}

class _MarksPainter extends CustomPainter {
  final ValueListenable<GlobeFrame> frame;
  final ValueListenable<DateTime> clock;
  final List<JourneyStop> stops;
  final HnPalette palette;

  _MarksPainter({
    required this.frame,
    required this.clock,
    required this.stops,
    required this.palette,
    required Listenable repaint,
  }) : super(repaint: repaint);

  bool _visible(GlobeFrame f, Offset p, Size size) {
    if (p.dx < 8 ||
        p.dy < HnLayout.navHeight ||
        p.dx > size.width - 8 ||
        p.dy > size.height - 8) {
      return false;
    }
    if (f.fadeX1 > f.fadeX0 && p.dx < (f.fadeX0 + f.fadeX1) / 2) return false;
    if (f.fadeY1 > f.fadeY0 && p.dy > (f.fadeY0 + f.fadeY1) / 2) return false;
    return true;
  }

  List<Offset?> _arc(GlobeCamera cam, JourneyStop a, JourneyStop b) {
    final n = (angularDistance(a.lon, a.lat, b.lon, b.lat) * 1.5)
        .clamp(12, 220)
        .round();
    return [
      for (var k = 0; k <= n; k++)
        (() {
          final (lon, lat) = slerpLonLat(a.lon, a.lat, b.lon, b.lat, k / n);
          return cam.project(lon, lat);
        })(),
    ];
  }

  void _dotted(
      Canvas canvas, List<Offset?> pts, Paint paint, GlobeFrame f, Size size,
      {double on = 2, double off = 5}) {
    final period = on + off;
    var acc = 0.0;
    for (var k = 0; k + 1 < pts.length; k++) {
      final a = pts[k], b = pts[k + 1];
      if (a == null ||
          b == null ||
          !_visible(f, a, size) ||
          !_visible(f, b, size)) {
        continue;
      }
      final seg = b - a, len = seg.distance;
      if (len == 0) continue;
      final dir = seg / len;
      final phase = acc % period;
      if (phase > 0 && phase < on) {
        canvas.drawLine(a, a + dir * math.min(len, on - phase), paint);
      }
      for (var s = (period - phase) % period; s < len; s += period) {
        canvas.drawLine(a + dir * s, a + dir * math.min(len, s + on), paint);
      }
      acc += len;
    }
  }

  TextPainter _text(String text, Color color) => TextPainter(
        text: TextSpan(text: text, style: HnType.label(color, size: 11.5)),
        textDirection: TextDirection.ltr,
      )..layout();

  /// Box for a label anchored at [at], kept inside the frame.
  Rect _place(Size size, TextPainter tp, Offset at) {
    final w = tp.width + 16, h = tp.height + 8;
    final bottom = size.height - HnLayout.laneHeight - 24;
    final x = at.dx.clamp(8.0, math.max(8.0, size.width - 12 - w)).toDouble();
    final y = at.dy.clamp(HnLayout.navHeight + 8, math.max(HnLayout.navHeight + 8, bottom - h)).toDouble();
    return Rect.fromLTWH(x, y, w, h);
  }

  void _draw(Canvas canvas, Rect r, TextPainter tp, Color border) {
    canvas.drawRect(r, Paint()..color = palette.paper);
    canvas.drawRect(
      r,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    tp.paint(canvas, r.topLeft + const Offset(8, 4));
  }

  Rect _label(Canvas canvas, Size size, String text, Offset at, {required bool strong, Color? color}) {
    final tp = _text(text, color ?? (strong ? palette.ink : palette.mute));
    final r = _place(size, tp, at);
    _draw(canvas, r, tp, color ?? (strong ? palette.ink : palette.hair));
    return r;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final f = frame.value, cam = f.camera;
    final now = clock.value.toUtc();
    // Routes are ink; the accent is kept for places and the live terminator.
    final route = Paint()
      ..color = palette.ink
      ..strokeWidth = 1.75
      ..strokeCap = StrokeCap.square;
    // Paper casing under lines so they read against the dither.
    final casing = Paint()
      ..color = palette.paper
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    void cased(List<Offset?> pts, Paint p, {double on = 2, double off = 5}) {
      _dotted(canvas, pts, casing, f, size, on: on, off: off);
      _dotted(canvas, pts, p, f, size, on: on, off: off);
    }

    void stopMark(Offset p) {
      canvas.drawRect(Rect.fromCenter(center: p, width: 11, height: 11),
          Paint()..color = palette.paper);
      canvas.drawRect(Rect.fromCenter(center: p, width: 7, height: 7),
          Paint()..color = palette.accent);
    }

    if (f.activeStop < 0) {
      // Hero: the whole route, faint, with every stop marked.
      for (var i = 0; i + 1 < stops.length; i++) {
        cased(_arc(cam, stops[i], stops[i + 1]), route, on: 3, off: 5);
      }
      for (final s in stops) {
        final p = cam.project(s.lon, s.lat);
        if (p == null || !_visible(f, p, size)) continue;
        stopMark(p);
      }
      _terminatorLabel(canvas, size, f, now);
      return;
    }

    final i = f.activeStop, s = stops[i];
    final ink = Paint()
      ..color = palette.ink
      ..strokeWidth = 1;
    if (i > 0) cased(_arc(cam, stops[i - 1], s), route, on: 3, off: 4);
    List<Offset?> nextArc = const [];
    if (i + 1 < stops.length) {
      nextArc = _arc(cam, s, stops[i + 1]);
      cased(
          nextArc,
          Paint()
            ..color = palette.ink
            ..strokeWidth = 1.5,
          on: 1.5,
          off: 5);
    }
    final p = cam.project(s.lon, s.lat);
    final showActive = p != null && _visible(f, p, size);
    final settle = (1 - f.inFlight * 2).clamp(0.0, 1.0);
    final arm = 48 * settle + 10;

    // Everything drawn near the active stop reserves its space, so the
    // other labels can step around it.
    final occupied = <Rect>[];
    TextPainter? activeText;
    Rect? activeBox;
    if (showActive) {
      occupied.add(Rect.fromCenter(center: p, width: (arm + 12) * 2, height: (arm + 12) * 2));
      if (settle > 0.5) {
        final local = localTime(s.zone, now);
        activeText = _text(
          '${s.code} · ${formatLat(s.lat)} ${formatLon(s.lon)} · ${hhmm(local.time)} ${local.zone}',
          palette.ink,
        );
        var box = _place(size, activeText, p + const Offset(30, 30));
        if (box.top < p.dy) box = _place(size, activeText, p + Offset(30, -30 - box.height));
        activeBox = box;
        occupied.add(box);
      }
    }

    for (var k = 0; k < stops.length; k++) {
      if (k == i) continue;
      final q = cam.project(stops[k].lon, stops[k].lat);
      if (q == null || !_visible(f, q, size)) continue;
      canvas.drawRect(Rect.fromCenter(center: q, width: 8, height: 8), Paint()..color = palette.paper);
      canvas.drawRect(
        Rect.fromCenter(center: q, width: 8, height: 8),
        Paint()
          ..color = palette.ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      occupied.add(Rect.fromCenter(center: q, width: 14, height: 14));
      if (f.inFlight >= 0.3 || k == i + 1) continue;
      final tp = _text(stops[k].code, palette.mute);
      final r = _place(size, tp, q + const Offset(12, -26));
      if (occupied.any((o) => o.overlaps(r.inflate(3)))) continue;
      _draw(canvas, r, tp, palette.hair);
      occupied.add(r);
    }

    // Where the route goes next: at the next stop if it is on screen,
    // otherwise where its leg leaves the frame. Tries positions around the
    // anchor and skips the label rather than let it touch another mark.
    if (i + 1 < stops.length && f.inFlight < 0.3) {
      final next = stops[i + 1];
      Offset? at = cam.project(next.lon, next.lat);
      if (at == null || !_visible(f, at, size)) {
        at = null;
        for (final q in nextArc) {
          if (q != null && _visible(f, q, size)) at = q;
        }
      }
      if (at != null) {
        final tp = _text('→ NEXT: ${next.city.toUpperCase()}', palette.ink);
        final w = tp.width + 16;
        final candidates = [
          const Offset(14, 10),
          const Offset(14, -34),
          Offset(-w - 14, -34),
          Offset(-w - 14, 10),
          const Offset(14, 44),
          Offset(-w - 14, 44),
          const Offset(14, -68),
          Offset(-w - 14, -68),
          Offset(-w / 2, -88),
          Offset(-w / 2, 78),
        ];
        for (final c in candidates) {
          final r = _place(size, tp, at + c);
          if (occupied.any((o) => o.overlaps(r.inflate(4)))) continue;
          _draw(canvas, r, tp, palette.hair);
          occupied.add(r);
          break;
        }
      }
    }

    if (!showActive) return;
    final halo = Paint()
      ..color = palette.paper
      ..strokeWidth = 4;
    for (final l in [
      [p.translate(-arm - 9, 0), p.translate(-9, 0)],
      [p.translate(9, 0), p.translate(arm + 9, 0)],
      [p.translate(0, -arm - 9), p.translate(0, -9)],
      [p.translate(0, 9), p.translate(0, arm + 9)],
    ]) {
      canvas.drawLine(l[0], l[1], halo);
    }
    canvas.drawCircle(
      p,
      22,
      Paint()
        ..color = palette.paper
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.drawLine(p.translate(-arm - 9, 0), p.translate(-9, 0), ink);
    canvas.drawLine(p.translate(9, 0), p.translate(arm + 9, 0), ink);
    canvas.drawLine(p.translate(0, -arm - 9), p.translate(0, -9), ink);
    canvas.drawLine(p.translate(0, 9), p.translate(0, arm + 9), ink);
    canvas.drawRect(Rect.fromCenter(center: p, width: 10, height: 10), Paint()..color = palette.ink);
    canvas.drawCircle(
      p,
      22,
      Paint()
        ..color = palette.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    if (activeText != null && activeBox != null) _draw(canvas, activeBox, activeText, palette.ink);
  }

  /// Names the live day/night line where it crosses the visible disc.
  void _terminatorLabel(Canvas canvas, Size size, GlobeFrame f, DateTime now) {
    Offset? best;
    for (final (lon, lat) in terminatorPoints(now, n: 240)) {
      final q = f.camera.project(lon, lat);
      if (q == null || !_visible(f, q, size)) continue;
      final inset = f.camera.radius - (q - f.camera.center).distance;
      if (inset < 36) continue;
      if (best == null || q.dy < best.dy) best = q;
    }
    if (best == null) return;
    _label(canvas, size, 'DAY / NIGHT · LIVE', best + const Offset(10, 6),
        strong: false, color: palette.accent);
  }

  @override
  bool shouldRepaint(_MarksPainter old) =>
      old.palette != palette || old.stops != stops;
}
