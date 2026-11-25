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
  double _bengaliFontSize = 15.0;
  String _reciterId = 'ar.alafasy';
  int _repeatCount = 1; // 1, 3, 5, 999
  int _currentRepeatIteration = 0;
  bool _isCompleted = false;
  bool _showTafsir = false;
  bool _isLoadingTafsir = false;
  Map<int, String> _tafsirMap = {};
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
    final reciter = await StorageService.getQuranReciter();
    final repeat = await StorageService.getQuranRepeatCount();
    final arSize = await StorageService.getArabicFontSize();
    final bnSize = await StorageService.getBengaliFontSize();
    final completedSet = await StorageService.getCompletedSurahs();
    if (!mounted) return;
    setState(() {
      _ayahs = loaded;
      _bookmarkedKeys = bookmarks.map((b) => b.key).toSet();
      _reciterId = reciter;
      _repeatCount = repeat;
      _arabicFontSize = arSize;
      _bengaliFontSize = bnSize;
      _isCompleted = completedSet.contains(widget.surah.number);
      _isLoading = false;
    });
  }

  Future<void> _playSingleAyah(int index, {bool resetRepeat = true}) async {
    if (resetRepeat && _playingAyahIndex == index && !_isPlayingSurah) {
      await AudioService.instance.stop();
      if (!mounted) return;
      setState(() {
        _playingAyahIndex = null;
        _isPlayingSurah = false;
        _currentRepeatIteration = 0;
      });
      return;
    }

    if (resetRepeat) {
      _currentRepeatIteration = 0;
    }

    final ayah = _ayahs[index];
    final url = QuranRepository.getAudioUrlForAyah(
      ayah,
      widget.surah.number,
      reciterId: _reciterId,
    );

    setState(() {
      _isPlayingSurah = false;
      _playingAyahIndex = index;
    });

    await AudioService.instance.playUrl(
      url,
      onCompleted: () {
        if (!mounted || _playingAyahIndex != index) return;
        _currentRepeatIteration++;
        if (_repeatCount == 999 || _currentRepeatIteration < _repeatCount) {
          _playSingleAyah(index, resetRepeat: false);
        } else {
          setState(() {
            _playingAyahIndex = null;
            _currentRepeatIteration = 0;
          });
        }
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
        _currentRepeatIteration = 0;
      });
      return;
    }

    final startIndex = _playingAyahIndex ?? 0;
    _currentRepeatIteration = 0;
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
          _currentRepeatIteration = 0;
        });
      }
      return;
    }

    final ayah = _ayahs[index];
    final url = QuranRepository.getAudioUrlForAyah(
      ayah,
      widget.surah.number,
      reciterId: _reciterId,
    );

    setState(() {
      _playingAyahIndex = index;
    });

    await AudioService.instance.playUrl(
      url,
      onCompleted: () {
        if (!mounted || !_isPlayingSurah) return;
        _currentRepeatIteration++;
        if (_repeatCount == 999 || _currentRepeatIteration < _repeatCount) {
          _playSurahSequenceFrom(index);
        } else {
          _currentRepeatIteration = 0;
          _playSurahSequenceFrom(index + 1);
        }
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
                      const SizedBox(height: 14),
                      // Quick Reader Controls: Reciter, Hifz Repeat & Mark Completed
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          InkWell(
                            onTap: _showReciterSheet,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? AppColors.borderDark : AppColors.emerald.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.record_voice_over_outlined, size: 14, color: AppColors.emerald),
                                  const SizedBox(width: 5),
                                  Text(
                                    QuranRepository.reciters
                                        .firstWhere((r) => r.id == _reciterId,
                                            orElse: () => QuranRepository.reciters.first)
                                        .nameBn,
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _cycleRepeatMode,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _repeatCount > 1
                                    ? AppColors.emerald.withOpacity(0.15)
                                    : (isDark ? Colors.white.withOpacity(0.06) : Colors.white),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _repeatCount > 1
                                      ? AppColors.emerald
                                      : (isDark ? AppColors.borderDark : AppColors.emerald.withOpacity(0.3)),
                                ),
                              ),
                              child: Text(
                                _repeatCount == 999
                                    ? '🔁 অবিরাম লুপ'
                                    : '🔁 ${BengaliNumerals.toBengali(_repeatCount)} বার',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _repeatCount > 1
                                      ? AppColors.emerald
                                      : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _toggleSurahCompleted,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _isCompleted
                                    ? AppColors.emerald
                                    : (isDark ? Colors.white.withOpacity(0.06) : Colors.white),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _isCompleted
                                      ? AppColors.emerald
                                      : (isDark ? AppColors.borderDark : AppColors.emerald.withOpacity(0.3)),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                                    size: 14,
                                    color: _isCompleted ? Colors.white : AppColors.emerald,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isCompleted ? 'পঠিত সম্পন্ন' : 'পঠিত চিহ্নিত করুন',
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _isCompleted
                                          ? Colors.white
                                          : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _toggleTafsirMode,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _showTafsir
                                    ? AppColors.amber.withOpacity(0.18)
                                    : (isDark ? Colors.white.withOpacity(0.06) : Colors.white),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _showTafsir
                                      ? AppColors.amber
                                      : (isDark ? AppColors.borderDark : AppColors.emerald.withOpacity(0.3)),
                                ),
                              ),
                              child: Text(
                                _isLoadingTafsir
                                    ? '⏳ তাফসীর...'
                                    : (_showTafsir ? '📘 তাফসীর চালু ✓' : '📘 তাফসীর দেখুন'),
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _showTafsir
                                      ? AppColors.amberDark
                                      : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                              fontSize: _bengaliFontSize,
                              height: 1.5,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          if (_showTafsir && _tafsirMap.containsKey(ayah.numberInSurah)) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.amberSoftDark.withOpacity(0.3)
                                    : AppColors.amberSoft,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.amber.withOpacity(0.35),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '📘 তাফসীর আল-মুখতাসার:',
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.amberDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _tafsirMap[ayah.numberInSurah]!,
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 12.5,
                                      height: 1.48,
                                      color: isDark
                                          ? const Color(0xFFFDE68A)
                                          : const Color(0xFF451A03),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                            : QuranRepository.reciters
                                .firstWhere((r) => r.id == _reciterId,
                                    orElse: () => QuranRepository.reciters.first)
                                .nameBn,
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

  Future<void> _cycleRepeatMode() async {
    const modes = [1, 3, 5, 999];
    final currentIdx = modes.indexOf(_repeatCount);
    final nextMode = modes[(currentIdx + 1) % modes.length];
    await StorageService.setQuranRepeatCount(nextMode);
    if (!mounted) return;
    setState(() {
      _repeatCount = nextMode;
      _currentRepeatIteration = 0;
    });
    final label = nextMode == 999
        ? 'অবিরাম লুপ'
        : '${BengaliNumerals.toBengali(nextMode)} বার';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'আয়াত পুনরাবৃত্তি: $label',
          style: GoogleFonts.hindSiliguri(fontSize: 13),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleSurahCompleted() async {
    final added = await StorageService.toggleCompletedSurah(widget.surah.number);
    if (!mounted) return;
    setState(() => _isCompleted = added);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added ? 'সূরাটি পঠিত তালিকায় যুক্ত হয়েছে' : 'পঠিত তালিকা থেকে সরানো হয়েছে',
          style: GoogleFonts.hindSiliguri(fontSize: 13),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleTafsirMode() async {
    if (_showTafsir) {
      setState(() => _showTafsir = false);
      return;
    }
    if (_tafsirMap.isNotEmpty) {
      setState(() => _showTafsir = true);
      return;
    }
    setState(() => _isLoadingTafsir = true);
    final loaded = await QuranRepository.fetchBengaliTafsir(widget.surah.number);
    if (!mounted) return;
    if (loaded.isNotEmpty) {
      setState(() {
        _tafsirMap = loaded;
        _showTafsir = true;
        _isLoadingTafsir = false;
      });
    } else {
      setState(() => _isLoadingTafsir = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'তাফসীর লোড করা যায়নি, ইন্টারনেট সংযোগ পরীক্ষা করুন।',
            style: GoogleFonts.hindSiliguri(fontSize: 13),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showReciterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ক্বারী নির্বাচন করুন',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...QuranRepository.reciters.map((r) {
                final selected = _reciterId == r.id;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    selected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: selected ? AppColors.emerald : Colors.grey,
                  ),
                  title: Text(
                    r.nameBn,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                      color: selected ? AppColors.emerald : null,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await AudioService.instance.stop();
                    await StorageService.setQuranReciter(r.id);
                    if (!mounted) return;
                    setState(() {
                      _reciterId = r.id;
                      _isPlayingSurah = false;
                      _playingAyahIndex = null;
                      _currentRepeatIteration = 0;
                    });
                  },
                );
              }),
            ],
          ),
        );
      },
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
                    "আরবি ফন্ট সাইজ: ${BengaliNumerals.toBengali(_arabicFontSize.toInt())}px",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                            setModalState(() => _arabicFontSize = val);
                            setState(() => _arabicFontSize = val);
                            StorageService.setArabicFontSize(val);
                          },
                        ),
                      ),
                      const Text("A", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "বাংলা অনুবাদ ফন্ট সাইজ: ${BengaliNumerals.toBengali(_bengaliFontSize.toInt())}px",
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Text("অ", style: TextStyle(fontSize: 13)),
                      Expanded(
                        child: Slider(
                          value: _bengaliFontSize,
                          min: 12.0,
                          max: 24.0,
                          divisions: 6,
                          activeColor: AppColors.emerald,
                          onChanged: (val) {
                            setModalState(() => _bengaliFontSize = val);
                            setState(() => _bengaliFontSize = val);
                            StorageService.setBengaliFontSize(val);
                          },
                        ),
                      ),
                      const Text("অ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
