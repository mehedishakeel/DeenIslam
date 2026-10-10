import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  int _target = 33;
  int _totalCount = 0;
  int _selectedZikrIndex = 0;

  final List<Map<String, String>> _zikrs = [
    {'ar': 'سُبْحَانَ اللَّهِ', 'bn': 'সুবহানাল্লাহ', 'meaning': 'আল্লাহ মহাপবিত্র'},
    {'ar': 'الْحَمْدُ لِلَّهِ', 'bn': 'আলহামদুলিল্লাহ', 'meaning': 'সকল প্রশংসা আল্লাহর'},
    {'ar': 'اللَّهُ أَكْبَرُ', 'bn': 'আল্লাহু আকবার', 'meaning': 'আল্লাহ সর্বশ্রেষ্ঠ'},
    {'ar': 'لَا إِلَٰهَ إِلَّا اللَّهُ', 'bn': 'লা ইলাহা ইল্লাল্লাহ', 'meaning': 'আল্লাহ ছাড়া কোনো উপাস্য নেই'},
    {'ar': 'أَسْتَغْفِرُ اللَّهَ', 'bn': 'আস্তাগফিরুল্লাহ', 'meaning': 'আমি আল্লাহর কাছে ক্ষমা চাই'},
  ];

  void _increment() {
    setState(() {
      _counter++;
      _totalCount++;
      if (_target > 0 && _counter > _target) {
        _counter = 1;
      }
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final zikr = _zikrs[_selectedZikrIndex];
    final progress = _target > 0 ? (_counter / _target).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ডিজিটাল তাসবীহ",
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "রিসেট করুন",
            onPressed: _reset,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Zikr Selector Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    zikr['ar']!,
                    style: GoogleFonts.amiri(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.amber,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    zikr['bn']!,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    zikr['meaning']!,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    children: List.generate(_zikrs.length, (index) {
                      final isSelected = _selectedZikrIndex == index;
                      return ChoiceChip(
                        label: Text(
                          _zikrs[index]['bn']!,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.emerald,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedZikrIndex = index;
                              _counter = 0;
                            });
                          }
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Target Selector Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [33, 99, 100].map((t) {
                final isSelected = _target == t;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text("${BengaliNumerals.toBengali(t)} বার"),
                    selected: isSelected,
                    selectedColor: AppColors.emeraldSoft,
                    checkmarkColor: AppColors.emerald,
                    onSelected: (val) {
                      setState(() {
                        _target = t;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Big Interactive Circular Counter
            GestureDetector(
              onTap: _increment,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.cardDark : Colors.white,
                  border: Border.all(
                    color: AppColors.emerald.withOpacity(0.4),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emerald.withOpacity(isDark ? 0.2 : 0.1),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 210,
                      height: 210,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emerald),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          BengaliNumerals.toBengali(_counter),
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          "লক্ষ্য: ${BengaliNumerals.toBengali(_target)} বার",
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "গণনা করতে বৃত্তে স্পর্শ করুন",
              style: GoogleFonts.hindSiliguri(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Text(
                "আজকের সর্বমোট গণনা: ${BengaliNumerals.toBengali(_totalCount)} বার",
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
