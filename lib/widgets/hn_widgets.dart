import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';

import '../theme/hn_theme.dart';
import 'pixel_text.dart';

/// Mono paragraph where `**double asterisks**` mark bold runs.
class MarkupText extends StatelessWidget {
  final String source;
  final double size;
  final Color? color;

  const MarkupText(this.source, {super.key, this.size = 14.5, this.color});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final base = HnType.body(color ?? p.ink.withValues(alpha: 0.86), size: size);
    final parts = source.split('**');
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(
              text: parts[i],
              style: i.isOdd ? TextStyle(fontWeight: FontWeight.w700, color: p.ink) : null,
            ),
        ],
      ),
    );
  }
}

/// Pixel-serif heading with a grey pixel-serif line under it.
class SectionHead extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double size;

  const SectionHead({super.key, required this.title, this.subtitle, this.size = 72});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final narrow = !HnLayout.isDesktop(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PixelText(title, size: narrow ? size * 0.72 : size, scale: narrow ? 3 : 4, header: true, fitOneLine: true),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          PixelText(subtitle!, size: narrow ? 28 : 32, scale: 2, color: p.mute),
        ],
      ],
    );
  }
}

/// Hover/focus aware tap target with keyboard activation.
class Pressable extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget Function(BuildContext context, bool hovered, bool focused) builder;
  final bool isLink;
  final String? semanticLabel;

  const Pressable({super.key, required this.onTap, required this.builder, this.isLink = false, this.semanticLabel});

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _hover = false;
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return Semantics(
      button: !widget.isLink,
      link: widget.isLink,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        enabled: widget.onTap != null,
        mouseCursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        onShowHoverHighlight: (v) => setState(() => _hover = v),
        onShowFocusHighlight: (v) => setState(() => _focus = v),
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onTap?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: _focus ? Border.all(color: p.accent, width: 2) : null,
              borderRadius: BorderRadius.circular(5),
            ),
            child: widget.builder(context, _hover, _focus),
          ),
        ),
      ),
    );
  }
}

/// External link rendered as a real anchor on the web.
class HnExternal extends StatelessWidget {
  final String url;
  final Widget Function(BuildContext context, bool hovered, bool focused) builder;

  const HnExternal({super.key, required this.url, required this.builder});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(url);
    return Link(
      uri: uri,
      target: url.startsWith('mailto:') ? LinkTarget.self : LinkTarget.blank,
      builder: (context, follow) => Pressable(onTap: follow, isLink: true, builder: builder),
    );
  }
}

/// Mono text link with an underline that darkens on hover.
class HnTextLink extends StatelessWidget {
  final String label;
  final String? url;
  final VoidCallback? onTap;
  final double size;
  final bool arrow;

  const HnTextLink(this.label, {super.key, this.url, this.onTap, this.size = 12.5, this.arrow = true});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    Widget build(BuildContext context, bool hover, bool focus) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          arrow ? '$label ↗' : label,
          style: HnType.body(hover ? p.accent : p.ink, size: size).copyWith(
            height: 1.4,
            decoration: TextDecoration.underline,
            decorationColor: hover ? p.accent : p.ink.withValues(alpha: 0.4),
            decorationThickness: 1,
          ),
        ),
      );
    }

    if (url != null) return HnExternal(url: url!, builder: build);
    return Pressable(onTap: onTap, isLink: true, builder: build);
  }
}

/// Black button with tracked caps, or its outlined sibling.
class HnButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onTap;
  final String? url;
  final bool compact;

  const HnButton(this.label, {super.key, this.filled = true, this.onTap, this.url, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    Widget build(BuildContext context, bool hover, bool focus) {
      final bg = filled ? (hover ? p.accent : p.ink) : (hover ? p.wash : p.paper);
      final fg = filled ? (hover ? p.onAccent : p.paper) : p.ink;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 18, vertical: compact ? 9 : 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: filled ? bg : p.hair),
        ),
        child: Text(label.toUpperCase(), style: HnType.label(fg, size: compact ? 11.5 : 12, weight: FontWeight.w600)),
      );
    }

    if (url != null) return HnExternal(url: url!, builder: build);
    return Pressable(onTap: onTap, builder: build);
  }
}

/// Small status dot (green means live / OK and nothing else).
class LiveDot extends StatelessWidget {
  final double size;

  const LiveDot({super.key, this.size = 7});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: p.go,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: p.go.withValues(alpha: 0.18), spreadRadius: 3)],
      ),
    );
  }
}

/// The profile photo at 16×16, scaled up nearest-neighbour.
class PixelAvatar extends StatelessWidget {
  final double size;

  const PixelAvatar({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return Semantics(
      label: 'Photo of Hafiz Nordin',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(border: Border.all(color: p.ink, width: 1)),
        child: Image.asset(
          'assets/images/splash_image.png',
          cacheWidth: 16,
          cacheHeight: 16,
          width: size,
          height: size,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}

/// A request line plus a pretty-printed JSON response, in the pale slate
/// code tint (the one broad use of the photo's blue).
class ResponseBlock extends StatelessWidget {
  final String method;
  final String path;
  final String status;
  final Map<String, Object> body;

  /// 0–1: how much of the body has arrived. Unarrived lines keep their
  /// space (drawn transparent) so the page never reflows.
  final double reveal;

  const ResponseBlock({
    super.key,
    this.method = 'GET',
    required this.path,
    required this.status,
    required this.body,
    this.reveal = 1,
  });

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final keyStyle = HnType.body(p.codeInk, size: 13).copyWith(height: 1.75);
    final strStyle = keyStyle.copyWith(color: Color.lerp(p.codeInk, p.accent, 0.65));
    final punct = keyStyle.copyWith(color: p.codeMute);

    List<InlineSpan> value(Object v) {
      if (v is List) {
        return [
          TextSpan(text: '[', style: punct),
          for (var i = 0; i < v.length; i++) ...[
            ...value(v[i] as Object),
            if (i < v.length - 1) TextSpan(text: ', ', style: punct),
          ],
          TextSpan(text: ']', style: punct),
        ];
      }
      if (v is num) return [TextSpan(text: '$v', style: strStyle.copyWith(fontWeight: FontWeight.w600))];
      return [TextSpan(text: '"$v"', style: strStyle)];
    }

    final entries = body.entries.toList();
    final shown = (reveal * entries.length).ceil();
    final done = reveal >= 1;
    TextStyle hide(TextStyle s, int i) => i < shown ? s : s.copyWith(color: const Color(0x00000000));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: BoxDecoration(color: p.code, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 4,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(text: '$method ', style: keyStyle.copyWith(fontWeight: FontWeight.w700)),
                TextSpan(text: path, style: keyStyle),
              ])),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (done)
                    const LiveDot(size: 7)
                  else
                    Container(width: 7, height: 7, decoration: BoxDecoration(color: p.codeMute, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(done ? status : 'pending…', style: keyStyle.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: '{\n', style: punct),
              for (var i = 0; i < entries.length; i++)
                TextSpan(
                  children: [
                    TextSpan(text: '  "${entries[i].key}"', style: hide(keyStyle, i)),
                    TextSpan(text: ': ', style: hide(punct, i)),
                    for (final s in value(entries[i].value))
                      s is TextSpan ? TextSpan(text: s.text, style: hide(s.style ?? keyStyle, i)) : s,
                    TextSpan(text: i < entries.length - 1 ? ',\n' : '\n', style: hide(punct, i)),
                  ],
                ),
              TextSpan(text: '}', style: punct),
            ]),
          ),
        ],
      ),
    );
  }
}

/// Uppercase caption in the label style.
class Caption extends StatelessWidget {
  final String text;
  final Color? color;

  const Caption(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: HnType.label(color ?? HnPalette.of(context).mute));
  }
}

/// A band of ordered dither that fades from dense to empty: the globe's
/// material, used as the rule that opens each later section.
class DitherRule extends StatelessWidget {
  final double height;

  const DitherRule({super.key, this.height = 8});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _DitherRulePainter(HnPalette.of(context).ink)),
      ),
    );
  }
}

class _DitherRulePainter extends CustomPainter {
  final Color ink;

  _DitherRulePainter(this.ink);

  static const List<int> _bayer = [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5];

  @override
  void paint(Canvas canvas, Size size) {
    const cell = 2.0;
    final paint = Paint()
      ..color = ink
      ..isAntiAlias = false;
    final cols = (size.width / cell).floor(), rows = (size.height / cell).floor();
    for (var x = 0; x < cols; x++) {
      final t = x / cols;
      final density = t < 0.55 ? 0.62 * (1 - t / 0.55) + 0.06 : 0.06 * (1 - (t - 0.55) / 0.45);
      for (var y = 0; y < rows; y++) {
        final thr = (_bayer[(y & 3) * 4 + (x & 3)] + 0.5) / 16;
        if (density > thr) canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DitherRulePainter old) => old.ink != ink;
}
