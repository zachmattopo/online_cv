import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Service for tracking page visits using local storage.
///
/// Records each visit with a date stamp and provides
/// aggregated daily visit data for charting.
class VisitorTracker {
  static const String _totalVisitsKey = 'visitor_total_visits';
  static const String _dailyVisitsKey = 'visitor_daily_visits';
  static const String _lastVisitDateKey = 'visitor_last_visit_date';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Records a page visit. Only counts one visit per calendar day
  /// to avoid inflating numbers on page refreshes.
  Future<void> recordVisit() async {
    final prefs = await _getPrefs();
    final today = _todayString();
    final lastVisitDate = prefs.getString(_lastVisitDateKey);

    // Only count one visit per day
    if (lastVisitDate == today) return;

    // Increment total visits
    final totalVisits = prefs.getInt(_totalVisitsKey) ?? 0;
    await prefs.setInt(_totalVisitsKey, totalVisits + 1);

    // Update daily visits map
    final dailyVisits = _getDailyVisitsMap(prefs);
    dailyVisits[today] = (dailyVisits[today] ?? 0) + 1;

    // Keep only the last 90 days of data
    _pruneOldEntries(dailyVisits, 90);

    await prefs.setString(_dailyVisitsKey, jsonEncode(dailyVisits));
    await prefs.setString(_lastVisitDateKey, today);
  }

  /// Returns the total number of recorded visits.
  Future<int> getTotalVisits() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_totalVisitsKey) ?? 0;
  }

  /// Returns a map of date strings (YYYY-MM-DD) to visit counts
  /// for the last [days] days, filling in zeros for days with no visits.
  Future<Map<String, int>> getDailyVisits({int days = 30}) async {
    final prefs = await _getPrefs();
    final storedVisits = _getDailyVisitsMap(prefs);
    final result = <String, int>{};

    final now = DateTime.now();
    for (var i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = _dateToString(date);
      result[dateStr] = storedVisits[dateStr] ?? 0;
    }

    return result;
  }

  Map<String, int> _getDailyVisitsMap(SharedPreferences prefs) {
    final jsonStr = prefs.getString(_dailyVisitsKey);
    if (jsonStr == null) return {};

    final Map<String, dynamic> decoded = jsonDecode(jsonStr);
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  void _pruneOldEntries(Map<String, int> visits, int maxDays) {
    final cutoff = DateTime.now().subtract(Duration(days: maxDays));
    final cutoffStr = _dateToString(cutoff);
    visits.removeWhere((key, _) => key.compareTo(cutoffStr) < 0);
  }

  String _todayString() => _dateToString(DateTime.now());

  String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
