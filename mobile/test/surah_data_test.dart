import 'package:flutter_test/flutter_test.dart';
import 'package:deen_islam/data/models/ayah_model.dart';
import 'package:deen_islam/data/repositories/quran_repository.dart';
import 'package:deen_islam/data/repositories/surah_data.dart';

void main() {
  group('SurahData Integrity Tests', () {
    test('Contains exactly 114 Surahs', () {
      expect(SurahData.allSurahs.length, 114);
    });

    test('All Surahs have sequential numbers from 1 to 114', () {
      for (int i = 0; i < SurahData.allSurahs.length; i++) {
        final surah = SurahData.allSurahs[i];
        expect(surah.number, i + 1, reason: 'Surah at index $i should have number ${i + 1}');
      }
    });

    test('All Surahs have valid non-empty fields and positive ayah counts', () {
      for (final surah in SurahData.allSurahs) {
        expect(surah.nameArabic.trim().isNotEmpty, isTrue, reason: 'Surah ${surah.number} Arabic name empty');
        expect(surah.nameBengali.trim().isNotEmpty, isTrue, reason: 'Surah ${surah.number} Bengali name empty');
        expect(surah.nameEnglish.trim().isNotEmpty, isTrue, reason: 'Surah ${surah.number} English name empty');
        expect(surah.numberOfAyahs, greaterThan(0), reason: 'Surah ${surah.number} Ayahs must be > 0');
        expect(
          surah.revelationType == 'মাক্কী' || surah.revelationType == 'মাদানী',
          isTrue,
          reason: 'Surah ${surah.number} has invalid revelation type: ${surah.revelationType}',
        );
      }
    });

    test('First Surah is Al-Fatiha and last Surah is An-Nas', () {
      expect(SurahData.allSurahs.first.nameEnglish, 'Al-Fatiha');
      expect(SurahData.allSurahs.first.numberOfAyahs, 7);
      expect(SurahData.allSurahs.last.nameEnglish, 'An-Nas');
      expect(SurahData.allSurahs.last.numberOfAyahs, 6);
    });

    test('QuranRepository exposes multiple reciters and builds valid audio URLs', () {
      expect(QuranRepository.reciters.length, greaterThanOrEqualTo(4));
      final urlDefault = QuranRepository.getAyahAudioUrl(1, 1);
      final urlSudais = QuranRepository.getAyahAudioUrl(
        2,
        255,
        reciterId: 'ar.abdurrahmaansudais',
      );
      expect(urlDefault, contains('Alafasy_128kbps/001001.mp3'));
      expect(urlSudais, contains('Abdurrahmaan_As-Sudais_192kbps/002255.mp3'));

      const sampleAyah = Ayah(
        numberInSurah: 1,
        numberInQuran: 1,
        textArabic: 'بِسْمِ اللَّهِ',
        textBengali: 'আল্লাহর নামে',
      );
      final cdnUrl = QuranRepository.getAudioUrlForAyah(
        sampleAyah,
        1,
        reciterId: 'ar.mahermuaiqly',
      );
      expect(cdnUrl, contains('ar.mahermuaiqly/1.mp3'));
    });
  });
}
