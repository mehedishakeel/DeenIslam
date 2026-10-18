import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/location_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/app_location.dart';
import 'city_search_screen.dart';

/// First-run location setup: automatic (GPS, runtime permission) or manual
/// (worldwide search). [onDone] is called once a location is confirmed.
class LocationOnboardingScreen extends StatefulWidget {
  final void Function(AppLocation? location) onDone;
  const LocationOnboardingScreen({super.key, required this.onDone});

  @override
  State<LocationOnboardingScreen> createState() => _LocationOnboardingScreenState();
}

class _LocationOnboardingScreenState extends State<LocationOnboardingScreen> {
  bool _auto = true;
  bool _detecting = false;
  LocationResult? _result;
  AppLocation? _chosen;

  Future<void> _detect() async {
    setState(() {
      _detecting = true;
      _result = null;
    });
    final r = await LocationService.detect();
    if (!mounted) return;
    setState(() {
      _detecting = false;
      _result = r;
      if (r.isSuccess) _chosen = r.location;
    });
  }

  Future<void> _pickCity() async {
    final loc = await Navigator.of(context).push<AppLocation>(
      MaterialPageRoute(builder: (_) => const CitySearchScreen()),
    );
    if (loc != null && mounted) setState(() => _chosen = loc);
  }

  Future<void> _finish(AppLocation? loc) async {
    await StorageService.setOnboarded(true);
    widget.onDone(loc);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final r = _result;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset('assets/images/mishkat_logo.png', width: 84, height: 84, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('MISHKAT',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.emeraldDark)),
                    Text('Your Faith. Your Light.',
                        textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12, color: secondary)),
                    const SizedBox(height: 28),
                    Text('আপনার এলাকার সঠিক নামাজের সময় পেতে লোকেশন নির্বাচন করুন',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hindSiliguri(fontSize: 20, fontWeight: FontWeight.bold, height: 1.35)),
                    const SizedBox(height: 20),
                    _segmented(isDark),
                    const SizedBox(height: 16),
                    if (_auto) _autoPanel(isDark, secondary, r) else _manualPanel(isDark, secondary),
                    if (_chosen != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.emerald),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${_chosen!.isGps ? 'শনাক্ত হয়েছে' : 'নির্বাচিত'}: ${_chosen!.label}',
                                style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _chosen == null ? null : () => _finish(_chosen),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text('চালিয়ে যান', style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _finish(null),
                    child: Text('পরে ঠিক করব (আপাতত ঢাকা)', style: GoogleFonts.hindSiliguri(color: secondary)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _segmented(bool isDark) {
    Widget seg(String text, IconData icon, bool selected, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? (isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft) : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: selected ? AppColors.emerald : Colors.transparent, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: selected ? AppColors.emerald : null),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(text,
                      style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.w600, color: selected ? AppColors.emerald : null)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          seg('অটোমেটিক পদ্ধতি', Icons.my_location, _auto, () => setState(() => _auto = true)),
          seg('ম্যানুয়াল পদ্ধতি', Icons.search, !_auto, () => setState(() => _auto = false)),
        ],
      ),
    );
  }

  Widget _autoPanel(bool isDark, Color secondary, LocationResult? r) {
    final blocked = r != null && !r.isSuccess;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.emeraldSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.emerald.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'লোকেশনের অনুমতি দিলে আপনার বর্তমান অবস্থান অনুযায়ী নির্ভুল সময়সূচী দেখানো হবে। অবস্থান শুধু আপনার ফোনেই থাকে এবং ক্রমাগত ট্র্যাক করা হয় না।',
            textAlign: TextAlign.center,
            style: GoogleFonts.hindSiliguri(fontSize: 13.5, height: 1.5),
          ),
          if (blocked) ...[
            const SizedBox(height: 10),
            Text(r.message,
                textAlign: TextAlign.center,
                style: GoogleFonts.hindSiliguri(fontSize: 13, height: 1.5, color: Colors.red.shade700, fontWeight: FontWeight.w600)),
          ],
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _detecting ? null : _detect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              icon: _detecting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.my_location, size: 18),
              label: Text(
                _detecting ? 'অবস্থান খোঁজা হচ্ছে...' : (blocked ? 'আবার চেষ্টা করুন' : 'লোকেশন পারমিশন দিন'),
                style: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (r?.status == LocationStatus.deniedForever)
            TextButton(
              onPressed: Geolocator.openAppSettings,
              child: Text('অ্যাপের অনুমতির সেটিংস খুলুন', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
            ),
          if (r?.status == LocationStatus.serviceDisabled)
            TextButton(
              onPressed: Geolocator.openLocationSettings,
              child: Text('অবস্থান সেটিংস খুলুন', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
            ),
          if (blocked)
            TextButton(
              onPressed: () => setState(() => _auto = false),
              child: Text('শহর বেছে নিন', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _manualPanel(bool isDark, Color secondary) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _pickCity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.emerald, width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.emerald),
            const SizedBox(width: 12),
            Expanded(
              child: Text('আপনার শহর বা দেশের নাম লিখুন',
                  style: GoogleFonts.hindSiliguri(fontSize: 15, color: secondary)),
            ),
          ],
        ),
      ),
    );
  }
}
