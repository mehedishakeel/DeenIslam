import 'dart:convert';
import 'dart:io';
import '../../core/services/storage_service.dart';
import '../models/ayah_model.dart';

class QuranRepository {
  static String getAyahAudioUrl(int surahNumber, int ayahNumber) {
    final s = surahNumber.toString().padLeft(3, '0');
    final a = ayahNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/Alafasy_128kbps/$s$a.mp3';
  }

  /// Get Ayahs synchronously from preset offline data
  static List<Ayah> getAyahsForSurah(int surahNumber) {
    if (_presetSurahs.containsKey(surahNumber)) {
      return _presetSurahs[surahNumber]!;
    }
    return List.generate(5, (index) {
      final ayahNum = index + 1;
      return Ayah(
        numberInSurah: ayahNum,
        numberInQuran: (surahNumber * 10) + ayahNum,
        textArabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
        textBengali: "পরম করুণাময় ও অসীম দয়ালু আল্লাহর নামে শুরু করছি। (আয়াত $ayahNum)",
        audioUrl: getAyahAudioUrl(surahNumber, ayahNum),
      );
    });
  }

  /// Load Surah Ayahs from offline cache -> preset -> or live AlQuran Cloud API (and cache offline)
  static Future<List<Ayah>> loadSurahWithOfflineCache(int surahNumber) async {
    final cached = await StorageService.getCachedSurahAyahs(surahNumber);
    if (cached != null && cached.isNotEmpty) {
      return cached
          .map(
            (e) => Ayah(
              numberInSurah: e['numberInSurah'] as int? ?? 1,
              numberInQuran: e['numberInQuran'] as int? ?? 1,
              textArabic: e['textArabic'] as String? ?? '',
              textBengali: e['textBengali'] as String? ?? '',
              audioUrl: e['audioUrl'] as String? ?? '',
            ),
          )
          .toList();
    }

    if (_presetSurahs.containsKey(surahNumber)) {
      return _presetSurahs[surahNumber]!;
    }

    final fetched = await fetchSurahFromApi(surahNumber);
    if (fetched != null && fetched.isNotEmpty) {
      return fetched;
    }

    return getAyahsForSurah(surahNumber);
  }

  /// Fetch full Surah from AlQuran Cloud API and persist to offline cache
  static Future<List<Ayah>?> fetchSurahFromApi(int surahNumber) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 12);
    try {
      final uri = Uri.parse(
        'https://api.alquran.cloud/v1/surah/$surahNumber/editions/quran-uthmani,bn.bengali',
      );
      final req = await client.getUrl(uri);
      final res = await req.close();
      if (res.statusCode != 200) return null;

      final body = await res.transform(utf8.decoder).join();
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as List<dynamic>?;
      if (data == null || data.length < 2) return null;

      final arabicEdition = data[0] as Map<String, dynamic>;
      final bengaliEdition = data[1] as Map<String, dynamic>;

      final arabicAyahs = arabicEdition['ayahs'] as List<dynamic>? ?? [];
      final bengaliAyahs = bengaliEdition['ayahs'] as List<dynamic>? ?? [];

      final result = <Ayah>[];
      final cachePayload = <Map<String, dynamic>>[];

      for (var i = 0; i < arabicAyahs.length; i++) {
        final ar = arabicAyahs[i] as Map<String, dynamic>;
        final bn = i < bengaliAyahs.length
            ? (bengaliAyahs[i] as Map<String, dynamic>)
            : <String, dynamic>{};

        final numberInSurah = ar['numberInSurah'] as int? ?? (i + 1);
        final numberInQuran = ar['number'] as int? ?? (i + 1);
        final textArabic = (ar['text'] as String? ?? '').trim();
        final textBengali = (bn['text'] as String? ?? '').trim();
        final audioUrl =
            'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$numberInQuran.mp3';

        final ayah = Ayah(
          numberInSurah: numberInSurah,
          numberInQuran: numberInQuran,
          textArabic: textArabic,
          textBengali: textBengali,
          audioUrl: audioUrl,
        );
        result.add(ayah);
        cachePayload.add({
          'numberInSurah': numberInSurah,
          'numberInQuran': numberInQuran,
          'textArabic': textArabic,
          'textBengali': textBengali,
          'audioUrl': audioUrl,
        });
      }

      if (cachePayload.isNotEmpty) {
        await StorageService.saveCachedSurahAyahs(surahNumber, cachePayload);
      }
      return result;
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }

  static const Map<int, List<Ayah>> _presetSurahs = {
    // 1. Surah Al-Fatiha
    1: [
      Ayah(
        numberInSurah: 1,
        numberInQuran: 1,
        textArabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
        textBengali: "শুরু করছি আল্লাহর নামে যিনি পরম করুণাময়, অতি দয়ালু।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3",
      ),
      Ayah(
        numberInSurah: 2,
        numberInQuran: 2,
        textArabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
        textBengali: "সমস্ত প্রশংসা সারা জাহানের প্রতিপালক আল্লাহর জন্য।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/2.mp3",
      ),
      Ayah(
        numberInSurah: 3,
        numberInQuran: 3,
        textArabic: "الرَّحْمَٰنِ الرَّحِيمِ",
        textBengali: "যিনি পরম করুণাময় ও অতিশয় মেহেরবান।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/3.mp3",
      ),
      Ayah(
        numberInSurah: 4,
        numberInQuran: 4,
        textArabic: "مَالِكِ يَوْمِ الدِّينِ",
        textBengali: "যিনি বিচার দিবসের একমাত্র মালিক ও অধিপতি।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/4.mp3",
      ),
      Ayah(
        numberInSurah: 5,
        numberInQuran: 5,
        textArabic: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
        textBengali: "আমরা কেবল আপনারই ইবাদত করি এবং শুধুমাত্র আপনারই সাহায্য প্রার্থনা করি।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/5.mp3",
      ),
      Ayah(
        numberInSurah: 6,
        numberInQuran: 6,
        textArabic: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
        textBengali: "আমাদেরকে সরল-সঠিক পথ প্রদর্শন করুন।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6.mp3",
      ),
      Ayah(
        numberInSurah: 7,
        numberInQuran: 7,
        textArabic: "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
        textBengali: "তাদের পথ, যাদের আপনি পুরস্কৃত করেছেন; তাদের পথ নয়, যারা আপনার ক্রোধের শিকার ও পথভ্রষ্ট হয়েছে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/7.mp3",
      ),
    ],

    // 112. Surah Al-Ikhlas
    112: [
      Ayah(
        numberInSurah: 1,
        numberInQuran: 6222,
        textArabic: "قُلْ هُوَ اللَّهُ أَحَدٌ",
        textBengali: "বলুন, তিনিই আল্লাহ, যিনি এক ও অদ্বিতীয়।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6222.mp3",
      ),
      Ayah(
        numberInSurah: 2,
        numberInQuran: 6223,
        textArabic: "اللَّهُ الصَّمَدُ",
        textBengali: "আল্লাহ কারও মুখাপেক্ষী নন, সকলেই তাঁর মুখাপেক্ষী।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6223.mp3",
      ),
      Ayah(
        numberInSurah: 3,
        numberInQuran: 6224,
        textArabic: "لَمْ يَلِدْ وَلَمْ يُولَدْ",
        textBengali: "তিনি কাউকেও জন্ম দেননি এবং তাঁকেও কেউ জন্ম দেয়নি।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6224.mp3",
      ),
      Ayah(
        numberInSurah: 4,
        numberInQuran: 6225,
        textArabic: "وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ",
        textBengali: "এবং তাঁর সমকক্ষ ও তুলনীয় কেউই নেই।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6225.mp3",
      ),
    ],

    // 113. Surah Al-Falaq
    113: [
      Ayah(
        numberInSurah: 1,
        numberInQuran: 6226,
        textArabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
        textBengali: "বলুন, আমি আশ্রয় প্রার্থনা করছি প্রভাতের রবের কাছে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6226.mp3",
      ),
      Ayah(
        numberInSurah: 2,
        numberInQuran: 6227,
        textArabic: "مِن شَرِّ مَا خَلَقَ",
        textBengali: "তিনি যা সৃষ্টি করেছেন তার সকল অনিষ্ট থেকে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6227.mp3",
      ),
      Ayah(
        numberInSurah: 3,
        numberInQuran: 6228,
        textArabic: "وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ",
        textBengali: "এবং অন্ধকার রাতের অনিষ্ট থেকে, যখন তা চতুর্দিকে সমাগত হয়।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6228.mp3",
      ),
      Ayah(
        numberInSurah: 4,
        numberInQuran: 6229,
        textArabic: "وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ",
        textBengali: "এবং গিরায় ফুঁকদানকারী যাদুকরদের অনিষ্ট থেকে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6229.mp3",
      ),
      Ayah(
        numberInSurah: 5,
        numberInQuran: 6230,
        textArabic: "وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ",
        textBengali: "এবং হিংসুকের অনিষ্ট থেকে, যখন সে হিংসা করে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6230.mp3",
      ),
    ],

    // 114. Surah An-Nas
    114: [
      Ayah(
        numberInSurah: 1,
        numberInQuran: 6231,
        textArabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
        textBengali: "বলুন, আমি আশ্রয় প্রার্থনা করছি মানবজাতির প্রতিপালকের কাছে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6231.mp3",
      ),
      Ayah(
        numberInSurah: 2,
        numberInQuran: 6232,
        textArabic: "مَلِكِ النَّاسِ",
        textBengali: "মানবজাতির মহারাজা ও অধিপতির কাছে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6232.mp3",
      ),
      Ayah(
        numberInSurah: 3,
        numberInQuran: 6233,
        textArabic: "إِلَٰهِ النَّاسِ",
        textBengali: "মানবজাতির একমাত্র উপাস্যের কাছে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6233.mp3",
      ),
      Ayah(
        numberInSurah: 4,
        numberInQuran: 6234,
        textArabic: "مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ",
        textBengali: "গোপনে কুমন্ত্রণাদাতার অনিষ্ট থেকে, যে বারবার ফিরে আসে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6234.mp3",
      ),
      Ayah(
        numberInSurah: 5,
        numberInQuran: 6235,
        textArabic: "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ",
        textBengali: "যে মানুষের অন্তরে কুমন্ত্রণা দেয়।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6235.mp3",
      ),
      Ayah(
        numberInSurah: 6,
        numberInQuran: 6236,
        textArabic: "مِنَ الْجِنَّةِ وَالنَّاسِ",
        textBengali: "জিনদের মধ্য থেকে কিংবা মানুষের মধ্য থেকে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6236.mp3",
      ),
    ],

    // 103. Surah Al-Asr
    103: [
      Ayah(
        numberInSurah: 1,
        numberInQuran: 6177,
        textArabic: "وَالْعَصْرِ",
        textBengali: "মহাকালের শপথ!",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6177.mp3",
      ),
      Ayah(
        numberInSurah: 2,
        numberInQuran: 6178,
        textArabic: "إِنَّ الْإِنسَانَ لَفِي خُسْرٍ",
        textBengali: "নিশ্চয়ই মানুষ চরম ক্ষতির মধ্যে নিমজ্জিত।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6178.mp3",
      ),
      Ayah(
        numberInSurah: 3,
        numberInQuran: 6179,
        textArabic: "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ",
        textBengali: "তারা ব্যতীত যারা ঈমান এনেছে, সৎকাজ করেছে এবং পরস্পরকে সত্যের উপদেশ ও ধৈর্যের পরামর্শ দিয়েছে।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6179.mp3",
      ),
    ],

    // 108. Surah Al-Kawthar
    108: [
      Ayah(
        numberInSurah: 1,
        numberInQuran: 6205,
        textArabic: "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ",
        textBengali: "নিশ্চয়ই আমি আপনাকে কাউসার (অফুরন্ত কল্যাণ ও হাউজে কাউসার) দান করেছি।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6205.mp3",
      ),
      Ayah(
        numberInSurah: 2,
        numberInQuran: 6206,
        textArabic: "فَصَلِّ لِرَبِّكَ وَانْحَرْ",
        textBengali: "অতএব আপনার রবের উদ্দেশ্যে নামাজ পড়ুন এবং কুরবানী করুন।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6206.mp3",
      ),
      Ayah(
        numberInSurah: 3,
        numberInQuran: 6207,
        textArabic: "إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ",
        textBengali: "নিশ্চয় আপনার শত্রুই নির্বংশ ও লেজকাটা।",
        audioUrl: "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6207.mp3",
      ),
    ],
  };
}
