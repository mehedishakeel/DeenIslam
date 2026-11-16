import 'package:flutter_test/flutter_test.dart';
import 'package:deen_islam/data/repositories/allah_names_data.dart';

void main() {
  group('AllahNamesData Integrity Tests', () {
    test('Contains all 99 Names of Allah', () {
      expect(AllahNamesData.allNames.length, 99);
    });

    test('Sequential numbering from 1 to 99', () {
      for (int i = 0; i < AllahNamesData.allNames.length; i++) {
        expect(AllahNamesData.allNames[i].id, i + 1);
      }
    });

    test('All 99 names have non-empty Arabic, transliteration, and meaning', () {
      for (final name in AllahNamesData.allNames) {
        expect(name.arabic.trim().isNotEmpty, isTrue, reason: 'Name ${name.id} Arabic is empty');
        expect(name.transliteration.trim().isNotEmpty, isTrue, reason: 'Name ${name.id} Transliteration is empty');
        expect(name.meaning.trim().isNotEmpty, isTrue, reason: 'Name ${name.id} Meaning is empty');
      }
    });
  });
}
