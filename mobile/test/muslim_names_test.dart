import 'package:flutter_test/flutter_test.dart';
import 'package:deen_islam/data/repositories/muslim_names_data.dart';

void main() {
  group('MuslimNamesData Integrity Tests', () {
    test('Contains authentic Muslim baby names with at least 100 names', () {
      expect(MuslimNamesData.names, isNotEmpty);
      expect(MuslimNamesData.names.length, greaterThanOrEqualTo(100));
    });

    test('Contains both boy and girl categories with proper balance', () {
      final boys = MuslimNamesData.names.where((n) => n.gender == 'boy').toList();
      final girls = MuslimNamesData.names.where((n) => n.gender == 'girl').toList();

      expect(boys.length, greaterThanOrEqualTo(50));
      expect(girls.length, greaterThanOrEqualTo(40));
      expect(boys.length + girls.length, equals(MuslimNamesData.names.length));
    });

    test('Every name item has valid fields and Bengali meaning', () {
      for (final n in MuslimNamesData.names) {
        expect(n.id, greaterThan(0));
        expect(n.name, isNotEmpty);
        expect(n.arabic, isNotEmpty);
        expect(n.english, isNotEmpty);
        expect(n.meaning, isNotEmpty);
        expect(n.gender == 'boy' || n.gender == 'girl', isTrue);
        expect(n.letter, isNotEmpty);
      }
    });

    test('Contains Islamic naming guidelines and prohibited names', () {
      expect(MuslimNamesData.guidelines.length, greaterThanOrEqualTo(5));
      for (final g in MuslimNamesData.guidelines) {
        expect(g['title'], isNotEmpty);
        expect(g['desc'], isNotEmpty);
      }

      expect(MuslimNamesData.prohibitedNames.length, greaterThanOrEqualTo(5));
      for (final p in MuslimNamesData.prohibitedNames) {
        expect(p['name'], isNotEmpty);
        expect(p['reason'], isNotEmpty);
      }
    });
  });
}
