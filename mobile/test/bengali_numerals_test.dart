import 'package:flutter_test/flutter_test.dart';
import 'package:deen_islam/core/utils/bengali_numerals.dart';

void main() {
  group('BengaliNumerals Tests', () {
    test('Converts English digits to Bengali digits correctly', () {
      expect(BengaliNumerals.convert('0123456789'), '০১২৩৪৫৬৭৮৯');
      expect(BengaliNumerals.convert('Surah 114'), 'Surah ১১৪');
      expect(BengaliNumerals.convert(2026), '২০২৬');
      expect(BengaliNumerals.convert(''), '');
    });

    test('Pads single digits with zero and converts to Bengali', () {
      expect(BengaliNumerals.padZero(5), '০৫');
      expect(BengaliNumerals.padZero(12), '১২');
      expect(BengaliNumerals.padZero(0), '০০');
    });
  });
}
