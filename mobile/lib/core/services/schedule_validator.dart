import 'package:flutter/material.dart' show TimeOfDay;

import '../../data/models/prayer_times_model.dart';

/// Result of checking one day's schedule before it is used for alarms.
class ScheduleCheck {
  /// Problems that make the day unusable (alarms are not scheduled).
  final List<String> errors;

  /// Legitimate edge cases (e.g. Isha after midnight at high latitudes).
  final List<String> warnings;

  /// Isha falls after midnight, so it cannot be scheduled on this date.
  final bool ishaPastMidnight;

  const ScheduleCheck(this.errors, this.warnings, {this.ishaPastMidnight = false});

  bool get ok => errors.isEmpty;
}

/// Never silently accepts a questionable schedule and never "repairs" times.
class ScheduleValidator {
  static int _min(TimeOfDay t) => t.hour * 60 + t.minute;

  static ScheduleCheck validate(PrayerTimesModel m) {
    final errors = <String>[];
    final warnings = <String>[];
    final core = <String, int>{
      'ফজর': _min(m.fajr),
      'সূর্যোদয়': _min(m.sunrise),
      'যোহর': _min(m.dhuhr),
      'আসর': _min(m.asr),
      'মাগরিব': _min(m.maghrib),
    };
    final names = core.keys.toList();
    final values = core.values.toList();
    for (var i = 1; i < values.length; i++) {
      if (values[i] <= values[i - 1]) {
        errors.add('${names[i - 1]} → ${names[i]} ক্রম ঠিক নেই');
      }
    }
    final isha = _min(m.isha);
    var wraps = false;
    if (isha <= values.last) {
      wraps = true;
      warnings.add('ইশা মধ্যরাতের পরে পড়ছে (উচ্চ অক্ষাংশ)');
    }
    return ScheduleCheck(errors, warnings, ishaPastMidnight: wraps);
  }
}
