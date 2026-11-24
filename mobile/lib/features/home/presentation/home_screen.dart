import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
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
import '../../names/presentation/muslim_names_screen.dart';
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

  // Asmaul Husna cycling state
  int _bentoNameBatchIndex = 0;

  // Audio recitation state
  bool _isPlayingQuran = false;
  int _fatihaAyahNum = 1;

  // Service category filter state
  String _serviceCategory = 'all'; // 'all', 'ibadah', 'knowledge', 'tools'

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

  Future<void> _loadSelectedCity() async {
    final city = await StorageService.getSelectedCity();
    if (!mounted) return;
    setState(() {
      _selectedCity = city;
      _prayerTimes = PrayerTimesModel.forCity(_now, city);
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _cycleBentoNames() {
    setState(() {
      _bentoNameBatchIndex = (_bentoNameBatchIndex + 1) % AllahNamesData.allNames.length;
    });
  }

  void _showCitySelector(BuildContext context, bool isDark) {
    String query = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredDistricts = PrayerTimesModel.allDistricts
                .where((d) => d.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "আপনার জেলা নির্বাচন করুন (${BengaliNumerals.toBengali(64)} জেলা)",
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (val) {
                          setModalState(() {
                            query = val.trim();
                          });
                        },
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                        decoration: InputDecoration(
                          hintText: "জেলা খুঁজুন (যেমন: ঢাকা, সিলেট, কুমিল্লা)...",
                          hintStyle: GoogleFonts.hindSiliguri(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                          prefixIcon: const Icon(Icons.search, size: 18),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: filteredDistricts.length,
                          separatorBuilder: (_, __) => Divider(
                            color: isDark ? AppColors.borderDark.withOpacity(0.5) : AppColors.borderLight,
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final district = filteredDistricts[index];
                            final isSelected = district == _selectedCity;
                            return ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              leading: Icon(
                                isSelected ? Icons.location_on : Icons.location_on_outlined,
                                color: isSelected
                                    ? AppColors.emerald
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                size: 18,
                              ),
                              title: Text(
                                district,
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.emerald
                                      : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle, color: AppColors.emerald, size: 18)
                                  : null,
                              onTap: () async {
                                final nav = Navigator.of(ctx);
                                await StorageService.setSelectedCity(district);
                                if (!mounted) return;
                                setState(() {
                                  _selectedCity = district;
                                  _prayerTimes = PrayerTimesModel.forCity(_now, district);
                                });
                                nav.pop();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
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
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                InkWell(
                  onTap: () => _showCitySelector(context, isDark),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 11, color: AppColors.emerald),
                        const SizedBox(width: 2),
                        Text(
                          _selectedCity,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.emerald,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.arrow_drop_down, size: 14, color: AppColors.emerald),
                      ],
                    ),
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
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Unified Spiritual Status Card (Prayer + Fasting Hub)
            _buildSpiritualHubCard(prayerStatus, fastingStatus, isDark),
            const SizedBox(height: 14),

            // 2. Quick Daily Essentials Row (4 Primary Daily Actions)
            _buildQuickEssentialsRow(context, isDark),
            const SizedBox(height: 14),

            // 3. Quran Audio Recitation Deck
            _buildQuranAudioCard(isDark),
            const SizedBox(height: 14),

            // 4. Featured Asmaul Husna (Name of the Moment)
            _buildBentoNamesCard(isDark),
            const SizedBox(height: 14),

            // 5. Featured Seerah Encyclopedia Banner Card
            _buildSeerahBannerCard(context, isDark),
            const SizedBox(height: 18),

            // 6. Categorized Services & Tools Grid
            _buildCategorizedServicesGrid(context, isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- CARD 1: Unified Spiritual Status Hub (Prayer + Fasting) ---
  Widget _buildSpiritualHubCard(PrayerStatus prayerStatus, FastingStatus fastingStatus, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Prayer Section (Top)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrayerScreen()),
              ).then((_) => _loadSelectedCity());
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(prayerStatus.icon, color: AppColors.emerald, size: 17),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "পরবর্তী ওয়াক্ত: ${prayerStatus.nextName}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            width: 0.6,
                          ),
                        ),
                        child: Text(
                          "বর্তমান: ${prayerStatus.currentName}",
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            BengaliNumerals.formatCountdown(prayerStatus.remaining),
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.emerald,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            "বাকি আছে (${prayerStatus.nextTimeFormatted}-এ শুরু)",
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "সকল ওয়াক্ত",
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 16, color: AppColors.emerald),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Divider(
            height: 1,
            thickness: 0.8,
            color: isDark ? AppColors.borderDark.withOpacity(0.6) : AppColors.borderLight.withOpacity(0.8),
          ),

          // Fasting Tracker Row (Bottom)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RamadanScreen()),
              );
            },
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A).withOpacity(0.5) : const Color(0xFFFAFAF9),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text("🌙", style: TextStyle(fontSize: 13)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                fastingStatus.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                      const SizedBox(width: 8),
                      Text(
                        BengaliNumerals.formatCountdown(fastingStatus.remaining),
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: fastingStatus.progress,
                      minHeight: 5,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amber),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fastingStatus.info,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 10.5,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      Text(
                        "${BengaliNumerals.toBengali((fastingStatus.progress * 100).toInt())}% সম্পন্ন",
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION 2: Daily Quick Essentials (4 Key Shortcuts) ---
  Widget _buildQuickEssentialsRow(BuildContext context, bool isDark) {
    final essentials = [
      {'title': 'কিবলা কম্পাস', 'icon': Icons.explore_outlined, 'color': AppColors.emerald, 'screen': const QiblaScreen()},
      {'title': 'ডিজিটাল তাসবীহ', 'icon': Icons.fingerprint, 'color': AppColors.amber, 'screen': const TasbihScreen()},
      {'title': 'নিত্যদিনের দোয়া', 'icon': Icons.favorite_border, 'color': AppColors.emerald, 'screen': const DuaScreen()},
      {'title': 'সালাত শিক্ষা', 'icon': Icons.mosque_outlined, 'color': AppColors.amber, 'screen': const SalatGuideScreen()},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.8,
        ),
      ),
      child: Row(
        children: essentials.map((item) {
          final color = item['color'] as Color;
          return Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['screen'] as Widget),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(isDark ? 0.2 : 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(item['icon'] as IconData, color: color, size: 22),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- CARD 3: Quran Audio Recitation Deck ---
  Widget _buildQuranAudioCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          IconButton.filled(
            onPressed: _toggleHomeFatihaAudio,
            icon: Icon(_isPlayingQuran ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.emerald,
              foregroundColor: Colors.white,
              minimumSize: const Size(44, 44),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuranScreen()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "সূরা আল-ফাতিহা",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "سُورَةُ الفَاتِحَةِ",
                        style: GoogleFonts.amiri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amber,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _isPlayingQuran
                        ? "মিশারি আল-আফাসী • আয়াত ${BengaliNumerals.toBengali(_fatihaAyahNum)}/৭ বাজছে..."
                        : "তিলাওয়াত শুনুন • মিশারি আল-আফাসী (৭ আয়াত)",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 10.5,
                      color: _isPlayingQuran
                          ? AppColors.emerald
                          : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      fontWeight: _isPlayingQuran ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuranScreen()),
              );
            },
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "কুরআন",
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emerald,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.emerald),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CARD 4: Featured Asmaul Husna (Name of the Moment) ---
  Widget _buildBentoNamesCard(bool isDark) {
    const all = AllahNamesData.allNames;
    final hero = all[_bentoNameBatchIndex % all.length];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  const Text("🌟", style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 6),
                  Text(
                    "আসমাউল হুসনা",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 13,
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
                  "#${BengaliNumerals.toBengali(hero.id)} / ৯৯",
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.amberDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFBFBFB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.transliteration,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hero.meaning,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                Text(
                  hero.arabic,
                  style: GoogleFonts.amiri(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.amber,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: _cycleBentoNames,
                icon: const Icon(Icons.refresh, size: 13),
                label: Text(
                  "অন্য নাম ↻",
                  style: GoogleFonts.hindSiliguri(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: AppColors.emerald,
                  side: const BorderSide(color: AppColors.emerald, width: 0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AllahNamesScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
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
                    'সীরাত মানচিত্র, ৫০ প্রজন্মের বংশলতিকা, সাহাবী ও গাযওয়া',
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

  // --- SECTION 6: Categorized Services & Tools Grid ---
  Widget _buildCategorizedServicesGrid(BuildContext context, bool isDark) {
    final allServices = [
      {'title': 'সালাত ও অজু শিক্ষা', 'category': 'ibadah', 'icon': Icons.mosque_outlined, 'color': AppColors.amber, 'screen': const SalatGuideScreen()},
      {'title': 'নামাজ ও আজান', 'category': 'ibadah', 'icon': Icons.notifications_active_outlined, 'color': AppColors.emerald, 'screen': const PrayerScreen()},
      {'title': 'কিবলা কম্পাস', 'category': 'ibadah', 'icon': Icons.explore_outlined, 'color': AppColors.amber, 'screen': const QiblaScreen()},
      {'title': 'ডিজিটাল তাসবীহ', 'category': 'ibadah', 'icon': Icons.fingerprint, 'color': AppColors.emerald, 'screen': const TasbihScreen()},
      {'title': 'নিত্যদিনের দোয়া', 'category': 'ibadah', 'icon': Icons.favorite, 'color': AppColors.amber, 'screen': const DuaScreen()},
      {'title': 'রমজান ও রোজা', 'category': 'ibadah', 'icon': Icons.nights_stay_outlined, 'color': AppColors.emerald, 'screen': const RamadanScreen()},
      {'title': 'হজ্জ ও উমরাহ গাইড', 'category': 'ibadah', 'icon': Icons.public_outlined, 'color': AppColors.amber, 'screen': const HajjScreen()},

      {'title': 'আল-কুরআন', 'category': 'knowledge', 'icon': Icons.menu_book, 'color': AppColors.emerald, 'screen': const QuranScreen()},
      {'title': 'হাদিস শরীফ', 'category': 'knowledge', 'icon': Icons.library_books_outlined, 'color': AppColors.amber, 'screen': const HadithScreen()},
      {'title': 'সীরাতুন্নবী (ﷺ)', 'category': 'knowledge', 'icon': Icons.map_outlined, 'color': AppColors.emerald, 'screen': const SeerahScreen()},
      {'title': '৬ কালিমা ও ঈমান', 'category': 'knowledge', 'icon': Icons.verified_outlined, 'color': AppColors.amber, 'screen': const KalimaScreen()},
      {'title': 'আল্লাহর ৯৯ নাম', 'category': 'knowledge', 'icon': Icons.auto_awesome, 'color': AppColors.emerald, 'screen': const AllahNamesScreen()},
      {'title': 'মুসলিম শিশুদের নাম', 'category': 'knowledge', 'icon': Icons.child_care_outlined, 'color': AppColors.amber, 'screen': const MuslimNamesScreen()},
      {'title': 'প্রবন্ধ ও মিডিয়া', 'category': 'knowledge', 'icon': Icons.play_circle_outline, 'color': AppColors.amber, 'screen': const ArticlesMediaScreen()},
      {'title': 'ইসলামিক কুইজ ও প্রশ্ন', 'category': 'knowledge', 'icon': Icons.quiz_outlined, 'color': AppColors.emerald, 'screen': const QuizScreen()},

      {'title': 'যাকাত ক্যালকুলেটর', 'category': 'tools', 'icon': Icons.calculate_outlined, 'color': AppColors.emerald, 'screen': const ZakatScreen()},
      {'title': 'হিজরি ক্যালেন্ডার', 'category': 'tools', 'icon': Icons.calendar_month_outlined, 'color': AppColors.amber, 'screen': const HijriCalendarScreen()},
      {'title': 'সংরক্ষিত বুকমার্ক', 'category': 'tools', 'icon': Icons.bookmarks_outlined, 'color': AppColors.emerald, 'screen': const BookmarksScreen()},
      {'title': 'সর্বজনীন অনুসন্ধান', 'category': 'tools', 'icon': Icons.search_rounded, 'color': AppColors.amber, 'screen': const GlobalSearchScreen()},
      {'title': 'পরিচিতি ও সদকা', 'category': 'tools', 'icon': Icons.volunteer_activism_outlined, 'color': AppColors.emerald, 'screen': const AboutScreen()},
    ];

    final filteredServices = _serviceCategory == 'all'
        ? allServices
        : allServices.where((s) => s['category'] == _serviceCategory).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ইসলামিক সেবাসমূহ",
              style: GoogleFonts.hindSiliguri(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              "${BengaliNumerals.toBengali(filteredServices.length)}টি সেবা",
              style: GoogleFonts.hindSiliguri(
                fontSize: 11,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildCategoryChip('all', 'সবগুলো (${BengaliNumerals.toBengali(allServices.length)})', isDark),
              const SizedBox(width: 6),
              _buildCategoryChip('ibadah', '🕌 ইবাদত (${BengaliNumerals.toBengali(7)})', isDark),
              const SizedBox(width: 6),
              _buildCategoryChip('knowledge', '📖 কুরআন ও জ্ঞান (${BengaliNumerals.toBengali(7)})', isDark),
              const SizedBox(width: 6),
              _buildCategoryChip('tools', '🛠️ টুলস (${BengaliNumerals.toBengali(5)})', isDark),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Service Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredServices.length,
          itemBuilder: (context, index) {
            final item = filteredServices[index];
            final color = item['color'] as Color;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['screen'] as Widget),
                ).then((_) => _loadSelectedCity());
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: color.withOpacity(isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item['icon'] as IconData, color: color, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildCategoryChip(String category, String label, bool isDark) {
    final isSelected = _serviceCategory == category;
    return InkWell(
      onTap: () {
        setState(() {
          _serviceCategory = category;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.emerald
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.emerald
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: 0.8,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.hindSiliguri(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
        ),
      ),
    );
  }
}
