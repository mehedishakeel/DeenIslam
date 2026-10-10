import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';

class SalatGuideScreen extends StatelessWidget {
  const SalatGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'সালাত ও অজু শিক্ষা',
            style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: AppColors.emerald,
            unselectedLabelColor:
                isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            indicatorColor: AppColors.emerald,
            labelStyle: GoogleFonts.hindSiliguri(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'অজু ও পবিত্রতা'),
              Tab(text: 'রাকাত ও নিয়ম'),
              Tab(text: 'নামাজের দোয়া'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildWuduTab(context, isDark),
            _buildRakatTab(context, isDark),
            _buildSalatDuasTab(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildWuduTab(BuildContext context, bool isDark) {
    final wuduSteps = [
      {
        'step': '১',
        'title': 'নিয়ত ও বিসমিল্লাহ পাঠ',
        'desc': 'মনে মনে পবিত্রতা অর্জনের নিয়ত করা এবং "বিসমিল্লাহির রাহমানির রাহীম" বলে অজু শুরু করা।',
      },
      {
        'step': '২',
        'title': 'উভয় হাতের কব্জি পর্যন্ত ধৌত করা',
        'desc': 'ডান হাত আগে এবং পরে বাম হাত কব্জি পর্যন্ত ভালোভাবে ৩ বার ধৌত করা ও আঙুল খিলাল করা।',
      },
      {
        'step': '৩',
        'title': 'কুলি করা ও নাকে পানি দেওয়া',
        'desc': 'ডান হাতে পানি নিয়ে ৩ বার কুলি করা এবং নাকে পানি দিয়ে বাম হাত দিয়ে নাক পরিষ্কার করা।',
      },
      {
        'step': '৪',
        'title': 'সমস্ত মুখমণ্ডল ধৌত করা (ফরজ)',
        'desc': 'কপালের চুলের গোড়া থেকে থুতনির নিচ পর্যন্ত এবং এক কানের লতি থেকে অন্য কানের লতি পর্যন্ত ৩ বার ধৌত করা।',
      },
      {
        'step': '৫',
        'title': 'উভয় হাত কনুইসহ ধৌত করা (ফরজ)',
        'desc': 'প্রথমে ডান হাত এবং পরে বাম হাতের আঙুলের মাথা থেকে কনুইসহ ৩ বার ভালোভাবে ধৌত করা।',
      },
      {
        'step': '৬',
        'title': 'মাথা ও কান মাসেহ করা (ফরজ)',
        'desc': 'ভেজা হাতে মাথার চারভাগের একভাগ বা সম্পূর্ণ মাথা ১ বার মাসেহ করা এবং শাহাদাত ও বৃদ্ধাঙ্গুলি দিয়ে কান মাসেহ করা।',
      },
      {
        'step': '৭',
        'title': 'উভয় পা টাখনুসহ ধৌত করা (ফরজ)',
        'desc': 'ডান পা আগে এবং বাম পা পরে টাখনুসহ (গিরাসহ) ৩ বার ধৌত করা ও পায়ের আঙুল খিলাল করা।',
      },
    ];

    final wuduBreakers = [
      'পায়খানা বা প্রস্রাবের রাস্তা দিয়ে কোনো কিছু বের হওয়া।',
      'শরীরের কোনো স্থান হতে রক্ত বা পুঁজ বের হয়ে গড়িয়ে পড়া।',
      'মুখ ভরে বমি হওয়া।',
      'চিত বা কাত হয়ে কিংবা হেলান দিয়ে ঘুমিয়ে পড়া।',
      'পাগল, মাতাল বা অচেতন হয়ে যাওয়া।',
      'নামাজের ভেতর উচ্চস্বরে (অট্টহাসি) হাসা।',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF065F46), Color(0xFF047857)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'অজুর ফরজ ৪টি',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '১. সমস্ত মুখমণ্ডল একবার ধৌত করা • ২. উভয় হাত কনুইসহ একবার ধৌত করা • ৩. মাথার এক-চতুর্থাংশ মাসেহ করা • ৪. উভয় পা টাখনুসহ একবার ধৌত করা (সূরা মায়িদাহ: ৬)',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12.5,
                  color: Colors.white.withOpacity(0.92),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'অজু করার সুন্নাহসম্মত ধারাবাহিক নিয়ম',
          style: GoogleFonts.hindSiliguri(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 10),
        ...wuduSteps.map((s) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    s['step']!,
                    style: GoogleFonts.hindSiliguri(
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s['title']!,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s['desc']!,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12.5,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        _buildDuaCard(
          context,
          isDark: isDark,
          title: 'অজু শেষে পাঠ করার দোয়া (কালিমায়ে শাহাদাত)',
          arabic:
              'أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ، اللّٰهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',
          pronunciation:
              'আশহাদু আল লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারীকা লাহু, ওয়া আশহাদু আন্না মুহাম্মাদান আবদুহু ওয়া রাসূলুহু। আল্লাহুম্মাজ আলনী মিনাত তাওয়াবীনা ওয়াজ আলনী মিনাল মুতাতাহহিরীন।',
          meaning:
              'আমি সাক্ষ্য দিচ্ছি যে আল্লাহ ছাড়া কোনো উপাস্য নেই, তিনি এক ও অদ্বিতীয় এবং মুহাম্মাদ (সা.) তাঁর বান্দা ও রাসূল। হে আল্লাহ! আমাকে তওবাকারীদের অন্তর্ভুক্ত করুন এবং পবিত্রতা অর্জনকারীদের অন্তর্ভুক্ত করুন। (সহীহ মুসলিম ও তিরমিযী)',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'অজু ভঙ্গের প্রধান কারণসমূহ',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 8),
              ...wuduBreakers.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '${BengaliNumerals.convert(e.key + 1)}. ${e.value}',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12.5,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRakatTab(BuildContext context, bool isDark) {
    final rakatRows = [
      {
        'waqt': 'ফজর',
        'sunnahBefore': '২ (সুন্নাতে মুয়াক্কাদাহ)',
        'farz': '২',
        'sunnahAfter': '—',
        'naflWitr': '—',
        'total': '৪ রাকাত',
      },
      {
        'waqt': 'যোহর',
        'sunnahBefore': '৪ (সুন্নাতে মুয়াক্কাদাহ)',
        'farz': '৪',
        'sunnahAfter': '২ (সুন্নাত)',
        'naflWitr': '২ নফল',
        'total': '১২ রাকাত',
      },
      {
        'waqt': 'আসর',
        'sunnahBefore': '৪ (সুন্নাতে যায়েদাহ)',
        'farz': '৪',
        'sunnahAfter': '—',
        'naflWitr': '—',
        'total': '৮ রাকাত',
      },
      {
        'waqt': 'মাগরিব',
        'sunnahBefore': '—',
        'farz': '৩',
        'sunnahAfter': '২ (সুন্নাত)',
        'naflWitr': '২ নফল',
        'total': '৭ রাকাত',
      },
      {
        'waqt': 'এশা ও বিতর',
        'sunnahBefore': '৪ (সুন্নাতে যায়েদাহ)',
        'farz': '৪',
        'sunnahAfter': '২ (সুন্নাত)',
        'naflWitr': '২ নফল + ৩ বিতর + ২ নফল',
        'total': '১৭ রাকাত',
      },
      {
        'waqt': 'জুমআ',
        'sunnahBefore': '৪ (কাবলাল জুমআ)',
        'farz': '২',
        'sunnahAfter': '৪ + ২ (বাদাল জুমআ)',
        'naflWitr': '২ নফল',
        'total': '১৪ রাকাত',
      },
    ];

    final farzList = [
      'শরীর পাক হওয়া',
      'কাপড় পাক হওয়া',
      'নামাজের জায়গা পাক হওয়া',
      'সতর ঢাকা (পুরুষের নাভি থেকে হাঁটু, নারীদের মুখ-হাত-পা ছাড়া সমস্ত শরীর)',
      'কিবলামুখী হওয়া',
      'ওয়াক্তমতো নামাজ পড়া',
      'নামাজের নিয়ত করা',
      'তাকবীরে তাহরীমা (আল্লাহু আকবার) বলা',
      'দাঁড়িয়ে নামাজ পড়া (কেয়াম করা)',
      'কিরাত পড়া (কমপক্ষে তিন ছোট আয়াত বা এক বড় আয়াত)',
      'রুকু করা',
      'দুই সিজদা করা',
      'শেষ বৈঠকে তাশাহহুদ পরিমাণ বসা',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'পাঁচ ওয়াক্ত ও জুমআর নামাজের রাকাত তালিকা',
          style: GoogleFonts.hindSiliguri(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 10),
        ...rakatRows.map((row) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      row['waqt']!,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'মোট ${row['total']}',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _rakatBadge(isDark, 'পূর্বের সুন্নাত: ${row['sunnahBefore']}'),
                    _rakatBadge(isDark, 'ফরজ: ${row['farz']} রাকাত', highlight: true),
                    _rakatBadge(isDark, 'পরের সুন্নাত: ${row['sunnahAfter']}'),
                    if (row['naflWitr'] != '—')
                      _rakatBadge(isDark, 'নফল/বিতর: ${row['naflWitr']}'),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'নামাজের ১৩টি ফরজ (৭টি আহকাম + ৬টি আরকান)',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 10),
              ...farzList.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${BengaliNumerals.convert(e.key + 1)}. ',
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                          fontSize: 12.5,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.value,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12.5,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _rakatBadge(bool isDark, String text, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.amberSoft
            : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.hindSiliguri(
          fontSize: 11.5,
          fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
          color: highlight
              ? AppColors.amberDark
              : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
        ),
      ),
    );
  }

  Widget _buildSalatDuasTab(BuildContext context, bool isDark) {
    final salatDuas = [
      {
        'title': '১. সানা (তাকবীরে তাহরীমার পর)',
        'arabic':
            'سُبْحَانَكَ اللّٰهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَىٰ جَدُّكَ وَلَا إِلٰهَ غَيْرُكَ',
        'pronunciation':
            'সুবহানাকাল্লাহুম্মা ওয়া বিহামদিকা ওয়া তাবারাকাসমুকা ওয়া তাআলা জাদ্দুকা ওয়া লা ইলাহা গাইরুক।',
        'meaning':
            'হে আল্লাহ! আমি আপনার পবিত্রতা ও প্রশংসা বর্ণনা করছি। আপনার নাম বরকতময়, আপনার মর্যাদা অতি উচ্চে এবং আপনি ছাড়া কোনো মাবুদ নেই।',
      },
      {
        'title': '২. রুকু ও সিজদার তাসবীহ',
        'arabic':
            'سُبْحَانَ رَبِّيَ الْعَظِيمِ • سَمِعَ اللّٰهُ لِمَنْ حَمِدَهُ • رَبَّنَا لَكَ الْحَمْدُ • سُبْحَانَ رَبِّيَ الْأَعْلَىٰ',
        'pronunciation':
            'রুকুতে: সুবহানা রাব্বিয়াল আযীম (৩ বার) • উঠার সময়: সামিআল্লাহু লিমান হামিদাহ, রাব্বানা লাকাল হামদ • সিজদায়: সুবহানা রাব্বিয়াল আলা (৩ বার)।',
        'meaning':
            'আমার মহান রবের পবিত্রতা বর্ণনা করছি • আল্লাহ তার কথা শোনেন যে তাঁর প্রশংসা করে • হে আমাদের রব! সকল প্রশংসা আপনারই • আমার সুমহান রবের পবিত্রতা বর্ণনা করছি।',
      },
      {
        'title': '৩. তাশাহহুদ (আত্তাহিয়্যাতু)',
        'arabic':
            'التَّحِيَّاتُ لِلّٰهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللّٰهِ وَبَرَكَاتُهُ، السَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ اللّٰهِ الصَّالِحِينَ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
        'pronunciation':
            'আত্তাহিয়্যাতু লিল্লাহি ওয়াস সালাওয়াতু ওয়াত ত্বায়্যিবাতু, আসসালামু আলাইকা আইয়্যুহান নাবিয়্যু ওয়া রাহমাতুল্লাহি ওয়া বারাকাতুহু, আসসালামু আলাইনা ওয়া আলা ইবাদিল্লাহিস সালিহীন। আশহাদু আল লা ইলাহা ইল্লাল্লাহু ওয়া আশহাদু আন্না মুহাম্মাদান আবদুহু ওয়া রাসূলুহু।',
        'meaning':
            'সকল মৌখিক, শারীরিক ও আর্থিক ইবাদত আল্লাহর জন্য। হে নবী! আপনার ওপর আল্লাহর শান্তি, রহমত ও বরকত বর্ষিত হোক। আমাদের ওপর এবং আল্লাহর নেক বান্দাদের ওপর শান্তি বর্ষিত হোক। আমি সাক্ষ্য দিচ্ছি আল্লাহ ছাড়া কোনো উপাস্য নেই এবং মুহাম্মাদ (সা.) তাঁর বান্দা ও রাসূল।',
      },
      {
        'title': '৪. দরুদ শরীফ (দরুদে ইব্রাহীম)',
        'arabic':
            'اللّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ، اللّٰهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
        'pronunciation':
            'আল্লাহুম্মা সাল্লি আলা মুহাম্মাদিঁউ ওয়া আলা আলি মুহাম্মাদ, কামা সাল্লাইতা আলা ইব্রাহীমা ওয়া আলা আলি ইব্রাহীম, ইন্নাকা হামীদুম মাজীদ। আল্লাহুম্মা বারিক আলা মুহাম্মাদিঁউ ওয়া আলা আলি মুহাম্মাদ, কামা বারাকতা আলা ইব্রাহীমা ওয়া আলা আলি ইব্রাহীম, ইন্নাকা হামীদুম মাজীদ।',
        'meaning':
            'হে আল্লাহ! মুহাম্মাদ (সা.) ও তাঁর পরিবারের ওপর রহমত বর্ষণ করুন, যেমন ইব্রাহীম (আ.) ও তাঁর পরিবারের ওপর রহমত বর্ষণ করেছেন। নিশ্চয়ই আপনি প্রশংসিত ও মহামহিম।',
      },
      {
        'title': '৫. দোয়া মাসুরা (সালাম ফেরানোর পূর্বে)',
        'arabic':
            'اللّٰهُمَّ إِنِّي ظَلَمْتُ نَفْسِي ظُلْمًا كَثِيرًا وَلَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ فَاغْفِرْ لِي مَغْفِرَةً مِنْ عِنْدِكَ وَارْحَمْنِي إِنَّكَ أَنْتَ الْغَفُورُ الرَّحِيمُ',
        'pronunciation':
            'আল্লাহুম্মা ইন্নী যালামতু নাফসী যুলমান কাসীরাঁও ওয়ালা ইয়াগফিরুয যুনূবা ইল্লা আনতা, ফাগফির লী মাগফিরাতাম মিন ইনদিকা ওয়ারহামনী ইন্নাকা আনতাল গাফূরুর রাহীম।',
        'meaning':
            'হে আল্লাহ! আমি আমার নিজের ওপর অনেক জুলুম করেছি এবং আপনি ছাড়া গুনাহ ক্ষমা করার কেউ নেই। অতএব আপনার পক্ষ হতে আমাকে ক্ষমা করুন এবং দয়া করুন। নিশ্চয়ই আপনি পরম ক্ষমাশীল ও দয়ালু।',
      },
      {
        'title': '৬. দোয়া কুনুত (বিতর নামাজের ৩য় রাকাতে)',
        'arabic':
            'اللّٰهُمَّ إِنَّا نَسْتَعِينُكَ وَنَسْتَغْفِرُكَ وَنُؤْمِنُ بِكَ وَنَتَوَكَّلُ عَلَيْكَ وَنُثْنِي عَلَيْكَ الْخَيْرَ وَنَشْكُرُكَ وَلَا نَكْفُرُكَ وَنَخْلَعُ وَنَتْرُكُ مَنْ يَفْجُرُكَ',
        'pronunciation':
            'আল্লাহুম্মা ইন্না নাসতাঈনুকা ওয়া নাসতাগফিরুকা ওয়া নুমিনু বিকা ওয়া নাতাওয়াক্কালু আলাইকা ওয়া নুসনী আলাইকাল খাইর, ওয়া নাশকুরুকা ওয়ালা নাকফুরুকা ওয়া নাখলাউ ওয়া নাতরুকু মাই ইয়াফজুরুকা।',
        'meaning':
            'হে আল্লাহ! আমরা আপনারই সাহায্য চাই, আপনারই নিকট ক্ষমা প্রার্থনা করি, আপনার প্রতি ঈমান আনি, আপনার ওপরই ভরসা করি এবং আপনার অকৃতজ্ঞ হই না।',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: salatDuas.length,
      itemBuilder: (context, index) {
        final d = salatDuas[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildDuaCard(
            context,
            isDark: isDark,
            title: d['title']!,
            arabic: d['arabic']!,
            pronunciation: d['pronunciation']!,
            meaning: d['meaning']!,
          ),
        );
      },
    );
  }

  Widget _buildDuaCard(
    BuildContext context, {
    required bool isDark,
    required String title,
    required String arabic,
    required String pronunciation,
    required String meaning,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emerald,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: '$title\n$arabic\n$pronunciation\n$meaning'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'দোয়া কপি করা হয়েছে',
                        style: GoogleFonts.hindSiliguri(fontSize: 13),
                      ),
                      duration: const Duration(seconds: 1),
                      backgroundColor: AppColors.emerald,
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 17, color: AppColors.emerald),
                tooltip: 'কপি করুন',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: 22,
                height: 1.85,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'উচ্চারণ: $pronunciation',
            style: GoogleFonts.hindSiliguri(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'অর্থ: $meaning',
            style: GoogleFonts.hindSiliguri(
              fontSize: 12.5,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
