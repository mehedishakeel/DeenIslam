import 'package:flutter/services.dart';
import '../../data/models/prayer_times_model.dart';
import '../../data/repositories/islamic_calendar_data.dart';

/// Native Android bridge for scheduled prayer notifications (AlarmManager)
/// and updating the DeenIslam Home Screen prayer widget.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const MethodChannel _channel =
      MethodChannel('com.mehedishakeel.deenislam/notifications');

  Future<bool> showTestNotification() async {
    try {
      final ok = await _channel.invokeMethod<bool>('showTestNotification');
      return ok ?? false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> cancelAllPrayerAlarms() async {
    try {
      await _channel.invokeMethod('cancelPrayerAlarms', {
        'ids': [1001, 1002, 1003, 1004, 1005, 1006, 2001, 2002, 2003, 2004, 2005, 2006],
      });
    } on MissingPluginException {
      // Safe no-op in tests or unsupported platforms
    } catch (_) {}
  }

  Future<void> syncPrayerScheduleAndWidget({
    required PrayerTimesModel prayerTimes,
    required String city,
    required Map<String, bool> alarms,
    required int preMinutes,
    required int hijriOffset,
  }) async {
    final now = DateTime.now();
    final status = prayerTimes.getUpcomingStatus(now);
    final hijri = IslamicCalendarData.gregorianToHijri(now, hijriOffset);

    try {
      await _channel.invokeMethod('updateHomeWidget', {
        'city': city,
        'nextWaqt': status.nextName,
        'nextTime': status.nextTimeFormatted,
        'hijri': '${hijri.dayBn} ${hijri.monthNameBn}, ${hijri.yearBn}',
      });
    } on MissingPluginException {
      return;
    } catch (_) {}

    await cancelAllPrayerAlarms();

    final scheduleTargets = <Map<String, dynamic>>[
      {
        'id': 1001,
        'preId': 2001,
        'key': 'সেহরি শেষ (ইমসাক)',
        'title': 'সেহরি শেষ ও ফজর প্রস্তুতি ($city)',
        'body': 'আজকের ফজর/সেহরির সময় হয়ে গেছে। নিয়ত করে নিন।',
        'dt': prayerTimes.toDateTime(prayerTimes.imsak),
      },
      {
        'id': 1002,
        'preId': 2002,
        'key': 'ফজর',
        'title': 'ফজরের সালাতের সময় হয়েছে ($city)',
        'body': 'আস-সালাতু খাইরুম মিনান নাওম — ফজরের নামাজ আদায় করুন।',
        'dt': prayerTimes.toDateTime(prayerTimes.fajr),
      },
      {
        'id': 1003,
        'preId': 2003,
        'key': 'যোহর',
        'title': 'যোহরের সালাতের সময় হয়েছে ($city)',
        'body': 'হাইয়্যা আলাস সালাহ — যোহরের নামাজের প্রস্তুতি নিন।',
        'dt': prayerTimes.toDateTime(prayerTimes.dhuhr),
      },
      {
        'id': 1004,
        'preId': 2004,
        'key': 'আসর',
        'title': 'আসরের সালাতের সময় হয়েছে ($city)',
        'body': 'সালাতুল উসতা বা আসরের নামাজের সময় হয়েছে।',
        'dt': prayerTimes.toDateTime(prayerTimes.asr),
      },
      {
        'id': 1005,
        'preId': 2005,
        'key': 'মাগরিব (ইফতার)',
        'title': 'মাগরিব ও ইফতারের সময় হয়েছে ($city)',
        'body': 'আল্লাহুম্মা ইন্নি লাকা সুমতু — ইফতার ও মাগরিবের নামাজ আদায় করুন।',
        'dt': prayerTimes.toDateTime(prayerTimes.maghrib),
      },
      {
        'id': 1006,
        'preId': 2006,
        'key': 'ইশা',
        'title': 'ইশার সালাতের সময় হয়েছে ($city)',
        'body': 'হাইয়্যা আলাস সালাহ — ইশার সালাত ও বিতর আদায় করুন।',
        'dt': prayerTimes.toDateTime(prayerTimes.isha),
      },
    ];

    for (final item in scheduleTargets) {
      final key = item['key'] as String;
      if (alarms[key] != true) continue;

      DateTime triggerDt = item['dt'] as DateTime;
      if (triggerDt.isBefore(now)) {
        triggerDt = triggerDt.add(const Duration(days: 1));
      }

      try {
        await _channel.invokeMethod('schedulePrayerAlarm', {
          'id': item['id'],
          'triggerAtMillis': triggerDt.millisecondsSinceEpoch,
          'title': item['title'],
          'body': item['body'],
        });

        if (preMinutes > 0) {
          final preDt = triggerDt.subtract(Duration(minutes: preMinutes));
          if (preDt.isAfter(now)) {
            await _channel.invokeMethod('schedulePrayerAlarm', {
              'id': item['preId'],
              'triggerAtMillis': preDt.millisecondsSinceEpoch,
              'title': '$key-এর $preMinutes মিনিট বাকি ($city)',
              'body': 'অল্প কিছুক্ষণের মধ্যেই $key ওয়াক্ত শুরু হবে। অযু করে প্রস্তুত হোন।',
            });
          }
        }
      } on MissingPluginException {
        return;
      } catch (_) {}
    }
  }
}
