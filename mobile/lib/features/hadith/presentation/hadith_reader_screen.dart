import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/models/hadith_model.dart';
import '../../../data/repositories/hadith_repository.dart';

class HadithReaderScreen extends StatefulWidget {
  final HadithBook book;
  final String? initialSearchQuery;

  const HadithReaderScreen({
    super.key,
    required this.book,
    this.initialSearchQuery,
  });

  @override
  State<HadithReaderScreen> createState() => _HadithReaderScreenState();
}

class _HadithReaderScreenState extends State<HadithReaderScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<HadithItem> _allHadiths = [];
  List<HadithItem> _filteredHadiths = [];
  Set<String> _bookmarkedKeys = {};
  bool _isLoading = true;
  bool _isSyncing = false;
  bool _isCachedOffline = false;
  double _arabicFontSize = 22.0;
  double _bengaliFontSize = 14.5;

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchQuery != null && widget.initialSearchQuery!.isNotEmpty) {
      _searchController.text = widget.initialSearchQuery!;
    }
    _loadHadiths();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHadiths() async {
    setState(() => _isLoading = true);
    final isCached = await StorageService.isHadithBookCached(widget.book.slug);
    final items = await HadithRepository.getHadithsForBook(widget.book.slug);
    final bookmarks = await StorageService.getBookmarks();
    if (!mounted) return;
    setState(() {
      _isCachedOffline = isCached;
      _allHadiths = items;
      _bookmarkedKeys = bookmarks.map((b) => b.key).toSet();
      _isLoading = false;
    });
    _applyFilter(_searchController.text);
  }

  Future<void> _syncOffline() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    final synced = await HadithRepository.syncBookFromApi(widget.book.slug);
    final isCached = await StorageService.isHadithBookCached(widget.book.slug);
    if (!mounted) return;
    setState(() {
      _allHadiths = synced;
      _isCachedOffline = isCached;
      _isSyncing = false;
    });
    _applyFilter(_searchController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCached
              ? '${widget.book.nameBengali} অফলাইনে সংরক্ষিত হয়েছে (${BengaliNumerals.convert(synced.length)}টি হাদিস)'
              : 'ইন্টারনেট সংযোগ পাওয়া যায়নি, অফলাইন সংকলন প্রদর্শিত হচ্ছে',
          style: GoogleFonts.hindSiliguri(fontSize: 13),
        ),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _toEnglishDigits(String input) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var out = input;
    for (var i = 0; i < bn.length; i++) {
      out = out.replaceAll(bn[i], i.toString());
    }
    return out;
  }

  void _applyFilter(String rawQuery) {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      setState(() => _filteredHadiths = _allHadiths);
      return;
    }
    final engQuery = _toEnglishDigits(query);
    final parsedNum = int.tryParse(engQuery);

    setState(() {
      if (parsedNum != null) {
        _filteredHadiths = _allHadiths
            .where((h) => h.hadithNumber == parsedNum)
            .toList();
      } else {
        final lower = query.toLowerCase();
        _filteredHadiths = _allHadiths.where((h) {
          return h.bengali.toLowerCase().contains(lower) ||
              h.chapterTitle.toLowerCase().contains(lower) ||
              h.narrator.toLowerCase().contains(lower) ||
              h.arabic.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _toggleBookmark(HadithItem hadith) async {
    final key = 'hadith_${hadith.bookSlug}_${hadith.hadithNumber}';
    final added = await StorageService.toggleBookmark(
      BookmarkItem(
        key: key,
        type: 'hadith',
        categoryTitle: hadith.bookNameBengali,
        title: 'হাদিস নং ${BengaliNumerals.convert(hadith.hadithNumber)} • ${hadith.chapterTitle}',
        arabic: hadith.arabic,
        bengali: hadith.bengali,
        reference: '${hadith.bookNameBengali} (${hadith.narrator})',
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
          added ? 'হাদিসটি বুকমার্কে সংরক্ষিত হয়েছে' : 'বুকমার্ক থেকে সরানো হয়েছে',
          style: GoogleFonts.hindSiliguri(fontSize: 13),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFontSettingsModal(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ফন্টের আকার পরিবর্তন করুন',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'আরবি ফন্ট সাইজ: ${BengaliNumerals.convert(_arabicFontSize.round())}',
                    style: GoogleFonts.hindSiliguri(fontSize: 13),
                  ),
                  Slider(
                    value: _arabicFontSize,
                    min: 18,
                    max: 32,
                    activeColor: AppColors.emerald,
                    onChanged: (val) {
                      setModalState(() => _arabicFontSize = val);
                      setState(() => _arabicFontSize = val);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'বাংলা অনুবাদ ফন্ট সাইজ: ${BengaliNumerals.convert(_bengaliFontSize.round())}',
                    style: GoogleFonts.hindSiliguri(fontSize: 13),
                  ),
                  Slider(
                    value: _bengaliFontSize,
                    min: 12,
                    max: 22,
                    activeColor: AppColors.emerald,
                    onChanged: (val) {
                      setModalState(() => _bengaliFontSize = val);
                      setState(() => _bengaliFontSize = val);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.book.nameBengali,
              style: GoogleFonts.hindSiliguri(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'মোট হাদিস: ${BengaliNumerals.convert(_allHadiths.length)}টি • ${_isCachedOffline ? "অফলাইন রেডি" : "সংকলিত"}',
              style: GoogleFonts.hindSiliguri(
                fontSize: 11,
                color: AppColors.emerald,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _isSyncing ? null : _syncOffline,
            tooltip: 'অফলাইনে ডাউনলোড করুন',
            icon: _isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.emerald,
                    ),
                  )
                : Icon(
                    _isCachedOffline
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_download_outlined,
                    color: AppColors.emerald,
                    size: 21,
                  ),
          ),
          IconButton(
            onPressed: () => _showFontSettingsModal(isDark),
            tooltip: 'ফন্ট সাইজ',
            icon: const Icon(Icons.text_fields, size: 20),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _applyFilter,
              style: GoogleFonts.hindSiliguri(fontSize: 13.5),
              decoration: InputDecoration(
                hintText: 'হাদিস নম্বর (যেমন: ১) বা শব্দ দিয়ে খুঁজুন...',
                hintStyle: GoogleFonts.hindSiliguri(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                prefixIcon: const Icon(Icons.search, size: 19, color: AppColors.emerald),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilter('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.cardDark : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.emerald, width: 1.4),
                ),
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.emerald),
                  )
                : _filteredHadiths.isEmpty
                    ? Center(
                        child: Text(
                          'কোনো হাদিস পাওয়া যায়নি',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 14,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                        itemCount: _filteredHadiths.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final hadith = _filteredHadiths[index];
                          final bKey = 'hadith_${hadith.bookSlug}_${hadith.hadithNumber}';
                          final isBookmarked = _bookmarkedKeys.contains(bKey);
                          return _buildHadithCard(hadith, isBookmarked, isDark);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithCard(HadithItem hadith, bool isBookmarked, bool isDark) {
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
          // Top Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.emerald.withOpacity(0.25),
                      ),
                    ),
                    child: Text(
                      'হাদিস ${BengaliNumerals.convert(hadith.hadithNumber)}',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.amberSoftDark : AppColors.amberSoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '✓ ${hadith.grade}',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.amberDark,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _toggleBookmark(hadith),
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      size: 20,
                      color: isBookmarked ? AppColors.amber : AppColors.emerald,
                    ),
                    tooltip: 'বুকমার্ক',
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      final copyText = [
                        if (hadith.arabic.isNotEmpty) hadith.arabic,
                        hadith.bengali,
                        '— ${hadith.bookNameBengali}, হাদিস নং ${BengaliNumerals.convert(hadith.hadithNumber)} (${hadith.narrator})',
                      ].join('\n\n');
                      Clipboard.setData(ClipboardData(text: copyText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'হাদিস কপি করা হয়েছে',
                            style: GoogleFonts.hindSiliguri(fontSize: 13),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: AppColors.emerald,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_outlined, size: 18),
                    tooltip: 'কপি করুন',
                  ),
                ],
              ),
            ],
          ),

          if (hadith.chapterTitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              hadith.chapterTitle,
              style: GoogleFonts.hindSiliguri(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.emerald,
              ),
            ),
          ],

          const Divider(height: 20),

          if (hadith.arabic.isNotEmpty) ...[
            Text(
              hadith.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: _arabicFontSize,
                height: 2.0,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 12),
          ],

          Text(
            hadith.bengali,
            style: GoogleFonts.hindSiliguri(
              fontSize: _bengaliFontSize,
              height: 1.65,
              color: isDark ? Colors.white.withOpacity(0.9) : AppColors.textPrimaryLight,
            ),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'বর্ণনাকারী: ${hadith.narrator}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ),
              Text(
                hadith.bookNameBengali,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
