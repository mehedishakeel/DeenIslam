import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/models/surah_model.dart';
import '../../../data/repositories/surah_data.dart';
import 'surah_reader_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'সকল'; // 'সকল', 'মাক্কী', 'মাদানী', 'অফলাইন'
  final List<Surah> _allSurahs = SurahData.allSurahs;
  Set<int> _offlineSurahs = {1, 103, 108, 112, 113, 114};
  Map<String, dynamic>? _lastRead;

  @override
  void initState() {
    super.initState();
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    final cached = await StorageService.getOfflineCachedSurahNumbers();
    final last = await StorageService.getLastReadSurah();
    if (!mounted) return;
    setState(() {
      _offlineSurahs = cached;
      _lastRead = last;
    });
  }

  void _openSurah(Surah s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahReaderScreen(surah: s),
      ),
    ).then((_) => _loadMetadata());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _allSurahs.where((s) {
      final matchesQuery = _searchQuery.isEmpty ||
          s.nameBengali.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.nameEnglish.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.nameArabic.contains(_searchQuery) ||
          s.number.toString().contains(_searchQuery);

      final matchesFilter = _selectedFilter == 'সকল' ||
          (_selectedFilter == 'অফলাইন'
              ? _offlineSurahs.contains(s.number)
              : s.revelationType == _selectedFilter);
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "আল-কুরআনুল কারীম",
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Continue Reading Banner if available
          if (_lastRead != null && _searchQuery.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: InkWell(
                onTap: () {
                  final num = _lastRead!['surahNumber'] as int? ?? 1;
                  final surah = _allSurahs.firstWhere(
                    (s) => s.number == num,
                    orElse: () => _allSurahs.first,
                  );
                  _openSurah(surah);
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.emerald.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded, color: AppColors.emerald, size: 18),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'সর্বশেষ পঠিত সূরা',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.emerald,
                                ),
                              ),
                              Text(
                                'সূরা ${_lastRead!['nameBengali'] ?? 'আল-ফাতিহা'} (${BengaliNumerals.toBengali(_lastRead!['totalAyahs'] as int? ?? 7)} আয়াত)',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'চালিয়ে যান',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: AppColors.emerald,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Search & Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: "সূরা খুঁজুন (নাম বা নম্বর দিয়ে)...",
                hintStyle: GoogleFonts.hindSiliguri(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: isDark ? AppColors.cardDark : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.emerald, width: 1.2),
                ),
              ),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: ['সকল', 'মাক্কী', 'মাদানী', 'অফলাইন'].map((f) {
                final isSelected = _selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      f == 'অফলাইন'
                          ? 'অফলাইন (${BengaliNumerals.toBengali(_offlineSurahs.length)})'
                          : f,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.emerald,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedFilter = f;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),

          // Surah List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final s = filtered[index];
                final isOffline = _offlineSurahs.contains(s.number);
                return InkWell(
                  onTap: () => _openSurah(s),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
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
                        // Surah Number Badge
                        Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.emeraldDark
                                  : AppColors.emerald.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            BengaliNumerals.toBengali(s.number),
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Surah Bengali & English Names
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    s.nameBengali,
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  if (isOffline) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.offline_pin_outlined,
                                      size: 14,
                                      color: AppColors.emerald,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    s.nameEnglish,
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: s.revelationType == 'মাক্কী'
                                          ? AppColors.amberSoft
                                          : AppColors.emeraldSoft,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "${s.revelationType} • ${BengaliNumerals.toBengali(s.numberOfAyahs)} আয়াত",
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: s.revelationType == 'মাক্কী'
                                            ? AppColors.amberDark
                                            : AppColors.emeraldDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Arabic Calligraphy Name
                        Text(
                          s.nameArabic,
                          style: GoogleFonts.amiri(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
