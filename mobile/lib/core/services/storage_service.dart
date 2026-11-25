import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkItem {
  final String key;
  final String type; // 'hadith', 'ayah', 'dua'
  final String categoryTitle;
  final String title;
  final String arabic;
  final String bengali;
  final String reference;
  final int timestamp;

  const BookmarkItem({
    required this.key,
    required this.type,
    required this.categoryTitle,
    required this.title,
    required this.arabic,
    required this.bengali,
    required this.reference,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'type': type,
        'categoryTitle': categoryTitle,
        'title': title,
        'arabic': arabic,
        'bengali': bengali,
        'reference': reference,
        'timestamp': timestamp,
      };

  factory BookmarkItem.fromJson(Map<String, dynamic> json) => BookmarkItem(
        key: json['key'] as String? ?? '',
        type: json['type'] as String? ?? 'hadith',
        categoryTitle: json['categoryTitle'] as String? ?? '',
        title: json['title'] as String? ?? '',
        arabic: json['arabic'] as String? ?? '',
        bengali: json['bengali'] as String? ?? '',
        reference: json['reference'] as String? ?? '',
        timestamp: json['timestamp'] as int? ?? 0,
      );
}

class StorageService {
  static const String _bookmarksKey = 'deen_bookmarks_v1';
  static const String _azanAlarmsKey = 'deen_azan_alarms_v1';
  static const String _azanMuazzinKey = 'deen_azan_muazzin_v1';
  static const String _azanPreReminderKey = 'deen_azan_pre_reminder_v1';
  static const String _selectedCityKey = 'deen_selected_city_v1';
  static const String _lastReadSurahKey = 'deen_last_read_surah_v1';
  static const String _darkModeKey = 'deen_dark_mode_v1';
  static const String _hijriOffsetKey = 'deen_hijri_offset';
  static const String _quranReciterKey = 'deen_quran_reciter_v1';
  static const String _quranRepeatKey = 'deen_quran_repeat_v1';
  static const String _arabicFontSizeKey = 'deen_arabic_font_size';
  static const String _bengaliFontSizeKey = 'deen_bengali_font_size';
  static const String _completedSurahsKey = 'deen_completed_surahs';
  static const String _dailyDuaCountsKey = 'deen_dua_counts_v1';

  // --- Hijri Moon-Sighting Offset Persistence ---
  static Future<int> getHijriOffset() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getInt(_hijriOffsetKey) ?? 0;
    return val.clamp(-3, 3);
  }

  static Future<void> setHijriOffset(int offset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hijriOffsetKey, offset.clamp(-3, 3));
  }

  // --- Theme Persistence ---
  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDark);
  }

  // --- Selected City Persistence ---
  static Future<String> getSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedCityKey) ?? 'ঢাকা';
  }

  static Future<void> setSelectedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedCityKey, city);
  }

  // --- Last Read Surah ---
  static Future<Map<String, dynamic>?> getLastReadSurah() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastReadSurahKey);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> setLastReadSurah({
    required int surahNumber,
    required String nameBengali,
    required int totalAyahs,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _lastReadSurahKey,
      jsonEncode({
        'surahNumber': surahNumber,
        'nameBengali': nameBengali,
        'totalAyahs': totalAyahs,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }),
    );
  }

  // --- Bookmarks Management ---
  static Future<List<BookmarkItem>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_bookmarksKey) ?? [];
    final items = <BookmarkItem>[];
    for (final raw in rawList) {
      try {
        items.add(BookmarkItem.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {}
    }
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  static Future<bool> isBookmarked(String key) async {
    final list = await getBookmarks();
    return list.any((b) => b.key == key);
  }

  static Future<bool> toggleBookmark(BookmarkItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getBookmarks();
    final existingIndex = current.indexWhere((b) => b.key == item.key);
    bool added;
    if (existingIndex >= 0) {
      current.removeAt(existingIndex);
      added = false;
    } else {
      current.insert(0, item);
      added = true;
    }
    await prefs.setStringList(
      _bookmarksKey,
      current.map((b) => jsonEncode(b.toJson())).toList(),
    );
    return added;
  }

  static Future<void> removeBookmark(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getBookmarks();
    current.removeWhere((b) => b.key == key);
    await prefs.setStringList(
      _bookmarksKey,
      current.map((b) => jsonEncode(b.toJson())).toList(),
    );
  }

  // --- Offline Surah Cache ---
  static String _surahCacheKey(int surahNumber) => 'deen_surah_cache_v1_$surahNumber';

  static Future<List<Map<String, dynamic>>?> getCachedSurahAyahs(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_surahCacheKey(surahNumber));
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveCachedSurahAyahs(
    int surahNumber,
    List<Map<String, dynamic>> ayahsJson,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_surahCacheKey(surahNumber), jsonEncode(ayahsJson));
  }

  static Future<Set<int>> getOfflineCachedSurahNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final result = <int>{1, 103, 108, 112, 113, 114}; // Built-in offline Surahs
    for (final k in keys) {
      if (k.startsWith('deen_surah_cache_v1_')) {
        final numStr = k.replaceFirst('deen_surah_cache_v1_', '');
        final parsed = int.tryParse(numStr);
        if (parsed != null) result.add(parsed);
      }
    }
    return result;
  }

  // --- Offline Hadith Cache ---
  static String _hadithCacheKey(String slug) => 'deen_hadith_cache_v1_$slug';

  static Future<List<Map<String, dynamic>>?> getCachedHadiths(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_hadithCacheKey(slug));
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveCachedHadiths(
    String slug,
    List<Map<String, dynamic>> hadithsJson,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hadithCacheKey(slug), jsonEncode(hadithsJson));
  }

  static Future<bool> isHadithBookCached(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_hadithCacheKey(slug));
  }

  // --- Azan Alarm Preferences ---
  static Future<Map<String, bool>> getAzanAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_azanAlarmsKey);
    final defaults = <String, bool>{
      'সেহরি শেষ (ইমসাক)': false,
      'ফজর': true,
      'যোহর': true,
      'আসর': true,
      'মাগরিব (ইফতার)': true,
      'ইশা': true,
    };
    if (raw == null) return defaults;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        if (value is bool) defaults[key] = value;
      });
      return defaults;
    } catch (_) {
      return defaults;
    }
  }

  static Future<void> setAzanAlarm(String waqtName, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getAzanAlarms();
    current[waqtName] = enabled;
    await prefs.setString(_azanAlarmsKey, jsonEncode(current));
  }

  static Future<String> getAzanMuazzin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_azanMuazzinKey) ?? 'মক্কা শরীফ (হারামাইন)';
  }

  static Future<void> setAzanMuazzin(String muazzin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_azanMuazzinKey, muazzin);
  }

  static Future<int> getAzanPreReminderMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_azanPreReminderKey) ?? 15;
  }

  static Future<void> setAzanPreReminderMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_azanPreReminderKey, minutes);
  }

  // --- Ramadan & Hajj Checklists + Quiz Persistence ---
  static const String _rozaDaysKey = 'deen_ramadan_roza_days_v1';
  static const String _dailyAmalsKey = 'deen_ramadan_daily_amals_v1';
  static const String _hajjChecklistKey = 'deen_hajj_checklist_v1';
  static const String _quizHighScoreKey = 'deen_quiz_high_score_v1';

  static Future<Set<int>> getRamadanRozaDays() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_rozaDaysKey);
    if (list == null) return {1, 2, 3};
    return list.map((e) => int.tryParse(e)).whereType<int>().toSet();
  }

  static Future<void> setRamadanRozaDays(Set<int> days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _rozaDaysKey,
      days.map((d) => d.toString()).toList(),
    );
  }

  static Future<Map<String, bool>> getRamadanDailyAmals(
    Map<String, bool> defaults,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dailyAmalsKey);
    final result = Map<String, bool>.from(defaults);
    if (raw == null) return result;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((k, v) {
        if (v is bool && result.containsKey(k)) {
          result[k] = v;
        }
      });
      return result;
    } catch (_) {
      return result;
    }
  }

  static Future<void> setRamadanDailyAmals(Map<String, bool> amals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dailyAmalsKey, jsonEncode(amals));
  }

  static Future<Map<String, bool>> getHajjChecklist(
    Map<String, bool> defaults,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_hajjChecklistKey);
    final result = Map<String, bool>.from(defaults);
    if (raw == null) return result;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((k, v) {
        if (v is bool && result.containsKey(k)) {
          result[k] = v;
        }
      });
      return result;
    } catch (_) {
      return result;
    }
  }

  static Future<void> setHajjChecklist(Map<String, bool> checklist) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hajjChecklistKey, jsonEncode(checklist));
  }

  static Future<int> getQuizHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_quizHighScoreKey) ?? 0;
  }

  static Future<void> setQuizHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_quizHighScoreKey) ?? 0;
    if (score > current) {
      await prefs.setInt(_quizHighScoreKey, score);
    }
  }

  // --- Quran Reader Preferences & Progress ---
  static Future<String> getQuranReciter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_quranReciterKey) ?? 'ar.alafasy';
  }

  static Future<void> setQuranReciter(String reciterId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quranReciterKey, reciterId);
  }

  static Future<int> getQuranRepeatCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_quranRepeatKey) ?? 1;
  }

  static Future<void> setQuranRepeatCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_quranRepeatKey, count);
  }

  static Future<double> getArabicFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_arabicFontSizeKey) ?? 24.0;
  }

  static Future<void> setArabicFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_arabicFontSizeKey, size);
  }

  static Future<double> getBengaliFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_bengaliFontSizeKey) ?? 15.0;
  }

  static Future<void> setBengaliFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_bengaliFontSizeKey, size);
  }

  static Future<Set<int>> getCompletedSurahs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_completedSurahsKey) ?? [];
    return list.map((e) => int.tryParse(e)).whereType<int>().toSet();
  }

  static Future<bool> toggleCompletedSurah(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getCompletedSurahs();
    bool added;
    if (current.contains(surahNumber)) {
      current.remove(surahNumber);
      added = false;
    } else {
      current.add(surahNumber);
      added = true;
    }
    await prefs.setStringList(
      _completedSurahsKey,
      current.map((e) => e.toString()).toList(),
    );
    return added;
  }

  // --- Daily Adhkar Loop Counter Persistence (auto-resets daily) ---
  static String _todayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static Future<Map<int, int>> getDailyDuaCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dailyDuaCountsKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      if (decoded['date'] == _todayDateString() &&
          decoded['counts'] is Map<String, dynamic>) {
        final rawCounts = decoded['counts'] as Map<String, dynamic>;
        final result = <int, int>{};
        rawCounts.forEach((k, v) {
          final id = int.tryParse(k);
          if (id != null && v is int) {
            result[id] = v;
          }
        });
        return result;
      }
    } catch (_) {}
    return {};
  }

  static Future<void> saveDailyDuaCounts(Map<int, int> counts) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedMap = <String, int>{};
    counts.forEach((k, v) {
      encodedMap[k.toString()] = v;
    });
    await prefs.setString(
      _dailyDuaCountsKey,
      jsonEncode({'date': _todayDateString(), 'counts': encodedMap}),
    );
  }

  // --- Full-State Backup Export & Import (JSON) ---
  static Future<String> exportFullBackupJson() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    final completedSurahs = await getCompletedSurahs();
    final payload = {
      'app': 'DeenIslam',
      'version': 2,
      'exportedAt': DateTime.now().toIso8601String(),
      'bookmarks': bookmarks.map((b) => b.toJson()).toList(),
      'completedSurahs': completedSurahs.toList(),
      'selectedCity': await getSelectedCity(),
      'hijriOffset': await getHijriOffset(),
      'quizHighScore': await getQuizHighScore(),
      'quranReciter': await getQuranReciter(),
      'quranRepeatCount': await getQuranRepeatCount(),
      'arabicFontSize': await getArabicFontSize(),
      'bengaliFontSize': await getBengaliFontSize(),
      'lastReadSurah': prefs.getString(_lastReadSurahKey),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  static Future<int> importFullBackupJson(String rawJson) async {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid JSON backup format');
    }
    final prefs = await SharedPreferences.getInstance();
    int restoredCount = 0;

    final rawBookmarks = decoded['bookmarks'];
    if (rawBookmarks is List) {
      final current = await getBookmarks();
      final existingKeys = current.map((b) => b.key).toSet();
      for (final item in rawBookmarks) {
        if (item is Map<String, dynamic>) {
          final parsed = BookmarkItem.fromJson(item);
          if (parsed.key.isNotEmpty && !existingKeys.contains(parsed.key)) {
            current.add(parsed);
            existingKeys.add(parsed.key);
            restoredCount++;
          }
        }
      }
      await prefs.setStringList(
        _bookmarksKey,
        current.map((b) => jsonEncode(b.toJson())).toList(),
      );
    }

    if (decoded['completedSurahs'] is List) {
      final merged = await getCompletedSurahs();
      for (final s in (decoded['completedSurahs'] as List)) {
        if (s is int) merged.add(s);
      }
      await prefs.setStringList(
        _completedSurahsKey,
        merged.map((e) => e.toString()).toList(),
      );
    }

    if (decoded['selectedCity'] is String) {
      await setSelectedCity(decoded['selectedCity'] as String);
    }
    if (decoded['hijriOffset'] is int) {
      await setHijriOffset(decoded['hijriOffset'] as int);
    }
    if (decoded['quizHighScore'] is int) {
      await setQuizHighScore(decoded['quizHighScore'] as int);
    }
    if (decoded['quranReciter'] is String) {
      await setQuranReciter(decoded['quranReciter'] as String);
    }
    if (decoded['quranRepeatCount'] is int) {
      await setQuranRepeatCount(decoded['quranRepeatCount'] as int);
    }
    if (decoded['arabicFontSize'] is num) {
      await setArabicFontSize((decoded['arabicFontSize'] as num).toDouble());
    }
    if (decoded['bengaliFontSize'] is num) {
      await setBengaliFontSize((decoded['bengaliFontSize'] as num).toDouble());
    }
    return restoredCount;
  }
}
