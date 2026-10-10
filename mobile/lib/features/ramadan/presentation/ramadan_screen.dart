import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/models/prayer_times_model.dart';

class RamadanScreen extends StatefulWidget {
  const RamadanScreen({super.key});

  @override
  State<RamadanScreen> createState() => _RamadanScreenState();
}

class _RamadanScreenState extends State<RamadanScreen> {
  String _selectedCity = 'ঢাকা';
  late PrayerTimesModel _prayerTimes;
  final Set<int> _completedRozaDays = {1, 2, 3};
  final Map<String, bool> _dailyAmals = {
    'আজকের রোজা / নফল সিয়াম পালন': true,
    'পাঁচ ওয়াক্ত ফরজ সালাত আদায়': true,
    'তারাবীহ / তাহাজ্জুদ সালাত আদায়': false,
    'কমপক্ষে ১ পৃষ্ঠা কুরআন তিলাওয়াত': true,
    'সকাল ও সন্ধ্যার মাসনুন যিকির': false,
    'দৈনিক দান-সদকা ও ইফতার করানো': false,
    'কমপক্ষে ১০০ বার ইস্তিগফার ও দরুদ পাঠ': true,
  };

  @override
  void initState() {
    super.initState();
    _prayerTimes = PrayerTimesModel.forCity(DateTime.now(), _selectedCity);
    _loadCity();
  }

  Future<void> _loadCity() async {
    final city = await StorageService.getSelectedCity();
    final rozaDays = await StorageService.getRamadanRozaDays();
    final amals = await StorageService.getRamadanDailyAmals(_dailyAmals);
    if (!mounted) return;
    setState(() {
      _selectedCity = city;
      _prayerTimes = PrayerTimesModel.forCity(DateTime.now(), city);
      _completedRozaDays
        ..clear()
        ..addAll(rozaDays);
      _dailyAmals
        ..clear()
        ..addAll(amals);
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
            'মাহে রমজান ও রোজা গাইড',
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
              Tab(text: 'সেহরি ও ইফতার'),
              Tab(text: 'রোজার মাসায়েল'),
              Tab(text: 'আমল ট্র্যাকার'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSehriIftarTab(isDark),
            _buildMasailTab(isDark),
            _buildTrackerTab(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSehriIftarTab(bool isDark) {
    final sehriTime = _prayerTimes.formatTime(_prayerTimes.imsak);
    final iftarTime = _prayerTimes.formatTime(_prayerTimes.maghrib);

    final duas = [
      {
        'title': 'ইফতারের সুন্নাহ দোয়া (আবু দাউদ: ২৩৫৭)',
        'arabic':
            'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللّٰهُ',
        'pronunciation':
            'যাহাবায যামাউ ওয়াবতাল্লাতিল উরূকু ওয়া সাবাতাল আজরু ইনশাআল্লাহ।',
        'meaning':
            'পিপাসা দূর হলো, শিরা-উপশিরা সিক্ত হলো এবং আল্লাহ চান তো সওয়াব নির্ধারিত হলো।',
      },
      {
        'title': 'ইফতারের প্রচলিত দোয়া',
        'arabic':
            'اللّٰهُمَّ لَكَ صُمْتُ وَعَلَىٰ رِزْقِكَ أَفْطَرْتُ',
        'pronunciation': 'বিসমিল্লাহি আল্লাহুম্মা লাকা সুমতু ওয়া আলা রিযকিকা আফতারতু।',
        'meaning':
            'হে আল্লাহ! আমি আপনারই সন্তুষ্টির জন্য রোজা রেখেছি এবং আপনারই দেওয়া রিযিক দ্বারা ইফতার করছি।',
      },
      {
        'title': 'অন্যের বাড়িতে ইফতার করলে মেজবানের জন্য দোয়া',
        'arabic':
            'أَفْطَرَ عِنْدَكُمُ الصَّائِمُونَ وَأَكَلَ طَعَامَكُمُ الْأَبْرَارُ وَصَلَّتْ عَلَيْكُمُ الْمَلَائِكَةُ',
        'pronunciation':
            'আফতারা ইনদাকুমুস সায়িমূনা ওয়া আকালা ত্বাআমাকুমুল আবরারু ওয়া সাল্লাত আলাইকুমুল মালাইকাহ।',
        'meaning':
            'রোজাদারগণ যেন তোমাদের কাছে ইফতার করে, নেককারগণ যেন তোমাদের খাবার খায় এবং ফেরেশতাগণ যেন তোমাদের জন্য মাগফিরাতের দোয়া করে।',
      },
      {
        'title': 'লাইলাতুল কদরের বিশেষ দোয়া (তিরমিযী: ৩৫১৩)',
        'arabic':
            'اللّٰهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
        'pronunciation': 'আল্লাহুম্মা ইন্নাকা আফুউবুন তুহিব্বুল আফওয়া ফা’ফু আন্নী।',
        'meaning':
            'হে আল্লাহ! নিশ্চয়ই আপনি পরম ক্ষমাশীল, আপনি ক্ষমা করতে ভালোবাসেন; অতএব আমাকে ক্ষমা করে দিন।',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Today's Sehri & Iftar Banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF065F46), Color(0xFF047857)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'আজকের সেহরি ও ইফতার ($_selectedCity)',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Icon(Icons.nights_stay_rounded, color: AppColors.amberLight),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'সেহরির শেষ সময়',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ভোর $sehriTime',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'ইফতারের সময়',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'সন্ধ্যা $iftarTime',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.amberLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...duas.map((d) {
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        d['title']!,
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
                          ClipboardData(
                            text: '${d['title']}\n${d['arabic']}\n${d['pronunciation']}\n${d['meaning']}',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'দোয়া কপি করা হয়েছে',
                              style: GoogleFonts.hindSiliguri(fontSize: 13),
                            ),
                            backgroundColor: AppColors.emerald,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 17, color: AppColors.emerald),
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
                    d['arabic']!,
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
                const SizedBox(height: 8),
                Text(
                  'উচ্চারণ: ${d['pronunciation']}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'অর্থ: ${d['meaning']}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12.5,
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

  Widget _buildMasailTab(bool isDark) {
    final sections = [
      {
        'title': 'রোজা ভঙ্গের কারণসমূহ (কাজা ও কাফফারা)',
        'color': Colors.redAccent,
        'items': [
          'ইচ্ছাকৃতভাবে পানাহার বা ধূমপান করলে রোজা ভেঙে যায় (কাজা ও কাফফারা উভয়ই ওয়াজিব)।',
          'রোজা অবস্থায় ইচ্ছাকৃতভাবে সহবাস করলে কাজা ও কাফফারা উভয়ই ফরজ হয়।',
          'নাকে বা কানে ওষুধ/তেল প্রবেশ করালে এবং তা কণ্ঠনালীতে পৌঁছালে রোজা ভেঙে যায় (কাজা ওয়াজিব)।',
          'ইচ্ছাকৃতভাবে মুখ ভরে বমি করলে রোজা ভেঙে যায়।',
          'কুলি করার সময় অসতর্কতাবশত পেটে পানি চলে গেলে রোজা ভেঙে যায় (শুধু কাজা ওয়াজিব)।',
        ],
      },
      {
        'title': 'যেসব কারণে রোজা ভাঙে না',
        'color': AppColors.emerald,
        'items': [
          'ভুলে কিছু খেয়ে ফেললে বা পান করলে রোজা ভাঙে না (স্মরণ হওয়া মাত্রই বিরত হতে হবে)।',
          'মিসওয়াক করলে বা টুথপেস্ট ছাড়া দাঁত পরিষ্কার করলে রোজা ভাঙে না।',
          'চোখে ড্রপ বা সুরমা ব্যবহার করলে রোজা ভাঙে না।',
          'রক্ত পরীক্ষা করার জন্য রক্ত দিলে বা ইনসুলিন/টিকা নিলে রোজা ভাঙে না।',
          'অনিচ্ছাকৃতভাবে বমি হলে কিংবা স্বপ্নদোষ হলে রোজা ভাঙে না।',
        ],
      },
      {
        'title': 'ইতিকাফ ও সদকাতুল ফিতর (ফিতরা)',
        'color': AppColors.amberDark,
        'items': [
          'রমজানের শেষ দশকে (২০ রমজান সূর্যাস্তের পূর্ব থেকে ঈদের চাঁদ দেখা পর্যন্ত) মসজিদে ইতিকাফ করা সুন্নাতে মুয়াক্কাদাহ কিফায়াহ।',
          'ঈদুল ফিতরের নামাজের পূর্বেই সদকাতুল ফিতর (ফিতরা) আদায় করা ওয়াজিব।',
          'শাওয়াল মাসে ৬টি নফল রোজা রাখা পূর্ণ এক বছর রোজা রাখার সমতুল্য (সহীহ মুসলিম)।',
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final s = sections[index];
        final items = s['items'] as List<String>;
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
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
                s['title'] as String,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: s['color'] as Color,
                ),
              ),
              const SizedBox(height: 10),
              ...items.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${BengaliNumerals.convert(e.key + 1)}. ',
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                          color: s['color'] as Color,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.value,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            height: 1.45,
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
        );
      },
    );
  }

  Widget _buildTrackerTab(bool isDark) {
    final completedAmalCount = _dailyAmals.values.where((v) => v).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Daily Amal Progress
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
                    'দৈনিক রমজান ও নেক আমল চেকলিস্ট',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    '${BengaliNumerals.convert(completedAmalCount)}/${BengaliNumerals.convert(_dailyAmals.length)} সম্পন্ন',
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
                  value: completedAmalCount / _dailyAmals.length,
                  minHeight: 8,
                  color: AppColors.emerald,
                  backgroundColor: AppColors.emeraldSoft,
                ),
              ),
              const SizedBox(height: 10),
              ..._dailyAmals.entries.map((entry) {
                return CheckboxListTile(
                  value: entry.value,
                  activeColor: AppColors.emerald,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
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
                      _dailyAmals[entry.key] = val ?? false;
                    });
                    StorageService.setRamadanDailyAmals(_dailyAmals);
                  },
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 30 Days Roza Grid Tracker
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
                    '৩০ দিনের সিয়াম ট্র্যাকার (ট্যাপ করে মার্ক করুন)',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    '${BengaliNumerals.convert(_completedRozaDays.length)}/৩০ দিন',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 30,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final done = _completedRozaDays.contains(day);
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        if (done) {
                          _completedRozaDays.remove(day);
                        } else {
                          _completedRozaDays.add(day);
                        }
                      });
                      StorageService.setRamadanRozaDays(_completedRozaDays);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: done
                            ? AppColors.emerald
                            : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: done
                              ? AppColors.emerald
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                      ),
                      child: Text(
                        BengaliNumerals.convert(day),
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                          color: done
                              ? Colors.white
                              : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
