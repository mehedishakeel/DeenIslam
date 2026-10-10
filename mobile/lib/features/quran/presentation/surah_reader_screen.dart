import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/models/ayah_model.dart';
import '../../../data/models/surah_model.dart';
import '../../../data/repositories/quran_repository.dart';

class SurahReaderScreen extends StatefulWidget {
  final Surah surah;

  const SurahReaderScreen({super.key, required this.surah});

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  List<Ayah> _ayahs = [];
  Set<String> _bookmarkedKeys = {};
  bool _isLoading = true;
  bool _isSyncing = false;
  double _arabicFontSize = 24.0;
  bool _isPlayingSurah = false;
  bool _isBufferingAudio = false;
  int? _playingAyahIndex;

  @override
  void initState() {
    super.initState();
    _ayahs = QuranRepository.getAyahsForSurah(widget.surah.number);
    AudioService.instance.addListener(_onAudioStateChanged);
    _initSurahData();
  }

  @override
  void dispose() {
    AudioService.instance.removeListener(_onAudioStateChanged);
    AudioService.instance.stop();
    super.dispose();
  }

  void _onAudioStateChanged() {
    if (!mounted) return;
    setState(() {
      _isBufferingAudio = AudioService.instance.isLoading;
    });
  }

  Future<void> _initSurahData() async {
    await StorageService.setLastReadSurah(
      surahNumber: widget.surah.number,
      nameBengali: widget.surah.nameBengali,
      totalAyahs: widget.surah.numberOfAyahs,
    );
    final loaded = await QuranRepository.loadSurahWithOfflineCache(widget.surah.number);
    final bookmarks = await StorageService.getBookmarks();
    if (!mounted) return;
    setState(() {
      _ayahs = loaded;
      _bookmarkedKeys = bookmarks.map((b) => b.key).toSet();
      _isLoading = false;
    });
  }

  Future<void> _playSingleAyah(int index) async {
    if (_playingAyahIndex == index && !_isPlayingSurah) {
      await AudioService.instance.stop();
      if (!mounted) return;
      setState(() {
        _playingAyahIndex = null;
        _isPlayingSurah = false;
      });
      return;
    }

    final ayah = _ayahs[index];
    final url = (ayah.audioUrl != null && ayah.audioUrl!.isNotEmpty)
        ? ayah.audioUrl!
        : QuranRepository.getAyahAudioUrl(widget.surah.number, ayah.numberInSurah);

    setState(() {
      _isPlayingSurah = false;
      _playingAyahIndex = index;
    });

    await AudioService.instance.playUrl(
      url,
      onCompleted: () {
        if (!mounted) return;
        setState(() {
          _playingAyahIndex = null;
        });
      },
    );
  }

  Future<void> _toggleFullSurahPlayback() async {
    if (_isPlayingSurah) {
      await AudioService.instance.stop();
      if (!mounted) return;
      setState(() {
        _isPlayingSurah = false;
        _playingAyahIndex = null;
      });
      return;
    }

    final startIndex = _playingAyahIndex ?? 0;
    setState(() {
      _isPlayingSurah = true;
    });
    await _playSurahSequenceFrom(startIndex);
  }

  Future<void> _playSurahSequenceFrom(int index) async {
    if (!mounted || !_isPlayingSurah || index >= _ayahs.length) {
      if (mounted) {
        setState(() {
          _isPlayingSurah = false;
          _playingAyahIndex = null;
        });
      }
      return;
    }

    final ayah = _ayahs[index];
    final url = (ayah.audioUrl != null && ayah.audioUrl!.isNotEmpty)
        ? ayah.audioUrl!
        : QuranRepository.getAyahAudioUrl(widget.surah.number, ayah.numberInSurah);

    setState(() {
      _playingAyahIndex = index;
    });

    await AudioService.instance.playUrl(
      url,
      onCompleted: () {
        if (!mounted || !_isPlayingSurah) return;
        _playSurahSequenceFrom(index + 1);
      },
    );
  }

  Future<void> _downloadSurahOffline() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    final fetched = await QuranRepository.fetchSurahFromApi(widget.surah.number);
    if (!mounted) return;
    setState(() {
      if (fetched != null && fetched.isNotEmpty) {
        _ayahs = fetched;
      }
      _isSyncing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          fetched != null
              ? 'সূরা ${widget.surah.nameBengali} অফলাইনে সংরক্ষিত হয়েছে (${BengaliNumerals.toBengali(_ayahs.length)} আয়াত)'
              : 'অফলাইন সংকলন সক্রিয় রয়েছে',
          style: GoogleFonts.hindSiliguri(fontSize: 13),
        ),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyAyah(Ayah ayah) {
    final text =
        "${ayah.textArabic}\n\n${ayah.textBengali}\n\n[সূরা ${widget.surah.nameBengali}: আয়াত ${BengaliNumerals.toBengali(ayah.numberInSurah)}]";
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "আয়াত কপি করা হয়েছে!",
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleBookmark(Ayah ayah) async {
    final key = 'ayah_${widget.surah.number}_${ayah.numberInSurah}';
    final added = await StorageService.toggleBookmark(
      BookmarkItem(
        key: key,
        type: 'ayah',
        categoryTitle: 'সূরা ${widget.surah.nameBengali}',
        title: 'আয়াত ${BengaliNumerals.toBengali(ayah.numberInSurah)}',
        arabic: ayah.textArabic,
        bengali: ayah.textBengali,
        reference:
            'সূরা ${widget.surah.nameBengali} (${widget.surah.nameEnglish}) : ${BengaliNumerals.toBengali(ayah.numberInSurah)}',
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
          added ? 'আয়াতটি বুকমার্কে সংরক্ষিত হয়েছে' : 'বুকমার্ক থেকে সরানো হয়েছে',
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
    final isTawbah = widget.surah.number == 9;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surah.nameBengali,
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _isSyncing ? null : _downloadSurahOffline,
            tooltip: "অফলাইনে সংরক্ষণ করুন",
            icon: _isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.emerald,
                    ),
                  )
                : const Icon(Icons.cloud_download_outlined, color: AppColors.emerald),
          ),
          IconButton(
            icon: const Icon(Icons.format_size),
            tooltip: "ফন্ট সাইজ পরিবর্তন",
            onPressed: _showFontSizeDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (_isLoading || _isBufferingAudio)
            const LinearProgressIndicator(
              minHeight: 2,
              color: AppColors.emerald,
            ),
          // Main Surah Reader Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Surah Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                          : [const Color(0xFFECFDF5), const Color(0xFFFFFBEB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.emerald.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.surah.nameArabic,
                        style: GoogleFonts.amiri(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amber,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "সূরা ${widget.surah.nameBengali} • ${widget.surah.nameEnglish}",
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.surah.revelationType} • ${BengaliNumerals.toBengali(widget.surah.numberOfAyahs)} আয়াত",
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      if (!isTawbah) ...[
                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        const SizedBox(height: 14),
                        Text(
                          "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                          style: GoogleFonts.amiri(
                            fontSize: 20,
                            color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Ayahs List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _ayahs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ayah = _ayahs[index];
                    final isPlayingThis = _playingAyahIndex == index;
                    final bKey = 'ayah_${widget.surah.number}_${ayah.numberInSurah}';
                    final isBookmarked = _bookmarkedKeys.contains(bKey);

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isPlayingThis
                              ? AppColors.emerald
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: isPlayingThis ? 1.5 : 0.8,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Ayah Header Action Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "আয়াত ${BengaliNumerals.toBengali(ayah.numberInSurah)}",
                                  style: GoogleFonts.hindSiliguri(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.emerald,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isPlayingThis
                                          ? Icons.stop_circle_outlined
                                          : Icons.play_circle_outline,
                                      size: 21,
                                      color: isPlayingThis ? AppColors.emerald : null,
                                    ),
                                    tooltip: isPlayingThis ? "থামান" : "তিলাওয়াত শুনুন",
                                    onPressed: () => _playSingleAyah(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 18),
                                    tooltip: "কপি করুন",
                                    onPressed: () => _copyAyah(ayah),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                      size: 18,
                                      color: isBookmarked ? AppColors.amber : null,
                                    ),
                                    tooltip: "বুকমার্ক করুন",
                                    onPressed: () => _toggleBookmark(ayah),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Arabic Text
                          Text(
                            ayah.textArabic,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.amiri(
                              fontSize: _arabicFontSize,
                              fontWeight: FontWeight.bold,
                              height: 1.8,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Bengali Translation
                          Text(
                            ayah.textBengali,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 13.5,
                              height: 1.5,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom Audio Player Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              border: Border(
                top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                IconButton.filled(
                  onPressed: _toggleFullSurahPlayback,
                  icon: Icon(_isPlayingSurah ? Icons.stop : Icons.play_arrow),
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
                        _playingAyahIndex != null
                            ? "সূরা ${widget.surah.nameBengali} • আয়াত ${BengaliNumerals.toBengali(_playingAyahIndex! + 1)}/${BengaliNumerals.toBengali(_ayahs.length)}"
                            : "সূরা ${widget.surah.nameBengali} - পূর্ণাঙ্গ তিলাওয়াত",
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        _isBufferingAudio
                            ? "অডিও লোড হচ্ছে..."
                            : "ক্বারী মিশারি রাশিদ আল-আফাসী",
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 10.5,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _toggleFullSurahPlayback,
                  child: Text(
                    _isPlayingSurah ? "থামান" : "শুনুন",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
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

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "আরবি ফন্ট সাইজ নির্ধারণ করুন",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text("A", style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Slider(
                          value: _arabicFontSize,
                          min: 18.0,
                          max: 36.0,
                          divisions: 9,
                          activeColor: AppColors.emerald,
                          onChanged: (val) {
                            setModalState(() {
                              _arabicFontSize = val;
                            });
                            setState(() {
                              _arabicFontSize = val;
                            });
                          },
                        ),
                      ),
                      const Text("A", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Center(
                    child: Text(
                      "সাইজ: ${BengaliNumerals.toBengali(_arabicFontSize.toInt())}px",
                      style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
