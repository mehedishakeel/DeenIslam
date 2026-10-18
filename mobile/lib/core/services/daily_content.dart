import '../../data/models/hadith_model.dart';
import '../../data/repositories/hadith_repository.dart';
import '../../data/repositories/quran_repository.dart';
import '../../data/repositories/surah_data.dart';

/// Text for the daily Ayah / Hadith reminder.
class DailyContent {
  final String title;
  final String body;
  const DailyContent(this.title, this.body);
}

/// Picks reminder text only from content already bundled in the app (the
/// Quran surahs with real text and the offline hadith collections). Nothing
/// is generated or invented; every item carries its reference.
class DailyContentService {
  /// Surahs whose full text is bundled. Other surahs are placeholders in the
  /// repository and are deliberately NOT used here.
  static const List<int> bundledSurahs = [1, 103, 108, 112, 113, 114];

  static List<DailyContent> _ayahs() {
    final out = <DailyContent>[];
    for (final s in bundledSurahs) {
      final surah = SurahData.allSurahs.firstWhere((x) => x.number == s);
      for (final a in QuranRepository.getAyahsForSurah(s)) {
        out.add(DailyContent(
          'আজকের আয়াত',
          '${a.textArabic}\n${a.textBengali}\n— সূরা ${surah.nameBengali}, আয়াত ${a.numberInSurah}',
        ));
      }
    }
    return out;
  }

  static List<DailyContent> _hadiths() {
    final out = <DailyContent>[];
    for (final book in HadithRepository.allBooks) {
      final items = HadithRepository.getOfflineHadithsForBook(book.slug);
      for (final HadithItem h in items) {
        if (h.bookSlug != book.slug) continue; // fallback list of another book
        out.add(DailyContent(
          'আজকের হাদিস',
          '${h.bengali}\n— ${h.narrator}, ${h.bookNameBengali} ${h.hadithNumber}'
              '${h.grade.isEmpty ? '' : ' (${h.grade})'}',
        ));
      }
    }
    return out;
  }

  /// Deterministic pick for a calendar day: Ayah and Hadith alternate daily.
  /// Returns null when no bundled content exists (nothing is scheduled).
  static DailyContent? forDay(DateTime day) {
    final ordinal =
        DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/ 86400000;
    final ayahs = _ayahs();
    final hadiths = _hadiths();
    final preferAyah = ordinal.isEven;
    final pool = preferAyah
        ? (ayahs.isNotEmpty ? ayahs : hadiths)
        : (hadiths.isNotEmpty ? hadiths : ayahs);
    if (pool.isEmpty) return null;
    return pool[(ordinal ~/ 2) % pool.length];
  }
}
