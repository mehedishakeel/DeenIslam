import 'dart:math' as math;

/// Geographic helpers shared by every prayer-related screen.
class PrayerService {
  PrayerService._();

  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  /// Calculation method used app-wide: University of Islamic Sciences, Karachi
  /// (Fajr 18°, Isha 18°) with the Hanafi Asr convention, which is the common
  /// convention in Bangladesh. Kept in one place so the UI and the reminder
  /// scheduler can never disagree.
  static const String methodDescription = 'করাচি পদ্ধতি (ফজর ১৮°, ইশা ১৮°), হানাফি আসর';

  /// Great-circle initial bearing from the given point to the Kaaba, in
  /// degrees clockwise from true north (0-360).
  static double qiblaBearing(double latitude, double longitude) {
    final phi1 = latitude * math.pi / 180;
    final phi2 = kaabaLatitude * math.pi / 180;
    final deltaLambda = (kaabaLongitude - longitude) * math.pi / 180;
    final y = math.sin(deltaLambda);
    final x = math.cos(phi1) * math.tan(phi2) -
        math.sin(phi1) * math.cos(deltaLambda);
    final bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360;
  }

  /// Haversine distance in kilometres.
  static double distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLon = (lon2 - lon1) * math.pi / 180;
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1 * math.pi / 180) *
            math.cos(lat2 * math.pi / 180) *
            math.pow(math.sin(dLon / 2), 2);
    return earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static bool isValidCoordinate(double latitude, double longitude) {
    return latitude.isFinite &&
        longitude.isFinite &&
        latitude.abs() <= 90 &&
        longitude.abs() <= 180;
  }
}
