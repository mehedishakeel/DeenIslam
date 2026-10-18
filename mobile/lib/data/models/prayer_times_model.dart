import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:flutter/material.dart';
import '../../core/services/prayer_service.dart';
import '../../core/services/timezone_service.dart';
import '../../core/utils/bengali_numerals.dart';
import 'app_location.dart';
import 'district_coordinates.dart';
import 'calc_config.dart';

class PrayerTimesModel {
  final DateTime date;
  final TimeOfDay fajr;
  final TimeOfDay sunrise;
  final TimeOfDay dhuhr;
  final TimeOfDay asr;
  final TimeOfDay maghrib;
  final TimeOfDay isha;
  final TimeOfDay imsak;

  /// UTC offset of the place the times were calculated for, or null when the
  /// device time zone applies. Times above are wall-clock at that place.
  final Duration? utcOffset;

  const PrayerTimesModel({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    this.utcOffset,
  });

  /// Default schedule (Dhaka) used only until a location has been loaded.
  factory PrayerTimesModel.defaultDhaka(DateTime date) {
    return PrayerTimesModel.forCity(date, 'ঢাকা');
  }

  /// All selectable districts (manual location fallback).
  static List<String> get allDistricts => districtCoordinates.keys.toList();

  /// Prayer times for a manually selected district, calculated astronomically
  /// from the district's coordinates.
  factory PrayerTimesModel.forCity(DateTime date, String city) {
    final c = districtCoordinates[city] ?? districtCoordinates['ঢাকা']!;
    return PrayerTimesModel.forCoordinates(date, c[0], c[1]);
  }

  /// Calendar day at [location] right now (differs from the device day when a
  /// place in another time zone was chosen).
  static DateTime placeToday(DateTime now, AppLocation location) {
    final off = TimeZoneService.offsetFor(location.timezone, now);
    if (off == null) return DateTime(now.year, now.month, now.day);
    final u = now.toUtc().add(off);
    return DateTime(u.year, u.month, u.day);
  }

  /// Prayer times for the app's current location (GPS or manual).
  factory PrayerTimesModel.forLocation(DateTime date, AppLocation location) {
    return PrayerTimesModel.forCoordinates(
      date,
      location.latitude,
      location.longitude,
      utcOffset: TimeZoneService.offsetFor(location.timezone, date),
    );
  }

  /// Real astronomical calculation (solar position, Fajr/Isha twilight angles,
  /// Asr shadow length) using the maintained `adhan_dart` library.
  ///
  /// Method and Asr rule come from [CalcConfig.current] unless [config] is
  /// given (default: Karachi, Fajr/Isha 18 deg, with the Hanafi Asr rule).
  /// Results are converted to the device's local time zone, or to
  /// [utcOffset] when given (used by tests for reproducibility).
  /// Throws [ArgumentError] for invalid coordinates; never invents a schedule.
  factory PrayerTimesModel.forCoordinates(
    DateTime date,
    double latitude,
    double longitude, {
    Duration? utcOffset,
    CalcConfig? config,
  }) {
    if (!PrayerService.isValidCoordinate(latitude, longitude)) {
      throw ArgumentError('Invalid coordinates: $latitude, $longitude');
    }
    // The user's chosen method and Asr rule (default Karachi + Hanafi).
    final params = (config ?? CalcConfig.current).parameters(latitude);

    final times = adhan.PrayerTimes(
      coordinates: adhan.Coordinates(latitude, longitude),
      date: DateTime.utc(date.year, date.month, date.day),
      calculationParameters: params,
      precision: true,
    );

    DateTime toLocalTime(DateTime utc) {
      final u = utc.toUtc();
      return utcOffset != null ? u.add(utcOffset) : u.toLocal();
    }

    // Round to the nearest minute.
    TimeOfDay tod(DateTime utc) {
      final l = toLocalTime(utc).add(const Duration(seconds: 30));
      return TimeOfDay(hour: l.hour, minute: l.minute);
    }

    return PrayerTimesModel(
      date: DateTime(date.year, date.month, date.day),
      fajr: tod(times.fajr),
      sunrise: tod(times.sunrise),
      dhuhr: tod(times.dhuhr),
      asr: tod(times.asr),
      maghrib: tod(times.maghrib),
      isha: tod(times.isha),
      imsak: tod(times.fajr.subtract(const Duration(minutes: 10))),
      utcOffset: utcOffset,
    );
  }

  /// Whether this schedule belongs to the same calendar day as [other].
  bool isSameDay(DateTime other) =>
      date.year == other.year &&
      date.month == other.month &&
      date.day == other.day;

  /// The current moment expressed as wall-clock time at the schedule's place.
  /// Use this (not the raw device time) with [getUpcomingStatus] and
  /// [isSameDay] so a city in another time zone counts down correctly.
  DateTime wallNow(DateTime now) {
    final off = utcOffset;
    if (off == null) return now;
    final u = now.toUtc().add(off);
    return DateTime(u.year, u.month, u.day, u.hour, u.minute, u.second);
  }

  /// The absolute instant of [time] on this schedule's day (for alarms).
  DateTime instant(TimeOfDay time) {
    final off = utcOffset;
    if (off == null) return toDateTime(time);
    return DateTime.utc(date.year, date.month, date.day, time.hour, time.minute)
        .subtract(off);
  }

  DateTime toDateTime(TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${BengaliNumerals.padZero(hour)}:${BengaliNumerals.padZero(time.minute)} $period';
  }

  /// Determine the current and next prayer with duration
  PrayerStatus getUpcomingStatus(DateTime now) {
    final fajrDt = toDateTime(fajr);
    final sunriseDt = toDateTime(sunrise);
    final dhuhrDt = toDateTime(dhuhr);
    final asrDt = toDateTime(asr);
    final maghribDt = toDateTime(maghrib);
    final ishaDt = toDateTime(isha);
    final nextFajrDt = fajrDt.add(const Duration(days: 1));

    if (now.isBefore(fajrDt)) {
      return PrayerStatus(
        currentName: "তাহাজ্জুদ / সেহরি",
        nextName: "ফজর",
        nextTimeFormatted: formatTime(fajr),
        remaining: fajrDt.difference(now),
        icon: Icons.nightlight_round,
      );
    } else if (now.isBefore(sunriseDt)) {
      return PrayerStatus(
        currentName: "ফজর",
        nextName: "সূর্যোদয় (ইশরাক)",
        nextTimeFormatted: formatTime(sunrise),
        remaining: sunriseDt.difference(now),
        icon: Icons.wb_twilight,
      );
    } else if (now.isBefore(dhuhrDt)) {
      return PrayerStatus(
        currentName: "চাশত / দুহা",
        nextName: "যোহর",
        nextTimeFormatted: formatTime(dhuhr),
        remaining: dhuhrDt.difference(now),
        icon: Icons.wb_sunny_outlined,
      );
    } else if (now.isBefore(asrDt)) {
      return PrayerStatus(
        currentName: "যোহর",
        nextName: "আসর",
        nextTimeFormatted: formatTime(asr),
        remaining: asrDt.difference(now),
        icon: Icons.wb_sunny,
      );
    } else if (now.isBefore(maghribDt)) {
      return PrayerStatus(
        currentName: "আসর",
        nextName: "মাগরিব (ইফতার)",
        nextTimeFormatted: formatTime(maghrib),
        remaining: maghribDt.difference(now),
        icon: Icons.wb_twilight,
      );
    } else if (now.isBefore(ishaDt)) {
      return PrayerStatus(
        currentName: "মাগরিব",
        nextName: "ইশা",
        nextTimeFormatted: formatTime(isha),
        remaining: ishaDt.difference(now),
        icon: Icons.nightlight,
      );
    } else {
      return PrayerStatus(
        currentName: "ইশা",
        nextName: "ফজর",
        nextTimeFormatted: formatTime(fajr),
        remaining: nextFajrDt.difference(now),
        icon: Icons.bedtime,
      );
    }
  }

  /// Fasting Calculation (Sehri vs Iftar countdown)
  FastingStatus getFastingStatus(DateTime now) {
    final fajrDt = toDateTime(fajr);
    final maghribDt = toDateTime(maghrib);
    final nextFajrDt = fajrDt.add(const Duration(days: 1));

    if (now.isAfter(fajrDt) && now.isBefore(maghribDt)) {
      // Roza active: countdown to Iftar
      final totalSecs = maghribDt.difference(fajrDt).inSeconds;
      final elapsedSecs = now.difference(fajrDt).inSeconds;
      final progress = (elapsedSecs / totalSecs).clamp(0.0, 1.0);
      return FastingStatus(
        isIftar: true,
        title: "ইফতারের বাকি",
        info: "আজকের ইফতার: ${formatTime(maghrib)}",
        remaining: maghribDt.difference(now),
        progress: progress,
      );
    } else {
      // Non-fasting period: countdown to Sehri end (Fajr)
      final target = now.isBefore(fajrDt) ? fajrDt : nextFajrDt;
      final prevMaghrib = now.isBefore(fajrDt) ? maghribDt.subtract(const Duration(days: 1)) : maghribDt;
      final totalSecs = target.difference(prevMaghrib).inSeconds;
      final elapsedSecs = now.difference(prevMaghrib).inSeconds;
      final progress = (elapsedSecs / totalSecs).clamp(0.0, 1.0);
      return FastingStatus(
        isIftar: false,
        title: "সেহরির বাকি",
        info: "সেহরি শেষ (ফজর): ${formatTime(fajr)}",
        remaining: target.difference(now),
        progress: progress,
      );
    }
  }
}

class PrayerStatus {
  final String currentName;
  final String nextName;
  final String nextTimeFormatted;
  final Duration remaining;
  final IconData icon;

  const PrayerStatus({
    required this.currentName,
    required this.nextName,
    required this.nextTimeFormatted,
    required this.remaining,
    required this.icon,
  });
}

class FastingStatus {
  final bool isIftar;
  final String title;
  final String info;
  final Duration remaining;
  final double progress;

  const FastingStatus({
    required this.isIftar,
    required this.title,
    required this.info,
    required this.remaining,
    required this.progress,
  });
}
