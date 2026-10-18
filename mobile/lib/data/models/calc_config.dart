import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:flutter/foundation.dart';

/// Prayer-time calculation methods offered by the `adhan_dart` library.
/// Only methods the library genuinely provides are listed.
enum CalcMethod {
  karachi,
  muslimWorldLeague,
  egyptian,
  ummAlQura,
  dubai,
  qatar,
  kuwait,
  singapore,
  northAmerica,
  moonsighting,
  turkiye,
}

/// The user's calculation settings: method (Fajr/Isha convention) and the
/// juristic Asr rule. This is the single configuration every prayer-time
/// consumer reads, so screens, countdown and alarms can never disagree.
///
/// The default (Karachi + Hanafi Asr) is the long-standing default of this app
/// and is never changed without the user choosing something else.
@immutable
class CalcConfig {
  final CalcMethod method;
  final bool hanafiAsr;

  const CalcConfig({required this.method, required this.hanafiAsr});

  static const CalcConfig defaults =
      CalcConfig(method: CalcMethod.karachi, hanafiAsr: true);

  /// Active configuration (loaded from storage at start-up).
  static CalcConfig current = defaults;

  /// Bumped whenever [current] changes so open screens can recompute.
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

  static void apply(CalcConfig config) {
    if (config == current) return;
    current = config;
    revision.value++;
  }

  static CalcMethod methodFromName(String? name) => CalcMethod.values.firstWhere(
        (m) => m.name == name,
        orElse: () => defaults.method,
      );

  /// Parameters for the library. Above ~48 degrees latitude the twilight
  /// angles may never be reached in summer, so the twilight-angle rule is used.
  adhan.CalculationParameters parameters(double latitude) {
    final adhan.CalculationParameters p;
    switch (method) {
      case CalcMethod.karachi:
        p = adhan.CalculationMethodParameters.karachi();
      case CalcMethod.muslimWorldLeague:
        p = adhan.CalculationMethodParameters.muslimWorldLeague();
      case CalcMethod.egyptian:
        p = adhan.CalculationMethodParameters.egyptian();
      case CalcMethod.ummAlQura:
        p = adhan.CalculationMethodParameters.ummAlQura();
      case CalcMethod.dubai:
        p = adhan.CalculationMethodParameters.dubai();
      case CalcMethod.qatar:
        p = adhan.CalculationMethodParameters.qatar();
      case CalcMethod.kuwait:
        p = adhan.CalculationMethodParameters.kuwait();
      case CalcMethod.singapore:
        p = adhan.CalculationMethodParameters.singapore();
      case CalcMethod.northAmerica:
        p = adhan.CalculationMethodParameters.northAmerica();
      case CalcMethod.moonsighting:
        p = adhan.CalculationMethodParameters.moonsightingCommittee();
      case CalcMethod.turkiye:
        p = adhan.CalculationMethodParameters.turkiye();
    }
    p.madhab = hanafiAsr ? adhan.Madhab.hanafi : adhan.Madhab.shafi;
    if (latitude.abs() > 48) {
      p.highLatitudeRule = adhan.HighLatitudeRule.twilightAngle;
    }
    return p;
  }

  static String methodName(CalcMethod m) {
    switch (m) {
      case CalcMethod.karachi:
        return 'করাচি (ইসলামিক সায়েন্সেস বিশ্ববিদ্যালয়)';
      case CalcMethod.muslimWorldLeague:
        return 'মুসলিম ওয়ার্ল্ড লীগ';
      case CalcMethod.egyptian:
        return 'মিশরীয় জেনারেল অথরিটি অব সার্ভে';
      case CalcMethod.ummAlQura:
        return 'উম্মুল কুরা (মক্কা)';
      case CalcMethod.dubai:
        return 'দুবাই';
      case CalcMethod.qatar:
        return 'কাতার';
      case CalcMethod.kuwait:
        return 'কুয়েত';
      case CalcMethod.singapore:
        return 'সিঙ্গাপুর (MUIS)';
      case CalcMethod.northAmerica:
        return 'উত্তর আমেরিকা (ISNA)';
      case CalcMethod.moonsighting:
        return 'মুনসাইটিং কমিটি';
      case CalcMethod.turkiye:
        return 'তুরস্ক (দিয়ানেত)';
    }
  }

  static String methodDetail(CalcMethod m) {
    switch (m) {
      case CalcMethod.karachi:
        return 'ফজর ১৮°, ইশা ১৮° — বাংলাদেশ, ভারত, পাকিস্তানে প্রচলিত';
      case CalcMethod.muslimWorldLeague:
        return 'ফজর ১৮°, ইশা ১৭° — ইউরোপ, দূরপ্রাচ্য ও আমেরিকার কিছু অংশে প্রচলিত';
      case CalcMethod.egyptian:
        return 'ফজর ১৯.৫°, ইশা ১৭.৫° — আফ্রিকা, সিরিয়া, লেবানন ও মালয়েশিয়ায় প্রচলিত';
      case CalcMethod.ummAlQura:
        return 'ফজর ১৮.৫°, ইশা মাগরিবের ৯০ মিনিট পর — আরব উপদ্বীপ';
      case CalcMethod.dubai:
        return 'ফজর ১৮.২°, ইশা ১৮.২° — সংযুক্ত আরব আমিরাত';
      case CalcMethod.qatar:
        return 'ফজর ১৮°, ইশা মাগরিবের ৯০ মিনিট পর';
      case CalcMethod.kuwait:
        return 'ফজর ১৮°, ইশা ১৭.৫°';
      case CalcMethod.singapore:
        return 'ফজর ২০°, ইশা ১৮° — সিঙ্গাপুর, মালয়েশিয়া, ইন্দোনেশিয়া অঞ্চল';
      case CalcMethod.northAmerica:
        return 'ফজর ১৫°, ইশা ১৫° — উত্তর আমেরিকায় প্রচলিত';
      case CalcMethod.moonsighting:
        return 'মুনসাইটিং কমিটি ওয়ার্ল্ডওয়াইডের পদ্ধতি (মৌসুম ও অক্ষাংশভিত্তিক সংশোধন সহ)';
      case CalcMethod.turkiye:
        return 'ফজর ১৮°, ইশা ১৭° — তুরস্কের ধর্মবিষয়ক অধিদপ্তর';
    }
  }

  /// One-line description shown next to the schedule.
  String get label =>
      '${methodName(method)}, ${hanafiAsr ? 'হানাফি' : 'শাফেয়ী/জমহুর'} আসর';

  CalcConfig copyWith({CalcMethod? method, bool? hanafiAsr}) =>
      CalcConfig(method: method ?? this.method, hanafiAsr: hanafiAsr ?? this.hanafiAsr);

  @override
  bool operator ==(Object other) =>
      other is CalcConfig && other.method == method && other.hanafiAsr == hanafiAsr;

  @override
  int get hashCode => Object.hash(method, hanafiAsr);
}
