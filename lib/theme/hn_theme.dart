import 'package:flutter/material.dart';

/// Colour tokens for the "GET /hafiz" world: paper, ink and one slate blue
/// sampled from the profile photo, used sparingly for places and focus.
@immutable
class HnPalette extends ThemeExtension<HnPalette> {
  final Color paper;
  final Color ink;
  final Color mute;
  final Color hair;
  final Color wash;
  final Color code;
  final Color codeInk;
  final Color codeMute;
  final Color accent;
  final Color onAccent;
  final Color go;

  const HnPalette({
    required this.paper,
    required this.ink,
    required this.mute,
    required this.hair,
    required this.wash,
    required this.code,
    required this.codeInk,
    required this.codeMute,
    required this.accent,
    required this.onAccent,
    required this.go,
  });

  static const HnPalette light = HnPalette(
    paper: Color(0xFFFFFFFF),
    ink: Color(0xFF151515),
    mute: Color(0xFF6B6B66),
    hair: Color(0xFFE4E4E0),
    wash: Color(0xFFF3F3F0),
    code: Color(0xFFD5DCE5),
    codeInk: Color(0xFF1C2633),
    codeMute: Color(0xFF55616F),
    accent: Color(0xFF55687C),
    onAccent: Color(0xFFFFFFFF),
    go: Color(0xFF1A7F3F),
  );

  static const HnPalette dark = HnPalette(
    paper: Color(0xFF0F0F0E),
    ink: Color(0xFFECECE8),
    mute: Color(0xFF9C9C96),
    hair: Color(0xFF2B2B28),
    wash: Color(0xFF1B1B19),
    code: Color(0xFF1D252F),
    codeInk: Color(0xFFDCE3EC),
    codeMute: Color(0xFF93A0B0),
    accent: Color(0xFF93A7C0),
    onAccent: Color(0xFF0F0F0E),
    go: Color(0xFF4CC47E),
  );

  static HnPalette of(BuildContext context) =>
      Theme.of(context).extension<HnPalette>() ?? light;

  @override
  HnPalette copyWith() => this;

  @override
  HnPalette lerp(HnPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return HnPalette(
      paper: l(paper, other.paper),
      ink: l(ink, other.ink),
      mute: l(mute, other.mute),
      hair: l(hair, other.hair),
      wash: l(wash, other.wash),
      code: l(code, other.code),
      codeInk: l(codeInk, other.codeInk),
      codeMute: l(codeMute, other.codeMute),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      go: l(go, other.go),
    );
  }
}

/// Type helpers. Display type is the procedural pixel serif (see PixelText);
/// everything else is JetBrains Mono.
class HnType {
  const HnType._();

  static const String mono = 'JetBrainsMono';
  static const String serif = 'LibreCaslonText';

  static TextStyle body(Color color, {double size = 14.5, FontWeight weight = FontWeight.w400}) =>
      TextStyle(fontFamily: mono, fontSize: size, height: 1.7, fontWeight: weight, color: color);

  /// Short uppercase labels (nav, buttons, captions). Callers pass the text uppercased.
  static TextStyle label(Color color, {double size = 11.5, FontWeight weight = FontWeight.w500}) =>
      TextStyle(
        fontFamily: mono,
        fontSize: size,
        height: 1.3,
        letterSpacing: size * 0.09,
        fontWeight: weight,
        color: color,
      );
}

/// Layout constants shared by sections.
class HnLayout {
  const HnLayout._();

  static const double desktopBreakpoint = 900;
  static const double navHeight = 60;
  static const double laneHeight = 64;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  static double gutter(double width) => width >= desktopBreakpoint ? 64 : 20;

  /// Width of the left text column on desktop.
  static double column(double width) => (width * 0.40).clamp(440.0, 560.0);
}

ThemeData buildTheme(Brightness brightness) {
  final p = brightness == Brightness.dark ? HnPalette.dark : HnPalette.light;
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: p.paper,
    fontFamily: HnType.mono,
    colorScheme: ColorScheme.fromSeed(
      seedColor: p.accent,
      brightness: brightness,
      surface: p.paper,
      onSurface: p.ink,
      primary: p.ink,
      onPrimary: p.paper,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: p.accent,
      selectionColor: p.accent.withValues(alpha: 0.28),
      selectionHandleColor: p.accent,
    ),
    focusColor: p.accent.withValues(alpha: 0.18),
    hoverColor: p.wash,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(p.ink.withValues(alpha: 0.35)),
      thickness: const WidgetStatePropertyAll(6),
      radius: const Radius.circular(3),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: p.ink, borderRadius: BorderRadius.circular(4)),
      textStyle: HnType.label(p.paper, size: 11.5),
    ),
    extensions: [p],
  );
}
