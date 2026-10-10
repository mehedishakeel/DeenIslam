import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/repositories/allah_names_data.dart';
import '../../../data/repositories/dua_data.dart';
import '../../../data/repositories/hadith_repository.dart';
import '../../../data/repositories/seerah_data.dart';
import '../../../data/repositories/surah_data.dart';
import '../../hadith/presentation/hadith_reader_screen.dart';
import '../../quran/presentation/surah_reader_screen.dart';
import '../../seerah/presentation/seerah_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = _query.trim().toLowerCase();

    final surahMatches = q.isEmpty
        ? SurahData.allSurahs.take(5).toList()
        : SurahData.allSurahs.where((s) {
            return s.nameBengali.toLowerCase().contains(q) ||
                s.nameEnglish.toLowerCase().contains(q) ||
                s.nameArabic.contains(q) ||
                s.number.toString() == q ||
                BengaliNumerals.toBengali(s.number) == q;
          }).toList();

    final seerahEventMatches = q.isEmpty
        ? SeerahData.events.take(3).toList()
        : SeerahData.events.where((e) {
            return e.titleBn.toLowerCase().contains(q) ||
                e.titleAr.contains(q) ||
                e.placeBn.toLowerCase().contains(q) ||
                e.summaryBn.toLowerCase().contains(q);
          }).toList();

    final companionMatches = q.isEmpty
        ? SeerahData.companions.take(3).toList()
        : SeerahData.companions.where((c) {
            return c.nameBn.toLowerCase().contains(q) ||
                c.nameAr.contains(q) ||
                c.laqabBn.toLowerCase().contains(q) ||
                c.bioBn.toLowerCase().contains(q);
          }).toList();

    final battleMatches = q.isEmpty
        ? SeerahData.battles.take(2).toList()
        : SeerahData.battles.where((b) {
            return b.nameBn.toLowerCase().contains(q) ||
                b.nameAr.contains(q) ||
                b.locationBn.toLowerCase().contains(q) ||
                b.summaryBn.toLowerCase().contains(q);
          }).toList();

    final duaMatches = q.isEmpty
        ? DuaData.allDuas.take(4).toList()
        : DuaData.allDuas.where((d) {
            return d.titleBengali.toLowerCase().contains(q) ||
                d.category.toLowerCase().contains(q) ||
                d.translation.toLowerCase().contains(q) ||
                d.pronunciation.toLowerCase().contains(q);
          }).toList();

    final hadithBookMatches = q.isEmpty
        ? HadithRepository.allBooks.take(3).toList()
        : HadithRepository.allBooks.where((b) {
            return b.nameBengali.toLowerCase().contains(q) ||
                b.slug.toLowerCase().contains(q) ||
                b.compiler.toLowerCase().contains(q) ||
                b.description.toLowerCase().contains(q);
          }).toList();

    final nameMatches = q.isEmpty
        ? AllahNamesData.allNames.take(4).toList()
        : AllahNamesData.allNames.where((n) {
            return n.transliteration.toLowerCase().contains(q) ||
                n.meaning.toLowerCase().contains(q) ||
                n.arabic.contains(q) ||
                (n.desc ?? '').toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'সর্বজনীন অনুসন্ধান',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (val) => setState(() => _query = val),
              style: GoogleFonts.hindSiliguri(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'সূরা, সীরাত, সাহাবী, গাযওয়া, হাদিস বা দোয়া খুঁজুন...',
                hintStyle: GoogleFonts.hindSiliguri(fontSize: 13.5),
                prefixIcon: const Icon(Icons.search, color: AppColors.emerald),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.clear, size: 18),
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.cardDark : Colors.white,
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
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (surahMatches.isNotEmpty) ...[
                  _sectionHeader(isDark, 'আল-কুরআন (${BengaliNumerals.convert(surahMatches.length)})'),
                  ...surahMatches.take(10).map((s) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.emeraldSoft,
                        child: Text(
                          BengaliNumerals.toBengali(s.number),
                          style: GoogleFonts.hindSiliguri(
                            fontWeight: FontWeight.bold,
                            color: AppColors.emerald,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      title: Text(
                        'সূরা ${s.nameBengali} (${s.nameEnglish})',
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        '${s.revelationType} • ${BengaliNumerals.toBengali(s.numberOfAyahs)} আয়াত',
                        style: GoogleFonts.hindSiliguri(fontSize: 12),
                      ),
                      trailing: Text(
                        s.nameArabic,
                        style: GoogleFonts.amiri(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurahReaderScreen(surah: s),
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 12),
                ],
                if (hadithBookMatches.isNotEmpty) ...[
                  _sectionHeader(isDark, 'হাদিস সংকলন (${BengaliNumerals.convert(hadithBookMatches.length)})'),
                  ...hadithBookMatches.map((b) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.amberSoft,
                        child: Icon(Icons.library_books_outlined, color: AppColors.amberDark, size: 18),
                      ),
                      title: Text(
                        b.nameBengali,
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        b.compiler,
                        style: GoogleFonts.hindSiliguri(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HadithReaderScreen(book: b),
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 12),
                ],
                if (duaMatches.isNotEmpty) ...[
                  _sectionHeader(isDark, 'নিত্যদিনের দোয়া (${BengaliNumerals.convert(duaMatches.length)})'),
                  ...duaMatches.take(8).map((d) {
                    return Card(
                      elevation: 0,
                      color: isDark ? AppColors.cardDark : Colors.white,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          d.titleBengali,
                          style: GoogleFonts.hindSiliguri(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                        subtitle: Text(
                          d.translation,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.hindSiliguri(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 17, color: AppColors.emerald),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: '${d.titleBengali}\n${d.arabicText}\n${d.translation}',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'দোয়া কপি করা হয়েছে',
                                  style: GoogleFonts.hindSiliguri(fontSize: 13),
                                ),
                                backgroundColor: AppColors.emerald,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                ],
                if (nameMatches.isNotEmpty) ...[
                  _sectionHeader(isDark, 'আল্লাহর সুন্দর নামসমূহ (${BengaliNumerals.convert(nameMatches.length)})'),
                  ...nameMatches.take(8).map((n) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      leading: Text(
                        n.arabic,
                        style: GoogleFonts.amiri(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                      title: Text(
                        '${n.transliteration} — ${n.meaning}',
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                      subtitle: Text(
                        n.desc ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.hindSiliguri(fontSize: 12),
                      ),
                    );
                  }),
                ],
                if (seerahEventMatches.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _sectionHeader(isDark, 'সীরাত ও ঐতিহাসিক ঘটনা (${BengaliNumerals.convert(seerahEventMatches.length)})'),
                  ...seerahEventMatches.take(6).map((e) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.emeraldSoft,
                        child: Icon(Icons.map_outlined, color: AppColors.emerald, size: 18),
                      ),
                      title: Text(
                        e.titleBn,
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                      subtitle: Text(
                        '${e.yearCe} • ${e.placeBn}',
                        style: GoogleFonts.hindSiliguri(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SeerahScreen(initialTabIndex: 0),
                          ),
                        );
                      },
                    );
                  }),
                ],
                if (companionMatches.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _sectionHeader(isDark, 'সাহাবী ডিরেক্টরি (${BengaliNumerals.convert(companionMatches.length)})'),
                  ...companionMatches.take(6).map((c) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.amberSoft,
                        child: Icon(Icons.people_outline, color: AppColors.amberDark, size: 18),
                      ),
                      title: Text(
                        c.nameBn,
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                      subtitle: Text(
                        c.laqabBn,
                        style: GoogleFonts.hindSiliguri(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SeerahScreen(initialTabIndex: 3),
                          ),
                        );
                      },
                    );
                  }),
                ],
                if (battleMatches.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _sectionHeader(isDark, 'গাযওয়া ও অভিযান (${BengaliNumerals.convert(battleMatches.length)})'),
                  ...battleMatches.take(6).map((b) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.emeraldSoft,
                        child: Icon(Icons.shield_outlined, color: AppColors.emerald, size: 18),
                      ),
                      title: Text(
                        '${b.nameBn} (${b.yearAh})',
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                      subtitle: Text(
                        '${b.locationBn} • ${b.outcomeBn}',
                        style: GoogleFonts.hindSiliguri(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SeerahScreen(initialTabIndex: 4),
                          ),
                        );
                      },
                    );
                  }),
                ],
                if (surahMatches.isEmpty &&
                    hadithBookMatches.isEmpty &&
                    duaMatches.isEmpty &&
                    nameMatches.isEmpty &&
                    seerahEventMatches.isEmpty &&
                    companionMatches.isEmpty &&
                    battleMatches.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Text(
                        'কোনো ফলাফল পাওয়া যায়নি',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(bool isDark, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.hindSiliguri(
          fontSize: 13.5,
          fontWeight: FontWeight.bold,
          color: AppColors.emerald,
        ),
      ),
    );
  }
}
