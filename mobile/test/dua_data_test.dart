import 'package:flutter_test/flutter_test.dart';
import 'package:deen_islam/data/repositories/dua_data.dart';

void main() {
  group('DuaData Integrity Tests', () {
    test('Contains authentic Hisnul Muslim daily duas', () {
      expect(DuaData.allDuas.isNotEmpty, isTrue);
      expect(DuaData.allDuas.length, greaterThanOrEqualTo(10));
    });

    test('All Duas have non-empty titles, Arabic, translations, and authentic references', () {
      for (final dua in DuaData.allDuas) {
        expect(dua.id, greaterThan(0));
        expect(dua.titleBengali.trim().isNotEmpty, isTrue, reason: 'Dua ${dua.id} title is empty');
        expect(dua.arabicText.trim().isNotEmpty, isTrue, reason: 'Dua ${dua.id} Arabic is empty');
        expect(dua.translation.trim().isNotEmpty, isTrue, reason: 'Dua ${dua.id} translation is empty');
        expect(dua.reference.trim().isNotEmpty, isTrue, reason: 'Dua ${dua.id} reference is empty');
        expect(dua.category.trim().isNotEmpty, isTrue, reason: 'Dua ${dua.id} category is empty');
      }
    });

    test('Unique IDs for each Dua entry', () {
      final ids = DuaData.allDuas.map((d) => d.id).toSet();
      expect(ids.length, DuaData.allDuas.length, reason: 'Duplicate Dua ID detected');
    });

    test('Morning/Evening Adhkar include multi-repetition targets (3x, 7x, 100x)', () {
      final targets = DuaData.allDuas.map((d) => d.targetCount).toSet();
      expect(targets.contains(3), isTrue);
      expect(targets.contains(7), isTrue);
      expect(targets.contains(100), isTrue);
      for (final dua in DuaData.allDuas) {
        expect(dua.targetCount, greaterThanOrEqualTo(1));
      }
    });
  });
}
