import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';

import '../theme/hn_theme.dart';
import 'hn_widgets.dart';

/// Footer with the visitor counter badge and a link to its statistics.
/// Uses visitorbadge.io — a free, zero-config service that increments a
/// counter every time the badge image is loaded.
class VisitorCounterSection extends StatelessWidget {
  const VisitorCounterSection({super.key});

  static const String _badgeUrl =
      'https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fzachmattopo.github.io%2Fonline-cv-live%2F&labelColor=%236b6b66&countColor=%2355687c&style=flat&labelStyle=upper';

  static const String _statsUrl =
      'https://visitorbadge.io/status?path=https%3A%2F%2Fzachmattopo.github.io%2Fonline-cv-live%2F';

  // Retain one unreferenced image so revisiting this section doesn't refetch.
  static final ScalableImageCache _badgeCache = ScalableImageCache(size: 1);
  static final ScalableImageSource _badgeSource =
      ScalableImageSource.fromSvgHttpUrl(Uri.parse(_badgeUrl));

  /// Fetches the badge (which registers the visit) as soon as the page loads,
  /// instead of waiting for this lazily built footer to scroll into view. The
  /// reference is never released, so the footer reuses the cached badge
  /// without a second request.
  static void preload() {
    final si = _badgeCache.addReferenceV2(_badgeSource);
    if (si is Future<ScalableImage>) {
      // Errors are shown by the badge widget itself; avoid an unhandled error.
      si.ignore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= HnLayout.desktopBreakpoint;
    final note = HnType.body(p.mute, size: 12.5).copyWith(height: 1.5);

    final badge = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 110, maxWidth: 220, maxHeight: 20),
      child: ScalableImageWidget.fromSISource(
        si: _badgeSource,
        cache: _badgeCache,
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        onLoading: (_) => Text('Counting visits…', style: note, maxLines: 1),
        onError: (_) => Text('Counter offline', style: note, maxLines: 1),
      ),
    );

    final credit = Text(
      '© ${DateTime.now().year} Hafiz Nordin. Built in Flutter: one fragment shader, a lot of dither.',
      style: note,
    );

    return Container(
      color: p.paper,
      padding: EdgeInsets.fromLTRB(
        HnLayout.gutter(width),
        28,
        HnLayout.gutter(width),
        desktop ? HnLayout.laneHeight + 56 : 56 + 32,
      ),
      decoration: null,
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: p.hair))),
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: desktop
              ? Row(
                  children: [
                    Expanded(child: credit),
                    badge,
                    const SizedBox(width: 18),
                    const HnTextLink('Visitor stats', url: _statsUrl, size: 12.5),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    credit,
                    const SizedBox(height: 14),
                    Row(children: [badge, const SizedBox(width: 14), const HnTextLink('Visitor stats', url: _statsUrl, size: 12.5)]),
                  ],
                ),
        ),
      ),
    );
  }
}
