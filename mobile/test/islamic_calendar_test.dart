import 'package:flutter_test/flutter_test.dart';
import 'package:deen_islam/data/repositories/islamic_calendar_data.dart';

void main() {
  group('IslamicCalendarData & Hijri Engine Tests', () {
    test('Defines all 12 Islamic months with exactly 4 Sacred Months', () {
      expect(IslamicCalendarData.months.length, equals(12));
      final sacred =
          IslamicCalendarData.months.where((m) => m.isSacred).toList();
      expect(sacred.length, equals(4));
      expect(
        sacred.map((m) => m.number).toList(),
        equals([1, 7, 11, 12]),
      );
    });

    test('Contains major annual Islamic events including Ramadan, Eids, Arafah, Ashura', () {
      expect(IslamicCalendarData.events.length, greaterThanOrEqualTo(15));
      final ids = IslamicCalendarData.events.map((e) => e.id).toSet();
      expect(ids.contains('ramadan_start'), isTrue);
      expect(ids.contains('eid_ul_fitr'), isTrue);
      expect(ids.contains('eid_ul_adha'), isTrue);
      expect(ids.contains('arafah_day'), isTrue);
      expect(ids.contains('ashura'), isTrue);
    });

    test('Accurately marks White Days (13, 14, 15) and Prohibited Fasting Days', () {
      final ramadan = IslamicCalendarData.getMonthCalendar(1448, 9);
      expect(ramadan.days.firstWhere((d) => d.hijriDay == 13).isWhiteDay, isTrue);
      expect(ramadan.days.firstWhere((d) => d.hijriDay == 14).isWhiteDay, isTrue);
      expect(ramadan.days.firstWhere((d) => d.hijriDay == 15).isWhiteDay, isTrue);
      expect(ramadan.days.firstWhere((d) => d.hijriDay == 12).isWhiteDay, isFalse);

      final shawwal = IslamicCalendarData.getMonthCalendar(1448, 10);
      expect(shawwal.days.firstWhere((d) => d.hijriDay == 1).isProhibitedFasting, isTrue);
      expect(shawwal.days.firstWhere((d) => d.hijriDay == 2).isProhibitedFasting, isFalse);

      final dhulHijjah = IslamicCalendarData.getMonthCalendar(1448, 12);
      expect(dhulHijjah.days.firstWhere((d) => d.hijriDay == 9).isProhibitedFasting, isFalse);
      expect(dhulHijjah.days.firstWhere((d) => d.hijriDay == 10).isProhibitedFasting, isTrue);
      expect(dhulHijjah.days.firstWhere((d) => d.hijriDay == 11).isProhibitedFasting, isTrue);
      expect(dhulHijjah.days.firstWhere((d) => d.hijriDay == 12).isProhibitedFasting, isTrue);
      expect(dhulHijjah.days.firstWhere((d) => d.hijriDay == 13).isProhibitedFasting, isTrue);
    });

    test('Respects manual moon-sighting offset in Gregorian to Hijri conversion', () {
      final date = DateTime(2026, 5, 15);
      final base = IslamicCalendarData.gregorianToHijri(date, 0);
      final plusOne = IslamicCalendarData.gregorianToHijri(date, 1);
      final minusOne = IslamicCalendarData.gregorianToHijri(date, -1);

      expect(base.formattedBn.contains('হিজরি'), isTrue);
      expect(plusOne.gregorianDate.day, equals(16));
      expect(minusOne.gregorianDate.day, equals(14));
    });

    test('getUpcomingEvents returns chronologically sorted upcoming events', () {
      final upcoming = IslamicCalendarData.getUpcomingEvents(DateTime(2026, 11, 25));
      expect(upcoming.length, equals(IslamicCalendarData.events.length));
      for (int i = 1; i < upcoming.length; i++) {
        expect(
          upcoming[i].daysRemaining,
          greaterThanOrEqualTo(upcoming[i - 1].daysRemaining),
        );
      }
    });
  });
}
