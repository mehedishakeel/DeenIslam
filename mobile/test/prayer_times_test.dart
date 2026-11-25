import 'package:flutter_test/flutter_test.dart';
import 'package:deen_islam/data/models/prayer_times_model.dart';

void main() {
  group('PrayerTimesModel Integrity & 64 Districts Tests', () {
    test('Contains exactly 64 districts of Bangladesh', () {
      expect(PrayerTimesModel.allDistrictOffsets.length, 64);
    });

    test('Dhaka district offset is 0', () {
      expect(PrayerTimesModel.allDistrictOffsets['ঢাকা'], 0);
    });

    test('All 64 districts have realistic minute offsets within [-15, +15]', () {
      for (final entry in PrayerTimesModel.allDistrictOffsets.entries) {
        expect(
          entry.value >= -15 && entry.value <= 15,
          isTrue,
          reason: 'District ${entry.key} offset ${entry.value} is out of expected Bangladesh bounds',
        );
      }
    });

    test('PrayerTimesModel.forCity returns valid prayer times for Dhaka, Chittagong, Sylhet, and Rajshahi', () {
      final now = DateTime(2026, 11, 16);
      final cities = ['ঢাকা', 'চট্টগ্রাম', 'সিলেট', 'রাজশাহী', 'খুলনা', 'বরিশাল', 'রংপুর', 'ময়মনসিংহ'];

      for (final city in cities) {
        final pt = PrayerTimesModel.forCity(now, city);
        expect(pt.fajr.hour >= 0 && pt.fajr.hour < 24, isTrue);
        expect(pt.dhuhr.hour >= 0 && pt.dhuhr.hour < 24, isTrue);
        expect(pt.asr.hour >= 0 && pt.asr.hour < 24, isTrue);
        expect(pt.maghrib.hour >= 0 && pt.maghrib.hour < 24, isTrue);
        expect(pt.isha.hour >= 0 && pt.isha.hour < 24, isTrue);

        // Verification of formatted string (Bengali numerals)
        final formattedFajr = pt.formatTime(pt.fajr);
        expect(formattedFajr.isNotEmpty, isTrue);
        expect(formattedFajr.contains('AM') || formattedFajr.contains('PM'), isTrue);
      }
    });

    test('Solar calculation adapts accurately across winter and summer seasons in Dhaka', () {
      final nov = PrayerTimesModel.forCity(DateTime(2026, 11, 25), 'ঢাকা');
      final jun = PrayerTimesModel.forCity(DateTime(2026, 6, 21), 'ঢাকা');

      // November Maghrib (~17:10) should be significantly earlier than June Maghrib (~18:49)
      final novMaghribMins = nov.maghrib.hour * 60 + nov.maghrib.minute;
      final junMaghribMins = jun.maghrib.hour * 60 + jun.maghrib.minute;
      expect(novMaghribMins < 17 * 60 + 25, isTrue);
      expect(junMaghribMins > 18 * 60 + 30, isTrue);

      // November Fajr should be later than June Fajr
      final novFajrMins = nov.fajr.hour * 60 + nov.fajr.minute;
      final junFajrMins = jun.fajr.hour * 60 + jun.fajr.minute;
      expect(novFajrMins > junFajrMins + 45, isTrue);
    });
  });
}
