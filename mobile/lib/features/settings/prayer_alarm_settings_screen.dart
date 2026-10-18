import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/audio_service.dart';
import '../../data/models/calc_config.dart';
import 'calculation_settings_screen.dart';
import '../../core/services/reminder_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/bengali_numerals.dart';

/// Per-prayer alarm settings wired to the real scheduler.
class PrayerAlarmSettingsScreen extends StatefulWidget {
  const PrayerAlarmSettingsScreen({super.key});

  @override
  State<PrayerAlarmSettingsScreen> createState() => _PrayerAlarmSettingsScreenState();
}

class _PrayerAlarmSettingsScreenState extends State<PrayerAlarmSettingsScreen> with WidgetsBindingObserver {
  static const _titles = ['ফজর', 'যোহর', 'আসর', 'মাগরিব', 'ইশা'];
  Map<String, bool> _alarms = {};
  int _preMinutes = 15;
  bool _adhanFile = false;
  bool _adhanOn = true;
  int _adhanChoice = 1;
  bool _notif = false;
  bool _exact = false;
  bool _loaded = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Returning from system settings: refresh permission state and schedule.
    if (state == AppLifecycleState.resumed) _load(reschedule: true);
  }

  Future<void> _load({bool reschedule = false}) async {
    final alarms = await StorageService.getAzanAlarms();
    final pre = await StorageService.getAzanPreReminderMinutes();
    final file = await ReminderService.instance.adhanAvailable();
    final on = await StorageService.getAdhanSound();
    final choice = await StorageService.getAdhanChoice();
    final notif = await ReminderService.instance.notificationsAllowed();
    final exact = await ReminderService.instance.canScheduleExact();
    if (reschedule) await ReminderService.instance.rescheduleFromSaved();
    if (!mounted) return;
    setState(() {
      _alarms = alarms;
      _preMinutes = pre;
      _adhanFile = file;
      _adhanOn = on;
      _adhanChoice = choice;
      _notif = notif;
      _exact = exact;
      _loaded = true;
    });
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg, style: GoogleFonts.hindSiliguri()),
        backgroundColor: error ? Colors.red.shade700 : AppColors.emerald,
        behavior: SnackBarBehavior.floating,
      ));
  }

  bool _on(String key) => _alarms[key] ?? true;

  Future<void> _toggle(String key, bool value) async {
    if (_busy) return;
    _busy = true;
    try {
      if (value && !await ReminderService.instance.requestNotificationPermission()) {
        _toast('নোটিফিকেশনের অনুমতি ছাড়া অ্যালার্ম চালু করা যাবে না।', error: true);
        await _load();
        return;
      }
      final old = _on(key);
      await StorageService.setAzanAlarm(key, value);
      final r = await ReminderService.instance.rescheduleFromSaved();
      if (value && (r.status == ReminderStatus.failed || r.status == ReminderStatus.notificationsDenied)) {
        await StorageService.setAzanAlarm(key, old);
        _toast('অ্যালার্ম চালু করা যায়নি, আবার চেষ্টা করুন', error: true);
        await _load();
        return;
      }
      await _load();
    } finally {
      _busy = false;
    }
  }

  Future<void> _toggleAll(bool value) async {
    if (value && !await ReminderService.instance.requestNotificationPermission()) {
      _toast('নোটিফিকেশনের অনুমতি ছাড়া অ্যালার্ম চালু করা যাবে না।', error: true);
      return;
    }
    final previous = {for (final k in ReminderService.waqtKeys) k: _on(k)};
    for (final k in ReminderService.waqtKeys) {
      await StorageService.setAzanAlarm(k, value);
    }
    final r = await ReminderService.instance.rescheduleFromSaved();
    if (value && r.status == ReminderStatus.failed) {
      // Restore exactly what the user had before the failed attempt.
      for (final e in previous.entries) {
        await StorageService.setAzanAlarm(e.key, e.value);
      }
      _toast('অ্যালার্ম চালু করা যায়নি', error: true);
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final allOn = ReminderService.waqtKeys.every(_on);

    return Scaffold(
      appBar: AppBar(title: Text('নামাজের অ্যালার্ম', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold))),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'ওয়াক্ত শুরু হলে রিমাইন্ডার আসবে। প্রতিটি ওয়াক্ত আলাদাভাবে চালু বা বন্ধ করা যায়। সময় আপনার নির্বাচিত লোকেশন থেকে ডিভাইসে হিসাব করা।',
                    style: GoogleFonts.hindSiliguri(fontSize: 13, height: 1.5),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: const Icon(Icons.calculate_outlined, color: AppColors.emerald),
                  title: Text('গণনা পদ্ধতি', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
                  subtitle: Text(CalcConfig.current.label, style: GoogleFonts.hindSiliguri(fontSize: 12.5, color: secondary)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CalculationSettingsScreen()),
                    );
                    if (mounted) setState(() {});
                  },
                ),
                if (ReminderService.instance.lastDiagnostics.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Text(
                      'কিছু দিনের সময়সূচি যাচাইয়ে সমস্যা পাওয়া গেছে, সেই দিনের অ্যালার্ম বসানো হয়নি: ${ReminderService.instance.lastDiagnostics.take(2).join('; ')}',
                      style: GoogleFonts.hindSiliguri(fontSize: 12, height: 1.4, color: Colors.red.shade700),
                    ),
                  ),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  activeColor: AppColors.emerald,
                  title: Text('সব ওয়াক্তের অ্যালার্ম', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold, fontSize: 15.5)),
                  value: allOn,
                  onChanged: _toggleAll,
                ),
                const Divider(height: 1),
                for (var i = 0; i < 5; i++) ...[
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    activeColor: AppColors.emerald,
                    secondary: const Icon(Icons.access_alarm, color: AppColors.emerald),
                    title: Text(_titles[i], style: GoogleFonts.hindSiliguri(fontSize: 15.5, fontWeight: FontWeight.w600)),
                    value: _on(ReminderService.waqtKeys[i]),
                    onChanged: (v) => _toggle(ReminderService.waqtKeys[i], v),
                  ),
                  const Divider(height: 1),
                ],
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                  child: Text('ওয়াক্তের আগে সতর্কতা', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold, color: secondary)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [0, 10, 15, 30].map((m) {
                      final sel = _preMinutes == m;
                      return ChoiceChip(
                        showCheckmark: false,
                        selected: sel,
                        selectedColor: AppColors.emerald,
                        label: Text(
                          m == 0 ? 'নেই' : '${BengaliNumerals.convert(m)} মিনিট আগে',
                          softWrap: false,
                          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold, color: sel ? Colors.white : null),
                        ),
                        onSelected: (_) async {
                          await StorageService.setAzanPreReminderMinutes(m);
                          await ReminderService.instance.rescheduleFromSaved();
                          await _load();
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                if (_adhanFile)
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    activeColor: AppColors.emerald,
                    title: Text('ওয়াক্ত শুরুতে পূর্ণ আজান', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
                    subtitle: Text('অ্যাপ বন্ধ থাকলেও বাজবে; ফোনের ভলিউম ও সাইলেন্ট সেটিং মানবে',
                        style: GoogleFonts.hindSiliguri(fontSize: 12, color: secondary)),
                    value: _adhanOn,
                    onChanged: (v) async {
                      await StorageService.setAdhanSound(v);
                      await ReminderService.instance.rescheduleFromSaved();
                      await _load();
                    },
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'এই সংস্করণে আজানের অডিও ফাইল যুক্ত নেই, তাই ওয়াক্তে ফোনের ডিফল্ট নোটিফিকেশন শব্দ বাজবে।',
                      style: GoogleFonts.hindSiliguri(fontSize: 12.5, height: 1.5, color: secondary),
                    ),
                  ),
                if (_adhanFile) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Text('আজান বাছাই করুন', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold, color: secondary)),
                  ),
                  for (var i = 1; i <= StorageService.adhanCount; i++)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      leading: Icon(
                        _adhanChoice == i ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: _adhanChoice == i ? AppColors.emerald : secondary,
                      ),
                      title: Text(ReminderService.adhanLabel(i), style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
                      trailing: AnimatedBuilder(
                        animation: AudioService.instance,
                        builder: (_, __) {
                          final playing = AudioService.instance.currentUrl == 'raw:${ReminderService.adhanRawName(i)}' &&
                              (AudioService.instance.isPlaying || AudioService.instance.isLoading);
                          return IconButton(
                            tooltip: playing ? 'থামান' : 'নমুনা শুনুন',
                            icon: Icon(playing ? Icons.stop_circle_outlined : Icons.play_circle_outline, color: AppColors.emerald, size: 30),
                            onPressed: () => playing
                                ? AudioService.instance.stop()
                                : AudioService.instance.playRaw(ReminderService.adhanRawName(i)),
                          );
                        },
                      ),
                      onTap: () async {
                        await StorageService.setAdhanChoice(i);
                        await ReminderService.instance.rescheduleFromSaved();
                        await _load();
                      },
                    ),
                ] else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: OutlinedButton.icon(
                      onPressed: () => AudioService.instance.playUrl('https://www.islamcan.com/audio/adhan/azan1.mp3'),
                      icon: const Icon(Icons.volume_up_outlined),
                      label: Text('আজানের নমুনা শুনুন (ইন্টারনেট লাগবে)', style: GoogleFonts.hindSiliguri()),
                    ),
                  ),
                const Divider(height: 32),
                ListTile(
                  leading: Icon(_notif ? Icons.check_circle : Icons.error_outline, color: _notif ? AppColors.emerald : Colors.red.shade700),
                  title: Text(_notif ? 'নোটিফিকেশনের অনুমতি আছে' : 'নোটিফিকেশনের অনুমতি নেই', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
                  trailing: _notif
                      ? null
                      : TextButton(
                          onPressed: () async {
                            await ReminderService.instance.requestNotificationPermission();
                            await _load(reschedule: true);
                          },
                          child: Text('অনুমতি দিন', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
                        ),
                ),
                ListTile(
                  leading: Icon(_exact ? Icons.check_circle : Icons.info_outline, color: _exact ? AppColors.emerald : AppColors.amber),
                  title: Text(_exact ? 'সঠিক সময়ের অ্যালার্ম চালু' : 'সঠিক সময়ের অ্যালার্ম বন্ধ', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    _exact ? '' : 'বন্ধ থাকলে রিমাইন্ডার কয়েক মিনিট দেরিতে আসতে পারে।',
                    style: GoogleFonts.hindSiliguri(fontSize: 12, color: secondary),
                  ),
                  trailing: _exact
                      ? null
                      : TextButton(
                          onPressed: ReminderService.instance.requestExactAlarmPermission,
                          child: Text('সেটিংস খুলুন', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold)),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'কিছু ফোনে (শাওমি, ওপো, ভিভো, হুয়াওয়ে, স্যামসাং পাওয়ার সেভিং) ব্যাকগ্রাউন্ড অ্যাপ বন্ধ হয়ে যেতে পারে; তখন ফোনের সেটিংস থেকে অ্যাপকে ব্যাকগ্রাউন্ডে চলার অনুমতি দিন।',
                    style: GoogleFonts.hindSiliguri(fontSize: 12, height: 1.5, color: secondary),
                  ),
                ),
              ],
            ),
    );
  }
}
