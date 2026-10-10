import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  static const MethodChannel _compassChannel =
      MethodChannel('com.mehedishakeel.deenislam/compass');

  double _heading = 0.0;
  double _qiblaAngle = 277.6; // Exact Qibla bearing from Dhaka (277.6° WNW)
  String _selectedCity = 'ঢাকা';
  bool _hasHardwareSensor = false;
  bool _wasAligned = false;

  static const Map<String, double> _cityQiblaAngles = {
    'ঢাকা': 277.6,
    'চট্টগ্রাম': 278.9,
    'সিলেট': 276.8,
    'রাজশাহী': 276.5,
    'খুলনা': 278.1,
    'বরিশাল': 278.3,
    'রংপুর': 275.9,
    'ময়মনসিংহ': 277.0,
    'কুমিল্লা': 278.1,
    'বগুড়া': 276.6,
  };

  @override
  void initState() {
    super.initState();
    _loadCityAndStartCompass();
  }

  Future<void> _loadCityAndStartCompass() async {
    final city = await StorageService.getSelectedCity();
    if (mounted) {
      setState(() {
        _selectedCity = city;
        _qiblaAngle = _cityQiblaAngles[city] ?? 277.6;
      });
    }

    _compassChannel.setMethodCallHandler((call) async {
      if (call.method == 'onHeadingChanged' && mounted) {
        final args = call.arguments as Map<dynamic, dynamic>?;
        final newHeading = (args?['heading'] as num?)?.toDouble();
        if (newHeading != null) {
          final diff = ((_qiblaAngle - newHeading + 540) % 360) - 180;
          final isAlignedNow = diff.abs() <= 4.0;
          if (isAlignedNow && !_wasAligned) {
            HapticFeedback.mediumImpact();
          }
          _wasAligned = isAlignedNow;
          setState(() {
            _heading = newHeading;
          });
        }
      }
    });

    try {
      final hasSensor = await _compassChannel.invokeMethod<bool>('startCompass');
      if (mounted) {
        setState(() {
          _hasHardwareSensor = hasSensor ?? false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasHardwareSensor = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _compassChannel.invokeMethod('stopCompass');
    super.dispose();
  }

  bool get _isAligned {
    final diff = ((_qiblaAngle - _heading + 540) % 360) - 180;
    return diff.abs() <= 5.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final aligned = _isAligned;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'কিবলা কম্পাস',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              avatar: Icon(
                _hasHardwareSensor ? Icons.sensors : Icons.tune,
                size: 15,
                color: AppColors.emerald,
              ),
              label: Text(
                _hasHardwareSensor ? 'লাইভ সেন্সর' : 'ম্যানুয়াল মোড',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
              backgroundColor: AppColors.emeraldSoft,
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // City & Bearing Status Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: aligned
                      ? AppColors.emerald
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: aligned ? 1.8 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_on, color: AppColors.emerald, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_selectedCity, বাংলাদেশ',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          'কাবার দিক: পশ্চিম-উত্তর (${BengaliNumerals.toBengali(_qiblaAngle.round())}° ডিগ্রী) • বর্তমান: ${BengaliNumerals.toBengali(_heading.round())}°',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 11.5,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: aligned ? AppColors.emerald : AppColors.amberSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      aligned
                          ? 'কিবলামুখী ✓'
                          : '${BengaliNumerals.toBengali(_qiblaAngle.round())}°',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: aligned ? Colors.white : AppColors.amberDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Top Alignment Indicator
            Column(
              children: [
                Icon(
                  Icons.keyboard_double_arrow_up_rounded,
                  color: aligned ? AppColors.emerald : AppColors.amber,
                  size: 28,
                ),
                Text(
                  aligned
                      ? 'আলহামদুলিল্লাহ! আপনি সঠিক কিবলার দিকে আছেন'
                      : 'ফোনটি ঘুরিয়ে কাবা আইকনটি উপরের তীরের সাথে মেলান',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: aligned
                        ? AppColors.emerald
                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Compass Dial Visualizer
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating Outer Compass Ring
                  Transform.rotate(
                    angle: -_heading * (math.pi / 180),
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.cardDark : Colors.white,
                        border: Border.all(
                          color: aligned
                              ? AppColors.emerald
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: aligned ? 3 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (aligned ? AppColors.emerald : Colors.black)
                                .withOpacity(isDark ? 0.3 : 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'উত্তর (N)',
                                style: GoogleFonts.hindSiliguri(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[600],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'দক্ষিণ (S)',
                                style: GoogleFonts.hindSiliguri(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'পশ্চিম (W)',
                                style: GoogleFonts.hindSiliguri(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'পূর্ব (E)',
                                style: GoogleFonts.hindSiliguri(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Kaaba Target Needle
                  Transform.rotate(
                    angle: (_qiblaAngle - _heading) * (math.pi / 180),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: aligned ? AppColors.emerald : AppColors.amberDark,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.mosque, color: Colors.white, size: 20),
                        ),
                        Container(
                          width: 4,
                          height: 88,
                          decoration: BoxDecoration(
                            color: aligned ? AppColors.emerald : AppColors.amberDark,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),

                  // Central Pivot Dot
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.emerald,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Manual Compass Test / Fallback Slider
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'কম্পাস রোটেশন অ্যাডজাস্ট / টেস্ট',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => _heading = _qiblaAngle);
                        },
                        child: Text(
                          'কিবলায় সেট করুন',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.emerald,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _heading.clamp(0.0, 360.0),
                    min: 0,
                    max: 360,
                    activeColor: AppColors.emerald,
                    onChanged: (val) {
                      setState(() => _heading = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Calibration Notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.amber, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'সঠিক ফলাফলের জন্য ফোনটি সমতল স্থানে রাখুন, ৮ (8) আকৃতিতে ঘুরিয়ে ক্যালিব্রেট করুন এবং ধাতব বস্তু থেকে দূরে রাখুন।',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
