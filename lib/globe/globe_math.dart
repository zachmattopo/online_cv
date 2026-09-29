import 'dart:math' as math;
import 'dart:ui';

import '../models/journey_stop.dart';

const double _rad = math.pi / 180;
const double _deg = 180 / math.pi;

/// A unit vector on the sphere, used for great-circle maths.
class _Vec3 {
  final double x, y, z;
  const _Vec3(this.x, this.y, this.z);

  factory _Vec3.fromLonLat(double lon, double lat) {
    final la = lat * _rad, lo = lon * _rad;
    return _Vec3(math.cos(la) * math.cos(lo), math.cos(la) * math.sin(lo), math.sin(la));
  }

  double dot(_Vec3 o) => x * o.x + y * o.y + z * o.z;
  double get lon => math.atan2(y, x) * _deg;
  double get lat => math.asin(z.clamp(-1.0, 1.0)) * _deg;
}

/// Angular distance between two points, in degrees.
double angularDistance(double lon1, double lat1, double lon2, double lat2) {
  final a = _Vec3.fromLonLat(lon1, lat1), b = _Vec3.fromLonLat(lon2, lat2);
  return math.acos(a.dot(b).clamp(-1.0, 1.0)) * _deg;
}

/// Point a fraction [t] of the way along the great circle from 1 to 2.
(double lon, double lat) slerpLonLat(double lon1, double lat1, double lon2, double lat2, double t) {
  final a = _Vec3.fromLonLat(lon1, lat1), b = _Vec3.fromLonLat(lon2, lat2);
  final omega = math.acos(a.dot(b).clamp(-1.0, 1.0));
  if (omega < 1e-6) return (lon1, lat1);
  final s = math.sin(omega), ka = math.sin((1 - t) * omega) / s, kb = math.sin(t * omega) / s;
  final v = _Vec3(a.x * ka + b.x * kb, a.y * ka + b.y * kb, a.z * ka + b.z * kb);
  return (v.lon, v.lat);
}

/// Where the globe is looking. The [focus] point on the sphere is drawn at
/// screen position [anchor]; the view centre sits [tilt] degrees south of it,
/// which leaves the planet's horizon arching across the top of the frame.
class GlobeCamera {
  final double focusLon;
  final double focusLat;
  final double radius;
  final Offset anchor;
  final double tilt;

  const GlobeCamera({
    required this.focusLon,
    required this.focusLat,
    required this.radius,
    required this.anchor,
    this.tilt = 0,
  });

  /// A close camera on a stop, tilted so the horizon sits at [horizonY].
  factory GlobeCamera.stop({
    required double lon,
    required double lat,
    required double radius,
    required Offset anchor,
    required double horizonY,
  }) {
    return GlobeCamera(
      focusLon: lon,
      focusLat: lat,
      radius: radius,
      anchor: anchor,
      tilt: tiltFor(radius, anchor.dy, horizonY),
    );
  }

  /// Tilt that puts the limb [anchorY] − [horizonY] px above the focus.
  static double tiltFor(double radius, double anchorY, double horizonY) {
    final s = (1 - (anchorY - horizonY) / radius).clamp(0.0, 0.9);
    return math.asin(s) * _deg;
  }

  double get lon0 => focusLon;
  double get lat0 => focusLat - tilt;
  Offset get center => Offset(anchor.dx, anchor.dy + radius * math.sin(tilt * _rad));

  /// Orthographic projection; null when the point is on the far side.
  Offset? project(double lon, double lat) {
    final phi = lat * _rad, lam = (lon - lon0) * _rad, phi0 = lat0 * _rad;
    final cosc = math.sin(phi0) * math.sin(phi) + math.cos(phi0) * math.cos(phi) * math.cos(lam);
    if (cosc < 0) return null;
    final x = math.cos(phi) * math.sin(lam);
    final y = math.cos(phi0) * math.sin(phi) - math.sin(phi0) * math.cos(phi) * math.cos(lam);
    final c = center;
    return Offset(c.dx + radius * x, c.dy - radius * y);
  }

  /// Rotates a geographic direction into view space (x east, y north, z out).
  (double, double, double) toView(double lon, double lat) {
    final phi = lat * _rad, lam = (lon - lon0) * _rad, phi0 = lat0 * _rad;
    final x = math.cos(phi) * math.sin(lam);
    final y = math.cos(phi0) * math.sin(phi) - math.sin(phi0) * math.cos(phi) * math.cos(lam);
    final z = math.sin(phi0) * math.sin(phi) + math.cos(phi0) * math.cos(phi) * math.cos(lam);
    return (x, y, z);
  }

  /// Flies from [a] to [b]: the focus follows the great circle, the radius
  /// eases in log space and dips on long hauls so the whole planet turns
  /// beneath the camera. [retilt] recomputes the tilt for horizon framing.
  static GlobeCamera fly(GlobeCamera a, GlobeCamera b, double t, {double? horizonY}) {
    if (t <= 0) return a;
    if (t >= 1) return b;
    final (lon, lat) = slerpLonLat(a.focusLon, a.focusLat, b.focusLon, b.focusLat, t);
    final dist = angularDistance(a.focusLon, a.focusLat, b.focusLon, b.focusLat);
    final dip = (dist / 120).clamp(0.0, 0.72) * math.sin(math.pi * t);
    final logR = lerpDouble(math.log(a.radius), math.log(b.radius), t)!;
    final radius = math.exp(logR) * (1 - dip);
    final anchor = Offset.lerp(a.anchor, b.anchor, t)!;
    final tilt = horizonY != null
        ? tiltFor(radius, anchor.dy, horizonY)
        : lerpDouble(a.tilt, b.tilt, t)!;
    return GlobeCamera(focusLon: lon, focusLat: lat, radius: radius, anchor: anchor, tilt: tilt);
  }
}

/// A camera plus the band where the dither fades into the page.
class GlobeFrame {
  final GlobeCamera camera;

  /// Density ramps from 0 at [fadeX0] to 1 at [fadeX1] (disabled when equal).
  final double fadeX0, fadeX1;

  /// Density ramps from 1 at [fadeY0] to 0 at [fadeY1] (disabled when equal).
  final double fadeY0, fadeY1;

  /// Index of the stop the camera is on or heading to; -1 in the hero.
  final int activeStop;

  /// 0 while holding on a stop, rising to 1 mid-flight.
  final double inFlight;

  const GlobeFrame({
    required this.camera,
    this.fadeX0 = 0,
    this.fadeX1 = 0,
    this.fadeY0 = 0,
    this.fadeY1 = 0,
    this.activeStop = -1,
    this.inFlight = 0,
  });

  static GlobeFrame lerpFade(GlobeFrame a, GlobeFrame b, double t, GlobeCamera camera, int active, double inFlight) {
    return GlobeFrame(
      camera: camera,
      fadeX0: lerpDouble(a.fadeX0, b.fadeX0, t)!,
      fadeX1: lerpDouble(a.fadeX1, b.fadeX1, t)!,
      fadeY0: lerpDouble(a.fadeY0, b.fadeY0, t)!,
      fadeY1: lerpDouble(a.fadeY1, b.fadeY1, t)!,
      activeStop: active,
      inFlight: inFlight,
    );
  }
}

/// Subsolar point for [utc] (NOAA-style approximation, well within a degree).
({double lon, double lat}) subsolarPoint(DateTime utc) {
  final start = DateTime.utc(utc.year, 1, 1);
  final dayOfYear = utc.difference(start).inMinutes / 1440.0 + 1;
  final hours = utc.hour + utc.minute / 60 + utc.second / 3600;
  final gamma = 2 * math.pi / 365 * (dayOfYear - 1 + (hours - 12) / 24);
  final eqTime = 229.18 *
      (0.000075 +
          0.001868 * math.cos(gamma) -
          0.032077 * math.sin(gamma) -
          0.014615 * math.cos(2 * gamma) -
          0.040849 * math.sin(2 * gamma));
  final decl = 0.006918 -
      0.399912 * math.cos(gamma) +
      0.070257 * math.sin(gamma) -
      0.006758 * math.cos(2 * gamma) +
      0.000907 * math.sin(2 * gamma) -
      0.002697 * math.cos(3 * gamma) +
      0.00148 * math.sin(3 * gamma);
  var lon = -15 * (hours - 12 + eqTime / 60);
  lon = ((lon + 180) % 360 + 360) % 360 - 180;
  return (lon: lon, lat: decl * _deg);
}

/// Points along the day/night terminator (the great circle 90° from the sun).
List<(double lon, double lat)> terminatorPoints(DateTime utc, {int n = 180}) {
  final s = subsolarPoint(utc), sv = _Vec3.fromLonLat(s.lon, s.lat);
  // Any vector not parallel to the sun gives an orthonormal pair with it.
  final ref = sv.z.abs() < 0.9 ? const _Vec3(0, 0, 1) : const _Vec3(1, 0, 0);
  var u = _Vec3(sv.y * ref.z - sv.z * ref.y, sv.z * ref.x - sv.x * ref.z, sv.x * ref.y - sv.y * ref.x);
  final ul = math.sqrt(u.dot(u));
  u = _Vec3(u.x / ul, u.y / ul, u.z / ul);
  final v = _Vec3(sv.y * u.z - sv.z * u.y, sv.z * u.x - sv.x * u.z, sv.x * u.y - sv.y * u.x);
  return [
    for (var k = 0; k < n; k++)
      (() {
        final t = 2 * math.pi * k / n, c = math.cos(t), sn = math.sin(t);
        final p = _Vec3(u.x * c + v.x * sn, u.y * c + v.y * sn, u.z * c + v.z * sn);
        return (p.lon, p.lat);
      })(),
  ];
}

/// Sun elevation in degrees at a place and moment.
double sunElevation(double lon, double lat, DateTime utc) {
  final s = subsolarPoint(utc);
  final v = _Vec3.fromLonLat(lon, lat).dot(_Vec3.fromLonLat(s.lon, s.lat));
  return math.asin(v.clamp(-1.0, 1.0)) * _deg;
}

/// Plain-language sun state for a place right now.
String sunState(double lon, double lat, DateTime utc) {
  final e = sunElevation(lon, lat, utc);
  if (e > 0) return 'up';
  if (e > -6) return 'twilight';
  return 'down';
}

DateTime _lastSunday(int year, int month) {
  final last = DateTime.utc(year, month + 1, 0);
  return last.subtract(Duration(days: last.weekday % 7));
}

DateTime _nthSunday(int year, int month, int n) {
  final first = DateTime.utc(year, month, 1);
  final firstSunday = first.add(Duration(days: (7 - first.weekday % 7) % 7));
  return firstSunday.add(Duration(days: 7 * (n - 1)));
}

/// Local wall-clock time and zone abbreviation for a stop.
({DateTime time, String zone}) localTime(StopZone zone, DateTime utc) {
  switch (zone) {
    case StopZone.malaysia:
      return (time: utc.add(const Duration(hours: 8)), zone: 'MYT');
    case StopZone.uk:
      final start = _lastSunday(utc.year, 3).add(const Duration(hours: 1));
      final end = _lastSunday(utc.year, 10).add(const Duration(hours: 1));
      final bst = !utc.isBefore(start) && utc.isBefore(end);
      return (time: utc.add(Duration(hours: bst ? 1 : 0)), zone: bst ? 'BST' : 'GMT');
    case StopZone.usCentral:
      final start = _nthSunday(utc.year, 3, 2).add(const Duration(hours: 8));
      final end = _nthSunday(utc.year, 11, 1).add(const Duration(hours: 7));
      final cdt = !utc.isBefore(start) && utc.isBefore(end);
      return (time: utc.add(Duration(hours: cdt ? -5 : -6)), zone: cdt ? 'CDT' : 'CST');
  }
}

String hhmm(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// Degrees with hemisphere letter, e.g. `52.49°N`.
String formatLat(double lat) => '${lat.abs().toStringAsFixed(2)}°${lat >= 0 ? 'N' : 'S'}';
String formatLon(double lon) => '${lon.abs().toStringAsFixed(2)}°${lon >= 0 ? 'E' : 'W'}';
