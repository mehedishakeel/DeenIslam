import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/models/dua_model.dart';
import '../../../data/repositories/dua_data.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'সকল';
  late List<Dua> _duas;
  Set<String> _bookmarkedKeys = {};
  Map<int, int> _tapCounts = {};

  final List<String> _categories = [
    'সকল', 'সকাল-সন্ধ্যা', 'নামাজ', 'ঘুম', 'দৈনন্দিন', 'বিপদ-আপদ'
  ];

  @override
  void initState() {
    super.initState();
    _duas = List.from(DuaData.allDuas);
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final items = await StorageService.getBookmarks();
    final counts = await StorageService.getDailyDuaCounts();
    if (!mounted) return;
    setState(() {
      _bookmarkedKeys = items.map((e) => e.key).toSet();
      _tapCounts = counts;
    });
  }

  Future<void> _incrementCounter(Dua dua) async {
    final current = _tapCounts[dua.id] ?? 0;
    int next = current + 1;
    if (next > dua.targetCount) {
      next = 0;
    } else if (next == dua.targetCount) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'মাশাআল্লাহ! পাঠ সম্পন্ন হয়েছে',
              style: GoogleFonts.hindSiliguri(fontSize: 13),
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: AppColors.emerald,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      HapticFeedback.lightImpact();
    }

    setState(() {
      _tapCounts[dua.id] = next;
    });
    await StorageService.saveDailyDuaCounts(_tapCounts);
  }

  Future<void> _resetSingleCounter(Dua dua) async {
    setState(() {
      _tapCounts[dua.id] = 0;
    });
    await StorageService.saveDailyDuaCounts(_tapCounts);
  }

  Future<void> _resetAllCounters() async {
    setState(() {
      _tapCounts.clear();
    });
    await StorageService.saveDailyDuaCounts(_tapCounts);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'সকল কাউন্টার রিসেট করা হয়েছে',
            style: GoogleFonts.hindSiliguri(fontSize: 13),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.emerald,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _copyDua(Dua dua) {
    final text = "${dua.titleBengali}\n\n${dua.arabicText}\n\nউচ্চারণ: ${dua.pronunciation}\n\nঅনুবাদ: ${dua.translation}\n\nরেফারেন্স: ${dua.reference}";
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "দোয়া কপি করা হয়েছে!",
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
      ),
    );
  }

  Future<void> _toggleFavorite(Dua dua) async {
    final key = 'dua_${dua.id}';
    final added = await StorageService.toggleBookmark(
      BookmarkItem(
        key: key,
        type: 'dua',
        categoryTitle: dua.category,
        title: dua.titleBengali,
        arabic: dua.arabicText,
        bengali: '${dua.pronunciation}\n\n${dua.translation}',
        reference: dua.reference,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    if (!mounted) return;
    setState(() {
      if (added) {
        _bookmarkedKeys.add(key);
      } else {
        _bookmarkedKeys.remove(key);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added ? 'দোয়াটি বুকমার্কে সংরক্ষিত হয়েছে' : 'বুকমার্ক থেকে সরানো হয়েছে',
          style: GoogleFonts.hindSiliguri(fontSize: 13),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _duas.where((d) {
      final matchesQuery = _searchQuery.isEmpty ||
          d.titleBengali.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.translation.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.pronunciation.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.arabicText.contains(_searchQuery);

      final matchesCategory = _selectedCategory == 'সকল' || d.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "দৈনন্দিন দো'আ ও জিকির",
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: "দোয়া খুঁজুন (নাম বা বিষয় দিয়ে)...",
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
                  borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.emerald, width: 1.2),
                ),
              ),
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      cat,
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
                          _selectedCategory = cat;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),

          // Daily Adhkar Progress Banner
          Builder(
            builder: (context) {
              final completedCount = _duas
                  .where((d) => (_tapCounts[d.id] ?? 0) >= d.targetCount)
                  .length;
              final totalCount = _duas.length;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '✨ আজকের দো\'আ ও আযকার অগ্রগতি',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${BengaliNumerals.toBengali(completedCount)}/${BengaliNumerals.toBengali(totalCount)}',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: _resetAllCounters,
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.06)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'রিসেট ↺',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: totalCount > 0 ? completedCount / totalCount : 0,
                          minHeight: 5,
                          backgroundColor: isDark
                              ? const Color(0xFF0F172A)
                              : Colors.grey.shade200,
                          color: AppColors.emerald,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Dua List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final dua = filtered[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header & Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.amberSoftDark : AppColors.amberSoft,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              dua.category,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.amberDark,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18),
                                tooltip: "দোয়া কপি করুন",
                                onPressed: () => _copyDua(dua),
                              ),
                              IconButton(
                                icon: Icon(
                                  _bookmarkedKeys.contains('dua_${dua.id}')
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  size: 18,
                                  color: _bookmarkedKeys.contains('dua_${dua.id}')
                                      ? AppColors.amber
                                      : null,
                                ),
                                tooltip: "পছন্দের তালিকায় রাখুন",
                                onPressed: () => _toggleFavorite(dua),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Title
                      Text(
                        dua.titleBengali,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Arabic Text
                      Text(
                        dua.arabicText,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.amiri(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.8,
                          color: AppColors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Pronunciation
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          dua.pronunciation,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12.5,
                            fontStyle: FontStyle.italic,
                            color: isDark ? Colors.white70 : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Translation
                      Text(
                        dua.translation,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          height: 1.45,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      if (dua.note != null && dua.note!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.amberSoftDark.withOpacity(0.35)
                                : AppColors.amberSoft,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.amber.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '★ ${dua.note}',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 11.5,
                              height: 1.4,
                              color: isDark ? const Color(0xFFFDE68A) : AppColors.amberDark,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),

                      // Reference & Interactive Tap Counter
                      Row(
                        children: [
                          const Icon(Icons.bookmark_outline, size: 13, color: AppColors.emerald),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              dua.reference,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.emerald,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () => _resetSingleCounter(dua),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                              ),
                              child: const Text(
                                '↺',
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Builder(
                            builder: (context) {
                              final currentCount = _tapCounts[dua.id] ?? 0;
                              final isDone = currentCount >= dua.targetCount;
                              return InkWell(
                                onTap: () => _incrementCounter(dua),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isDone
                                        ? AppColors.emerald
                                        : (isDark
                                            ? AppColors.emeraldSoftDark.withOpacity(0.6)
                                            : AppColors.emeraldSoft),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDone
                                          ? AppColors.emerald
                                          : AppColors.emerald.withOpacity(0.35),
                                    ),
                                  ),
                                  child: Text(
                                    '${BengaliNumerals.toBengali(currentCount)} / ${BengaliNumerals.toBengali(dua.targetCount)}${isDone ? ' ✓' : ''}',
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isDone ? Colors.white : AppColors.emerald,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
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
