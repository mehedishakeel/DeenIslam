import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/reminder_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/models/app_location.dart';
import '../../location/city_search_screen.dart';
import '../../settings/notification_settings_screen.dart';
import '../../settings/prayer_alarm_settings_screen.dart';
import '../../../data/models/calc_config.dart';
import '../../../data/models/prayer_times_model.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> with WidgetsBindingObserver {
  DateTime _now = DateTime.now();
  late AppLocation _location;
  late PrayerTimesModel _prayerTimes;
  Map<String, bool> _azanAlarms = {};
  String _selectedMuazzin = "মক্কা শরীফ (হারামাইন)";
  int _preReminderMinutes = 15;
  bool _detecting = false;
  bool _adhanFile = false; // full Adhan audio bundled in this build
  bool _adhanOn = true;
  Timer? _dayTimer;

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
    WidgetsBinding.instance.addObserver(this);
    _location = LocationService.manual('ঢাকা');
    _prayerTimes = PrayerTimesModel.forLocation(_now, _location);
    _loadPreferences();
    CalcConfig.revision.addListener(_onCalcChanged);
    // Recompute when the calendar day changes while the screen stays open.
    _dayTimer = Timer.periodic(const Duration(minutes: 1), (_) => _refreshIfDayChanged());
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    CalcConfig.revision.removeListener(_onCalcChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshIfDayChanged();
  }

  void _onCalcChanged() {
    if (!mounted) return;
    setState(() => _applyLocation(_location));
  }

  void _refreshIfDayChanged() {
    final now = DateTime.now();
    if (!mounted) return;
    final today = PrayerTimesModel.placeToday(now, _location);
    if (!_prayerTimes.isSameDay(today)) {
      setState(() {
        _now = now;
        _prayerTimes = PrayerTimesModel.forLocation(today, _location);
      });
    }
  }

  void _applyLocation(AppLocation loc) {
    _now = DateTime.now();
    _location = loc;
    _prayerTimes = PrayerTimesModel.forLocation(PrayerTimesModel.placeToday(_now, loc), loc);
  }

  Future<void> _loadPreferences() async {
    final loc = await LocationService.load();
    final alarms = await StorageService.getAzanAlarms();
    final muazzin = await StorageService.getAzanMuazzin();
    final preMin = await StorageService.getAzanPreReminderMinutes();
    final adhanFile = await ReminderService.instance.adhanAvailable();
    final adhanOn = await StorageService.getAdhanSound();
    if (!mounted) return;
    setState(() {
      _adhanFile = adhanFile;
      _adhanOn = adhanOn;
      _applyLocation(loc);
      _azanAlarms = alarms;
      _selectedMuazzin = muazzin;
      _preReminderMinutes = preMin;
    });
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg, style: GoogleFonts.hindSiliguri(fontSize: 13)),
          duration: Duration(seconds: error ? 4 : 2),
          backgroundColor: error ? Colors.red.shade700 : AppColors.emerald,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  /// Re-applies reminders for the current location and reports the real result.
  Future<ReminderResult> _reschedule() async {
    final r = await ReminderService.instance.reschedule(_location);
    if (r.ok && !r.exact) {
      _toast('অ্যান্ড্রয়েডের সীমাবদ্ধতার কারণে রিমাইন্ডার কয়েক মিনিট দেরিতে আসতে পারে।');
    }
    return r;
  }

  Future<void> _onCityChanged(String city) async {
    final loc = await LocationService.selectManual(city);
    if (!mounted) return;
    setState(() => _applyLocation(loc));
    final r = await _reschedule();
    if (!r.ok && r.status == ReminderStatus.failed) {
      _toast('রিমাইন্ডার আপডেট করা যায়নি', error: true);
    }
  }

  Future<void> _detectLocation() async {
    if (_detecting) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('অবস্থান ব্যবহারের অনুমতি',
            style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
        content: Text(
          'আপনার এলাকার সঠিক নামাজের সময় ও কিবলা দেখাতে একবার ফোনের অবস্থান (GPS) দরকার। '
          'অবস্থান শুধু ফোনেই সংরক্ষিত থাকে এবং ক্রমাগত ট্র্যাক করা হয় না।',
          style: GoogleFonts.hindSiliguri(fontSize: 13.5, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('এখন নয়', style: GoogleFonts.hindSiliguri()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('এগিয়ে যান', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _detecting = true);
    final result = await LocationService.detect();
    if (!mounted) return;
    setState(() {
      _detecting = false;
      if (result.isSuccess) _applyLocation(result.location!);
    });
    _toast(result.message, error: !result.isSuccess);
    if (result.isSuccess) await _reschedule();
  }

  Future<void> _toggleAlarm(String waqtName) async {
    final current = _azanAlarms[waqtName] ?? true;
    final nextVal = !current;
    HapticFeedback.lightImpact();

    if (nextVal) {
      final allowed = await ReminderService.instance.requestNotificationPermission();
      if (!allowed) {
        _toast('নোটিফিকেশনের অনুমতি ছাড়া রিমাইন্ডার চালু করা যাবে না। ফোনের সেটিংস থেকে অনুমতি দিন।',
            error: true);
        return;
      }
    }

    await StorageService.setAzanAlarm(waqtName, nextVal);
    final r = await _reschedule();
    if (nextVal && !r.ok) {
      // Do not show an enabled state when scheduling actually failed.
      await StorageService.setAzanAlarm(waqtName, current);
      _toast('রিমাইন্ডার চালু করা যায়নি, আবার চেষ্টা করুন', error: true);
      return;
    }
    if (!mounted) return;
    setState(() {
      _azanAlarms[waqtName] = nextVal;
    });
    _toast(nextVal
        ? '$waqtName-এর রিমাইন্ডার চালু করা হয়েছে'
        : '$waqtName-এর রিমাইন্ডার বন্ধ করা হয়েছে');
  }

  void _showAzanSettingsSheet(bool isDark) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const PrayerAlarmSettingsScreen()))
        .then((_) => _loadPreferences());
  }

  Future<void> _openCitySearch() async {
    final loc = await Navigator.of(context).push<AppLocation>(
      MaterialPageRoute(builder: (_) => const CitySearchScreen()),
    );
    if (loc == null || !mounted) return;
    setState(() => _applyLocation(loc));
    final r = await _reschedule();
    if (!r.ok && r.status == ReminderStatus.failed) {
      _toast('রিমাইন্ডার আপডেট করা যায়নি', error: true);
    }
  }

  // ignore: unused_element
  void _legacyAzanSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [10, 15, 30].map((mins) {
                      final isSelected = _preReminderMinutes == mins;
                      return ChoiceChip(
                        showCheckmark: false,
                        avatar: isSelected
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                        label: Text(
                          '${BengaliNumerals.convert(mins)} মিনিট আগে',
                          softWrap: false,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12.5,
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
                          await _reschedule();
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<bool>>(
                    future: Future.wait([
                      ReminderService.instance.notificationsAllowed(),
                      ReminderService.instance.canScheduleExact(),
                    ]),
                    builder: (context, snap) {
                      if (!snap.hasData) return const SizedBox.shrink();
                      final notif = snap.data![0];
                      final exact = snap.data![1];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            notif
                                ? '✔ নোটিফিকেশনের অনুমতি আছে'
                                : '✖ নোটিফিকেশনের অনুমতি নেই — রিমাইন্ডার আসবে না',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: notif ? AppColors.emerald : Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            exact
                                ? '✔ সঠিক সময়ের অ্যালার্ম চালু আছে'
                                : '• সঠিক সময়ের অ্যালার্মের অনুমতি নেই — রিমাইন্ডার কয়েক মিনিট দেরিতে আসতে পারে',
                            style: GoogleFonts.hindSiliguri(fontSize: 12, height: 1.4),
                          ),
                          if (!exact)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () async {
                                  await ReminderService.instance.requestExactAlarmPermission();
                                  setModalState(() {});
                                },
                                child: Text('অনুমতির সেটিংস খুলুন',
                                    style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (_adhanFile)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.emerald,
                      title: Text('ওয়াক্ত শুরুতে পূর্ণ আজান',
                          style: GoogleFonts.hindSiliguri(fontSize: 13.5, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'অ্যাপ বন্ধ থাকলেও বাজবে। ফোনের ভলিউম, সাইলেন্ট ও ডু-নট-ডিস্টার্ব সেটিং মানবে।',
                          style: GoogleFonts.hindSiliguri(fontSize: 11.5, height: 1.4)),
                      value: _adhanOn,
                      onChanged: (v) async {
                        await StorageService.setAdhanSound(v);
                        setModalState(() => _adhanOn = v);
                        setState(() => _adhanOn = v);
                        await _reschedule();
                      },
                    )
                  else
                    Text(
                      'এই সংস্করণে আজানের অডিও ফাইল যুক্ত নেই, তাই ওয়াক্ত হলে ফোনের ডিফল্ট নোটিফিকেশন শব্দে রিমাইন্ডার আসে। অ্যাপ খোলা থাকলে আজান ইন্টারনেট থেকে বাজে। নিচের বাটন একটি নমুনা শোনায় (নেট প্রয়োজন)।',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11.5,
                        height: 1.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  const SizedBox(height: 12),
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
                      'আজানের নমুনা শুনুন',
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

    final enabledCount = ReminderService.waqtKeys.where((k) => _azanAlarms[k] ?? true).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "নামাজের সময়সূচি ও আজান",
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())),
            tooltip: 'নোটিফিকেশন সেটিংস',
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.emerald),
          ),
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
                  Expanded(
                    child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.emerald, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: (!_location.isGps && _cities.contains(_location.label)) ? _location.label : null,
                          hint: Text(
                            _location.label,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.hindSiliguri(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
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
                      ),
                    ],
                  ),
                  ),
                  IconButton(
                    onPressed: _openCitySearch,
                    tooltip: 'বিশ্বের যেকোনো শহর খুঁজুন',
                    icon: const Icon(Icons.travel_explore, color: AppColors.emerald, size: 20),
                  ),
                  IconButton(
                    onPressed: _detecting ? null : _detectLocation,
                    tooltip: 'আমার অবস্থান ব্যবহার করুন',
                    icon: _detecting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location, color: AppColors.emerald, size: 20),
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
