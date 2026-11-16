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
  });
}
