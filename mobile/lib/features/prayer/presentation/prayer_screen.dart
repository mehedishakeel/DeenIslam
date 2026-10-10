import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/models/prayer_times_model.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final DateTime _now = DateTime.now();
  late PrayerTimesModel _prayerTimes;
  String _selectedCity = "ঢাকা";
  Map<String, bool> _azanAlarms = {};
  String _selectedMuazzin = "মক্কা শরীফ (হারামাইন)";
  int _preReminderMinutes = 15;

  final List<String> _cities = PrayerTimesModel.allDistricts;

  final List<String> _muazzinList = [
    "মক্কা শরীফ (হারামাইন)",
    "মদিনা শরীফ (মসজিদে নববী)",
    "মিশারি রাশিদ আল-আফাসী",
    "আব্দুল বাসিত আব্দুস সামাদ",
  ];

  @override
  void initState() {
    super.initState();
    _prayerTimes = PrayerTimesModel.forCity(_now, _selectedCity);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final city = await StorageService.getSelectedCity();
    final alarms = await StorageService.getAzanAlarms();
    final muazzin = await StorageService.getAzanMuazzin();
    final preMin = await StorageService.getAzanPreReminderMinutes();
    if (!mounted) return;
    setState(() {
      _selectedCity = city;
      _prayerTimes = PrayerTimesModel.forCity(_now, city);
      _azanAlarms = alarms;
      _selectedMuazzin = muazzin;
      _preReminderMinutes = preMin;
    });
  }

  Future<void> _onCityChanged(String city) async {
    await StorageService.setSelectedCity(city);
    if (!mounted) return;
    setState(() {
      _selectedCity = city;
      _prayerTimes = PrayerTimesModel.forCity(_now, city);
    });
  }

  Future<void> _toggleAlarm(String waqtName) async {
    final current = _azanAlarms[waqtName] ?? true;
    final nextVal = !current;
    await StorageService.setAzanAlarm(waqtName, nextVal);
    HapticFeedback.lightImpact();
    if (!mounted) return;
    setState(() {
      _azanAlarms[waqtName] = nextVal;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nextVal
              ? '$waqtName-এর আজান অ্যালার্ম চালু করা হয়েছে'
              : '$waqtName-এর আজান অ্যালার্ম বন্ধ করা হয়েছে',
          style: GoogleFonts.hindSiliguri(fontSize: 13),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAzanSettingsSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'আজান ও নোটিফিকেশন সেটিংস',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      const Icon(Icons.volume_up_outlined, color: AppColors.emerald),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'মুয়াজ্জিন নির্বাচন করুন',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMuazzin,
                        isExpanded: true,
                        items: _muazzinList.map((m) {
                          return DropdownMenuItem(
                            value: m,
                            child: Text(
                              m,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) async {
                          if (val != null) {
                            await StorageService.setAzanMuazzin(val);
                            setModalState(() => _selectedMuazzin = val);
                            setState(() => _selectedMuazzin = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ওয়াক্তের পূর্বে রিমাইন্ডার',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [10, 15, 30].map((mins) {
                      final isSelected = _preReminderMinutes == mins;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              '${BengaliNumerals.convert(mins)} মিনিট আগে',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.emerald,
                            onSelected: (_) async {
                              await StorageService.setAzanPreReminderMinutes(mins);
                              setModalState(() => _preReminderMinutes = mins);
                              setState(() => _preReminderMinutes = mins);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(ctx);
                      AudioService.instance.playUrl(
                        'https://www.islamcan.com/audio/adhan/azan1.mp3',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'আজান বাজছে ($_selectedMuazzin • আল্লাহু আকবার)',
                            style: GoogleFonts.hindSiliguri(fontSize: 13),
                          ),
                          duration: const Duration(seconds: 15),
                          action: SnackBarAction(
                            label: 'থামান',
                            textColor: Colors.white,
                            onPressed: () => AudioService.instance.stop(),
                          ),
                          backgroundColor: AppColors.emerald,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.notifications_active_outlined, size: 18),
                    label: Text(
                      'আজান অ্যালার্ম টেস্ট করুন',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayers = [
      {
        'name': 'সেহরি শেষ (ইমসাক)',
        'time': _prayerTimes.formatTime(_prayerTimes.imsak),
        'icon': Icons.nightlight_round,
        'badge': 'রোজা',
        'hasAlarm': true,
      },
      {
        'name': 'ফজর',
        'time': _prayerTimes.formatTime(_prayerTimes.fajr),
        'icon': Icons.wb_twilight,
        'isMain': true,
        'hasAlarm': true,
      },
      {
        'name': 'সূর্যোদয় (ইশরাক)',
        'time': _prayerTimes.formatTime(_prayerTimes.sunrise),
        'icon': Icons.wb_sunny_outlined,
        'hasAlarm': false,
      },
      {
        'name': 'যোহর',
        'time': _prayerTimes.formatTime(_prayerTimes.dhuhr),
        'icon': Icons.wb_sunny,
        'isMain': true,
        'hasAlarm': true,
      },
      {
        'name': 'আসর',
        'time': _prayerTimes.formatTime(_prayerTimes.asr),
        'icon': Icons.wb_sunny_outlined,
        'isMain': true,
        'hasAlarm': true,
      },
      {
        'name': 'মাগরিব (ইফতার)',
        'time': _prayerTimes.formatTime(_prayerTimes.maghrib),
        'icon': Icons.wb_twilight,
        'isMain': true,
        'badge': 'ইফতার',
        'hasAlarm': true,
      },
      {
        'name': 'ইশা',
        'time': _prayerTimes.formatTime(_prayerTimes.isha),
        'icon': Icons.nightlight,
        'isMain': true,
        'hasAlarm': true,
      },
    ];

    final enabledCount = _azanAlarms.values.where((v) => v).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "নামাজের সময়সূচি ও আজান",
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAzanSettingsSheet(isDark),
            tooltip: 'আজান সেটিংস',
            icon: const Icon(Icons.tune_rounded, color: AppColors.emerald),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // City Selector & Date Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.emerald, size: 18),
                      const SizedBox(width: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCity,
                          items: _cities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(
                                city,
                                style: GoogleFonts.hindSiliguri(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              _onCityChanged(val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => _showAzanSettingsSheet(isDark),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.notifications_active,
                            size: 14,
                            color: AppColors.emerald,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "আজান (${BengaliNumerals.convert(enabledCount)} ওয়াক্ত)",
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Azan Muazzin Status Banner
            InkWell(
              onTap: () => _showAzanSettingsSheet(isDark),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.emerald.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.amberSoftDark : AppColors.amberSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.campaign_rounded, color: AppColors.amber, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'মুয়াজ্জিন: $_selectedMuazzin',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            'ওয়াক্তের ${BengaliNumerals.convert(_preReminderMinutes)} মিনিট পূর্বে প্রি-রিমাইন্ডার সক্রিয়',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 11.5,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.emerald),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Prayer Time List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prayers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final p = prayers[index];
                final waqtName = p['name'] as String;
                final isMain = p['isMain'] == true;
                final badge = p['badge'] as String?;
                final hasAlarm = p['hasAlarm'] == true;
                final isAlarmEnabled = _azanAlarms[waqtName] ?? isMain;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isMain
                          ? (isDark ? AppColors.borderDark : AppColors.borderLight)
                          : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isMain
                              ? (isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft)
                              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          p['icon'] as IconData,
                          color: isMain
                              ? AppColors.emerald
                              : (isDark ? Colors.white60 : Colors.black45),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              waqtName,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13.5,
                                fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                            ),
                            if (badge != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.amberSoft,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  badge,
                                  style: GoogleFonts.hindSiliguri(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.amberDark,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        p['time'] as String,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: isMain
                              ? AppColors.emerald
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                      if (hasAlarm) ...[
                        const SizedBox(width: 6),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _toggleAlarm(waqtName),
                          tooltip: isAlarmEnabled ? 'অ্যালার্ম চালু' : 'অ্যালার্ম বন্ধ',
                          icon: Icon(
                            isAlarmEnabled
                                ? Icons.notifications_active
                                : Icons.notifications_off_outlined,
                            size: 19,
                            color: isAlarmEnabled
                                ? AppColors.emerald
                                : (isDark ? Colors.white38 : Colors.black38),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
