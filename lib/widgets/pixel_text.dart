import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/hn_theme.dart';

/// A procedural bitmap serif: the text is set in Libre Caslon at
/// `size / scale`, rasterised, hard-thresholded to one colour, and drawn
/// back up with nearest-neighbour sampling, so every glyph edge steps in
/// `scale`-px pixels. Screen readers get the plain string.
class PixelText extends StatelessWidget {
  final String text;
  final double size;
  final int scale;
  final Color? color;
  final bool header;

  /// Shrinks [size] (in whole pixels of the base face) until a single
  /// line fits the available width.
  final bool fitOneLine;

  const PixelText(
    this.text, {
    super.key,
    required this.size,
    this.scale = 4,
    this.color,
    this.header = false,
    this.fitOneLine = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? HnPalette.of(context).ink;
    return Semantics(
      label: text,
      header: header,
      excludeSemantics: true,
      child: ListenableBuilder(
        // Rebuild when a raster finishes, or when a font loads late.
        listenable: Listenable.merge([_PixelRaster.ready, PaintingBinding.instance.systemFonts]),
        builder: (context, _) => LayoutBuilder(
          builder: (context, constraints) {
            final raster = _PixelRaster.obtain(
              text: text,
              size: size,
              scale: scale,
              color: c,
              maxWidth: constraints.maxWidth,
              fitOneLine: fitOneLine,
            );
            return SizedBox(
              width: raster.width * scale.toDouble(),
              height: raster.height * scale.toDouble(),
              child: raster.image == null ? null : CustomPaint(painter: _PixelPainter(raster, raster.image!)),
            );
          },
        ),
      ),
    );
  }
}

class _PixelRaster {
  final int width;
  final int height;
  ui.Image? image;

  _PixelRaster(this.width, this.height);

  static final Map<String, _PixelRaster> _cache = {};

  /// Bumped whenever a raster finishes, so waiting PixelTexts repaint.
  static final ValueNotifier<int> ready = ValueNotifier(0);
  static bool _listening = false;

  static _PixelRaster obtain({
    required String text,
    required double size,
    required int scale,
    required Color color,
    required double maxWidth,
    required bool fitOneLine,
  }) {
    // Rasters made before a font load used fallback glyphs.
    if (!_listening) {
      PaintingBinding.instance.systemFonts.addListener(_cache.clear);
      _listening = true;
    }
    var base = (size / scale).roundToDouble();
    final limit = maxWidth.isFinite ? maxWidth / scale : double.infinity;
    TextPainter layout(double fs) {
      return TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: HnType.serif,
            fontSize: fs,
            // Hairlines vanish at small sizes; a heavier cut keeps them.
            fontWeight: fs < 15 ? FontWeight.w600 : (fs < 20 ? FontWeight.w500 : FontWeight.w400),
            height: 1.08,
            letterSpacing: fs > 18 ? -0.25 : 0,
            color: const Color(0xFF000000),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: fitOneLine ? double.infinity : limit);
    }

    var tp = layout(base);
    while (fitOneLine && tp.width > limit && base > 8) {
      base -= 1;
      tp = layout(base);
    }
    final w = tp.width.ceil() + 2, h = (tp.height + base * 0.12).ceil();
    final key = '$text|$base|$scale|${color.toARGB32()}|${w}x$h';
    final hit = _cache[key];
    if (hit != null) return hit;

    final raster = _cache[key] = _PixelRaster(w, h);
    final recorder = ui.PictureRecorder();
    tp.paint(Canvas(recorder), const Offset(1, 0));
    _threshold(recorder.endRecording(), w, h, color, base < 15 ? 96 : 112).then((img) {
      raster.image = img;
      ready.value++;
    });
    return raster;
  }

  static Future<ui.Image> _threshold(ui.Picture picture, int w, int h, Color color, int cutoff) async {
    final src = await picture.toImage(w, h);
    final data = await src.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
    src.dispose();
    picture.dispose();
    final inBytes = data!.buffer.asUint8List();
    final out = Uint8List(inBytes.length);
    final r = (color.r * 255).round(), g = (color.g * 255).round(), b = (color.b * 255).round();
    for (var i = 0; i < inBytes.length; i += 4) {
      if (inBytes[i + 3] >= cutoff) {
        out[i] = r;
        out[i + 1] = g;
        out[i + 2] = b;
        out[i + 3] = 255;
      }
    }
    final buffer = await ui.ImmutableBuffer.fromUint8List(out);
    final descriptor = ui.ImageDescriptor.raw(buffer, width: w, height: h, pixelFormat: ui.PixelFormat.rgba8888);
    final codec = await descriptor.instantiateCodec();
    return (await codec.getNextFrame()).image;
  }
}

class _PixelPainter extends CustomPainter {
  final _PixelRaster raster;
  final ui.Image image;

  _PixelPainter(this.raster, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, raster.width.toDouble(), raster.height.toDouble()),
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  @override
  bool shouldRepaint(_PixelPainter old) => old.image != image;
}
