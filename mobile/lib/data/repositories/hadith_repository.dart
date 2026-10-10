import 'dart:convert';
import 'dart:io';
import '../../core/services/storage_service.dart';
import '../models/hadith_model.dart';

class HadithRepository {
  static const List<HadithBook> allBooks = [
    HadithBook(
      index: 1,
      slug: 'bukhari',
      nameBengali: 'সহীহ বুখারী',
      nameArabic: 'صحيح البخاري',
      compiler: 'ইমাম মুহাম্মাদ ইবনে ইসমাঈল বুখারী (রহঃ)',
      description: 'ইমাম বুখারী (রহঃ) কর্তৃক সংকলিত সবচেয়ে নির্ভরযোগ্য বিশুদ্ধ হাদিস গ্রন্থ।',
      badge: 'সহীহ সংকলন',
      totalCount: 7563,
    ),
    HadithBook(
      index: 2,
      slug: 'muslim',
      nameBengali: 'সহীহ মুসলিম',
      nameArabic: 'صحيح مسلم',
      compiler: 'ইমাম মুসলিম ইবনুল হাজ্জাজ (রহঃ)',
      description: 'ইমাম মুসলিম (রহঃ) সংকলিত বিশুদ্ধ হাদিসের অন্যতম শ্রেষ্ঠ আধার।',
      badge: 'সহীহ সংকলন',
      totalCount: 7453,
    ),
    HadithBook(
      index: 3,
      slug: 'abudawud',
      nameBengali: 'সুনানে আবু দাউদ',
      nameArabic: 'سنن أبي داود',
      compiler: 'ইমাম আবু দাউদ সুলাইমান আস-সিজিস্তানী (রহঃ)',
      description: 'ইমাম আবু দাউদ (রহঃ) সংকলিত সুনান ও ফিকহি হাদিসের অন্যতম সংকলন।',
      badge: 'সুনান গ্রন্থ',
      totalCount: 5274,
    ),
    HadithBook(
      index: 4,
      slug: 'tirmidhi',
      nameBengali: 'জামে আত-তিরমিযী',
      nameArabic: 'جامع الترمذي',
      compiler: 'ইমাম আবু ঈসা মুহাম্মাদ আত-তিরমিযী (রহঃ)',
      description: 'ইমাম তিরমিযী (রহঃ) সংকলিত সুনান ও হাদিস যাচাইয়ের নির্ভরযোগ্য কোষ।',
      badge: 'জামে গ্রন্থ',
      totalCount: 3956,
    ),
    HadithBook(
      index: 5,
      slug: 'nasai',
      nameBengali: 'সুনানে আন-নাসায়ী',
      nameArabic: 'سنن النسائي',
      compiler: 'ইমাম আহমাদ ইবনে শুআইব আন-নাসায়ী (রহঃ)',
      description: 'ইমাম নাসায়ী (রহঃ) সংকলিত সুনানে কুবরা ও সুগরা গ্রন্থ।',
      badge: 'সুনান গ্রন্থ',
      totalCount: 5758,
    ),
    HadithBook(
      index: 6,
      slug: 'ibnmajah',
      nameBengali: 'সুনানে ইবনে মাজাহ',
      nameArabic: 'سنن ابن ماجه',
      compiler: 'ইমাম মুহাম্মাদ ইবনে ইয়াযিদ ইবনে মাজাহ (রহঃ)',
      description: 'সিহাহ সিত্তাহ বা বিশুদ্ধ ছয় গ্রন্থের মধ্যে একটি অনন্য সংকলন।',
      badge: 'সুনান গ্রন্থ',
      totalCount: 4341,
    ),
    HadithBook(
      index: 7,
      slug: 'malik',
      nameBengali: 'মুয়াত্তা ইমাম মালিক',
      nameArabic: 'موطأ الإمام مالك',
      compiler: 'ইমাম মালিক ইবনে আনাস (রহঃ)',
      description: 'ইমাম মালিক (রহঃ) কর্তৃক সংকলিত ইসলামী ইতিহাসের অন্যতম প্রাচীন হাদিস গ্রন্থ।',
      badge: 'মুয়াত্তা',
      totalCount: 1858,
    ),
  ];

  static HadithBook getBookBySlug(String slug) {
    return allBooks.firstWhere(
      (b) => b.slug == slug,
      orElse: () => allBooks.first,
    );
  }

  /// Load hadiths from local cache if available, otherwise return offline built-in collection
  static Future<List<HadithItem>> getHadithsForBook(String slug) async {
    final cached = await StorageService.getCachedHadiths(slug);
    if (cached != null && cached.isNotEmpty) {
      return cached.map((e) => HadithItem.fromJson(e)).toList();
    }
    return getOfflineHadithsForBook(slug);
  }

  /// Fetch from CDN API and cache locally (up to 150 hadiths per book for fast offline access)
  static Future<List<HadithItem>> syncBookFromApi(String slug) async {
    final book = getBookBySlug(slug);
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 12);

    try {
      final benUri = Uri.parse(
        'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions/ben-$slug.json',
      );
      final benReq = await client.getUrl(benUri);
      final benRes = await benReq.close();
      if (benRes.statusCode != 200) {
        return getOfflineHadithsForBook(slug);
      }

      final benBody = await benRes.transform(utf8.decoder).join();
      final benJson = jsonDecode(benBody) as Map<String, dynamic>;
      final rawList = (benJson['hadiths'] as List<dynamic>? ?? []);

      final offlineDefaults = getOfflineHadithsForBook(slug);
      final arabicLookup = <int, String>{
        for (final item in offlineDefaults) item.hadithNumber: item.arabic,
      };

      final items = <HadithItem>[];
      for (final entry in rawList) {
        if (entry is! Map<String, dynamic>) continue;
        final text = (entry['text'] as String? ?? '').trim().replaceFirst(RegExp(r'^[।\s]+'), '');
        if (text.length < 3) continue;

        final rawNum = entry['hadithnumber'];
        final hNum = rawNum is int ? rawNum : (int.tryParse(rawNum.toString()) ?? (items.length + 1));

        String grade = 'সহীহ';
        final grades = entry['grades'] as List<dynamic>?;
        if (grades != null && grades.isNotEmpty) {
          final firstGrade = grades.first;
          if (firstGrade is Map<String, dynamic> && firstGrade['grade'] != null) {
            grade = firstGrade['grade'].toString();
          }
        }

        items.add(
          HadithItem(
            hadithNumber: hNum,
            bookSlug: slug,
            bookNameBengali: book.nameBengali,
            chapterTitle: '${book.nameBengali} সংকলন',
            arabic: arabicLookup[hNum] ?? '',
            bengali: text,
            narrator: book.compiler,
            grade: grade,
          ),
        );

        if (items.length >= 120) break;
      }

      if (items.isNotEmpty) {
        await StorageService.saveCachedHadiths(
          slug,
          items.map((e) => e.toJson()).toList(),
        );
        return items;
      }
    } catch (_) {
      // Fallback to built-in offline dataset
    } finally {
      client.close();
    }
    return getOfflineHadithsForBook(slug);
  }

  /// Built-in authentic offline Hadiths for every collection
  static List<HadithItem> getOfflineHadithsForBook(String slug) {
    return _offlineHadithsByBook[slug] ?? _offlineHadithsByBook['bukhari']!;
  }

  static const Map<String, List<HadithItem>> _offlineHadithsByBook = {
    'bukhari': [
      HadithItem(
        hadithNumber: 1,
        bookSlug: 'bukhari',
        bookNameBengali: 'সহীহ বুখারী',
        chapterTitle: 'ওহীর সূচনা অধ্যায়',
        arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى دُنْيَا يُصِيبُهَا أَوْ إِلَى امْرَأَةٍ يَنْكِحُهَا فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ',
        bengali: 'সকল কাজের ফলাফল নিয়তের ওপর নির্ভরশীল এবং প্রত্যেক ব্যক্তি তাই পাবে যা সে নিয়ত করবে। সুতরাং যার হিজরত আল্লাহ ও তাঁর রাসূলের উদ্দেশ্যে হবে, তার হিজরত আল্লাহ ও তাঁর রাসূলের উদ্দেশ্যেই গণ্য হবে।',
        narrator: 'উমর ইবনুল খাত্তাব (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 2,
        bookSlug: 'bukhari',
        bookNameBengali: 'সহীহ বুখারী',
        chapterTitle: 'ঈমান অধ্যায়',
        arabic: 'بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَإِقَامِ الصَّلاَةِ، وَإِيتَاءِ الزَّكَاةِ، وَالْحَجِّ، وَصَوْمِ رَمَضَانَ',
        bengali: 'ইসলামের ভিত্তি পাঁচটি বিষয়ের ওপর স্থাপিত: এ সাক্ষ্য দেওয়া যে আল্লাহ ছাড়া কোনো মাবুদ নেই এবং মুহাম্মাদ (সা.) আল্লাহর রাসূল, নামাজ কায়েম করা, যাকাত প্রদান করা, হজ পালন করা এবং রমজান মাসের রোজা রাখা।',
        narrator: 'আব্দুল্লাহ ইবনে উমর (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 3,
        bookSlug: 'bukhari',
        bookNameBengali: 'সহীহ বুখারী',
        chapterTitle: 'ঈমান অধ্যায়',
        arabic: 'الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ، وَالْمُهَاجِرُ مَنْ هَجَرَ مَا نَهَى اللَّهُ عَنْهُ',
        bengali: 'প্রকৃত মুসলিম সে-ই, যার জিহ্বা ও হাত থেকে অন্য মুসলিমগণ নিরাপদ থাকে। আর প্রকৃত মুহাজির সে-ই, যে আল্লাহ তাআলা যা নিষেধ করেছেন তা পরিত্যাগ করে।',
        narrator: 'আব্দুল্লাহ ইবনে আমর (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 4,
        bookSlug: 'bukhari',
        bookNameBengali: 'সহীহ বুখারী',
        chapterTitle: 'ঈমান অধ্যায়',
        arabic: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
        bengali: 'তোমাদের কেউ ততক্ষণ পর্যন্ত পূর্ণ মুমিন হতে পারবে না, যতক্ষণ না সে নিজের জন্য যা পছন্দ করে তার মুসলিম ভাইয়ের জন্যও তা পছন্দ করবে।',
        narrator: 'আনাস ইবনে মালিক (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 5,
        bookSlug: 'bukhari',
        bookNameBengali: 'সহীহ বুখারী',
        chapterTitle: 'ইলম (জ্ঞান) অধ্যায়',
        arabic: 'مَنْ يُرِدِ اللَّهُ بِهِ خَيْرًا يُفَقِّهْهُ فِي الدِّينِ',
        bengali: 'আল্লাহ যার কল্যাণ চান, তাকে দ্বীনের গভীর প্রজ্ঞা ও সঠিক বুঝ দান করেন।',
        narrator: 'মুআবিয়া (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 6,
        bookSlug: 'bukhari',
        bookNameBengali: 'সহীহ বুখারী',
        chapterTitle: 'কুরআনের ফজিলত অধ্যায়',
        arabic: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
        bengali: 'তোমাদের মধ্যে সর্বোত্তম ঐ ব্যক্তি, যে নিজে কুরআন শিক্ষা করে এবং অপরকে তা শিক্ষা দেয়।',
        narrator: 'উসমান ইবনে আফফান (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 7,
        bookSlug: 'bukhari',
        bookNameBengali: 'সহীহ বুখারী',
        chapterTitle: 'আদব অধ্যায়',
        arabic: 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
        bengali: 'যে ব্যক্তি আল্লাহ ও আখিরাত দিবসের ওপর ঈমান রাখে, সে যেন উত্তম কথা বলে অথবা নীরব থাকে।',
        narrator: 'আবু হুরায়রা (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 8,
        bookSlug: 'bukhari',
        bookNameBengali: 'সহীহ বুখারী',
        chapterTitle: 'দোয়া ও জিকির অধ্যায়',
        arabic: 'كَلِمَتَانِ خَفِيفَتَانِ عَلَى اللِّسَانِ، ثَقِيلَتَانِ فِي الْمِيزَانِ، حَبِيبَتَانِ إِلَى الرَّحْمَنِ: سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
        bengali: 'দুটি বাক্য এমন রয়েছে যা উচ্চারণে খুবই সহজ, মীযানের পাল্লায় অত্যন্ত ভারী এবং দয়াময় আল্লাহর নিকট অতি প্রিয়: সুবহানাল্লাহি ওয়া বিহামদিহী, সুবহানাল্লাহিল আযীম।',
        narrator: 'আবু হুরায়রা (রাঃ)',
        grade: 'সহীহ',
      ),
    ],
    'muslim': [
      HadithItem(
        hadithNumber: 1,
        bookSlug: 'muslim',
        bookNameBengali: 'সহীহ মুসলিম',
        chapterTitle: 'পবিত্রতা অধ্যায়',
        arabic: 'الطُّهُورُ شَطْرُ الإِيمَانِ وَالْحَمْدُ لِلَّهِ تَمْلأُ الْمِيزَانَ',
        bengali: 'পবিত্রতা ঈমানের অঙ্গ (অর্ধেক)। আলহামদুলিল্লাহ মীযানের পাল্লাকে পূর্ণ করে দেয় এবং সুবহানাল্লাহ ও আলহামদুলিল্লাহ আসমান ও জমিনের মধ্যবর্তী স্থান পূর্ণ করে দেয়।',
        narrator: 'আবু মালিক আল-আশআরী (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 2,
        bookSlug: 'muslim',
        bookNameBengali: 'সহীহ মুসলিম',
        chapterTitle: 'ঈমান অধ্যায়',
        arabic: 'الدِّينُ النَّصِيحَةُ قُلْنَا لِمَنْ قَالَ لِلَّهِ وَلِكِتَابِهِ وَلِرَسُولِهِ وَلأَئِمَّةِ الْمُسْلِمِينَ وَعَامَّتِهِمْ',
        bengali: 'দ্বীন হলো কল্যাণকামিতা। আমরা জিজ্ঞেস করলাম: কার জন্য? রাসূলুল্লাহ (সা.) বললেন: আল্লাহর জন্য, তাঁর কিতাবের জন্য, তাঁর রাসূলের জন্য, মুসলিম নেতৃবৃন্দের জন্য এবং সাধারণ মুসলিমদের জন্য।',
        narrator: 'তামীম আদ-দারী (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 3,
        bookSlug: 'muslim',
        bookNameBengali: 'সহীহ মুসলিম',
        chapterTitle: 'সদকা ও ইনফাক অধ্যায়',
        arabic: 'مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ وَمَا زَادَ اللَّهُ عَبْدًا بِعَفْوٍ إِلاَّ عِزًّا وَمَا تَوَاضَعَ أَحَدٌ لِلَّهِ إِلاَّ رَفَعَهُ اللَّهُ',
        bengali: 'সদকা করলে সম্পদ কখনো কমে না। ক্ষমা করার কারণে আল্লাহ বান্দার মর্যাদা কেবল বৃদ্ধিই করেন। আর যে ব্যক্তি আল্লাহর সন্তুষ্টির জন্য বিনয়ী হয়, আল্লাহ তার মর্যাদা সমুন্নত করেন।',
        narrator: 'আবু হুরায়রা (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 4,
        bookSlug: 'muslim',
        bookNameBengali: 'সহীহ মুসলিম',
        chapterTitle: 'ইলম ও সওয়াব অধ্যায়',
        arabic: 'إِذَا مَاتَ الإِنْسَانُ انْقَطَعَ عَنْهُ عَمَلُهُ إِلاَّ مِنْ ثَلاَثَةٍ إِلاَّ مِنْ صَدَقَةٍ جَارِيَةٍ أَوْ عِلْمٍ يُنْتَفَعُ بِهِ أَوْ وَلَدٍ صَالِحٍ يَدْعُو لَهُ',
        bengali: 'মানুষ যখন মৃত্যুবরণ করে, তখন তার সমস্ত আমল বন্ধ হয়ে যায়; কেবল তিনটি আমল ব্যতীত: সদকায়ে জারিয়া, এমন জ্ঞান যা দ্বারা মানুষ উপকৃত হয় এবং নেককার সন্তান যে তার জন্য দোয়া করে।',
        narrator: 'আবু হুরায়রা (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 5,
        bookSlug: 'muslim',
        bookNameBengali: 'সহীহ মুসলিম',
        chapterTitle: 'আখলাক ও চরিত্র অধ্যায়',
        arabic: 'إِنَّ اللَّهَ لاَ يَنْظُرُ إِلَى صُوَرِكُمْ وَأَمْوَالِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ وَأَعْمَالِكُمْ',
        bengali: 'নিশ্চয় আল্লাহ তোমাদের বাহ্যিক অবয়ব ও সম্পদের দিকে তাকান না; বরং তিনি তোমাদের অন্তর ও আমলের দিকে তাকান।',
        narrator: 'আবু হুরায়রা (রাঃ)',
        grade: 'সহীহ',
      ),
    ],
    'abudawud': [
      HadithItem(
        hadithNumber: 1,
        bookSlug: 'abudawud',
        bookNameBengali: 'সুনানে আবু দাউদ',
        chapterTitle: 'পবিত্রতা অধ্যায়',
        arabic: 'مِفْتَاحُ الصَّلاَةِ الطُّهُورُ وَتَحْرِيمُهَا التَّكْبِيرُ وَتَحْلِيلُهَا التَّسْلِيمُ',
        bengali: 'নামাজের চাবি হলো পবিত্রতা (অজু), আর তাকবীরে তাহরীমা দ্বারা নামাজ শুরু হয় এবং সালাম ফেরানোর মাধ্যমে নামাজ শেষ হয়।',
        narrator: 'আলী ইবনে আবি তালিব (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 2,
        bookSlug: 'abudawud',
        bookNameBengali: 'সুনানে আবু দাউদ',
        chapterTitle: 'আদব ও সদাচরণ অধ্যায়',
        arabic: 'مَا مِنْ شَىْءٍ أَثْقَلُ فِي الْمِيزَانِ مِنْ حُسْنِ الْخُلُقِ',
        bengali: 'কিয়ামতের দিন মুমিনের মীযানের পাল্লায় উত্তম চরিত্রের চেয়ে অধিক ভারী আর কোনো জিনিস হবে না।',
        narrator: 'আবু দারদা (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 3,
        bookSlug: 'abudawud',
        bookNameBengali: 'সুনানে আবু দাউদ',
        chapterTitle: 'দোয়া অধ্যায়',
        arabic: 'الدُّعَاءُ هُوَ الْعِبَادَةُ',
        bengali: 'দোয়াই হলো মূল ইবাদত। অতঃপর রাসূলুল্লাহ (সা.) তিলাওয়াত করলেন: তোমাদের রব বলেন, তোমরা আমাকে ডাকো, আমি তোমাদের ডাকে সাড়া দেব।',
        narrator: 'নুমান ইবনে বশীর (রাঃ)',
        grade: 'সহীহ',
      ),
    ],
    'tirmidhi': [
      HadithItem(
        hadithNumber: 1,
        bookSlug: 'tirmidhi',
        bookNameBengali: 'জামে আত-তিরমিযী',
        chapterTitle: 'নেক আমল ও সদাচরণ অধ্যায়',
        arabic: 'اتَّقِ اللَّهِ حَيْثُمَا كُنْتَ وَأَتْبِعِ السَّيِّئَةَ الْحَسَنَةَ تَمْحُهَا وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ',
        bengali: 'তুমি যেখানেই থাকো আল্লাহকে ভয় করো, কোনো গুনাহ হয়ে গেলে সাথে সাথে নেক আমল করো যা সেটিকে মিটিয়ে দেবে এবং মানুষের সাথে উত্তম আচরণ করো।',
        narrator: 'আবু যর গিফারী (রাঃ)',
        grade: 'হাসান সহীহ',
      ),
      HadithItem(
        hadithNumber: 2,
        bookSlug: 'tirmidhi',
        bookNameBengali: 'জামে আত-তিরমিযী',
        chapterTitle: 'যুহদ ও তাকওয়া অধ্যায়',
        arabic: 'مِنْ حُسْنِ إِسْلاَمِ الْمَرْءِ تَرْكُهُ مَا لاَ يَعْنِيهِ',
        bengali: 'একজন মানুষের ইসলামের সৌন্দর্য হলো অনর্থক কথা ও কাজ পরিত্যাগ করা।',
        narrator: 'আবু হুরায়রা (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 3,
        bookSlug: 'tirmidhi',
        bookNameBengali: 'জামে আত-তিরমিযী',
        chapterTitle: 'দয়া ও অনুগ্রহ অধ্যায়',
        arabic: 'الرَّاحِمُونَ يَرْحَمُهُمُ الرَّحْمَنُ ارْحَمُوا مَنْ فِي الأَرْضِ يَرْحَمْكُمْ مَنْ فِي السَّمَاءِ',
        bengali: 'দয়াশীলদের প্রতি দয়াময় আল্লাহ রহম করেন। তোমরা পৃথিবীবাসীর প্রতি দয়া করো, তাহলে আকাশের অধিপতি আল্লাহ তোমাদের প্রতি দয়া করবেন।',
        narrator: 'আব্দুল্লাহ ইবনে আমর (রাঃ)',
        grade: 'সহীহ',
      ),
    ],
    'nasai': [
      HadithItem(
        hadithNumber: 1,
        bookSlug: 'nasai',
        bookNameBengali: 'সুনানে আন-নাসায়ী',
        chapterTitle: 'সালাত অধ্যায়',
        arabic: 'جُعِلَتْ قُرَّةُ عَيْنِي فِي الصَّلاَةِ',
        bengali: 'আমার চোখের শীতলতা ও প্রশান্তি রাখা হয়েছে নামাজের ভেতর।',
        narrator: 'আনাস ইবনে মালিক (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 2,
        bookSlug: 'nasai',
        bookNameBengali: 'সুনানে আন-নাসায়ী',
        chapterTitle: 'সিয়াম অধ্যায়',
        arabic: 'مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
        bengali: 'যে ব্যক্তি ঈমানের সাথে ও সওয়াবের আশায় রমজান মাসের রোজা রাখে, তার পূর্ববর্তী সকল গুনাহ ক্ষমা করে দেওয়া হয়।',
        narrator: 'আবু হুরায়রা (রাঃ)',
        grade: 'সহীহ',
      ),
    ],
    'ibnmajah': [
      HadithItem(
        hadithNumber: 1,
        bookSlug: 'ibnmajah',
        bookNameBengali: 'সুনানে ইবনে মাজাহ',
        chapterTitle: 'ইলম অধ্যায়',
        arabic: 'طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ',
        bengali: 'প্রত্যেক মুসলিমের ওপর দ্বীনি জ্ঞান অর্জন করা ফরজ।',
        narrator: 'আনাস ইবনে মালিক (রাঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 2,
        bookSlug: 'ibnmajah',
        bookNameBengali: 'সুনানে ইবনে মাজাহ',
        chapterTitle: 'আহকাম অধ্যায়',
        arabic: 'لاَ ضَرَرَ وَلاَ ضِرَارَ',
        bengali: 'ইসলামে নিজে কারো ক্ষতি করা যাবে না এবং প্রতিশোধ হিসেবেও কারো ক্ষতি করা যাবে না।',
        narrator: 'উবাদা ইবনে সামিত (রাঃ)',
        grade: 'সহীহ',
      ),
    ],
    'malik': [
      HadithItem(
        hadithNumber: 1,
        bookSlug: 'malik',
        bookNameBengali: 'মুয়াত্তা ইমাম মালিক',
        chapterTitle: 'কুরআন ও সুন্নাহ অধ্যায়',
        arabic: 'تَرَكْتُ فِيكُمْ أَمْرَيْنِ لَنْ تَضِلُّوا مَا تَمَسَّكْتُمْ بِهِمَا كِتَابَ اللَّهِ وَسُنَّةَ نَبِيِّهِ',
        bengali: 'আমি তোমাদের মাঝে দুটি জিনিস রেখে যাচ্ছি, যতক্ষণ তোমরা এ দুটিকে আঁকড়ে ধরে রাখবে ততক্ষণ কখনোই পথভ্রষ্ট হবে না: আল্লাহর কিতাব (আল-কুরআন) এবং তাঁর নবীর সুন্নাহ।',
        narrator: 'ইমাম মালিক (রহঃ)',
        grade: 'সহীহ',
      ),
      HadithItem(
        hadithNumber: 2,
        bookSlug: 'malik',
        bookNameBengali: 'মুয়াত্তা ইমাম মালিক',
        chapterTitle: 'উত্তম চরিত্র অধ্যায়',
        arabic: 'إِنَّمَا بُعِثْتُ لأُتَمِّمَ حُسْنَ الأَخْلاَقِ',
        bengali: 'নিশ্চয় আমি প্রেরিত হয়েছি উত্তম চরিত্রের পরিপূর্ণতা সাধনের জন্য।',
        narrator: 'আবু হুরায়রা (রাঃ)',
        grade: 'সহীহ',
      ),
    ],
  };
}
