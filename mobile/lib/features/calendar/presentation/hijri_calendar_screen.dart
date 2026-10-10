import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';

class HijriCalendarScreen extends StatelessWidget {
  const HijriCalendarScreen({super.key});

  static const List<Map<String, String>> _hijriMonths = [
    {'num': '১', 'name': 'মুহাররম (الْمُحَرَّم)', 'type': 'সম্মানিত মাস (আশুরা)'},
    {'num': '২', 'name': 'সফর (صَفَر)', 'type': 'হিজরি ২য় মাস'},
    {'num': '৩', 'name': 'রবিউল আউয়াল (رَبِيع الْأَوَّل)', 'type': 'রাসূল (সা.)-এর জন্ম ও ওফাত মাস'},
    {'num': '৪', 'name': 'রবিউস সানী (رَبِيع الثَّانِي)', 'type': 'হিজরি ৪র্থ মাস'},
    {'num': '৫', 'name': 'জমাদিউল আউয়াল (جُمَادَىٰ الْأُولَىٰ)', 'type': 'হিজরি ৫ম মাস'},
    {'num': '৬', 'name': 'জমাদিউস সানী (جُمَادَىٰ الآخِرَة)', 'type': 'হিজরি ৬ষ্ঠ মাস'},
    {'num': '৭', 'name': 'রজব (رَجَب)', 'type': 'সম্মানিত মাস (ইসরা ও মিরাজ)'},
    {'num': '৮', 'name': 'শাবান (شَعْبَان)', 'type': 'রমজানের প্রস্তুতির মাস'},
    {'num': '৯', 'name': 'রমজান (رَمَضَان)', 'type': 'সিয়াম ও কুরআন নাযিলের মাস'},
    {'num': '১০', 'name': 'শাওয়াল (شَوَّال)', 'type': 'ঈদুল ফিতর ও হজ্জের মাস'},
    {'num': '১১', 'name': 'জিলকদ (ذُو الْقَعْدَة)', 'type': 'সম্মানিত মাস (হজ্জের মাস)'},
    {'num': '১২', 'name': 'জিলহজ্জ (ذُو الْحِجَّة)', 'type': 'সম্মানিত মাস (হজ্জ ও কুরবানি)'},
  ];

  static const List<Map<String, String>> _specialDays = [
    {
      'date': '১০ মুহাররম',
      'title': 'পবিত্র আশুরা (ইয়াওমু আশুরা)',
      'desc':
          'মূসা (আ.) ও বনী ইসরাঈলের নাজাতের দিন। ৯ ও ১০ মুহাররম (অথবা ১০ ও ১১ মুহাররম) ২ দিন রোজা রাখলে পূর্ববর্তী ১ বছরের সগীরা গুনাহ মাফ হয় (সহীহ মুসলিম: ১১৬২)।',
    },
    {
      'date': '১২ রবিউল আউয়াল',
      'title': 'সীরাতুন্নবী (সা.) ও ওফাত দিবস',
      'desc':
          'বিশ্বনবী মুহাম্মাদুর রাসূলুল্লাহ (সা.)-এর দুনিয়ায় আগমন, হিজরত ও ওফাতের ঐতিহাসিক মাস। বেশি বেশি দরুদ পাঠ ও সুন্নাহর অনুসরণ কাম্য।',
    },
    {
      'date': '২৭ রজব',
      'title': 'শবে মেরাজ (ইসরা ও মিরাজ)',
      'desc':
          'রাসূলুল্লাহ (সা.)-এর মসজিদুল হারাম থেকে মসজিদুল আকসা এবং সপ্তাকাশ ভ্রমণের অলৌকিক রজনী, যে রাতে ৫ ওয়াক্ত সালাত ফরজ হয়।',
    },
    {
      'date': '১৫ শাবান',
      'title': 'লাইলাতুন নিসফি মিন শাবান',
      'desc':
          'শাবান মাসে রাসূলুল্লাহ (সা.) সবচেয়ে বেশি নফল রোজা রাখতেন এবং রবের দরবারে আমল পেশ হওয়ার প্রস্তুতি নিতেন (সহীহ বুখারী ও মুসলিম)।',
    },
    {
      'date': '১ রমজান — ৩০ রমজান',
      'title': 'মাহে রমজান ও ফরজ সিয়াম',
      'desc':
          'রহমত, মাগফিরাত ও নাজাতের মাস। পবিত্র কুরআন নাযিলের মাস এবং ঈমান ও ইহতিসাবের সাথে সিয়াম ও তারাবীহ আদায়ের মাস।',
    },
    {
      'date': 'রমজানের শেষ দশকের বেজোড় রাত (২১, ২৩, ২৫, ২৭, ২৯)',
      'title': 'শবে কদর (লাইলাতুল কদর)',
      'desc':
          'হাজার মাসের চেয়েও উত্তম রজনী (সূরা আল-কদর)। এই রাতে ইবাদত করলে ৮৩ বছর ৪ মাসের চেয়েও বেশি ইবাদতের সওয়াব পাওয়া যায়।',
    },
    {
      'date': '১ শাওয়াল',
      'title': 'পবিত্র ঈদুল ফিতর',
      'desc':
          'দীর্ঘ এক মাস সিয়াম সাধনার পর আনন্দ ও শুকরিয়ার দিন। ঈদের সালাতের পূর্বেই সদকাতুল ফিতর আদায় করা ওয়াজিব।',
    },
    {
      'date': '৯ জিলহজ্জ',
      'title': 'ইয়াওমু আরাফাহ (আরাফার দিন)',
      'desc':
          'হজ্জের প্রধান রুকন। হাজী ছাড়া অন্যদের জন্য আরাফার দিনের ১টি রোজা পূর্ববর্তী ১ বছর ও পরবর্তী ১ বছরের গুনাহ মোচন করে (সহীহ মুসলিম: ১১৬২)।',
    },
    {
      'date': '১০ জিলহজ্জ',
      'title': 'পবিত্র ঈদুল আযহা (কুরবানির ঈদ)',
      'desc':
          'ইব্রাহীম (আ.)-এর মহান আত্মত্যাগের স্মরণে ঈদের সালাত ও পশু কুরবানির দিন। ৯ জিলহজ্জ ফজর থেকে ১৩ জিলহজ্জ আসর পর্যন্ত তাকবীরে তাশরীক পাঠ করা ওয়াজিব।',
    },
  ];

  static const List<Map<String, String>> _sunnahFasts = [
    {
      'title': 'আইয়ামে বীজের ৩টি রোজা (প্রতি হিজরি মাসের ১৩, ১৪ ও ১৫ তারিখ)',
      'desc':
          'প্রতি চান্দ্র মাসের ১৩, ১৪ ও ১৫ তারিখ রোজা রাখা সারা বছর রোজা রাখার সমতুল্য। এটি রাসূলুল্লাহ (সা.)-এর নিয়মিত অসিয়ত ও সুন্নাহ (সহীহ বুখারী: ১৯৭৫)।',
    },
    {
      'title': 'প্রতি সপ্তাহের সোমবার ও বৃহস্পতিবারের রোজা',
      'desc':
          'সোমবার ও বৃহস্পতিবার বান্দার আমল আল্লাহর দরবারে পেশ করা হয়, তাই রাসূলুল্লাহ (সা.) এই দুই দিন রোজা রাখতে পছন্দ করতেন (সুনান তিরমিযী: ৭৪৭)।',
    },
    {
      'title': 'শাওয়াল মাসের ৬টি রোজা',
      'desc':
          'রমজানের রোজা রাখার পর শাওয়াল মাসে ৬টি রোজা রাখলে পূর্ণ এক বছর রোজা রাখার সওয়াব পাওয়া যায় (সহীহ মুসলিম: ১১৬৪)।',
    },
    {
      'title': 'জিলহজ্জ মাসের প্রথম ৯ দিনের রোজা (বিশেষ করে ৯ জিলহজ্জ আরাফার রোজা)',
      'desc':
          'জিলহজ্জের প্রথম দশকের নেক আমল আল্লাহর কাছে বছরের অন্য যেকোনো দিনের চেয়ে অধিক প্রিয় (সহীহ বুখারী: ৯৬৯)।',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'হিজরি ক্যালেন্ডার ও দিবসসমূহ',
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
              Tab(text: 'ইসলামিক দিবস'),
              Tab(text: 'হিজরি ১২ মাস'),
              Tab(text: 'নফল রোজা'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSpecialDaysTab(isDark),
            _buildHijriMonthsTab(isDark),
            _buildSunnahFastsTab(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialDaysTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _specialDays.length,
      itemBuilder: (context, index) {
        final item = _specialDays[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.emeraldSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['date']!,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emerald,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['title']!,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item['desc']!,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12.8,
                  height: 1.48,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHijriMonthsTab(bool isDark) {
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
                'আশহুরে হুরুম (৪টি সম্মানিত মাস)',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'পবিত্র কুরআনে (সূরা আত-তাওবাহ: ৩৬) ১২ মাসের মধ্যে ৪টি মাসকে বিশেষ সম্মানিত ঘোষণা করা হয়েছে: ১. জিলকদ • ২. জিলহজ্জ • ৩. মুহাররম • ৪. রজব।',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12.8,
                  height: 1.5,
                  color: Colors.white.withOpacity(0.92),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ..._hijriMonths.map((m) {
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
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    m['num']!,
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
                        m['name']!,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        m['type']!,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSunnahFastsTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sunnahFasts.length,
      itemBuilder: (context, index) {
        final item = _sunnahFasts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
                '${BengaliNumerals.convert(index + 1)}. ${item['title']}',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['desc']!,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
