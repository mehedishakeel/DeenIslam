import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/calc_config.dart';

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
  static const String _adhanSoundKey = 'deen_adhan_sound_v1';
  static const String _adhanChoiceKey = 'deen_adhan_choice_v1';
  static const String _calcMethodKey = 'deen_calc_method_v1';
  static const String _calcHanafiKey = 'deen_calc_hanafi_v1';
  static const String _hijriAdjustKey = 'deen_hijri_adjust_v1';
  static const String _dailyMinutesKey = 'deen_daily_minutes_v1';
  static const String _azanMuazzinKey = 'deen_azan_muazzin_v1';
  static const String _azanPreReminderKey = 'deen_azan_pre_reminder_v1';
  static const String _selectedCityKey = 'deen_selected_city_v1';
  static const String _gpsLocationKey = 'deen_gps_location_v1';
  static const String _lastReadSurahKey = 'deen_last_read_surah_v1';
  static const String _darkModeKey = 'deen_dark_mode_v1';

  // --- Theme Persistence ---
  /// Whether the full Adhan sound (when bundled) is used for prayer reminders.
  static Future<bool> getAdhanSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adhanSoundKey) ?? true;
  }

  static Future<void> setAdhanSound(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adhanSoundKey, enabled);
  }

  /// Which bundled Adhan (1..adhanCount) plays at prayer time. Default 1.
  static const int adhanCount = 3;

  static Future<int> getAdhanChoice() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getInt(_adhanChoiceKey) ?? 1;
    return (v >= 1 && v <= adhanCount) ? v : 1;
  }

  static Future<void> setAdhanChoice(int choice) async {
    if (choice < 1 || choice > adhanCount) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_adhanChoiceKey, choice);
  }

  /// Loads the saved calculation settings into [CalcConfig.current].
  static Future<CalcConfig> loadCalcConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final cfg = CalcConfig(
      method: CalcConfig.methodFromName(prefs.getString(_calcMethodKey)),
      hanafiAsr: prefs.getBool(_calcHanafiKey) ?? CalcConfig.defaults.hanafiAsr,
    );
    CalcConfig.apply(cfg);
    return cfg;
  }

  static Future<void> saveCalcConfig(CalcConfig cfg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_calcMethodKey, cfg.method.name);
    await prefs.setBool(_calcHanafiKey, cfg.hanafiAsr);
    CalcConfig.apply(cfg);
  }

  /// Days added to the calculated Hijri date to follow local moon sighting
  /// (-2..2, default 0 = pure calculation).
  static Future<int> getHijriAdjust() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getInt(_hijriAdjustKey) ?? 0).clamp(-2, 2);
  }

  static Future<void> setHijriAdjust(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hijriAdjustKey, days.clamp(-2, 2));
  }

  /// Time of the daily Ayah/Hadith reminder, minutes after midnight.
  static Future<int> getDailyReminderMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getInt(_dailyMinutesKey) ?? 7 * 60).clamp(0, 1439);
  }

  static Future<void> setDailyReminderMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyMinutesKey, minutes.clamp(0, 1439));
  }

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

  // --- GPS Location Persistence (last detected fix) ---
  static Future<Map<String, dynamic>?> getGpsLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_gpsLocationKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> setGpsLocation({
    required double latitude,
    required double longitude,
    required String label,
    required DateTime detectedAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _gpsLocationKey,
      jsonEncode({
        'lat': latitude,
        'lon': longitude,
        'label': label,
        'at': detectedAt.millisecondsSinceEpoch,
      }),
    );
  }

  static Future<void> clearGpsLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gpsLocationKey);
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

  // --- Manually selected worldwide place (coordinates + time zone) ---
  static const String _manualPlaceKey = 'deen_manual_place_v1';
  static const String _onboardedKey = 'deen_onboarded_v1';

  static Future<Map<String, dynamic>?> getManualPlace() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_manualPlaceKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> setManualPlace({
    required double latitude,
    required double longitude,
    required String label,
    String? timezone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _manualPlaceKey,
      jsonEncode({'lat': latitude, 'lon': longitude, 'label': label, 'tz': timezone}),
    );
  }

  static Future<void> clearManualPlace() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_manualPlaceKey);
  }

  static Future<bool> getOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardedKey) ?? false;
  }

  static Future<void> setOnboarded(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardedKey, value);
  }

  // --- Notification preferences (master / Friday / weekly fasting) ---
  static Future<bool> getNotifPref(String key, {bool defaultValue = true}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('deen_notif_$key') ?? defaultValue;
  }

  static Future<void> setNotifPref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('deen_notif_$key', value);
  }
}
