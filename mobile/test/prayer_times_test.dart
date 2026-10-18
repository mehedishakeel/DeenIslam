import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:deen_islam/core/services/prayer_service.dart';
import 'package:deen_islam/core/services/reminder_service.dart';
import 'package:deen_islam/data/models/district_coordinates.dart';
import 'package:deen_islam/data/models/prayer_times_model.dart';

int _m(TimeOfDay t) => t.hour * 60 + t.minute;

/// Reference minutes come from an independent PrayTimes-style implementation
/// (Karachi 18/18, Hanafi Asr, UTC+6); tolerance is +-3 minutes because the
/// two implementations differ slightly in rounding/refraction conventions.
void _expectNear(PrayerTimesModel p, List<int> ref) {
  final actual = [p.fajr, p.sunrise, p.dhuhr, p.asr, p.maghrib, p.isha].map(_m).toList();
  for (var i = 0; i < ref.length; i++) {
    expect((actual[i] - ref[i]).abs(), lessThanOrEqualTo(3),
        reason: 'index $i actual ${actual[i]} ref ${ref[i]}');
  }
}

PrayerTimesModel _at(DateTime d, double lat, double lon) =>
    PrayerTimesModel.forCoordinates(d, lat, lon, utcOffset: const Duration(hours: 6));

void main() {
  const dhaka = [23.8103, 90.4125];

  group('astronomical prayer times', () {
    test('Dhaka matches reference on four dates', () {
      _expectNear(_at(DateTime(2026, 1, 15), dhaka[0], dhaka[1]), [323, 403, 728, 957, 1053, 1132]);
      _expectNear(_at(DateTime(2026, 3, 21), dhaka[0], dhaka[1]), [286, 362, 726, 988, 1090, 1165]);
      _expectNear(_at(DateTime(2026, 6, 21), dhaka[0], dhaka[1]), [224, 312, 720, 1001, 1128, 1216]);
      _expectNear(_at(DateTime(2026, 10, 15), dhaka[0], dhaka[1]), [280, 356, 704, 955, 1052, 1128]);
    });

    test('other districts differ by real longitude', () {
      _expectNear(_at(DateTime(2026, 10, 15), 24.8949, 91.8687), [274, 350, 698, 948, 1046, 1122]);
      _expectNear(_at(DateTime(2026, 1, 15), 22.3569, 91.7832), [316, 395, 722, 954, 1050, 1128]);
    });

    test('times are ordered and imsak precedes fajr', () {
      final p = _at(DateTime(2026, 5, 5), 23.8, 90.4);
      final v = [p.imsak, p.fajr, p.sunrise, p.dhuhr, p.asr, p.maghrib, p.isha].map(_m).toList();
      for (var i = 1; i < v.length; i++) {
        expect(v[i], greaterThan(v[i - 1]));
      }
    });

    test('invalid coordinates throw instead of inventing times', () {
      expect(() => PrayerTimesModel.forCoordinates(DateTime(2026, 1, 1), 95, 10), throwsArgumentError);
      expect(() => PrayerTimesModel.forCoordinates(DateTime(2026, 1, 1), 10, 200), throwsArgumentError);
      expect(PrayerService.isValidCoordinate(double.nan, 10), isFalse);
    });

    test('every district has valid coordinates and a calculable schedule', () {
      expect(districtCoordinates.length, 64);
      districtCoordinates.forEach((name, c) {
        expect(PrayerService.isValidCoordinate(c[0], c[1]), isTrue, reason: name);
        expect(() => _at(DateTime(2026, 7, 1), c[0], c[1]), returnsNormally, reason: name);
      });
    });
  });

  group('status and countdown', () {
    final p = _at(DateTime(2026, 10, 15), dhaka[0], dhaka[1]);

    test('after isha the next prayer is fajr of the next day', () {
      final s = p.getUpcomingStatus(DateTime(2026, 10, 15, 23, 59));
      expect(s.nextName, 'ফজর');
      expect(s.remaining.inMinutes, greaterThan(0));
      expect(s.remaining.inHours, lessThan(8));
    });

    test('before fajr the next prayer is fajr', () {
      final s = p.getUpcomingStatus(DateTime(2026, 10, 15, 0, 5));
      expect(s.nextName, 'ফজর');
    });

    test('countdown equals time to the next prayer', () {
      final now = DateTime(2026, 10, 15, 12, 0);
      final s = p.getUpcomingStatus(now);
      expect(s.nextName, 'আসর');
      expect(s.remaining, p.toDateTime(p.asr).difference(now));
    });

    test('isSameDay detects a date change', () {
      expect(p.isSameDay(DateTime(2026, 10, 15, 23, 59)), isTrue);
      expect(p.isSameDay(DateTime(2026, 10, 16, 0, 1)), isFalse);
    });
  });

  group('qibla', () {
    test('bearing from Dhaka and New York', () {
      expect(PrayerService.qiblaBearing(23.8103, 90.4125), closeTo(277.6, 0.5));
      expect(PrayerService.qiblaBearing(40.7128, -74.0060), closeTo(58.5, 0.5));
    });
  });

  group('reminder ids', () {
    test('unique across a 7-day horizon', () {
      final ids = <int>{};
      var n = 0;
      for (var d = 0; d < ReminderService.horizonDays; d++) {
        for (var i = 0; i < 5; i++) {
          for (final pre in [false, true]) {
            ids.add(ReminderService.notificationId(d, i, pre));
            n++;
          }
        }
      }
      expect(ids.length, n);
    });
  });
}
