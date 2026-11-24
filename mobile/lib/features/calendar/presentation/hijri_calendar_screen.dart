import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/repositories/islamic_calendar_data.dart';

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  int _offset = 0;
  late DateTime _now;
  Timer? _countdownTimer;

  // Monthly grid selection state
  late int _selectedCalMonth;
  late int _selectedCalYear;

  // Event filter state
  String _eventFilter = 'all';

  // Converter state
  DateTime _g2hSelectedDate = DateTime.now();
  int _h2gDay = 1;
  int _h2gMonth = 1;
  int _h2gYear = 1448;

  static const List<String> _bnMonthsFull = [
    "জানুয়ারি",
    "ফেব্রুয়ারি",
    "মার্চ",
    "এপ্রিল",
    "মে",
    "জুন",
    "জুলাই",
    "আগস্ট",
    "সেপ্টেম্বর",
    "অক্টোবর",
    "নভেম্বর",
    "ডিসেম্বর",
  ];

  static const List<String> _bnMonthsShort = [
    "জানু",
    "ফেব্রু",
    "মার্চ",
    "এপ্রিল",
    "মে",
    "জুন",
    "জুলাই",
    "আগস্ট",
    "সেপ্টে",
    "অক্টো",
    "নভে",
    "ডিসে",
  ];

  static const List<String> _bnWeekdays = [
    "",
    "সোমবার",
    "মঙ্গলবার",
    "বুধবার",
    "বৃহস্পতিবার",
    "শুক্রবার (পবিত্র জুমু'আ)",
    "শনিবার",
    "রবিবার",
  ];

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    final initialHijri = IslamicCalendarData.gregorianToHijri(_now, 0);
    _selectedCalMonth = initialHijri.month;
    _selectedCalYear = initialHijri.year;
    _h2gDay = initialHijri.day;
    _h2gMonth = initialHijri.month;
    _h2gYear = initialHijri.year;

    _loadStoredOffset();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadStoredOffset() async {
    final stored = await StorageService.getHijriOffset();
    if (!mounted) return;
    setState(() {
      _offset = stored;
      final h = IslamicCalendarData.gregorianToHijri(_now, _offset);
      _selectedCalMonth = h.month;
      _selectedCalYear = h.year;
      _h2gDay = h.day;
      _h2gMonth = h.month;
      _h2gYear = h.year;
    });
  }

  Future<void> _updateOffset(int newOffset) async {
    await StorageService.setHijriOffset(newOffset);
    if (!mounted) return;
    setState(() {
      _offset = newOffset;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'হিজরি তারিখ সমন্বয় করা হয়েছে (${newOffset >= 0 ? '+' : ''}${BengaliNumerals.toBengali(newOffset)} দিন)',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyTodayHijri(HijriDateInfo todayHijri) {
    final gStr =
        '${_bnWeekdays[_now.weekday]} • ${BengaliNumerals.toBengali(_now.day)} ${_bnMonthsFull[_now.month - 1]} ${BengaliNumerals.toBengali(_now.year)} খ্রিষ্টাব্দ';
    final text = 'আজকের ইসলামিক তারিখ: ${todayHijri.formattedBn} ($gStr)\n[DeenIslam]';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'আজকের হিজরি তারিখ কপি করা হয়েছে!',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateMonth(int delta) {
    setState(() {
      _selectedCalMonth += delta;
      if (_selectedCalMonth < 1) {
        _selectedCalMonth = 12;
        _selectedCalYear--;
      } else if (_selectedCalMonth > 12) {
        _selectedCalMonth = 1;
        _selectedCalYear++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todayHijri = IslamicCalendarData.gregorianToHijri(_now, _offset);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ইসলামিক ক্যালেন্ডার',
            style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.copy_outlined, size: 20),
              tooltip: 'আজকের হিজরি তারিখ কপি',
              onPressed: () => _copyTodayHijri(todayHijri),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.emerald,
            unselectedLabelColor:
                isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            indicatorColor: AppColors.emerald,
            labelStyle: GoogleFonts.hindSiliguri(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'আজ ও কাউন্টডাউন'),
              Tab(text: 'মাসিক দিনপঞ্জি'),
              Tab(text: 'তারিখ কনভার্টার'),
              Tab(text: '১২ মাস ও রোজা'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTodayAndCountdownsTab(isDark, todayHijri),
            _buildMonthlyGridTab(isDark, todayHijri),
            _buildConverterTab(isDark),
            _buildMonthsAndRulesTab(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayHeroCard(HijriDateInfo todayHijri) {
    final gStr =
        '${_bnWeekdays[_now.weekday]} • ${BengaliNumerals.toBengali(_now.day)} ${_bnMonthsFull[_now.month - 1]} ${BengaliNumerals.toBengali(_now.year)} খ্রিষ্টাব্দ';

    final badges = <String>[];
    if (todayHijri.isSacredMonth) badges.add('👑 আশহুরুল হুরুম');
    if (todayHijri.month == 9) badges.add('🌙 মাহে রমজান');
    if (todayHijri.isWhiteDay) badges.add('🌟 আইয়ামে বিজ (সুন্নাত রোজা)');
    if (todayHijri.isMonday || todayHijri.isThursday) {
      badges.add('✨ সাপ্তাহিক সুন্নাত রোজা');
    }
    if (todayHijri.isProhibitedFasting) badges.add('🚫 আজ রোজা রাখা হারাম');
    if (todayHijri.isFriday) badges.add('🕌 পবিত্র জুমু\'আ');
    for (final ev in todayHijri.events) {
      badges.add('${ev.icon} ${ev.titleBn}');
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065F46), Color(0xFF047857), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '🟢 আজকের হিজরি তারিখ',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFA7F3D0),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                todayHijri.monthNameAr,
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  color: const Color(0xFFA7F3D0),
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            todayHijri.formattedBn,
            style: GoogleFonts.hindSiliguri(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            gStr,
            style: GoogleFonts.hindSiliguri(
              fontSize: 12.5,
              color: const Color(0xFFD1FAE5),
            ),
          ),
          if (badges.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: badges.map((b) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(
                    b,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '🌙 চাঁদ দেখা সমন্বয় (অফসেট)',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFA7F3D0),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _offset == 0
                          ? 'স্বাভাবিক (০ দিন)'
                          : '${_offset > 0 ? '+' : ''}${BengaliNumerals.toBengali(_offset)} দিন',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [-2, -1, 0, 1, 2].map((val) {
                    final selected = _offset == val;
                    final label = val == 0
                        ? '০'
                        : '${val > 0 ? '+' : ''}${BengaliNumerals.toBengali(val)}';
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: InkWell(
                          onTap: () => _updateOffset(val),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.emeraldLight
                                  : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selected
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.15),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$label দিন',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayAndCountdownsTab(bool isDark, HijriDateInfo todayHijri) {
    final upcoming = IslamicCalendarData.getUpcomingEvents(_now, _offset);
    final filtered = upcoming.where((item) {
      final id = item.event.id;
      if (_eventFilter == 'eid') return id.contains('eid');
      if (_eventFilter == 'ramadan') {
        return id.contains('ramadan') || id.contains('qadr') || id.contains('badr');
      }
      if (_eventFilter == 'fasting') {
        return id.contains('fast') || id.contains('ashura') || id.contains('arafah');
      }
      if (_eventFilter == 'hajj') {
        return id.contains('hajj') || id.contains('arafah') || id.contains('dhul_hijjah');
      }
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTodayHeroCard(todayHijri),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(
                'আসন্ন দিবস ও লাইভ কাউন্টডাউন',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('all', 'সকল দিবস', isDark),
              const SizedBox(width: 6),
              _buildFilterChip('ramadan', 'রমজান ও কদর', isDark),
              const SizedBox(width: 6),
              _buildFilterChip('eid', 'দুই ঈদ', isDark),
              const SizedBox(width: 6),
              _buildFilterChip('fasting', 'নফল রোজা', isDark),
              const SizedBox(width: 6),
              _buildFilterChip('hajj', 'হজ ও আরাফাহ', isDark),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...filtered.map((item) => _buildEventCountdownCard(item, isDark)),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label, bool isDark) {
    final isSelected = _eventFilter == value;
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.hindSiliguri(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.grey.shade300 : Colors.black87),
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.emerald,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      side: BorderSide(
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
      ),
      onSelected: (_) {
        setState(() {
          _eventFilter = value;
        });
      },
    );
  }

  Widget _buildEventCountdownCard(UpcomingIslamicEvent item, bool isDark) {
    final ev = item.event;
    final monthName = IslamicCalendarData.months
        .firstWhere((m) => m.number == ev.month)
        .nameBn;
    final targetDate = item.targetGregorianDate;
    final diff = targetDate.difference(_now);

    final days = diff.isNegative ? 0 : diff.inDays;
    final hours = diff.isNegative ? 0 : (diff.inHours % 24);
    final mins = diff.isNegative ? 0 : (diff.inMinutes % 60);
    final secs = diff.isNegative ? 0 : (diff.inSeconds % 60);
    final isUrgent = item.daysRemaining <= 7 && item.daysRemaining >= 0;

    final gDateStr =
        '${BengaliNumerals.toBengali(targetDate.day)} ${_bnMonthsFull[targetDate.month - 1]}, ${BengaliNumerals.toBengali(targetDate.year)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent
              ? AppColors.emerald.withOpacity(0.7)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isUrgent ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isUrgent
                      ? AppColors.emerald.withOpacity(0.14)
                      : (isDark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${ev.icon} ${ev.badge}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isUrgent
                        ? AppColors.emerald
                        : (isDark ? Colors.grey.shade300 : Colors.black87),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${BengaliNumerals.toBengali(ev.day)} $monthName',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ev.titleBn,
            style: GoogleFonts.hindSiliguri(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ev.description,
            style: GoogleFonts.hindSiliguri(
              fontSize: 12.2,
              height: 1.4,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'সম্ভাব্য তারিখ:',
                style: GoogleFonts.hindSiliguri(fontSize: 11.5, color: Colors.grey),
              ),
              Text(
                gDateStr,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: item.isToday
                ? Center(
                    child: Text(
                      '🎉 আজ পবিত্র দিবস',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      _buildCountdownCell(
                          BengaliNumerals.toBengali(days), 'দিন', AppColors.emerald),
                      _buildCountdownSep(),
                      _buildCountdownCell(
                          BengaliNumerals.toBengali(hours.toString().padLeft(2, '0')),
                          'ঘণ্টা',
                          isDark ? Colors.white : Colors.black87),
                      _buildCountdownSep(),
                      _buildCountdownCell(
                          BengaliNumerals.toBengali(mins.toString().padLeft(2, '0')),
                          'মিনিট',
                          isDark ? Colors.white : Colors.black87),
                      _buildCountdownSep(),
                      _buildCountdownCell(
                          BengaliNumerals.toBengali(secs.toString().padLeft(2, '0')),
                          'সেকেন্ড',
                          AppColors.amber),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCell(String val, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            val,
            style: GoogleFonts.hindSiliguri(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.hindSiliguri(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownSep() {
    return Text(
      ':',
      style: GoogleFonts.hindSiliguri(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildMonthlyGridTab(bool isDark, HijriDateInfo todayHijri) {
    final calData = IslamicCalendarData.getMonthCalendar(
      _selectedCalYear,
      _selectedCalMonth,
      _offset,
    );
    final mInfo = calData.monthInfo;
    // Sunday = 0 .. Saturday = 6 (DateTime.weekday: Sun=7 -> 0, Mon=1 -> 1 .. Sat=6 -> 6)
    final firstWeekday = calData.days.first.gregorianWeekday % 7;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Month Controls
        Row(
          children: [
            IconButton.outlined(
              onPressed: () => _navigateMonth(-1),
              icon: const Icon(Icons.chevron_left),
              tooltip: 'পূর্ববর্তী মাস',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${mInfo.nameBn} (${mInfo.nameAr}) — ${BengaliNumerals.toBengali(_selectedCalYear)} হিজরি',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      '${mInfo.meaning} • মোট ${BengaliNumerals.toBengali(calData.totalDays)} দিন',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11,
                        color: AppColors.emerald,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              onPressed: () => _navigateMonth(1),
              icon: const Icon(Icons.chevron_right),
              tooltip: 'পরবর্তী মাস',
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Legend
        Wrap(
          spacing: 10,
          runSpacing: 6,
          children: [
            _buildLegendDot(AppColors.emerald, 'আজ'),
            _buildLegendDot(AppColors.amber, 'আইয়ামে বিজ (১৩-১৫)'),
            _buildLegendDot(Colors.redAccent, 'রোজা হারাম'),
            _buildLegendDot(Colors.teal, 'জুমু\'আ'),
          ],
        ),
        const SizedBox(height: 10),

        // Grid Container
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            children: [
              // Weekday Headers
              Row(
                children: ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি']
                    .map((w) {
                  final isFri = w == 'শুক্র';
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        w,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: isFri ? Colors.teal : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.78,
                ),
                itemCount: firstWeekday + calData.days.length,
                itemBuilder: (context, index) {
                  if (index < firstWeekday) {
                    return const SizedBox.shrink();
                  }
                  final day = calData.days[index - firstWeekday];
                  final isToday = day.hijriDay == todayHijri.day &&
                      day.hijriMonth == todayHijri.month &&
                      day.hijriYear == todayHijri.year;

                  Color bg = isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC);
                  Color borderColor =
                      isDark ? AppColors.borderDark : AppColors.borderLight;

                  if (isToday) {
                    bg = AppColors.emerald.withOpacity(0.18);
                    borderColor = AppColors.emerald;
                  } else if (day.isProhibitedFasting) {
                    bg = Colors.redAccent.withOpacity(0.12);
                    borderColor = Colors.redAccent.withOpacity(0.45);
                  } else if (day.isWhiteDay) {
                    bg = AppColors.amber.withOpacity(0.14);
                    borderColor = AppColors.amber.withOpacity(0.45);
                  } else if (day.isFriday) {
                    bg = Colors.teal.withOpacity(0.1);
                    borderColor = Colors.teal.withOpacity(0.35);
                  }

                  return InkWell(
                    onTap: () => _showDayDetails(day, mInfo),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: borderColor,
                          width: isToday ? 1.6 : 0.8,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                day.hijriDayBn,
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isToday
                                      ? AppColors.emerald
                                      : (isDark ? Colors.white : Colors.black87),
                                ),
                              ),
                              if (day.events.isNotEmpty)
                                const Icon(Icons.star,
                                    size: 10, color: Colors.purpleAccent),
                            ],
                          ),
                          Text(
                            '${BengaliNumerals.toBengali(day.gregorianDay)} ${_bnMonthsShort[day.gregorianMonth - 1]}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 9,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Text(
            '${mInfo.nameBn} মাসের তাৎপর্য: ${mInfo.significance}',
            style: GoogleFonts.hindSiliguri(
              fontSize: 12.5,
              height: 1.45,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.hindSiliguri(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  void _showDayDetails(CalendarDayEntry day, IslamicMonthInfo mInfo) {
    final gDate = day.gregorianDate;
    final gFormatted =
        '${BengaliNumerals.toBengali(gDate.day)} ${_bnMonthsFull[gDate.month - 1]}, ${BengaliNumerals.toBengali(gDate.year)}';
    final notes = <String>[
      'অনুরূপ ইংরেজি তারিখ: $gFormatted',
    ];
    if (day.isWhiteDay) {
      notes.add('🌟 এটি আইয়ামে বিজের দিন (নফল রোজা রাখা সুন্নাত)।');
    }
    if (day.isProhibitedFasting) {
      notes.add('🚫 এই দিনে রোজা রাখা শরীয়ত মোতাবেক হারাম।');
    }
    if (day.isFriday) {
      notes.add('🕌 পবিত্র জুমু\'আ বার।');
    }
    for (final e in day.events) {
      notes.add('${e.icon} বিশেষ দিবস: ${e.titleBn}');
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          '${day.hijriDayBn} ${mInfo.nameBn}, ${BengaliNumerals.toBengali(day.hijriYear)} হিজরি',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: notes
              .map((n) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(n, style: GoogleFonts.hindSiliguri(fontSize: 13)),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('ঠিক আছে',
                style: GoogleFonts.hindSiliguri(
                    fontWeight: FontWeight.bold, color: AppColors.emerald)),
          ),
        ],
      ),
    );
  }

  Widget _buildConverterTab(bool isDark) {
    final g2hResult =
        IslamicCalendarData.gregorianToHijri(_g2hSelectedDate, _offset);
    final h2gResult = IslamicCalendarData.hijriToGregorian(
        _h2gYear, _h2gMonth, _h2gDay, _offset);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Gregorian -> Hijri
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🗓️ ইংরেজি (গ্রেগরিয়ান) → হিজরি তারিখ',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _g2hSelectedDate,
                    firstDate: DateTime(1920),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _g2hSelectedDate = picked;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  '${BengaliNumerals.toBengali(_g2hSelectedDate.day)} ${_bnMonthsFull[_g2hSelectedDate.month - 1]}, ${BengaliNumerals.toBengali(_g2hSelectedDate.year)}',
                  style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : AppColors.emeraldSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'অনুরূপ হিজরি তারিখ',
                      style: GoogleFonts.hindSiliguri(
                          fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      g2hResult.formattedBn,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                    Text(
                      '${g2hResult.day} ${g2hResult.monthNameAr} ${g2hResult.year} هـ',
                      style: GoogleFonts.amiri(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. Hijri -> Gregorian
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🌙 হিজরি → ইংরেজি (গ্রেগরিয়ান) তারিখ',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<int>(
                      value: _h2gDay,
                      decoration: InputDecoration(
                        labelText: 'দিন',
                        labelStyle: GoogleFonts.hindSiliguri(fontSize: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                      ),
                      items: List.generate(
                        30,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text(BengaliNumerals.toBengali(i + 1),
                              style: GoogleFonts.hindSiliguri(fontSize: 13)),
                        ),
                      ),
                      onChanged: (v) {
                        if (v != null) setState(() => _h2gDay = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: DropdownButtonFormField<int>(
                      value: _h2gMonth,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'মাস',
                        labelStyle: GoogleFonts.hindSiliguri(fontSize: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                      ),
                      items: IslamicCalendarData.months
                          .map((m) => DropdownMenuItem(
                                value: m.number,
                                child: Text(
                                  '${BengaliNumerals.toBengali(m.number)}. ${m.nameBn}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.hindSiliguri(fontSize: 13),
                                ),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _h2gMonth = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<int>(
                      value: _h2gYear,
                      decoration: InputDecoration(
                        labelText: 'সন',
                        labelStyle: GoogleFonts.hindSiliguri(fontSize: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                      ),
                      items: List.generate(25, (i) => 1435 + i)
                          .map((y) => DropdownMenuItem(
                                value: y,
                                child: Text(BengaliNumerals.toBengali(y),
                                    style:
                                        GoogleFonts.hindSiliguri(fontSize: 13)),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _h2gYear = v);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : AppColors.emeraldSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'অনুরূপ ইংরেজি তারিখ',
                      style: GoogleFonts.hindSiliguri(
                          fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${BengaliNumerals.toBengali(h2gResult.day)} ${_bnMonthsFull[h2gResult.month - 1]}, ${BengaliNumerals.toBengali(h2gResult.year)}',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                    Text(
                      _bnWeekdays[h2gResult.weekday],
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthsAndRulesTab(bool isDark) {
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
                '👑 আশহুরুল হুরুম (৪টি সম্মানিত মাস)',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'পবিত্র কুরআনে (সূরা আত-তাওবাহ: ৩৬) ১২ মাসের মধ্যে ৪টি মাসকে বিশেষ সম্মানিত ঘোষণা করা হয়েছে: ১. জিলকদ • ২. জিলহজ • ৩. মুহাররম • ৪. রজব।',
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
        Text(
          '📜 হিজরি ১২ মাসের পরিচিতি',
          style: GoogleFonts.hindSiliguri(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        ...IslamicCalendarData.months.map((m) {
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
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    BengaliNumerals.toBengali(m.number),
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
                      Row(
                        children: [
                          Text(
                            m.nameBn,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          if (m.isSacred) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.amber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'সম্মানিত',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.amber,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          Text(
                            m.nameAr,
                            style: GoogleFonts.amiri(
                              fontSize: 15,
                              color: AppColors.emerald,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${m.meaning} • ${m.significance}',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          height: 1.4,
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
        const SizedBox(height: 14),
        Text(
          '🕌 সুন্নাত রোজা ও নিষিদ্ধ দিনের বিধান',
          style: GoogleFonts.hindSiliguri(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        ...IslamicCalendarData.fastingRules.asMap().entries.map((entry) {
          final index = entry.key;
          final rule = entry.value;
          final isForbidden = rule['ruling']!.contains('হারাম');
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isForbidden
                    ? Colors.redAccent.withOpacity(0.4)
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${BengaliNumerals.toBengali(index + 1)}. ${rule['title']}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isForbidden ? Colors.redAccent : AppColors.emerald,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  rule['desc']!,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12.5,
                    height: 1.45,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
