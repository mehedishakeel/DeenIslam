import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../data/models/app_location.dart';
import '../../data/models/district_coordinates.dart';
import 'prayer_service.dart';
import 'storage_service.dart';

enum LocationStatus {
  success,
  denied,
  deniedForever,
  serviceDisabled,
  timeout,
  invalid,
  error,
}

class LocationResult {
  final LocationStatus status;
  final AppLocation? location;

  const LocationResult(this.status, [this.location]);

  bool get isSuccess => status == LocationStatus.success && location != null;

  /// User-facing Bengali explanation of the outcome.
  String get message {
    switch (status) {
      case LocationStatus.success:
        return 'বর্তমান অবস্থান শনাক্ত হয়েছে';
      case LocationStatus.denied:
        return 'লোকেশনের অনুমতি দেওয়া হয়নি। আপনি জেলা বেছে নিতে পারেন।';
      case LocationStatus.deniedForever:
        return 'লোকেশনের অনুমতি বন্ধ আছে। ফোনের সেটিংস থেকে অনুমতি দিন, অথবা জেলা বেছে নিন।';
      case LocationStatus.serviceDisabled:
        return 'ফোনের লোকেশন (GPS) বন্ধ আছে। চালু করুন, অথবা জেলা বেছে নিন।';
      case LocationStatus.timeout:
        return 'নির্দিষ্ট সময়ে অবস্থান পাওয়া যায়নি। আবার চেষ্টা করুন বা জেলা বেছে নিন।';
      case LocationStatus.invalid:
        return 'ডিভাইস থেকে অবৈধ অবস্থান পাওয়া গেছে। জেলা বেছে নিন।';
      case LocationStatus.error:
        return 'অবস্থান শনাক্ত করা যায়নি। জেলা বেছে নিন।';
    }
  }
}

/// Single source of truth for the user's location.
///
/// Prayer times, Qibla and reminder scheduling all call [load] so they always
/// agree. Detection is a one-shot fix (no continuous tracking).
class LocationService {
  LocationService._();

  /// A GPS fix older than this is considered stale for auto-refresh.
  static const Duration gpsMaxAge = Duration(hours: 12);

  /// Only snap the label to a district when it is this close (km).
  static const double _districtLabelRadiusKm = 40;

  /// Loads the saved location: last GPS fix when the user chose GPS,
  /// otherwise the manually selected district.
  static Future<AppLocation> load() async {
    final gps = await StorageService.getGpsLocation();
    if (gps != null) {
      final lat = (gps['lat'] as num?)?.toDouble();
      final lon = (gps['lon'] as num?)?.toDouble();
      final at = gps['at'] as int?;
      if (lat != null && lon != null && PrayerService.isValidCoordinate(lat, lon)) {
        return AppLocation(
          latitude: lat,
          longitude: lon,
          label: (gps['label'] as String?) ?? 'বর্তমান অবস্থান',
          isGps: true,
          detectedAt: at == null ? null : DateTime.fromMillisecondsSinceEpoch(at),
        );
      }
    }
    final place = await StorageService.getManualPlace();
    if (place != null) {
      final lat = (place['lat'] as num?)?.toDouble();
      final lon = (place['lon'] as num?)?.toDouble();
      if (lat != null && lon != null && PrayerService.isValidCoordinate(lat, lon)) {
        return AppLocation(
          latitude: lat,
          longitude: lon,
          label: (place['label'] as String?) ?? 'নির্বাচিত স্থান',
          isGps: false,
          timezone: place['tz'] as String?,
        );
      }
    }
    final city = await StorageService.getSelectedCity();
    return manual(city);
  }

  static AppLocation manual(String city) {
    final c = districtCoordinates[city] ?? districtCoordinates['ঢাকা']!;
    return AppLocation(
      latitude: c[0],
      longitude: c[1],
      label: districtCoordinates.containsKey(city) ? city : 'ঢাকা',
      isGps: false,
    );
  }

  /// Switches back to a manually selected district (drops the GPS fix).
  static Future<AppLocation> selectManual(String city) async {
    await StorageService.setSelectedCity(city);
    await StorageService.clearGpsLocation();
    await StorageService.clearManualPlace();
    return manual(city);
  }

  /// Saves a place found through worldwide search (real coordinates and time
  /// zone) as the active manual location. It is never overwritten by an
  /// automatic refresh; only an explicit GPS action replaces it.
  static Future<AppLocation> selectPlace({
    required double latitude,
    required double longitude,
    required String label,
    String? timezone,
  }) async {
    if (!PrayerService.isValidCoordinate(latitude, longitude)) {
      throw ArgumentError('Invalid coordinates');
    }
    await StorageService.setManualPlace(
      latitude: latitude,
      longitude: longitude,
      label: label,
      timezone: timezone,
    );
    await StorageService.clearGpsLocation();
    return AppLocation(
      latitude: latitude,
      longitude: longitude,
      label: label,
      isGps: false,
      timezone: timezone,
    );
  }

  /// Whether the saved GPS fix should be refreshed on startup.
  static bool isStale(AppLocation location) {
    if (!location.isGps) return false;
    final at = location.detectedAt;
    return at == null || DateTime.now().difference(at) > gpsMaxAge;
  }

  /// Whether location permission is already granted (never prompts).
  static Future<bool> hasPermission() async {
    final p = await Geolocator.checkPermission();
    return p == LocationPermission.always || p == LocationPermission.whileInUse;
  }

  /// One-shot GPS detection. When [requestPermission] is false it never shows
  /// a permission dialog (used for silent refresh on startup).
  static Future<LocationResult> detect({bool requestPermission = true}) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationResult(LocationStatus.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && requestPermission) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(LocationStatus.deniedForever);
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        return const LocationResult(LocationStatus.denied);
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 15),
        );
      } on TimeoutException {
        position = await Geolocator.getLastKnownPosition();
        if (position == null) return const LocationResult(LocationStatus.timeout);
      }

      if (!PrayerService.isValidCoordinate(position.latitude, position.longitude)) {
        return const LocationResult(LocationStatus.invalid);
      }

      final label = _labelFor(position.latitude, position.longitude);
      final now = DateTime.now();
      // A deliberate switch to automatic location replaces a manual place.
      await StorageService.clearManualPlace();
      await StorageService.setGpsLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        label: label,
        detectedAt: now,
      );
      return LocationResult(
        LocationStatus.success,
        AppLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          label: label,
          isGps: true,
          detectedAt: now,
        ),
      );
    } on TimeoutException {
      return const LocationResult(LocationStatus.timeout);
    } catch (_) {
      return const LocationResult(LocationStatus.error);
    }
  }

  /// No geocoding service is used: the label is the nearest Bangladesh
  /// district when within [_districtLabelRadiusKm], otherwise the coordinates.
  static String _labelFor(double lat, double lon) {
    String? nearest;
    var best = double.infinity;
    districtCoordinates.forEach((name, c) {
      final d = PrayerService.distanceKm(lat, lon, c[0], c[1]);
      if (d < best) {
        best = d;
        nearest = name;
      }
    });
    if (nearest != null && best <= _districtLabelRadiusKm) {
      return 'বর্তমান অবস্থান (নিকটস্থ: $nearest)';
    }
    return 'বর্তমান অবস্থান (${lat.toStringAsFixed(2)}, ${lon.toStringAsFixed(2)})';
  }
}
