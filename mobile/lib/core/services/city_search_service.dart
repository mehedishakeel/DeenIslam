import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'prayer_service.dart';

/// A place returned by worldwide search (real coordinates, never invented).
class PlaceResult {
  final String name;
  final String? admin1;
  final String country;
  final double latitude;
  final double longitude;
  final String? timezone;

  const PlaceResult({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.admin1,
    this.timezone,
  });

  /// Short label stored as the active location name.
  String get label => country.isEmpty ? name : '$name, $country';

  /// Region and country shown under the name in search results.
  String get subtitle {
    final parts = <String>[
      if (admin1 != null && admin1!.isNotEmpty && admin1 != name) admin1!,
      if (country.isNotEmpty) country,
    ];
    return parts.join(', ');
  }
}

class CitySearchException implements Exception {
  final String message;
  const CitySearchException(this.message);
  @override
  String toString() => message;
}

/// City search backed by the Open-Meteo geocoding API (GeoNames data).
/// Free for non-commercial use; a commercial release needs their API key.
class CitySearchService {
  CitySearchService._();

  static const String _host = 'geocoding-api.open-meteo.com';

  static Future<List<PlaceResult>> search(String query, {String language = 'bn'}) async {
    final q = query.trim();
    if (q.length < 2) return const [];
    final uri = Uri.https(_host, '/v1/search', {
      'name': q,
      'count': '20',
      'language': language,
      'format': 'json',
    });
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final req = await client.getUrl(uri);
      final res = await req.close().timeout(const Duration(seconds: 10));
      if (res.statusCode == 429) {
        throw const CitySearchException('অনেক বেশি অনুসন্ধান হয়েছে। কিছুক্ষণ পর আবার চেষ্টা করুন।');
      }
      if (res.statusCode != 200) {
        throw CitySearchException('অনুসন্ধান সেবা এখন কাজ করছে না (${res.statusCode})।');
      }
      final body = await res.transform(utf8.decoder).join();
      return parse(body);
    } on CitySearchException {
      rethrow;
    } on SocketException {
      throw const CitySearchException('ইন্টারনেট সংযোগ নেই। সংযোগ দেখে আবার চেষ্টা করুন।');
    } on TimeoutException {
      throw const CitySearchException('সংযোগে বেশি সময় লাগছে। আবার চেষ্টা করুন।');
    } on HandshakeException {
      throw const CitySearchException('নিরাপদ সংযোগ স্থাপন করা যায়নি।');
    } on FormatException {
      throw const CitySearchException('অনুসন্ধানের ফলাফল পড়া যায়নি।');
    } finally {
      client.close(force: true);
    }
  }

  /// Parses an API response. Entries without valid coordinates are dropped.
  static List<PlaceResult> parse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) return const [];
    final results = decoded['results'];
    if (results is! List) return const [];
    final out = <PlaceResult>[];
    for (final r in results) {
      if (r is! Map) continue;
      final lat = (r['latitude'] as num?)?.toDouble();
      final lon = (r['longitude'] as num?)?.toDouble();
      final name = r['name'] as String?;
      if (lat == null || lon == null || name == null || name.isEmpty) continue;
      if (!PrayerService.isValidCoordinate(lat, lon)) continue;
      out.add(PlaceResult(
        name: name,
        admin1: r['admin1'] as String?,
        country: (r['country'] as String?) ?? '',
        latitude: lat,
        longitude: lon,
        timezone: r['timezone'] as String?,
      ));
    }
    return out;
  }
}
