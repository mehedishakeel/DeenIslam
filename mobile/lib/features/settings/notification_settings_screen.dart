import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/reminder_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/bengali_numerals.dart';
import 'calculation_settings_screen.dart';
import 'prayer_alarm_settings_screen.dart';

/// Global notification settings. Every switch is persisted and applied to the
/// real scheduler; a switch is reverted if scheduling fails.
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _master = true;
  bool _friday = true;
  bool _sawm = true;
  bool _daily = false;
  bool _bid = false;
  int _dailyMinutes = 7 * 60;
  bool _loaded = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final m = await StorageService.getNotifPref('master');
    final f = await StorageService.getNotifPref('friday');
    final w = await StorageService.getNotifPref('weekly_sawm');
    final dy = await StorageService.getNotifPref('daily_ayah', defaultValue: false);
    final bd = await StorageService.getNotifPref('ayyam_bid', defaultValue: false);
    final dm = await StorageService.getDailyReminderMinutes();
    if (!mounted) return;
    setState(() {
      _master = m;
      _friday = f;
      _sawm = w;
      _daily = dy;
      _bid = bd;
      _dailyMinutes = dm;
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

  Future<void> _set(String key, bool value, void Function(bool) apply) async {
    if (_busy) return;
    _busy = true;
    try {
      if (value && !await ReminderService.instance.requestNotificationPermission()) {
        _toast('নোটিফিকেশনের অনুমতি ছাড়া চালু করা যাবে না। ফোনের সেটিংস থেকে অনুমতি দিন।', error: true);
        return;
      }
      await StorageService.setNotifPref(key, value);
      final r = await ReminderService.instance.rescheduleFromSaved();
      if (value && (r.status == ReminderStatus.failed || r.status == ReminderStatus.notificationsDenied)) {
        await StorageService.setNotifPref(key, !value);
        _toast('চালু করা যায়নি, আবার চেষ্টা করুন', error: true);
        return;
      }
      if (!mounted) return;
      setState(() => apply(value));
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    Widget sw(String title, String sub, bool value, ValueChanged<bool>? onChanged) => SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          activeColor: AppColors.emerald,
          title: Text(title, style: GoogleFonts.hindSiliguri(fontSize: 15.5, fontWeight: FontWeight.w600)),
          subtitle: Text(sub, style: GoogleFonts.hindSiliguri(fontSize: 12.5, height: 1.4, color: secondary)),
          value: value,
          onChanged: onChanged,
        );

    return Scaffold(
      appBar: AppBar(title: Text('নোটিফিকেশন সেটিংস', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold))),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PrayerAlarmSettingsScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.alarm, color: AppColors.emerald, size: 30),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('নামাজের অ্যালার্ম সেটিংস',
                                    style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.emeraldDark)),
                                Text('প্রতিটি ওয়াক্তের অ্যালার্ম চালু বা বন্ধ করুন',
                                    style: GoogleFonts.hindSiliguri(fontSize: 12.5, color: secondary)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: const Icon(Icons.calculate_outlined, color: AppColors.emerald),
                  title: Text('গণনা পদ্ধতি', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
                  subtitle: Text('নামাজের সময়ের পদ্ধতি, আসরের হিসাব ও হিজরি সমন্বয়',
                      style: GoogleFonts.hindSiliguri(fontSize: 12.5, color: secondary)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CalculationSettingsScreen()),
                  ),
                ),
                const Divider(height: 1),
                sw('সব নোটিফিকেশন', 'বন্ধ করলে নামাজ ও অন্যান্য সব রিমাইন্ডার বন্ধ হয়ে যাবে', _master,
                    (v) => _set('master', v, (x) => _master = x)),
                const Divider(height: 1),
                sw('জুমার রিমাইন্ডার', 'প্রতি শুক্রবার সকাল ১০টায় সূরা আল-কাহফ তিলাওয়াতের স্মরণ', _friday,
                    _master ? (v) => _set('friday', v, (x) => _friday = x) : null),
                const Divider(height: 1),
                sw('সাপ্তাহিক নফল রোজার রিমাইন্ডার', 'রবি ও বুধবার রাত ৮টায় পরদিনের (সোম ও বৃহস্পতিবার) নফল রোজার স্মরণ', _sawm,
                    _master ? (v) => _set('weekly_sawm', v, (x) => _sawm = x) : null),
                const Divider(height: 1),
                sw('আইয়ামে বীযের রোজা', 'হিজরি ১৩, ১৪ ও ১৫ তারিখের আগের সন্ধ্যা ৮টায় স্মরণ (গাণিতিক ক্যালেন্ডার; সমন্বয় গণনা পদ্ধতি পাতায়)', _bid,
                    _master ? (v) => _set('ayyam_bid', v, (x) => _bid = x) : null),
                const Divider(height: 1),
                sw('দৈনিক আয়াত ও হাদিস', 'প্রতিদিন একটি আয়াত বা হাদিস, অ্যাপে থাকা বিষয়বস্তু থেকে রেফারেন্স সহ', _daily,
                    _master ? (v) => _set('daily_ayah', v, (x) => _daily = x) : null),
                if (_daily && _master)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: const Icon(Icons.schedule, color: AppColors.emerald),
                    title: Text('রিমাইন্ডারের সময়', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
                    trailing: Text(
                      '${BengaliNumerals.convert((_dailyMinutes ~/ 60).toString().padLeft(2, '0'))}:${BengaliNumerals.convert((_dailyMinutes % 60).toString().padLeft(2, '0'))}',
                      style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: _dailyMinutes ~/ 60, minute: _dailyMinutes % 60),
                      );
                      if (picked == null) return;
                      final m = picked.hour * 60 + picked.minute;
                      await StorageService.setDailyReminderMinutes(m);
                      await ReminderService.instance.rescheduleFromSaved();
                      if (mounted) setState(() => _dailyMinutes = m);
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'রিমাইন্ডার ফোনের নিজস্ব সময়ে আগামী ৭ দিনের জন্য সেট হয়। অ্যাপ ৭ দিনের বেশি না খুললে নতুন রিমাইন্ডার সেট হবে না। কিছু ফোনে ব্যাটারি সেভার অ্যাপকে বন্ধ করে দিলে রিমাইন্ডার আসতে নাও পারে।',
                    style: GoogleFonts.hindSiliguri(fontSize: 12, height: 1.5, color: secondary),
                  ),
                ),
              ],
            ),
    );
  }
}
