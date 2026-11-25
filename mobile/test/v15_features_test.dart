import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deen_islam/core/services/notification_service.dart';
import 'package:deen_islam/core/services/storage_service.dart';
import 'package:deen_islam/data/models/prayer_times_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('StorageService exports and imports full v2 JSON backup cleanly', () async {
    await StorageService.setSelectedCity('চট্টগ্রাম');
    await StorageService.setHijriOffset(1);
    await StorageService.setArabicFontSize(28.0);
    await StorageService.setBengaliFontSize(17.5);
    await StorageService.setQuranReciter('ar.abdurrahmaansudais');
    await StorageService.toggleCompletedSurah(114);
    await StorageService.toggleBookmark(
      const BookmarkItem(
        key: 'surah_1_1',
        type: 'ayah',
        categoryTitle: 'আল-কুরআন',
        title: 'আল-ফাতিহা ১:১',
        arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        bengali: 'পরম করুণাময় অতি দয়ালু আল্লাহর নামে',
        reference: 'সূরা আল-ফাতিহা',
        timestamp: 1700000000000,
      ),
    );

    final exportedJson = await StorageService.exportFullBackupJson();
    final decoded = jsonDecode(exportedJson) as Map<String, dynamic>;
    expect(decoded['app'], 'DeenIslam');
    expect(decoded['version'], 2);
    expect(decoded['selectedCity'], 'চট্টগ্রাম');
    expect((decoded['bookmarks'] as List).length, 1);

    // Clear prefs and restore
    SharedPreferences.setMockInitialValues({});
    final restoredBookmarks = await StorageService.importFullBackupJson(exportedJson);
    expect(restoredBookmarks, 1);
    expect(await StorageService.getSelectedCity(), 'চট্টগ্রাম');
    expect(await StorageService.getHijriOffset(), 1);
    expect(await StorageService.getArabicFontSize(), 28.0);
    expect(await StorageService.getBengaliFontSize(), 17.5);
    expect(await StorageService.getQuranReciter(), 'ar.abdurrahmaansudais');
    expect((await StorageService.getCompletedSurahs()).contains(114), true);
  });

  test('NotificationService handles test environments without platform channels safely', () async {
    final testOk = await NotificationService.instance.showTestNotification();
    expect(testOk, false);

    final times = PrayerTimesModel.forCity(DateTime(2026, 11, 25), 'ঢাকা');
    await NotificationService.instance.syncPrayerScheduleAndWidget(
      prayerTimes: times,
      city: 'ঢাকা',
      alarms: {'ফজর': true, 'যোহর': true},
      preMinutes: 15,
      hijriOffset: 0,
    );
  });
}
