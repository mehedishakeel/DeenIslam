import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/models/allah_name.dart';
import '../../../data/models/prayer_times_model.dart';
import '../../../data/repositories/allah_names_data.dart';
import '../../about/presentation/about_screen.dart';
import '../../articles/presentation/articles_media_screen.dart';
import '../../bookmarks/presentation/bookmarks_screen.dart';
import '../../calendar/presentation/hijri_calendar_screen.dart';
import '../../dua/presentation/dua_screen.dart';
import '../../hadith/presentation/hadith_screen.dart';
import '../../hajj/presentation/hajj_screen.dart';
import '../../kalima/presentation/kalima_screen.dart';
import '../../names/presentation/allah_names_screen.dart';
import '../../prayer/presentation/prayer_screen.dart';
import '../../qibla/presentation/qibla_screen.dart';
import '../../quiz/presentation/quiz_screen.dart';
import '../../quran/presentation/quran_screen.dart';
import '../../ramadan/presentation/ramadan_screen.dart';
import '../../salat/presentation/salat_guide_screen.dart';
import '../../search/presentation/global_search_screen.dart';
import '../../seerah/presentation/seerah_screen.dart';
import '../../tasbih/presentation/tasbih_screen.dart';
import '../../zakat/presentation/zakat_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late Timer _timer;
  DateTime _now = DateTime.now();
  late PrayerTimesModel _prayerTimes;
  String _selectedCity = 'ঢাকা';
  
  // Bento 99 Names State (Mobile view: exactly 5 names per batch)
  int _bentoNameBatchIndex = 0;
  
  // Audio state
  bool _isPlayingQuran = false;
  int _fatihaAyahNum = 1;

  @override
  void initState() {
    super.initState();
    _prayerTimes = PrayerTimesModel.forCity(_now, _selectedCity);
    _loadSelectedCity();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  Future<void> _toggleHomeFatihaAudio() async {
    if (_isPlayingQuran) {
      await AudioService.instance.stop();
      if (!mounted) return;
      setState(() {
        _isPlayingQuran = false;
        _fatihaAyahNum = 1;
      });
      return;
    }

    setState(() {
      _isPlayingQuran = true;
      _fatihaAyahNum = 1;
    });
    await _playFatihaAyah(1);
  }

  Future<void> _playFatihaAyah(int ayahNumber) async {
    if (!mounted || !_isPlayingQuran || ayahNumber > 7) {
      if (mounted) {
        setState(() {
          _isPlayingQuran = false;
          _fatihaAyahNum = 1;
        });
      }
      return;
    }

    setState(() => _fatihaAyahNum = ayahNumber);
    final url = 'https://everyayah.com/data/Alafasy_128kbps/00100$ayahNumber.mp3';
    await AudioService.instance.playUrl(
      url,
      onCompleted: () {
        if (!mounted || !_isPlayingQuran) return;
        _playFatihaAyah(ayahNumber + 1);
      },
    );
  }

  Future<void> _loadSelectedCity() async {
    final city = await StorageService.getSelectedCity();
    if (!mounted) return;
    setState(() {
      _selectedCity = city;
      _prayerTimes = PrayerTimesModel.forCity(_now, city);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _cycleBentoNames() {
    setState(() {
      _bentoNameBatchIndex = (_bentoNameBatchIndex + 5) % AllahNamesData.allNames.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prayerStatus = _prayerTimes.getUpcomingStatus(_now);
    final fastingStatus = _prayerTimes.getFastingStatus(_now);
    final isDark = widget.isDark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.emeraldDark : AppColors.emerald.withOpacity(0.2),
                ),
              ),
              child: const Icon(Icons.mosque, color: AppColors.emerald, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "দ্বীন ইসলাম",
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  "$_selectedCity, বাংলাদেশ",
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 21),
            tooltip: "সর্বজনীন অনুসন্ধান",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GlobalSearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined, size: 20),
            tooltip: "সংরক্ষিত বুকমার্ক",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookmarksScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
            ),
            tooltip: "থিম পরিবর্তন",
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Bento Card 1: Prayer Times Status Card
            _buildPrayerCountdownCard(prayerStatus, isDark),
            const SizedBox(height: 12),

            // 2. Bento Card 2: Ramadan / Daily Fasting Tracker
            _buildFastingTrackerCard(fastingStatus, isDark),
            const SizedBox(height: 12),

            // 3. Bento Card 3: 99 Names of Allah (Mobile 5-Names Layout)
            _buildBentoNamesCard(isDark),
            const SizedBox(height: 12),

            // 4. Bento Card 4: Quran Audio Recitation Deck
            _buildQuranAudioCard(isDark),
            const SizedBox(height: 12),

            // 5. Featured Seerah Encyclopedia Banner Card
            _buildSeerahBannerCard(context, isDark),
            const SizedBox(height: 16),

            // 6. Quick Access Grid Services
            _buildQuickServicesGrid(context, isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- CARD 1: Prayer Status Card ---
  Widget _buildPrayerCountdownCard(PrayerStatus status, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(status.icon, color: AppColors.emerald, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "পরবর্তী ওয়াক্ত",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    status.nextName,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark ? AppColors.emeraldDark : AppColors.emerald.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      status.nextTimeFormatted,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  "বর্তমান ওয়াক্ত",
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 10,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                Text(
                  status.currentName,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CARD 2: Fasting Tracker Card ---
  Widget _buildFastingTrackerCard(FastingStatus status, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("🌙", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    status.title,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              Text(
                BengaliNumerals.formatCountdown(status.remaining),
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: status.progress,
              minHeight: 6,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amber),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.info,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 11,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              Text(
                "${BengaliNumerals.toBengali((status.progress * 100).toInt())}% সম্পন্ন",
                style: GoogleFonts.hindSiliguri(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CARD 3: Asmaul Husna 5-Names Mobile Grid ---
  Widget _buildBentoNamesCard(bool isDark) {
    const all = AllahNamesData.allNames;
    final total = all.length;
    final batch = <AllahName>[];
    for (int i = 0; i < 5; i++) {
      batch.add(all[(_bentoNameBatchIndex + i) % total]);
    }
    final hero = batch[0];
    final others = batch.sublist(1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("🌟", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    "আল্লাহর ৯৯ নাম",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark ? AppColors.emeraldDark : AppColors.emerald.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  "${BengaliNumerals.toBengali(hero.id)}–${BengaliNumerals.toBengali(batch.last.id)} / ৯৯",
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emerald,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1. Hero Card (Top wide card)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                    : [const Color(0xFFFBFBFB), const Color(0xFFFFFBEB)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.amberDark : AppColors.amber.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.amberSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "#${BengaliNumerals.toBengali(hero.id)}",
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amberDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hero.transliteration,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          hero.meaning,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 11,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  hero.arabic,
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.amber,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 2. 2x2 Grid for Remaining 4 Names
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: others.length,
            itemBuilder: (context, index) {
              final item = others[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "#${BengaliNumerals.toBengali(item.id)} ${item.transliteration}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            item.meaning,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 9.5,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item.arabic,
                      style: GoogleFonts.amiri(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.emeraldLight : AppColors.emerald,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          // Actions Deck
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: _cycleBentoNames,
                icon: const Icon(Icons.refresh, size: 14),
                label: Text(
                  "পরবর্তী ৫টি ↻",
                  style: GoogleFonts.hindSiliguri(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: AppColors.emerald,
                  side: const BorderSide(color: AppColors.emerald, width: 0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AllahNamesScreen()),
                  );
                },
                child: Text(
                  "সকল ৯৯ নাম →",
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emerald,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CARD 4: Quran Audio Recitation Deck ---
  Widget _buildQuranAudioCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("🎧", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    "কুরআন তিলাওয়াত",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.amberSoftDark : AppColors.amberSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "মাক্কী • ৭ আয়াত",
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.amberDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuranScreen()),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFBFBFB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  Text(
                    "سُورَةُ الفَاتِحَةِ",
                    style: GoogleFonts.amiri(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.amber,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "সূরা আল-ফাতিহা • The Opening",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                    style: GoogleFonts.amiri(
                      fontSize: 14,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton.filled(
                onPressed: _toggleHomeFatihaAudio,
                icon: Icon(_isPlayingQuran ? Icons.stop : Icons.play_arrow),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "মিশারি রাশিদ আল-আফাসী",
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      _isPlayingQuran
                          ? "প্লে হচ্ছে • আয়াত ${BengaliNumerals.toBengali(_fatihaAyahNum)}/৭"
                          : "তিলাওয়াত শুনুন",
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 10,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _isPlayingQuran ? "${BengaliNumerals.toBengali(_fatihaAyahNum)}/৭" : "৭ আয়াত",
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CARD 5: Featured Seerah Encyclopedia Card ---
  Widget _buildSeerahBannerCard(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SeerahScreen()),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF064E3B), const Color(0xFF0F172A)]
                : [const Color(0xFF065F46), const Color(0xFF047857)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.amber.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.map_outlined,
                color: AppColors.amber,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'সীরাতুন্নবী (ﷺ) বিশ্বকোষ • Seerah',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'সীরাত মানচিত্র, ৫০ প্রজন্মের বংশলতিকা, আহলে বাইত, সাহাবী ও গাযওয়া',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 11.5,
                      color: Colors.white.withOpacity(0.88),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.amber,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // --- Quick Access Services Grid ---
  Widget _buildQuickServicesGrid(BuildContext context, bool isDark) {
    final services = [
      {'title': 'আল-কুরআন', 'icon': Icons.menu_book, 'color': AppColors.emerald, 'screen': const QuranScreen()},
      {'title': 'সীরাতুন্নবী (ﷺ)', 'icon': Icons.map_outlined, 'color': AppColors.amber, 'screen': const SeerahScreen()},
      {'title': 'হাদিস শরীফ', 'icon': Icons.library_books_outlined, 'color': AppColors.emerald, 'screen': const HadithScreen()},
      {'title': 'নিত্যদিনের দোয়া', 'icon': Icons.favorite, 'color': AppColors.amber, 'screen': const DuaScreen()},
      {'title': '৬ কালিমা ও ঈমান', 'icon': Icons.verified_outlined, 'color': AppColors.emerald, 'screen': const KalimaScreen()},
      {'title': 'সালাত ও অজু শিক্ষা', 'icon': Icons.mosque_outlined, 'color': AppColors.amber, 'screen': const SalatGuideScreen()},
      {'title': 'রমজান ও রোজা', 'icon': Icons.nights_stay_outlined, 'color': AppColors.emerald, 'screen': const RamadanScreen()},
      {'title': 'হজ্জ ও উমরাহ গাইড', 'icon': Icons.public_outlined, 'color': AppColors.amber, 'screen': const HajjScreen()},
      {'title': 'প্রবন্ধ ও মিডিয়া', 'icon': Icons.play_circle_outline, 'color': AppColors.emerald, 'screen': const ArticlesMediaScreen()},
      {'title': 'নামাজ ও আজান', 'icon': Icons.notifications_active_outlined, 'color': AppColors.amber, 'screen': const PrayerScreen()},
      {'title': 'ডিজিটাল তাসবীহ', 'icon': Icons.fingerprint, 'color': AppColors.emerald, 'screen': const TasbihScreen()},
      {'title': 'কিবলা কম্পাস', 'icon': Icons.explore_outlined, 'color': AppColors.amber, 'screen': const QiblaScreen()},
      {'title': 'যাকাত ক্যালকুলেটর', 'icon': Icons.calculate_outlined, 'color': AppColors.emerald, 'screen': const ZakatScreen()},
      {'title': 'আল্লাহর ৯৯ নাম', 'icon': Icons.auto_awesome, 'color': AppColors.amber, 'screen': const AllahNamesScreen()},
      {'title': 'সংরক্ষিত বুকমার্ক', 'icon': Icons.bookmarks_outlined, 'color': AppColors.emerald, 'screen': const BookmarksScreen()},
      {'title': 'হিজরি ক্যালেন্ডার', 'icon': Icons.calendar_month_outlined, 'color': AppColors.amber, 'screen': const HijriCalendarScreen()},
      {'title': 'ইসলামিক কুইজ ও প্রশ্ন', 'icon': Icons.quiz_outlined, 'color': AppColors.emerald, 'screen': const QuizScreen()},
      {'title': 'পরিচিতি ও সদকা', 'icon': Icons.volunteer_activism_outlined, 'color': AppColors.amber, 'screen': const AboutScreen()},
      {'title': 'সর্বজনীন অনুসন্ধান', 'icon': Icons.search_rounded, 'color': AppColors.emerald, 'screen': const GlobalSearchScreen()},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ইসলামিক সেবাসমূহ",
          style: GoogleFonts.hindSiliguri(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final item = services[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['screen'] as Widget),
                ).then((_) => _loadSelectedCity());
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
