import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/models/hadith_model.dart';
import '../../../data/repositories/hadith_repository.dart';
import 'hadith_reader_screen.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedBookSlug = 'bukhari';
  Set<String> _cachedSlugs = {};

  @override
  void initState() {
    super.initState();
    _checkCachedBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkCachedBooks() async {
    final cached = <String>{};
    for (final book in HadithRepository.allBooks) {
      if (await StorageService.isHadithBookCached(book.slug)) {
        cached.add(book.slug);
      }
    }
    if (mounted) {
      setState(() => _cachedSlugs = cached);
    }
  }

  void _openBookSearch() {
    final query = _searchController.text.trim();
    final book = HadithRepository.getBookBySlug(_selectedBookSlug);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HadithReaderScreen(
          book: book,
          initialSearchQuery: query.isEmpty ? null : query,
        ),
      ),
    ).then((_) => _checkCachedBooks());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const books = HadithRepository.allBooks;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'হাদিস শরীফ সংকলন',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Banner Card
            Container(
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
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'সিহাহ সিত্তাহ ও মুয়াত্তা',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.emerald,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'বিশুদ্ধ হাদিস গ্রন্থসমূহ',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'রাসূলুল্লাহ (সা.)-এর সুন্নাহ ও দিকনির্দেশনার নির্ভরযোগ্য সংকলন ও বাংলা অনুবাদ',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Book Dropdown + Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBookSlug,
                        isExpanded: true,
                        items: books.map((b) {
                          return DropdownMenuItem(
                            value: b.slug,
                            child: Text(
                              b.nameBengali,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedBookSlug = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (_) => _openBookSearch(),
                          style: GoogleFonts.hindSiliguri(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'হাদিস নম্বর বা শব্দ (যেমন: নিয়ত)...',
                            hintStyle: GoogleFonts.hindSiliguri(
                              fontSize: 12.5,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 18,
                              color: AppColors.emerald,
                            ),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
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
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _openBookSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'খুঁজুন',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Books List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: books.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final book = books[index];
                final isCached = _cachedSlugs.contains(book.slug);
                return _buildBookCard(book, isCached, isDark);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(HadithBook book, bool isCached, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HadithReaderScreen(book: book)),
        ).then((_) => _checkCachedBooks());
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.emerald.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        BengaliNumerals.convert(book.index),
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.nameBengali,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          book.nameArabic,
                          style: GoogleFonts.amiri(
                            fontSize: 14,
                            color: AppColors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        book.badge,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                    if (isCached) ...[
                      const SizedBox(height: 4),
                      Text(
                        '✓ অফলাইন ক্যাশড',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 10,
                          color: AppColors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              book.description,
              style: GoogleFonts.hindSiliguri(
                fontSize: 12.5,
                height: 1.5,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'হাদিস সংখ্যা: ~${BengaliNumerals.convert(book.totalCount)}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'হাদিস পড়ুন',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12.5,
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
          ],
        ),
      ),
    );
  }
}
