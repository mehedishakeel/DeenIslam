/// The single location used by prayer times, Qibla and reminders.
class AppLocation {
  final double latitude;
  final double longitude;

  /// Human readable label (district name, nearest district, or coordinates).
  final String label;

  /// True when the coordinates came from the device GPS, false when the user
  /// picked a district manually.
  final bool isGps;

  /// When a GPS fix was obtained (null for manual selection).
  final DateTime? detectedAt;

  /// IANA time-zone id of a manually selected place (e.g. `Europe/London`).
  /// Null for GPS fixes and district picks, which use the device time zone.
  final String? timezone;

  const AppLocation({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.isGps,
    this.detectedAt,
    this.timezone,
  });

  @override
  bool operator ==(Object other) =>
      other is AppLocation &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.isGps == isGps &&
      other.timezone == timezone;

  @override
  int get hashCode => Object.hash(latitude, longitude, isGps, timezone);
}
