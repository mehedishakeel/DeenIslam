import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deen_islam/core/services/city_search_service.dart';
import 'package:deen_islam/core/services/location_service.dart';
import 'package:deen_islam/core/services/timezone_service.dart';
import 'package:deen_islam/data/models/app_location.dart';
import 'package:deen_islam/data/models/prayer_times_model.dart';

int _m(TimeOfDay t) => t.hour * 60 + t.minute;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('city search parsing', () {
    test('keeps valid results and drops invalid coordinates', () {
      const body = '''
{"results":[
 {"name":"London","latitude":51.50853,"longitude":-0.12574,"country":"United Kingdom","admin1":"England","timezone":"Europe/London"},
 {"name":"Bad","latitude":123.0,"longitude":10.0,"country":"X"},
 {"name":"NoCoords","country":"X"}
]}''';
      final r = CitySearchService.parse(body);
      expect(r.length, 1);
      expect(r.first.name, 'London');
      expect(r.first.timezone, 'Europe/London');
      expect(r.first.subtitle, 'England, United Kingdom');
      expect(r.first.label, 'London, United Kingdom');
    });

    test('empty and malformed payloads give no results', () {
      expect(CitySearchService.parse('{}'), isEmpty);
      expect(CitySearchService.parse('{"results":[]}'), isEmpty);
      expect(CitySearchService.parse('[]'), isEmpty);
    });

    test('very short queries do not hit the network', () async {
      expect(await CitySearchService.search(' a '), isEmpty);
    });
  });

  group('time zones', () {
    test('offsets including daylight saving', () {
      expect(TimeZoneService.offsetFor('Asia/Dhaka', DateTime(2026, 10, 15)), const Duration(hours: 6));
      expect(TimeZoneService.offsetFor('America/New_York', DateTime(2026, 10, 15)), const Duration(hours: -4));
      expect(TimeZoneService.offsetFor('America/New_York', DateTime(2026, 12, 15)), const Duration(hours: -5));
      expect(TimeZoneService.offsetFor('Europe/London', DateTime(2026, 1, 15)), Duration.zero);
      expect(TimeZoneService.offsetFor('Europe/London', DateTime(2026, 7, 15)), const Duration(hours: 1));
    });

    test('null and unknown zones fall back to the device zone', () {
      expect(TimeZoneService.offsetFor(null, DateTime(2026, 1, 1)), isNull);
      expect(TimeZoneService.offsetFor('Not/AZone', DateTime(2026, 1, 1)), isNull);
    });
  });

  group('worldwide schedules', () {
    // Reference minutes from an independent PrayTimes-style calculation
    // (Karachi 18/18, Hanafi Asr) at the place's own local time; +-3 min.
    void near(PrayerTimesModel p, List<int> ref) {
      final a = [p.fajr, p.sunrise, p.dhuhr, p.asr, p.maghrib, p.isha].map(_m).toList();
      for (var i = 0; i < ref.length; i++) {
        expect((a[i] - ref[i]).abs(), lessThanOrEqualTo(3), reason: 'index $i actual ${a[i]} ref ${ref[i]}');
      }
    }

    const nyc = AppLocation(
        latitude: 40.7128, longitude: -74.0060, label: 'New York', isGps: false, timezone: 'America/New_York');
    const makkah = AppLocation(
        latitude: 21.4225, longitude: 39.8262, label: 'Makkah', isGps: false, timezone: 'Asia/Riyadh');
    const london = AppLocation(
        latitude: 51.5074, longitude: -0.1278, label: 'London', isGps: false, timezone: 'Europe/London');

    test('New York in October (EDT) and December (EST)', () {
      near(PrayerTimesModel.forLocation(DateTime(2026, 10, 15), nyc), [336, 427, 762, 993, 1096, 1187]);
      near(PrayerTimesModel.forLocation(DateTime(2026, 12, 15), nyc), [334, 433, 711, 889, 989, 1088]);
    });

    test('Makkah', () {
      near(PrayerTimesModel.forLocation(DateTime(2026, 10, 15), makkah), [302, 376, 726, 979, 1076, 1151]);
    });

    test('London in January', () {
      near(PrayerTimesModel.forLocation(DateTime(2026, 1, 15), london), [359, 480, 730, 873, 981, 1101]);
    });

    test('high latitude in summer does not crash', () {
      expect(() => PrayerTimesModel.forLocation(DateTime(2026, 6, 21), london), returnsNormally);
    });

    test('instant() is an absolute moment at the place', () {
      final p = PrayerTimesModel.forLocation(DateTime(2026, 10, 15), nyc);
      final at = p.instant(p.fajr).toUtc();
      expect(at.hour * 60 + at.minute, (_m(p.fajr) + 4 * 60) % 1440);
    });

    test('wallNow and placeToday follow the place, not the device', () {
      final now = DateTime.utc(2026, 10, 15, 23, 30);
      const dhaka = AppLocation(
          latitude: 23.8, longitude: 90.4, label: 'Dhaka', isGps: false, timezone: 'Asia/Dhaka');
      expect(PrayerTimesModel.placeToday(now, dhaka), DateTime(2026, 10, 16));
      expect(PrayerTimesModel.placeToday(now, nyc), DateTime(2026, 10, 15));
      final p = PrayerTimesModel.forLocation(DateTime(2026, 10, 16), dhaka);
      final w = p.wallNow(now);
      expect([w.year, w.month, w.day, w.hour, w.minute], [2026, 10, 16, 5, 30]);
    });
  });

  group('location persistence', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('manual worldwide place is saved with coordinates and time zone', () async {
      final saved = await LocationService.selectPlace(
          latitude: 40.7128, longitude: -74.006, label: 'New York, United States', timezone: 'America/New_York');
      expect(saved.timezone, 'America/New_York');
      final loaded = await LocationService.load();
      expect(loaded.label, 'New York, United States');
      expect(loaded.isGps, isFalse);
      expect(loaded.latitude, closeTo(40.7128, 1e-6));
      expect(loaded.timezone, 'America/New_York');
    });

    test('choosing a district replaces the worldwide place', () async {
      await LocationService.selectPlace(latitude: 40.7, longitude: -74.0, label: 'New York', timezone: 'America/New_York');
      await LocationService.selectManual('সিলেট');
      final loaded = await LocationService.load();
      expect(loaded.label, 'সিলেট');
      expect(loaded.timezone, isNull);
    });

    test('invalid coordinates are rejected and nothing is saved', () async {
      expect(() => LocationService.selectPlace(latitude: 200, longitude: 0, label: 'x'), throwsArgumentError);
      expect((await LocationService.load()).label, 'ঢাকা');
    });

    test('fresh install defaults to the Dhaka district', () async {
      final loaded = await LocationService.load();
      expect(loaded.label, 'ঢাকা');
      expect(loaded.isGps, isFalse);
    });
  });
}
