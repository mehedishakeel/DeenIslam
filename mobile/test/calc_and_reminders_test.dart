import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:deen_islam/core/services/daily_content.dart';
import 'package:deen_islam/core/services/reminder_service.dart';
import 'package:deen_islam/core/services/schedule_validator.dart';
import 'package:deen_islam/core/services/storage_service.dart';
import 'package:deen_islam/core/utils/hijri_date.dart';
import 'package:deen_islam/data/models/calc_config.dart';
import 'package:deen_islam/data/models/prayer_times_model.dart';

int _m(TimeOfDay t) => t.hour * 60 + t.minute;

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    CalcConfig.apply(CalcConfig.defaults);
  });

  group('Hijri date', () {
    test('matches known civil dates', () {
      expect(HijriDate.fromGregorian(DateTime(2026, 3, 20)), const HijriDate(1447, 10, 1));
      expect(HijriDate.fromGregorian(DateTime(2026, 6, 17)), const HijriDate(1448, 1, 1));
      expect(HijriDate.fromGregorian(DateTime(2026, 10, 17)), const HijriDate(1448, 5, 5));
      expect(HijriDate.fromGregorian(DateTime(2025, 3, 1)), const HijriDate(1446, 9, 1));
    });

    test('adjustment moves the date by whole days', () {
      expect(HijriDate.fromGregorian(DateTime(2026, 10, 17), adjustDays: 1), const HijriDate(1448, 5, 6));
      expect(HijriDate.fromGregorian(DateTime(2026, 10, 17), adjustDays: -2), const HijriDate(1448, 5, 3));
    });
  });

  group('Calculation settings', () {
    const dhaka = [23.8103, 90.4125];
    PrayerTimesModel at(CalcConfig c) => PrayerTimesModel.forCoordinates(
          DateTime(2026, 10, 15), dhaka[0], dhaka[1],
          utcOffset: const Duration(hours: 6), config: c);

    test('default is Karachi with Hanafi Asr', () {
      expect(CalcConfig.current, CalcConfig.defaults);
      expect(CalcConfig.defaults.method, CalcMethod.karachi);
      expect(CalcConfig.defaults.hanafiAsr, isTrue);
    });

    test('a different method changes Fajr; Shafi Asr is earlier than Hanafi', () {
      final karachi = at(CalcConfig.defaults);
      final isna = at(const CalcConfig(method: CalcMethod.northAmerica, hanafiAsr: true));
      expect(_m(isna.fajr), greaterThan(_m(karachi.fajr))); // 15 deg vs 18 deg
      final shafi = at(const CalcConfig(method: CalcMethod.karachi, hanafiAsr: false));
      expect(_m(shafi.asr), lessThan(_m(karachi.asr)));
      expect(_m(shafi.maghrib), _m(karachi.maghrib)); // unaffected by Asr rule
    });

    test('Umm al-Qura Isha is 90 minutes after Maghrib', () {
      final p = PrayerTimesModel.forCoordinates(DateTime(2026, 10, 15), 21.4225, 39.8262,
          utcOffset: const Duration(hours: 3),
          config: const CalcConfig(method: CalcMethod.ummAlQura, hanafiAsr: false));
      final d = _m(p.isha) - _m(p.maghrib);
      expect(d, inInclusiveRange(89, 91));
    });

    test('every method produces an ordered, valid schedule for Dhaka', () {
      for (final m in CalcMethod.values) {
        final p = at(CalcConfig(method: m, hanafiAsr: true));
        expect(ScheduleValidator.validate(p).ok, isTrue, reason: m.name);
      }
    });

    test('current config is used by default and notifies on change', () {
      var bumps = 0;
      void l() => bumps++;
      CalcConfig.revision.addListener(l);
      final before = PrayerTimesModel.forCoordinates(DateTime(2026, 10, 15), dhaka[0], dhaka[1],
          utcOffset: const Duration(hours: 6));
      CalcConfig.apply(const CalcConfig(method: CalcMethod.northAmerica, hanafiAsr: true));
      final after = PrayerTimesModel.forCoordinates(DateTime(2026, 10, 15), dhaka[0], dhaka[1],
          utcOffset: const Duration(hours: 6));
      CalcConfig.apply(CalcConfig.current); // same value: no notification
      CalcConfig.revision.removeListener(l);
      expect(bumps, 1);
      expect(_m(after.fajr), isNot(_m(before.fajr)));
    });

    test('settings persist and reload', () async {
      await StorageService.saveCalcConfig(const CalcConfig(method: CalcMethod.egyptian, hanafiAsr: false));
      CalcConfig.apply(CalcConfig.defaults);
      final loaded = await StorageService.loadCalcConfig();
      expect(loaded.method, CalcMethod.egyptian);
      expect(loaded.hanafiAsr, isFalse);
      expect(CalcConfig.current, loaded);
    });

    test('unknown stored method falls back to the default, not a random one', () async {
      SharedPreferences.setMockInitialValues({'deen_calc_method_v1': 'bogus'});
      final loaded = await StorageService.loadCalcConfig();
      expect(loaded.method, CalcConfig.defaults.method);
    });
  });

  group('Schedule validator', () {
    test('rejects a day whose order is broken, never repairs it', () {
      const t = TimeOfDay(hour: 5, minute: 0);
      final bad = PrayerTimesModel(
        date: DateTime(2026, 10, 15),
        fajr: const TimeOfDay(hour: 6, minute: 0),
        sunrise: t, // before Fajr
        dhuhr: const TimeOfDay(hour: 12, minute: 0),
        asr: const TimeOfDay(hour: 15, minute: 0),
        maghrib: const TimeOfDay(hour: 17, minute: 30),
        isha: const TimeOfDay(hour: 19, minute: 0),
        imsak: const TimeOfDay(hour: 5, minute: 50),
      );
      final r = ScheduleValidator.validate(bad);
      expect(r.ok, isFalse);
      expect(r.errors, isNotEmpty);
    });

    test('flags Isha after midnight as a warning, not an error', () {
      final p = PrayerTimesModel(
        date: DateTime(2026, 6, 21),
        fajr: const TimeOfDay(hour: 2, minute: 0),
        sunrise: const TimeOfDay(hour: 4, minute: 45),
        dhuhr: const TimeOfDay(hour: 13, minute: 0),
        asr: const TimeOfDay(hour: 17, minute: 30),
        maghrib: const TimeOfDay(hour: 21, minute: 20),
        isha: const TimeOfDay(hour: 0, minute: 30),
        imsak: const TimeOfDay(hour: 1, minute: 50),
      );
      final r = ScheduleValidator.validate(p);
      expect(r.ok, isTrue);
      expect(r.ishaPastMidnight, isTrue);
      expect(r.warnings, isNotEmpty);
    });
  });

  group('Daily Ayah / Hadith content', () {
    test('every day yields content with a reference, deterministically', () {
      for (var i = 0; i < 40; i++) {
        final day = DateTime(2026, 10, 1).add(Duration(days: i));
        final a = DailyContentService.forDay(day);
        final b = DailyContentService.forDay(day);
        expect(a, isNotNull);
        expect(a!.body, b!.body);
        expect(a.body.contains('— '), isTrue, reason: 'reference missing on $day');
        expect(a.title == 'আজকের আয়াত' || a.title == 'আজকের হাদিস', isTrue);
      }
    });

    test('Ayah and Hadith both occur and only bundled surahs are used', () {
      final titles = <String>{};
      for (var i = 0; i < 10; i++) {
        final c = DailyContentService.forDay(DateTime(2026, 10, 1).add(Duration(days: i)))!;
        titles.add(c.title);
        if (c.title == 'আজকের আয়াত') expect(c.body.contains('সূরা'), isTrue);
      }
      expect(titles.length, 2);
    });
  });

  group('Notification ids', () {
    test('prayer, weekly, daily and Ayyam al-Bid ids never collide', () {
      final ids = <int>{};
      var n = 0;
      for (var d = 0; d < ReminderService.horizonDays; d++) {
        for (var p = 0; p < 5; p++) {
          for (final pre in [false, true]) {
            ids.add(ReminderService.notificationId(d, p, pre));
            n++;
          }
        }
        for (var k = 1; k <= 3; k++) {
          ids.add(8000 + d * 10 + k);
          n++;
        }
        ids.add(8100 + d);
        n++;
        for (var x = 0; x < 3; x++) {
          ids.add(8300 + d * 10 + x);
          n++;
        }
      }
      expect(ids.length, n);
    });
  });
}
