import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';

class KalimaScreen extends StatelessWidget {
  const KalimaScreen({super.key});

  static const List<Map<String, String>> _kalimas = [
    {
      'number': '১',
      'title': 'কালিমা তাইয়্যিবাহ',
      'subtitle': 'পবিত্রতার বাণী',
      'arabic': 'لَا إِلَٰهَ إِلَّا اللَّهُ مُحَمَّدٌ رَسُولُ اللَّهِ',
      'pronunciation': 'লা ইলাহা ইল্লাল্লাহু মুহাম্মাদুর রাসূলুল্লাহ।',
      'meaning': 'আল্লাহ ছাড়া কোনো সত্য উপাস্য নেই, হযরত মুহাম্মাদ (সা.) আল্লাহর প্রেরিত রাসূল।',
    },
    {
      'number': '২',
      'title': 'কালিমা শাহাদাত',
      'subtitle': 'সাক্ষ্যদানের বাণী',
      'arabic': 'أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      'pronunciation': 'আশহাদু আল লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারীকা লাহু, ওয়া আশহাদু আন্না মুহাম্মাদান আবদুহু ওয়া রাসূলুহু।',
      'meaning': 'আমি সাক্ষ্য দিচ্ছি যে, আল্লাহ ছাড়া কোনো মাবুদ নেই, তিনি এক ও অদ্বিতীয়, তাঁর কোনো শরীক নেই। আমি আরও সাক্ষ্য দিচ্ছি যে, মুহাম্মাদ (সা.) তাঁর বান্দা ও রাসূল।',
    },
    {
      'number': '৩',
      'title': 'কালিমা তামজীদ',
      'subtitle': 'মহিমা ও প্রশংসার বাণী',
      'arabic': 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَٰهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ',
      'pronunciation': 'সুবহানাল্লাহি ওয়ালহামদুলিল্লাহি ওয়া লা ইলাহা ইল্লাল্লাহু ওয়াল্লাহু আকবার, ওয়া লা হাওলা ওয়া লা কুওয়াতা ইল্লা বিল্লাহিল আলিয়্যিল আযীম।',
      'meaning': 'মহিমান্বিত আল্লাহ, সমস্ত প্রশংসা আল্লাহর জন্য, আল্লাহ ছাড়া কোনো মাবুদ নেই, আল্লাহ সর্বশ্রেষ্ঠ। সুউচ্চ ও মহান আল্লাহর সাহায্য ছাড়া পাপ থেকে বাঁচার ও নেক কাজ করার কোনো শক্তি নেই।',
    },
    {
      'number': '৪',
      'title': 'কালিমা তাওহীদ',
      'subtitle': 'একত্ববাদের বাণী',
      'arabic': 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لَا يَمُوتُ أَبَدًا أَبَدًا ذُو الْجَلَالِ وَالْإِكْرَامِ بِيَدِهِ الْخَيْرُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
      'pronunciation': 'লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারীকা লাহু, লাহুল মুলকু ওয়া লাহুল হামদু, ইউহয়ী ওয়া ইউমীতু ওয়া হুয়া হাইয়্যুল লা ইয়ামূতু আবাদান আবাদা, যুল জালালি ওয়াল ইকরাম, বিয়াদিহিল খাইরু ওয়া হুয়া আলা কুল্লি শাইয়িন কাদীর।',
      'meaning': 'আল্লাহ ছাড়া কোনো মাবুদ নেই, তিনি এক ও অদ্বিতীয়। রাজত্ব তাঁরই এবং প্রশংসা তাঁরই। তিনিই জীবন দান করেন ও মৃত্যু ঘটান। তিনি চিরঞ্জীব, কখনোই মৃত্যুবরণ করবেন না। তিনি মহামহিমান্বিত ও দাতা। সকল কল্যাণ তাঁরই হাতে এবং তিনি সর্ববিষয়ে সর্বশক্তিমান।',
    },
    {
      'number': '৫',
      'title': 'ঈমানে মুজমাল',
      'subtitle': 'সংক্ষিপ্ত ঈমানের ঘোষণা',
      'arabic': 'آمَنْتُ بِاللَّهِ كَمَا هُوَ بِأَسْمَائِهِ وَصِفَاتِهِ وَقَبِلْتُ جَمِيعَ أَحْكَامِهِ إِقْرَارٌ بِاللِّسَانِ وَتَصْدِيقٌ بِالْقَلْبِ',
      'pronunciation': 'আমানতু বিল্লাহি কামা হুয়া বিআসমাইহি ওয়া সিফাতিহি ওয়া কাবিলতু জামীআ আহকামিহি ইকরারুম বিল লিসানি ওয়া তাসদীকুম বিল কালব।',
      'meaning': 'আমি আল্লাহ তাআলার ওপর ঈমান আনলাম ঠিক তেমনভাবে, যেমনভাবে তিনি তাঁর নামসমূহ ও গুণাবলীর সাথে বিদ্যমান আছেন এবং আমি তাঁর সকল বিধানকে মুখে স্বীকার ও অন্তরে বিশ্বাস করে কবুল করে নিলাম।',
    },
    {
      'number': '৬',
      'title': 'ঈমানে মুফাসসাল',
      'subtitle': 'বিস্তারিত ঈমানের ঘোষণা',
      'arabic': 'آمَنْتُ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الْآخِرِ وَالْقَدْرِ خَيْرِهِ وَشَرِّهِ مِنَ اللَّهِ تَعَالَىٰ وَالْبَعْثِ بَعْدَ الْمَوْتِ',
      'pronunciation': 'আমানতু বিল্লাহি ওয়া মালাইকাতিহি ওয়া কুতুবিহি ওয়া রুসুলিহি ওয়াল ইয়াওমিল আখিরি ওয়াল কাদরি খাইরিহি ওয়া শাররিহি মিনাল্লাহি তাআলা ওয়াল বা’সি বা’দাল মাওত।',
      'meaning': 'আমি ঈমান আনলাম আল্লাহর ওপর, তাঁর ফেরেশতাগণের ওপর, তাঁর আসমানী কিতাবসমূহের ওপর, তাঁর রাসূলগণের ওপর, শেষ দিবসের (কিয়ামত) ওপর এবং ভালো-মন্দ তাকদীর আল্লাহ তাআলার পক্ষ থেকে হওয়ার ওপর এবং মৃত্যুর পর পুনরুত্থানের ওপর।',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'কালিমা ও ঈমান শিক্ষা',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _kalimas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _kalimas[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoft,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            item['number'] ?? BengaliNumerals.convert(index + 1),
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']!,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              item['subtitle']!,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 11.5,
                                color: AppColors.emerald,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        final copy = '${item['title']}\n\n${item['arabic']}\n\nউচ্চারণ: ${item['pronunciation']}\n\nঅর্থ: ${item['meaning']}';
                        Clipboard.setData(ClipboardData(text: copy));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${item['title']} কপি করা হয়েছে',
                              style: GoogleFonts.hindSiliguri(fontSize: 13),
                            ),
                            duration: const Duration(seconds: 1),
                            backgroundColor: AppColors.emerald,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy_outlined, size: 18),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text(
                  item['arabic']!,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    height: 2.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Text(
                    'উচ্চারণ: ${item['pronunciation']}',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.amberDark,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'অর্থ: ${item['meaning']}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13.5,
                    height: 1.55,
                    color: isDark ? Colors.white.withOpacity(0.9) : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
