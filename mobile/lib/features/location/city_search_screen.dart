import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/city_search_service.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/app_location.dart';
import '../../data/models/district_coordinates.dart';

/// Worldwide city search. Pops with the saved [AppLocation] once a place is
/// chosen. With an empty query it lists Bangladesh districts (works offline).
class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  int _requestId = 0;
  bool _loading = false;
  String? _error;
  List<PlaceResult> _results = const [];
  String _activeQuery = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final q = value.trim();
    setState(() {
      _activeQuery = q;
      _error = null;
      if (q.length < 2) {
        _results = const [];
        _loading = false;
      }
    });
    if (q.length < 2) return;
    _debounce = Timer(const Duration(milliseconds: 450), () => _search(q));
  }

  Future<void> _search(String q) async {
    final id = ++_requestId;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await CitySearchService.search(q);
      if (!mounted || id != _requestId) return;
      setState(() {
        _results = r;
        _loading = false;
      });
    } on CitySearchException catch (e) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _error = e.message;
        _results = const [];
        _loading = false;
      });
    } catch (_) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _error = 'অনুসন্ধান করা যায়নি। আবার চেষ্টা করুন।';
        _results = const [];
        _loading = false;
      });
    }
  }

  Future<void> _pickPlace(PlaceResult p) async {
    try {
      final loc = await LocationService.selectPlace(
        latitude: p.latitude,
        longitude: p.longitude,
        label: p.label,
        timezone: p.timezone,
      );
      if (mounted) Navigator.of(context).pop<AppLocation>(loc);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('এই স্থানটি নির্বাচন করা যায়নি', style: GoogleFonts.hindSiliguri())),
      );
    }
  }

  Future<void> _pickDistrict(String name) async {
    final loc = await LocationService.selectManual(name);
    if (mounted) Navigator.of(context).pop<AppLocation>(loc);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final showDistricts = _activeQuery.length < 2;
    final districts = districtCoordinates.keys.toList();

    Widget body;
    if (showDistricts) {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: districts.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'শহর বা দেশের নাম লিখে বিশ্বের যেকোনো স্থান খুঁজুন। নিচে বাংলাদেশের জেলাগুলো (ইন্টারনেট ছাড়াও কাজ করে):',
                style: GoogleFonts.hindSiliguri(fontSize: 12.5, height: 1.5, color: secondary),
              ),
            );
          }
          final name = districts[i - 1];
          return _tile(isDark, name, 'বাংলাদেশ', () => _pickDistrict(name));
        },
      );
    } else if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = _message(Icons.wifi_off_rounded, _error!, secondary,
          action: TextButton(
            onPressed: () => _search(_activeQuery),
            child: Text('আবার চেষ্টা করুন', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
          ));
    } else if (_results.isEmpty) {
      body = _message(Icons.search_off_rounded, 'কোনো স্থান পাওয়া যায়নি। বানান বদলে আবার চেষ্টা করুন।', secondary);
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: _results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final p = _results[i];
          return _tile(isDark, p.name, p.subtitle, () => _pickPlace(p));
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('আপনার শহর নির্বাচন করুন', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'বন্ধ করুন',
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _controller,
                autofocus: false,
                textInputAction: TextInputAction.search,
                onChanged: _onChanged,
                style: GoogleFonts.hindSiliguri(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'আপনার শহর বা দেশের নাম লিখুন',
                  hintStyle: GoogleFonts.hindSiliguri(color: secondary),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'মুছুন',
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            _onChanged('');
                          },
                        ),
                  filled: true,
                  fillColor: isDark ? AppColors.cardDark : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
                  ),
                ),
              ),
            ),
            Expanded(child: body),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text('স্থানের তথ্য: GeoNames (Open-Meteo)',
                  style: GoogleFonts.hindSiliguri(fontSize: 10.5, color: secondary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(bool isDark, String title, String subtitle, VoidCallback onTap) {
    return Material(
      color: isDark ? AppColors.cardDark : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.emerald, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.w600)),
                    if (subtitle.isNotEmpty)
                      Text(subtitle,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12.5,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _message(IconData icon, String text, Color color, {Widget? action}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center, style: GoogleFonts.hindSiliguri(fontSize: 14, height: 1.5, color: color)),
            if (action != null) action,
          ],
        ),
      ),
    );
  }
}
