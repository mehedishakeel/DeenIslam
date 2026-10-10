import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<BookmarkItem> _bookmarks = [];
  String _selectedType = 'all'; // 'all', 'ayah', 'hadith', 'dua'
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _isLoading = true);
    final items = await StorageService.getBookmarks();
    if (!mounted) return;
    setState(() {
      _bookmarks = items;
      _isLoading = false;
    });
  }

  Future<void> _removeBookmark(String key) async {
    await StorageService.removeBookmark(key);
    await _loadBookmarks();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'বুকমার্ক সরানো হয়েছে',
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
    final filtered = _selectedType == 'all'
        ? _bookmarks
        : _bookmarks.where((b) => b.type == _selectedType).toList();

    final tabs = [
      {'id': 'all', 'label': 'সকল (${BengaliNumerals.convert(_bookmarks.length)})'},
      {'id': 'ayah', 'label': 'কুরআন'},
      {'id': 'hadith', 'label': 'হাদিস'},
      {'id': 'dua', 'label': 'দোয়া'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'সংরক্ষিত বুকমার্ক',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Row(
              children: tabs.map((tab) {
                final isSelected = _selectedType == tab['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      tab['label']!,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.emerald,
                    backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                    onSelected: (_) {
                      setState(() => _selectedType = tab['id']!);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.emerald))
                : filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bookmark_border_rounded,
                                size: 48,
                                color: AppColors.emerald.withOpacity(0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'কোনো বুকমার্ক পাওয়া যায়নি',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'কুরআনের আয়াত, হাদিস বা দোয়া পড়ার সময় বুকমার্ক আইকনে ট্যাপ করে এখানে সংরক্ষণ করুন।',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 12.5,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _buildBookmarkCard(item, isDark);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(BookmarkItem item, bool isDark) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.categoryTitle,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      final text = [
                        if (item.arabic.isNotEmpty) item.arabic,
                        item.bengali,
                        '— ${item.reference}',
                      ].join('\n\n');
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'কপি করা হয়েছে',
                            style: GoogleFonts.hindSiliguri(fontSize: 13),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: AppColors.emerald,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_outlined, size: 18),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _removeBookmark(item.key),
                    icon: const Icon(Icons.delete_outline, size: 19, color: Colors.redAccent),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 18),
          if (item.arabic.isNotEmpty) ...[
            Text(
              item.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: 21,
                height: 1.9,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            item.bengali,
            style: GoogleFonts.hindSiliguri(
              fontSize: 13.5,
              height: 1.6,
              color: isDark ? Colors.white.withOpacity(0.9) : AppColors.textPrimaryLight,
            ),
          ),
          if (item.reference.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.reference,
              style: GoogleFonts.hindSiliguri(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.emerald,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
