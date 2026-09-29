import 'education.dart';
import 'experience.dart';

/// Time zone rules for the places on the journey. Kept as a closed set so
/// local times work without shipping a time zone database.
enum StopZone { uk, malaysia, usCentral }

/// One place on the career globe, and what happened there.
class JourneyStop {
  /// Slug used in the stop's request path, e.g. `birmingham`.
  final String id;
  final String city;
  final String region;

  /// Airport code, used as the compact label on the globe.
  final String code;
  final double lat;
  final double lon;
  final StopZone zone;

  /// Year shown on the fast-lane chip.
  final String year;

  /// One-line role and dates, set in the grey pixel serif.
  final String subhead;

  /// Summary paragraph. `**double asterisks**` mark bold runs.
  final String summary;

  /// The response body shown for this stop. Values may be strings, numbers
  /// or lists of strings.
  final Map<String, Object> facts;
  final List<Experience> roles;
  final List<Education> schooling;

  const JourneyStop({
    required this.id,
    required this.city,
    required this.region,
    required this.code,
    required this.lat,
    required this.lon,
    required this.zone,
    required this.year,
    required this.subhead,
    required this.summary,
    required this.facts,
    this.roles = const [],
    this.schooling = const [],
  });

  /// Lower-case text the fast-lane search matches against.
  String get searchText => [
        city,
        region,
        code,
        year,
        subhead,
        summary.replaceAll('**', ''),
        for (final r in roles) '${r.company} ${r.position} ${r.date} ${r.highlights.join(' ')}',
        for (final s in schooling) '${s.institution} ${s.qualification} ${s.date}',
      ].join(' ').toLowerCase();
}
