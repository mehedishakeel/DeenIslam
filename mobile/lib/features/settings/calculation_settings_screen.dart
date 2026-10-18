import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/reminder_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/calc_config.dart';

/// Calculation method, Asr rule and Hijri-date adjustment. Changes are saved,
/// applied to every screen and used to replace the scheduled alarms.
class CalculationSettingsScreen extends StatefulWidget {
  const CalculationSettingsScreen({super.key});

  @override
  State<CalculationSettingsScreen> createState() => _CalculationSettingsScreenState();
}

class _CalculationSettingsScreenState extends State<CalculationSettingsScreen> {
  CalcConfig _cfg = CalcConfig.current;
  int _hijri = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await StorageService.loadCalcConfig();
    final h = await StorageService.getHijriAdjust();
    if (!mounted) return;
    setState(() {
      _cfg = c;
      _hijri = h;
      _loaded = true;
    });
  }

  Future<void> _save(CalcConfig next) async {
    setState(() => _cfg = next);
    await StorageService.saveCalcConfig(next);
    await ReminderService.instance.rescheduleFromSaved();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(title: Text('গণনা পদ্ধতি', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold))),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'নামাজের সময় আপনার লোকেশনের স্থানাঙ্ক থেকে ডিভাইসেই হিসাব করা হয়। ফজর ও ইশার সূর্যকোণ পদ্ধতিভেদে আলাদা, তাই অন্য টাইমটেবিলের সাথে কয়েক মিনিট পার্থক্য হতে পারে। এখন ব্যবহৃত: ${_cfg.label}।',
                    style: GoogleFonts.hindSiliguri(fontSize: 13, height: 1.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                  child: Text('গণনা পদ্ধতি', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold, color: secondary)),
                ),
                for (final m in CalcMethod.values)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    leading: Icon(
                      _cfg.method == m ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: _cfg.method == m ? AppColors.emerald : secondary,
                    ),
                    title: Text(CalcConfig.methodName(m), style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600)),
                    subtitle: Text(CalcConfig.methodDetail(m),
                        style: GoogleFonts.hindSiliguri(fontSize: 12, height: 1.4, color: secondary)),
                    onTap: () => _save(_cfg.copyWith(method: m)),
                  ),
                const Divider(height: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                  child: Text('আসরের হিসাব', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold, color: secondary)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final e in const [(true, 'হানাফি (ছায়া দ্বিগুণ)'), (false, 'শাফেয়ী/জমহুর (ছায়া সমান)')])
                        ChoiceChip(
                          showCheckmark: false,
                          selected: _cfg.hanafiAsr == e.$1,
                          selectedColor: AppColors.emerald,
                          label: Text(e.$2,
                              style: GoogleFonts.hindSiliguri(
                                  fontWeight: FontWeight.bold, color: _cfg.hanafiAsr == e.$1 ? Colors.white : null)),
                          onSelected: (_) => _save(_cfg.copyWith(hanafiAsr: e.$1)),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 32),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                  child: Text('হিজরি তারিখ সমন্বয়', style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold, color: secondary)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final d in const [-2, -1, 0, 1, 2])
                        ChoiceChip(
                          showCheckmark: false,
                          selected: _hijri == d,
                          selectedColor: AppColors.emerald,
                          label: Text(d == 0 ? 'গণনা অনুযায়ী' : (d > 0 ? '+$d দিন' : '$d দিন'),
                              style: GoogleFonts.hindSiliguri(
                                  fontWeight: FontWeight.bold, color: _hijri == d ? Colors.white : null)),
                          onSelected: (_) async {
                            setState(() => _hijri = d);
                            await StorageService.setHijriAdjust(d);
                            await ReminderService.instance.rescheduleFromSaved();
                          },
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    'হিজরি তারিখ গাণিতিক ক্যালেন্ডার থেকে হিসাব করা; চাঁদ দেখার ওপর নির্ভর করে দেশে দেশে ১-২ দিনের পার্থক্য হয়। আইয়ামে বীযের রিমাইন্ডার এই সমন্বয় মেনে চলে।',
                    style: GoogleFonts.hindSiliguri(fontSize: 12, height: 1.5, color: secondary),
                  ),
                ),
              ],
            ),
    );
  }
}
