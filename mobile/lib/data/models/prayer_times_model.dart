import 'package:flutter/material.dart';
import '../../core/utils/bengali_numerals.dart';

class PrayerTimesModel {
  final DateTime date;
  final TimeOfDay fajr;
  final TimeOfDay sunrise;
  final TimeOfDay dhuhr;
  final TimeOfDay asr;
  final TimeOfDay maghrib;
  final TimeOfDay isha;
  final TimeOfDay imsak;

  const PrayerTimesModel({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.imsak,
  });

  /// Factory preset for Dhaka, Bangladesh
  factory PrayerTimesModel.defaultDhaka(DateTime date) {
    return PrayerTimesModel.forCity(date, 'ঢাকা');
  }

  static TimeOfDay _shiftTime(TimeOfDay base, int offsetMinutes) {
    final totalMinutes = (base.hour * 60 + base.minute + offsetMinutes) % (24 * 60);
    return TimeOfDay(
      hour: totalMinutes ~/ 60,
      minute: totalMinutes % 60,
    );
  }

  /// Minute offsets for all 64 districts of Bangladesh relative to Dhaka
  static const Map<String, int> allDistrictOffsets = <String, int>{
    // ঢাকা বিভাগ (13)
    'ঢাকা': 0,
    'গাজীপুর': 0,
    'নারায়ণগঞ্জ': -1,
    'নরসিংদী': -2,
    'মানিকগঞ্জ': 2,
    'মুন্সীগঞ্জ': 0,
    'টাঙ্গাইল': 2,
    'কিশোরগঞ্জ': -2,
    'ফরিদপুর': 3,
    'গোপালগঞ্জ': 2,
    'মাদারীপুর': 1,
    'রাজবাড়ী': 4,
    'শরীয়তপুর': 1,
    // চট্টগ্রাম বিভাগ (11)
    'চট্টগ্রাম': -6,
    'কক্সবাজার': -6,
    'কুমিল্লা': -3,
    'ব্রাহ্মণবাড়িয়া': -3,
    'চাঁদপুর': -1,
    'নোয়াখালী': -3,
    'ফেনী': -4,
    'লক্ষ্মীপুর': -2,
    'রাঙ্গামাটি': -7,
    'বান্দরবান': -7,
    'খাগড়াছড়ি': -6,
    // সিলেট বিভাগ (4)
    'সিলেট': -6,
    'মৌলভীবাজার': -6,
    'হবিগঞ্জ': -4,
    'সুনামগঞ্জ': -4,
    // রাজশাহী বিভাগ (8)
    'রাজশাহী': 7,
    'বগুড়া': 4,
    'পাবনা': 5,
    'সিরাজগঞ্জ': 3,
    'নাটোর': 6,
    'নওগাঁ': 6,
    'চাঁপাইনবাবগঞ্জ': 9,
    'জয়পুরহাট': 5,
    // খুলনা বিভাগ (10)
    'খুলনা': 4,
    'যশোর': 5,
    'সাতক্ষীরা': 6,
    'কুষ্টিয়া': 6,
    'ঝিনাইদহ': 5,
    'মাগুরা': 4,
    'নড়াইল': 4,
    'বাগেরহাট': 3,
    'চুয়াডাঙ্গা': 7,
    'মেহেরপুর': 8,
    // বরিশাল বিভাগ (6)
    'বরিশাল': 1,
    'পটুয়াখালী': 1,
    'ভোলা': -1,
    'পিরোজপুর': 2,
    'বরগুনা': 2,
    'ঝালকাঠি': 2,
    // রংপুর বিভাগ (8)
    'রংপুর': 5,
    'দিনাজপুর': 7,
    'কুড়িগ্রাম': 3,
    'গাইবান্ধা': 4,
    'নীলফামারী': 6,
    'পঞ্চগড়': 8,
    'ঠাকুরগাঁও': 8,
    'লালমনিরহাট': 4,
    // ময়মনসিংহ বিভাগ (4)
    'ময়মনসিংহ': -1,
    'জামালপুর': 2,
    'শেরপুর': 1,
    'নেত্রকোনা': -2,
  };

  static List<String> get allDistricts => allDistrictOffsets.keys.toList();

  /// Calculate prayer times for all 64 Bangladesh districts relative to Dhaka
  factory PrayerTimesModel.forCity(DateTime date, String city) {
    final offset = allDistrictOffsets[city] ?? 0;
    return PrayerTimesModel(
      date: date,
      fajr: _shiftTime(const TimeOfDay(hour: 5, minute: 4), offset),
      sunrise: _shiftTime(const TimeOfDay(hour: 6, minute: 18), offset),
      dhuhr: _shiftTime(const TimeOfDay(hour: 11, minute: 56), offset),
      asr: _shiftTime(const TimeOfDay(hour: 15, minute: 52), offset),
      maghrib: _shiftTime(const TimeOfDay(hour: 17, minute: 32), offset),
      isha: _shiftTime(const TimeOfDay(hour: 18, minute: 48), offset),
      imsak: _shiftTime(const TimeOfDay(hour: 4, minute: 54), offset),
    );
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
