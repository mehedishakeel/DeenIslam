import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/repositories/muslim_names_data.dart';

class MuslimNamesScreen extends StatefulWidget {
  const MuslimNamesScreen({super.key});

  @override
  State<MuslimNamesScreen> createState() => _MuslimNamesScreenState();
}

class _MuslimNamesScreenState extends State<MuslimNamesScreen> {
  String _selectedGender = 'all'; // 'all', 'boy', 'girl'
  String _selectedLetter = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Set<String> _bookmarkedKeys = {};

  final List<String> _letters = [
    'all', 'অ', 'আ', 'ই', 'ঈ', 'উ', 'ক', 'খ', 'গ', 'জ', 'ত', 'দ', 'ন', 'ফ', 'ব', 'ম', 'র', 'ল', 'শ', 'স', 'হ', 'ও'
  ];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await StorageService.getBookmarks();
    if (!mounted) return;
    setState(() {
      _bookmarkedKeys = bookmarks.map((b) => b.key).toSet();
    });
  }

  Future<void> _toggleBookmark(MuslimNameItem item) async {
    final key = 'name_${item.id}';
    final bookmarkItem = BookmarkItem(
      key: key,
      type: 'muslim_name',
      categoryTitle: item.gender == 'boy' ? 'ছেলেদের ইসলামিক নাম' : 'মেয়েদের ইসলামিক নাম',
      title: item.name,
      arabic: item.arabic,
      bengali: item.meaning,
      reference: item.english,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    final added = await StorageService.toggleBookmark(bookmarkItem);
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
          added ? 'বুকমার্কে যুক্ত করা হয়েছে' : 'বুকমার্ক থেকে সরানো হয়েছে',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyName(MuslimNameItem item) {
    final text = "${item.name} (${item.arabic})\nইংরেজি: ${item.english}\nঅর্থ: ${item.meaning}\n[DeenIslam • ইসলামিক নাম সংকলন]";
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'নাম ও অর্থ কপি করা হয়েছে!',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<MuslimNameItem> get _filteredNames {
    return MuslimNamesData.names.filter((n) {
      if (_selectedGender != 'all' && n.gender != _selectedGender) return false;
      if (_selectedLetter != 'all' && n.letter != _selectedLetter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase().trim();
        final matchName = n.name.toLowerCase().contains(q);
        final matchMeaning = n.meaning.toLowerCase().contains(q);
        final matchEng = n.english.toLowerCase().contains(q);
        final matchAr = n.arabic.contains(q);
        return matchName || matchMeaning || matchEng || matchAr;
      }
      return true;
    }).toList();
  }

  void _showGuidelinesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book, color: AppColors.emerald, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'নামকরণের সুন্নাত নীতিমালা ও নিষিদ্ধ নাম',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      '📜 ইসলামিক নামকরণের ৫টি সুন্নাত আদব:',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...MuslimNamesData.guidelines.map((g) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g['title']!,
                            style: GoogleFonts.hindSiliguri(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            g['desc']!,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 16),
                    Text(
                      '🚫 যে নামগুলো রাখা ইসলামে সম্পূর্ণ নিষিদ্ধ:',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...MuslimNamesData.prohibitedNames.map((p) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.red.withOpacity(0.08) : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.red.withOpacity(0.2) : Colors.red.shade100,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['name']!,
                            style: GoogleFonts.hindSiliguri(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p['reason']!,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredNames;

    final boyCount = MuslimNamesData.names.where((n) => n.gender == 'boy').length;
    final girlCount = MuslimNamesData.names.where((n) => n.gender == 'girl').length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'মুসলিম শিশুদের সুন্দর নাম',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'নামকরণের নীতিমালা ও নিষিদ্ধ নাম',
            onPressed: _showGuidelinesSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Box
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'নাম, অর্থ বা ইংরেজি বানান দিয়ে খুঁজুন...',
                    hintStyle: GoogleFonts.hindSiliguri(fontSize: 13, color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Gender Category Selector Chips
                Row(
                  children: [
                    _buildGenderChip('all', 'সকল নাম (${BengaliNumerals.toBengali(MuslimNamesData.names.length)})', isDark),
                    const SizedBox(width: 8),
                    _buildGenderChip('boy', 'ছেলে (${BengaliNumerals.toBengali(boyCount)})', isDark),
                    const SizedBox(width: 8),
                    _buildGenderChip('girl', 'মেয়ে (${BengaliNumerals.toBengali(girlCount)})', isDark),
                  ],
                ),
                const SizedBox(height: 8),

                // Alphabet Scroll
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _letters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, idx) {
                      final l = _letters[idx];
                      final isSelected = _selectedLetter == l;
                      return ActionChip(
                        label: Text(
                          l == 'all' ? 'সব বর্ণ' : l,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.grey.shade300 : Colors.black87),
                          ),
                        ),
                        backgroundColor: isSelected
                            ? AppColors.emerald
                            : (isDark ? const Color(0xFF1E293B) : Colors.grey.shade100),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        onPressed: () {
                          setState(() {
                            _selectedLetter = l;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Result List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 56, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'কোনো নাম খুঁজে পাওয়া যায়নি',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'অনুসন্ধানের বানান পরিবর্তন করে চেষ্টা করুন',
                          style: GoogleFonts.hindSiliguri(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isBoy = item.gender == 'boy';
                      final isBookmarked = _bookmarkedKeys.contains('name_${item.id}');

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200,
                          ),
                        ),
                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isBoy
                                          ? AppColors.emerald.withOpacity(0.12)
                                          : const Color(0xFFF43F5E).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isBoy ? 'ছেলেদের নাম' : 'মেয়েদের নাম',
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isBoy ? AppColors.emerald : const Color(0xFFF43F5E),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    item.arabic,
                                    style: GoogleFonts.amiri(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.amber : AppColors.emerald,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${item.english})',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.meaning,
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 13,
                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(height: 1),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                      color: isBookmarked ? AppColors.amber : Colors.grey,
                                      size: 20,
                                    ),
                                    tooltip: 'বুকমার্ক',
                                    onPressed: () => _toggleBookmark(item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy_outlined, size: 19, color: Colors.grey),
                                    tooltip: 'কপি করুন',
                                    onPressed: () => _copyName(item),
                                  ),
                                ],
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

  Widget _buildGenderChip(String gender, String label, bool isDark) {
    final isSelected = _selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.emerald
                : (isDark ? const Color(0xFF1E293B) : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.hindSiliguri(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? Colors.white : (isDark ? Colors.grey.shade300 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}

extension on List<MuslimNameItem> {
  List<MuslimNameItem> filter(bool Function(MuslimNameItem) predicate) {
    return where(predicate).toList();
  }
}
