import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/app_location.dart';
import '../../data/models/prayer_times_model.dart';
import '../utils/hijri_date.dart';
import 'daily_content.dart';
import 'location_service.dart';
import 'schedule_validator.dart';
import 'storage_service.dart';

enum ReminderStatus {
  scheduled,
  nothingEnabled,
  notificationsDenied,
  failed,
}

class ReminderResult {
  final ReminderStatus status;

  /// Number of notifications actually queued with the OS.
  final int count;

  /// False when Android 12+ exact-alarm permission is missing; reminders are
  /// then delivered inexactly (they can be a few minutes late).
  final bool exact;

  const ReminderResult(this.status, {this.count = 0, this.exact = true});

  bool get ok => status == ReminderStatus.scheduled;
}

/// Local prayer reminders built on the calculated schedule.
///
/// Architecture: one mechanism only - `flutter_local_notifications` scheduled
/// notifications (AlarmManager under the hood, restored after reboot by the
/// plugin's boot receiver). The next [horizonDays] days are scheduled with
/// stable ids and the whole set is replaced on every change, so duplicates
/// cannot accumulate. The app reschedules on start/resume, which also covers
/// date and time-zone changes.
///
/// Sound: when the bundled Adhan files (res/raw/adhan_1..3) are present and the
/// user keeps "full Adhan" on, the prayer-start notification plays the chosen
/// Adhan through its own channel; otherwise the system default sound is used.
/// Pre-reminders always use the default sound.
class ReminderService {
  ReminderService._();
  static final ReminderService instance = ReminderService._();

  static const int horizonDays = 7;
  static const String _channelId = 'prayer_reminders';
  static String adhanChannelId(int choice) => 'prayer_adhan_${choice}_v1';
  static String adhanRawName(int choice) => 'adhan_$choice';
  static String adhanLabel(int choice) => 'আজান $choice';
  static const MethodChannel _native = MethodChannel('com.mehedishakeel.deenislam/audio');
  bool? _adhanAvailable;

  /// Problems found by the schedule validator during the last reschedule
  /// (days whose alarms were skipped). Empty when everything was scheduled.
  List<String> lastDiagnostics = [];

  /// True only when the Adhan files are part of the Android build
  /// (`res/raw/adhan_1.*` ...).
  Future<bool> adhanAvailable() async {
    if (_adhanAvailable != null) return _adhanAvailable!;
    try {
      _adhanAvailable = await _native.invokeMethod<bool>('hasAdhanSound') ?? false;
    } catch (_) {
      _adhanAvailable = false;
    }
    return _adhanAvailable!;
  }

  /// Alarm keys match the waqt names used by the prayer screen.
  static const List<String> waqtKeys = [
    'ফজর',
    'যোহর',
    'আসর',
    'মাগরিব (ইফতার)',
    'ইশা',
  ];
  static const List<String> _shortNames = ['ফজর', 'যোহর', 'আসর', 'মাগরিব', 'ইশা'];

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  Future<void>? _initFuture;

  Future<void> init() {
    return _initFuture ??= _init();
  }

  Future<void> _init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings);
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        'নামাজের ওয়াক্তের রিমাইন্ডার',
        description: 'ওয়াক্ত শুরুর সময় এবং আগে থেকে সতর্কতা',
        importance: Importance.high,
      ),
    );
    if (await adhanAvailable()) {
      // Each channel's sound is played by Android itself when the alarm fires,
      // so it works with the app closed. It follows the phone's volume and
      // silent / Do-Not-Disturb rules. A channel's sound cannot change after
      // creation, hence one channel per Adhan.
      for (var i = 1; i <= StorageService.adhanCount; i++) {
        await android?.createNotificationChannel(
          AndroidNotificationChannel(
            adhanChannelId(i),
            '${adhanLabel(i)} (ওয়াক্ত শুরু)',
            description: 'ওয়াক্ত শুরু হলে আজানের শব্দ',
            importance: Importance.max,
            playSound: true,
            sound: RawResourceAndroidNotificationSound(adhanRawName(i)),
          ),
        );
      }
    }
    _initialized = true;
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  /// Asks for the notification permission (Android 13+). Returns whether
  /// notifications can be shown.
  Future<bool> requestNotificationPermission() async {
    await init();
    final android = _android;
    if (android == null) return false;
    final enabled = await android.areNotificationsEnabled() ?? false;
    if (enabled) return true;
    return await android.requestNotificationsPermission() ?? false;
  }

  Future<bool> notificationsAllowed() async {
    await init();
    return await _android?.areNotificationsEnabled() ?? false;
  }

  /// Whether exact alarms may be used (Android 12+ special access).
  Future<bool> canScheduleExact() async {
    await init();
    return await _android?.canScheduleExactNotifications() ?? false;
  }

  /// Opens the system screen where the user can allow exact alarms.
  Future<void> requestExactAlarmPermission() async {
    await init();
    await _android?.requestExactAlarmsPermission();
  }

  /// Reschedules using the saved location (used by settings screens).
  Future<ReminderResult> rescheduleFromSaved() async =>
      reschedule(await LocationService.load());

  /// Replaces every scheduled reminder using the current location and the
  /// user's per-prayer preferences. Never throws.
  Future<ReminderResult> reschedule(AppLocation location) async {
    try {
      await init();
      await _plugin.cancelAll();

      // Master switch: everything off, nothing pending.
      if (!await StorageService.getNotifPref('master')) {
        return const ReminderResult(ReminderStatus.nothingEnabled);
      }
      final fridayOn = await StorageService.getNotifPref('friday');
      final sawmOn = await StorageService.getNotifPref('weekly_sawm');
      final dailyOn = await StorageService.getNotifPref('daily_ayah', defaultValue: false);
      final bidOn = await StorageService.getNotifPref('ayyam_bid', defaultValue: false);
      final dailyMinutes = await StorageService.getDailyReminderMinutes();
      final hijriAdjust = await StorageService.getHijriAdjust();
      // Same calculation settings as the screens (also when started in background).
      await StorageService.loadCalcConfig();
      lastDiagnostics = [];

      final alarms = await StorageService.getAzanAlarms();
      final preMinutes = await StorageService.getAzanPreReminderMinutes();
      final enabled = <int>[
        for (var i = 0; i < waqtKeys.length; i++)
          if (alarms[waqtKeys[i]] ?? true) i,
      ];
      if (enabled.isEmpty && !fridayOn && !sawmOn && !dailyOn && !bidOn) {
        return const ReminderResult(ReminderStatus.nothingEnabled);
      }
      if (!await notificationsAllowed()) {
        return const ReminderResult(ReminderStatus.notificationsDenied);
      }

      final exact = await canScheduleExact();
      final mode = exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'নামাজের ওয়াক্তের রিমাইন্ডার',
          channelDescription: 'ওয়াক্ত শুরুর সময় এবং আগে থেকে সতর্কতা',
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
        ),
      );
      final useAdhan = await adhanAvailable() && await StorageService.getAdhanSound();
      final adhanChoice = await StorageService.getAdhanChoice();
      final adhanDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          adhanChannelId(adhanChoice),
          '${adhanLabel(adhanChoice)} (ওয়াক্ত শুরু)',
          channelDescription: 'ওয়াক্ত শুরু হলে আজানের শব্দ',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(adhanRawName(adhanChoice)),
        ),
      );

      const generalDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'general_reminders',
          'সাধারণ ইসলামিক রিমাইন্ডার',
          channelDescription: 'জুমা ও সাপ্তাহিক নফল রোজার স্মরণ',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          category: AndroidNotificationCategory.reminder,
        ),
      );

      final now = DateTime.now();
      final today = PrayerTimesModel.placeToday(now, location);
      final deviceToday = DateTime(now.year, now.month, now.day);
      var count = 0;

      for (var d = 0; d < horizonDays; d++) {
        // Weekly reminders use the phone's own calendar and clock.
        final devDay = deviceToday.add(Duration(days: d));
        Future<void> weekly(int kind, int hour, String title, String body) async {
          final at = DateTime(devDay.year, devDay.month, devDay.day, hour);
          if (!at.isAfter(now)) return;
          await _schedule(
            id: 8000 + d * 10 + kind,
            title: title,
            body: body,
            at: at,
            details: generalDetails,
            mode: mode,
          );
          count++;
        }

        if (fridayOn && devDay.weekday == DateTime.friday) {
          await weekly(1, 10, 'আজ জুমার দিন', 'সূরা আল-কাহফ তিলাওয়াত ও জুমার প্রস্তুতির কথা স্মরণ করানো হচ্ছে।');
        }
        if (sawmOn && devDay.weekday == DateTime.sunday) {
          await weekly(2, 20, 'আগামীকাল সোমবার', 'নফল রোজা রাখতে চাইলে সেহরির প্রস্তুতি ও নিয়ত করতে পারেন।');
        }
        if (sawmOn && devDay.weekday == DateTime.wednesday) {
          await weekly(3, 20, 'আগামীকাল বৃহস্পতিবার', 'নফল রোজা রাখতে চাইলে সেহরির প্রস্তুতি ও নিয়ত করতে পারেন।');
        }

        // Daily Ayah / Hadith from the app's bundled content (phone clock).
        if (dailyOn) {
          final content = DailyContentService.forDay(devDay);
          final at = DateTime(devDay.year, devDay.month, devDay.day, dailyMinutes ~/ 60, dailyMinutes % 60);
          if (content != null && at.isAfter(now)) {
            await _schedule(
              id: 8100 + d,
              title: content.title,
              body: content.body,
              at: at,
              details: NotificationDetails(
                android: AndroidNotificationDetails(
                  'daily_ayah_hadith',
                  'দৈনিক আয়াত ও হাদিস',
                  channelDescription: 'প্রতিদিন একটি আয়াত বা হাদিসের স্মরণ',
                  importance: Importance.defaultImportance,
                  priority: Priority.defaultPriority,
                  category: AndroidNotificationCategory.reminder,
                  styleInformation: BigTextStyleInformation(content.body),
                ),
              ),
              mode: mode,
            );
            count++;
          }
        }

        // Ayyam al-Bid: evening before the 13th/14th/15th Hijri day. This is a
        // calendar calculation (+ user adjustment); moon sighting can differ.
        if (bidOn) {
          final h = HijriDate.fromGregorian(devDay, adjustDays: hijriAdjust);
          if (h.day >= 12 && h.day <= 14) {
            final at = DateTime(devDay.year, devDay.month, devDay.day, 20);
            if (at.isAfter(now)) {
              await _schedule(
                id: 8300 + d * 10 + (h.day - 12),
                title: 'আগামীকাল আইয়ামে বীযের রোজা',
                body: 'আগামীকাল হিজরি ${h.day + 1} তারিখ (${h.monthNameBn})। নফল রোজা রাখতে চাইলে নিয়ত ও সেহরির প্রস্তুতি নিন। চাঁদ দেখার ওপর নির্ভর করে তারিখ ১ দিন এদিক-ওদিক হতে পারে।',
                at: at,
                details: generalDetails,
                mode: mode,
              );
              count++;
            }
          }
        }

        final day = today.add(Duration(days: d));
        final model = PrayerTimesModel.forLocation(day, location);
        final check = ScheduleValidator.validate(model);
        if (!check.ok) {
          lastDiagnostics.add('${day.year}-${day.month}-${day.day}: ${check.errors.join(', ')}');
          continue; // never schedule alarms from a questionable schedule
        }
        final times = [model.fajr, model.dhuhr, model.asr, model.maghrib, model.isha];

        for (final p in enabled) {
          if (p == 4 && check.ishaPastMidnight) {
            lastDiagnostics.add('${day.year}-${day.month}-${day.day}: ইশা মধ্যরাতের পরে, অ্যালার্ম বসানো হয়নি');
            continue;
          }
          final at = model.instant(times[p]);

          if (at.isAfter(now)) {
            await _schedule(
              id: notificationId(d, p, false),
              title: '${_shortNames[p]}-এর ওয়াক্ত হয়েছে',
              body: '${model.formatTime(times[p])} • ${location.label}',
              at: at,
              details: useAdhan ? adhanDetails : details,
              mode: mode,
            );
            count++;
          }

          final pre = at.subtract(Duration(minutes: preMinutes));
          if (preMinutes > 0 && pre.isAfter(now)) {
            await _schedule(
              id: notificationId(d, p, true),
              title: '${_shortNames[p]}-এর ওয়াক্ত ঘনিয়ে আসছে',
              body: 'আর $preMinutes মিনিট পর • ${model.formatTime(times[p])}',
              at: pre,
              details: details,
              mode: mode,
            );
            count++;
          }
        }
      }

      return ReminderResult(ReminderStatus.scheduled, count: count, exact: exact);
    } catch (e) {
      debugPrint('ReminderService.reschedule failed: $e');
      return const ReminderResult(ReminderStatus.failed);
    }
  }

  /// Stable id: day offset, prayer index and kind (main / pre-reminder).
  @visibleForTesting
  static int notificationId(int dayOffset, int prayerIndex, bool isPre) =>
      1000 + dayOffset * 100 + prayerIndex * 10 + (isPre ? 1 : 0);

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required NotificationDetails details,
    required AndroidScheduleMode mode,
  }) {
    return _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(at, tz.UTC),
      details,
      androidScheduleMode: mode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
