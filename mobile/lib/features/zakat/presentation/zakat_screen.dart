import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final _cashController = TextEditingController();
  final _goldController = TextEditingController();
  final _businessController = TextEditingController();
  final _debtController = TextEditingController();

  double _totalNet = 0;
  double _zakatDue = 0;
  bool _calculated = false;

  void _calculateZakat() {
    final cash = double.tryParse(_cashController.text) ?? 0;
    final gold = double.tryParse(_goldController.text) ?? 0;
    final business = double.tryParse(_businessController.text) ?? 0;
    final debt = double.tryParse(_debtController.text) ?? 0;

    final net = (cash + gold + business) - debt;
    setState(() {
      _totalNet = net > 0 ? net : 0;
      _zakatDue = _totalNet * 0.025; // 2.5%
      _calculated = true;
    });
  }

  void _reset() {
    _cashController.clear();
    _goldController.clear();
    _businessController.clear();
    _debtController.clear();
    setState(() {
      _totalNet = 0;
      _zakatDue = 0;
      _calculated = false;
    });
  }

  @override
  void dispose() {
    _cashController.dispose();
    _goldController.dispose();
    _businessController.dispose();
    _debtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "যাকাত ক্যালকুলেটর",
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nisab Notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.amberDark : AppColors.amber.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Text("⚖️", style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "নিসাব পরিমাণ: স্বর্ণ ৭.৫ ভরি (৮৫ গ্রাম) অথবা রূপা ৫২.৫ ভরি (৫৯৫ গ্রাম) সমমূল্যের সম্পদ এক বছর সঞ্চিত থাকলে যাকাত ফরজ হয়।",
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF78350F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Form Inputs
            _buildInputField(
              controller: _cashController,
              label: "নগদ টাকা ও ব্যাংক জমা (৳)",
              hint: "আপনার জমানো নগদ অর্থ",
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildInputField(
              controller: _goldController,
              label: "স্বর্ণ ও রূপার বাজারমূল্য (৳)",
              hint: "স্বর্ণ ও রূপার বর্তমান মূল্য",
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildInputField(
              controller: _businessController,
              label: "ব্যবসায়িক পণ্য ও বিনিয়োগ (৳)",
              hint: "বিক্রয়যোগ্য পণ্যের ক্রয়মূল্য",
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildInputField(
              controller: _debtController,
              label: "জরুরি ঋণ ও দেনা বাদ (৳)",
              hint: "তাৎক্ষণিক প্রদেয় দেনা",
              isDark: isDark,
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _calculateZakat,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "যাকাত হিসাব করুন",
                style: GoogleFonts.hindSiliguri(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Result Card
            if (_calculated)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF064E3B), const Color(0xFF022C22)]
                        : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.emerald.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    Text(
                      "আপনার প্রদেয় যাকাত (২.৫%)",
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : AppColors.emeraldDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "৳ ${BengaliNumerals.toBengali(_zakatDue.toInt())}",
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.emerald,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "মোট যাকাতযোগ্য সম্পদ: ৳ ${BengaliNumerals.toBengali(_totalNet.toInt())}",
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : AppColors.emeraldDark,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.hindSiliguri(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.hindSiliguri(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            filled: true,
            fillColor: isDark ? AppColors.cardDark : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.emerald, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
