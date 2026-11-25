import 'dart:math' as math;
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

  static double _dtr(double deg) => deg * math.pi / 180.0;
  static double _rtd(double rad) => rad * 180.0 / math.pi;

  static double _fixAngle(double a) {
    final res = a - 360.0 * (a / 360.0).floor();
    return res < 0 ? res + 360.0 : res;
  }

  static double _fixHour(double a) {
    final res = a - 24.0 * (a / 24.0).floor();
    return res < 0 ? res + 24.0 : res;
  }

  static double _julianDate(int year, int month, int day) {
    int y = year;
    int m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + day + b - 1524.5;
  }

  static ({double decl, double eqt}) _sunPosition(double jd) {
    final d = jd - 2451545.0;
    final g = _fixAngle(357.529 + 0.98560028 * d);
    final q = _fixAngle(280.459 + 0.98564736 * d);
    final l = _fixAngle(q + 1.915 * math.sin(_dtr(g)) + 0.020 * math.sin(_dtr(2 * g)));
    final e = 23.439 - 0.00000036 * d;
    final ra = _rtd(math.atan2(math.cos(_dtr(e)) * math.sin(_dtr(l)), math.cos(_dtr(l)))) / 15.0;
    final eqt = q / 15.0 - _fixHour(ra);
    final decl = _rtd(math.asin(math.sin(_dtr(e)) * math.sin(_dtr(l))));
    return (decl: decl, eqt: eqt);
  }

  static double _midDay(double jdBase, double timeHours) {
    final pos = _sunPosition(jdBase + timeHours / 24.0);
    return _fixHour(12.0 - pos.eqt);
  }

  static double _sunAngleTime(double jdBase, double lat, double angle, double timeHours, {required bool ccw}) {
    final pos = _sunPosition(jdBase + timeHours / 24.0);
    final noon = _midDay(jdBase, timeHours);
    final numerator = -math.sin(_dtr(angle)) - math.sin(_dtr(pos.decl)) * math.sin(_dtr(lat));
    final denominator = math.cos(_dtr(pos.decl)) * math.cos(_dtr(lat));
    final cosHa = (numerator / denominator).clamp(-1.0, 1.0);
    final ha = _rtd(math.acos(cosHa)) / 15.0;
    return noon + (ccw ? -ha : ha);
  }

  static double _asrTime(double jdBase, double lat, double factor, double timeHours) {
    final pos = _sunPosition(jdBase + timeHours / 24.0);
    final altRad = math.atan(1.0 / (factor + math.tan(_dtr((lat - pos.decl).abs()))));
    final noon = _midDay(jdBase, timeHours);
    final numerator = math.sin(altRad) - math.sin(_dtr(pos.decl)) * math.sin(_dtr(lat));
    final denominator = math.cos(_dtr(pos.decl)) * math.cos(_dtr(lat));
    final cosHa = (numerator / denominator).clamp(-1.0, 1.0);
    final ha = _rtd(math.acos(cosHa)) / 15.0;
    return noon + ha;
  }

  static TimeOfDay _hoursToTimeOfDay(double rawHours, double tz, double lng, int offsetMinutes) {
    final localHours = _fixHour(rawHours + tz - lng / 15.0);
    final totalMins = (localHours * 60.0 + offsetMinutes).round() % (24 * 60);
    final normalized = totalMins < 0 ? totalMins + 24 * 60 : totalMins;
    return TimeOfDay(
      hour: normalized ~/ 60,
      minute: normalized % 60,
    );
  }

  /// Calculate seasonal astronomical prayer times (Karachi 18°/18°, Hanafi Asr)
  /// for Dhaka coordinates (23.8103° N, 90.4125° E) adjusted across all 64 districts.
  factory PrayerTimesModel.forCity(DateTime date, String city) {
    const double dhakaLat = 23.8103;
    const double dhakaLng = 90.4125;
    const double bdTz = 6.0;
    final offset = allDistrictOffsets[city] ?? 0;

    final jdBase = _julianDate(date.year, date.month, date.day) - dhakaLng / 360.0;

    // Two-pass iterative solar refinement
    double fajrH = _sunAngleTime(jdBase, dhakaLat, 18.0, 5.0, ccw: true);
    double sunriseH = _sunAngleTime(jdBase, dhakaLat, 0.833, 6.0, ccw: true);
    double dhuhrH = _midDay(jdBase, 12.0);
    double asrH = _asrTime(jdBase, dhakaLat, 2.0, 15.0);
    double maghribH = _sunAngleTime(jdBase, dhakaLat, 0.833, 18.0, ccw: false);
    double ishaH = _sunAngleTime(jdBase, dhakaLat, 18.0, 19.0, ccw: false);

    fajrH = _sunAngleTime(jdBase, dhakaLat, 18.0, fajrH, ccw: true);
    sunriseH = _sunAngleTime(jdBase, dhakaLat, 0.833, sunriseH, ccw: true);
    dhuhrH = _midDay(jdBase, dhuhrH);
    asrH = _asrTime(jdBase, dhakaLat, 2.0, asrH);
    maghribH = _sunAngleTime(jdBase, dhakaLat, 0.833, maghribH, ccw: false);
    ishaH = _sunAngleTime(jdBase, dhakaLat, 18.0, ishaH, ccw: false);

    final fajrTime = _hoursToTimeOfDay(fajrH, bdTz, dhakaLng, offset);
    final imsakTime = _shiftTime(fajrTime, -10);

    return PrayerTimesModel(
      date: date,
      fajr: fajrTime,
      sunrise: _hoursToTimeOfDay(sunriseH, bdTz, dhakaLng, offset),
      dhuhr: _hoursToTimeOfDay(dhuhrH, bdTz, dhakaLng, offset + 1),
      asr: _hoursToTimeOfDay(asrH, bdTz, dhakaLng, offset),
      maghrib: _hoursToTimeOfDay(maghribH, bdTz, dhakaLng, offset),
      isha: _hoursToTimeOfDay(ishaH, bdTz, dhakaLng, offset),
      imsak: imsakTime,
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
