import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:deen_islam/core/services/reminder_service.dart';
import 'package:deen_islam/core/services/storage_service.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('default Adhan choice is 1 and persists', () async {
    expect(await StorageService.getAdhanChoice(), 1);
    await StorageService.setAdhanChoice(3);
    expect(await StorageService.getAdhanChoice(), 3);
  });

  test('out-of-range choices are ignored', () async {
    await StorageService.setAdhanChoice(2);
    await StorageService.setAdhanChoice(0);
    await StorageService.setAdhanChoice(StorageService.adhanCount + 1);
    expect(await StorageService.getAdhanChoice(), 2);
  });

  test('channel ids and raw names are unique per Adhan', () {
    final ids = {for (var i = 1; i <= StorageService.adhanCount; i++) ReminderService.adhanChannelId(i)};
    final raws = {for (var i = 1; i <= StorageService.adhanCount; i++) ReminderService.adhanRawName(i)};
    expect(ids.length, StorageService.adhanCount);
    expect(raws, {'adhan_1', 'adhan_2', 'adhan_3'});
  });
}
