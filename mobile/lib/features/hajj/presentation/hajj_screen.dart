import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';

class HajjScreen extends StatefulWidget {
  const HajjScreen({super.key});

  @override
  State<HajjScreen> createState() => _HajjScreenState();
}

class _HajjScreenState extends State<HajjScreen> {
  final Map<String, bool> _hajjChecklist = {
    'মীকাত অতিক্রমের পূর্বে ইহরাম বাঁধা ও ২ রাকাত নফল পড়া': true,
    'তালবিয়াহ পাঠ (লাব্বাইক আল্লাহুম্মা লাব্বাইক)': true,
    'পবিত্র কাবা শরীফ ৭ চক্কর তাওয়াফ করা': false,
    'মাকামে ইব্রাহীমের পেছনে ২ রাকাত সালাত ও যমযমের পানি পান': false,
    'সাফা ও মারওয়া পাহাড়ে ৭ বার সাঈ করা': false,
    '৮ জিলহজ্জ মিনায় অবস্থান': false,
    '৯ জিলহজ্জ আরাফাতের ময়দানে অবস্থান (হজ্জের প্রধান ফরজ)': false,
    '৯ জিলহজ্জ রাতে মুযদালিফায় রাত্রিযাপন ও কঙ্কর সংগ্রহ': false,
    '১০ জিলহজ্জ বড় জামারায় ৭টি কঙ্কর নিক্ষেপ, কুরবানি ও হলক': false,
    'তাওয়াফে যিয়ারত (ফরজ তাওয়াফ) ও বিদায়ী তাওয়াফ সম্পন্ন করা': false,
  };

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    final saved = await StorageService.getHajjChecklist(_hajjChecklist);
    if (!mounted) return;
    setState(() {
      _hajjChecklist
        ..clear()
        ..addAll(saved);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'হজ্জ ও উমরাহ গাইড',
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
              Tab(text: 'তালবিয়াহ ও উমরাহ'),
              Tab(text: 'হজ্জের ৫ দিন'),
              Tab(text: 'চেকলিস্ট'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUmrahTab(isDark),
            _buildHajjDaysTab(isDark),
            _buildChecklistTab(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildUmrahTab(bool isDark) {
    final umrahSteps = [
      {
        'step': '১',
        'title': 'ইহরাম বাঁধা (ফরজ)',
        'desc':
            'মীকাত অতিক্রমের পূর্বে গোসল বা অজু করে সেলাইবিহীন দুই খণ্ড সাদা কাপড় (পুরুষদের জন্য) পরিধান করা, উমরাহর নিয়ত করা এবং তালবিয়াহ পাঠ করা।',
      },
      {
        'step': '২',
        'title': 'পবিত্র কাবা শরীফ তাওয়াফ করা (ফরজ)',
        'desc':
            'হাজরে আসওয়াদ থেকে শুরু করে কাবাঘরকে বামে রেখে ৭ চক্কর তাওয়াফ করা। তাওয়াফ শেষে মাকামে ইব্রাহীমের পেছনে ২ রাকাত সালাত আদায় ও যমযম পানি পান করা।',
      },
      {
        'step': '৩',
        'title': 'সাফা ও মারওয়া সাঈ করা (ওয়াজিব)',
        'desc':
            'সাফা পাহাড় থেকে শুরু করে মারওয়া পাহাড় পর্যন্ত ৭ বার প্রদক্ষিণ করা (সাফা থেকে মারওয়া ১ চক্কর, মারওয়া থেকে সাফা ২য় চক্কর)।',
      },
      {
        'step': '৪',
        'title': 'হলক বা কসর (মাথা মুণ্ডন বা চুল ছোট করা - ওয়াজিব)',
        'desc':
            'পুরুষগণ সম্পূর্ণ মাথা মুণ্ডন করবেন অথবা সমগ্র মাথার চুল সমানভাবে ছোট করবেন। নারীগণ চুলের অগ্রভাগ থেকে এক কর পরিমাণ কাটবেন। এর মাধ্যমে উমরাহ সম্পন্ন হয়।',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Talbiyah Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.emerald.withOpacity(0.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'তালবিয়াহ (হজ্জ ও উমরাহর প্রধান ধ্বনি)',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                        const ClipboardData(
                          text:
                              'لَبَّيْكَ اللّٰهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'তালবিয়াহ কপি করা হয়েছে',
                            style: GoogleFonts.hindSiliguri(fontSize: 13),
                          ),
                          backgroundColor: AppColors.emerald,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.emerald),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'لَبَّيْكَ اللّٰهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 23,
                    height: 1.9,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'উচ্চারণ: লাব্বাইক আল্লাহুম্মা লাব্বাইক, লাব্বাইকা লা শারীকা লাকা লাব্বাইক, ইন্নাল হামদা ওয়ান নি’মাতা লাকা ওয়াল মুলক, লা শারীকা লাক।',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'অর্থ: আমি হাজির হে আল্লাহ! আমি হাজির। আপনার কোনো শরীক নেই, আমি হাজির। নিশ্চয়ই সকল প্রশংসা ও নেয়ামত আপনারই এবং রাজত্বও আপনার; আপনার কোনো শরীক নেই।',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12.5,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'উমরাহ পালনের ৪টি ধারাবাহিক ধাপ',
          style: GoogleFonts.hindSiliguri(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 10),
        ...umrahSteps.map((s) {
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
      ],
    );
  }

  Widget _buildHajjDaysTab(bool isDark) {
    final days = [
      {
        'day': '৮ জিলহজ্জ (ইয়াওমুত তারবিয়াহ)',
        'place': 'মক্কা থেকে মিনা',
        'tasks':
            'ইহরাম বেঁধে মিনায় গমন এবং যোহর, আসর, মাগরিব, এশা ও ৯ জিলহজ্জ ফজর মোট ৫ ওয়াক্ত সালাত মিনায় আদায় ও রাত্রিযাপন (সুন্নাত)।',
      },
      {
        'day': '৯ জিলহজ্জ (ইয়াওমু আরাফাহ - হজ্জের প্রধান দিন)',
        'place': 'আরাফাতের ময়দান ও মুযদালিফা',
        'tasks':
            'সূর্যোদয়ের পর আরাফাতে গমন, যোহর থেকে সূর্যাস্ত পর্যন্ত আরাফাতে অবস্থান (হজ্জের প্রধান ফরজ)। সূর্যাস্তের পর মুযদালিফায় গিয়ে মাগরিব ও এশা একত্রে আদায়, রাত্রিযাপন এবং ৭০টি কঙ্কর সংগ্রহ।',
      },
      {
        'day': '১০ জিলহজ্জ (ইয়াওমুন নাহর / কুরবানির দিন)',
        'place': 'মিনা ও পবিত্র কাবা শরীফ',
        'tasks':
            '১. বড় জামারায় (জামারাতুল আকাবা) ৭টি কঙ্কর নিক্ষেপ • ২. দমে শোকর (হজ্জের কুরবানি) করা • ৩. মাথা মুণ্ডন বা চুল ছোট করে ইহরাম খোলা • ৪. মক্কায় গিয়ে ফরজ তাওয়াফ (তাওয়াফে যিয়ারত) ও সাঈ সম্পন্ন করা।',
      },
      {
        'day': '১১ ও ১২ জিলহজ্জ (আইয়ামে তাশরীক)',
        'place': 'মিনা',
        'tasks':
            'প্রতিদিন সূর্য ঢলে পড়ার পর প্রথমে ছোট, তারপর মধ্যম এবং শেষে বড় জামারায় ৭টি করে মোট ২১টি কঙ্কর নিক্ষেপ করা (ওয়াজিব)।',
      },
      {
        'day': 'মক্কা ত্যাগের পূর্বে (তাওয়াফে বিদা)',
        'place': 'মসজিদুল হারাম',
        'tasks':
            'মীকাতের বাইরের হাজীদের জন্য দেশে ফেরার পূর্বে বিদায়ী তাওয়াফ (তাওয়াফে ওয়াদা) করা ওয়াজিব।',
      },
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
                'হজ্জের ফরজ ৩টি',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '১. হজ্জের নিয়তে ইহরাম বাঁধা • ২. ৯ জিলহজ্জ আরাফাতের ময়দানে অবস্থান করা • ৩. তাওয়াফে যিয়ারত (১০-১২ জিলহজ্জের মধ্যে ফরজ তাওয়াফ) করা।',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12.5,
                  color: Colors.white.withOpacity(0.92),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...days.map((d) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(15),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        d['day']!,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.amberSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        d['place']!,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amberDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  d['tasks']!,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12.8,
                    height: 1.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildChecklistTab(bool isDark) {
    final completed = _hajjChecklist.values.where((v) => v).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'হজ্জ ও উমরাহর আমল চেকলিস্ট',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    '${BengaliNumerals.convert(completed)}/${BengaliNumerals.convert(_hajjChecklist.length)} সম্পন্ন',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: completed / _hajjChecklist.length,
                  minHeight: 8,
                  color: AppColors.emerald,
                  backgroundColor: AppColors.emeraldSoft,
                ),
              ),
              const SizedBox(height: 10),
              ..._hajjChecklist.entries.map((entry) {
                return CheckboxListTile(
                  value: entry.value,
                  activeColor: AppColors.emerald,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    entry.key,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      decoration: entry.value ? TextDecoration.lineThrough : null,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  onChanged: (val) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _hajjChecklist[entry.key] = val ?? false;
                    });
                    StorageService.setHajjChecklist(_hajjChecklist);
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
