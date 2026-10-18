import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Resolves the UTC offset of a named time zone on a given calendar day, so a
/// manually selected city anywhere in the world gets its own local times
/// (including daylight saving) instead of the phone's time zone.
class TimeZoneService {
  TimeZoneService._();

  static bool _ready = false;

  static void ensureInitialized() {
    if (_ready) return;
    tzdata.initializeTimeZones();
    _ready = true;
  }

  /// Offset at 12:00 UTC of [date]; null when [zoneId] is null or unknown.
  /// (DST switches happen at night local time, so midday is representative.)
  static Duration? offsetFor(String? zoneId, DateTime date) {
    if (zoneId == null || zoneId.isEmpty) return null;
    try {
      ensureInitialized();
      final loc = tz.getLocation(zoneId);
      final at = DateTime.utc(date.year, date.month, date.day, 12);
      return Duration(milliseconds: loc.timeZone(at.millisecondsSinceEpoch).offset);
    } catch (_) {
      return null;
    }
  }
}
