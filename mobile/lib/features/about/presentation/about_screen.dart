import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sources = [
      {
        'title': 'আল-কুরআনুল কারীম ও অনুবাদ',
        'desc':
            'AlQuran Cloud API (উসমানী মুসহাফ টেক্সট ও মাওলানা মুহিউদ্দীন খান / তাইসীরুল কুরআন বাংলা অনুবাদ)।',
      },
      {
        'title': 'কুরআন তিলাওয়াত ও আজান অডিও',
        'desc':
            'শাইখ মিশারি রাশিদ আল-আফাসী (EveryAyah & Islamic Network CDN) এবং মক্কা শরীফ হারামাইন আজান।',
      },
      {
        'title': 'হাদিস শরীফ সংকলন',
        'desc':
            'সিহাহ সিত্তাহ ও মুয়াত্তা মালিক (সহীহ বুখারী, মুসলিম, আবু দাউদ, তিরমিযী, নাসাঈ, ইবনে মাজাহ) বাংলা সংস্করণ।',
      },
      {
        'title': 'নামাজ ও সেহরি-ইফতারের সময়সূচি',
        'desc':
            'ইসলামিক ফাউন্ডেশন বাংলাদেশ এবং বাংলাদেশের সকল বিভাগীয় শহরের ভৌগোলিক সময় সমন্বয়।',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'পরিচিতি ও সদকায়ে জারিয়া',
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF065F46), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.mosque, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DeenIslam • দ্বীন ইসলাম',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'সংস্করণ v1.0 • ১০০% বিজ্ঞাপনমুক্ত ও উন্মুক্ত',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'দ্বীন ইসলাম একটি সম্পূর্ণ বিজ্ঞাপনমুক্ত, ট্র্যাকারমুক্ত ও সদকায়ে জারিয়া মূলক ইসলামিক অ্যাপ। কুরআন, সহীহ হাদিস, সালাত, সিয়াম, যাকাত ও নিত্যদিনের সুন্নাহ আমল বাংলাভাষী মুসলিমদের হাতের মুঠোয় পৌঁছে দেওয়াই এর মূল লক্ষ্য।',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.94),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sadaqah Jariyah Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.volunteer_activism, color: AppColors.emerald, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'সদকায়ে জারিয়ায় অংশ নিন',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'রাসূলুল্লাহ (সা.) বলেছেন: "যে ব্যক্তি কাউকে কল্যাণের পথ দেখায়, সে ওই আমলকারীর সমপরিমাণ সওয়াব পায়।" (সহীহ মুসলিম: ১৮৯৩)। অ্যাপটি পরিবার ও বন্ধুদের সাথে শেয়ার করে আপনিও এই সদকায়ে জারিয়ার অংশীদার হতে পারেন।',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        const ClipboardData(
                          text:
                              'DeenIslam (দ্বীন ইসলাম) — কুরআন, সহীহ হাদিস, নামাজের সময়সূচি ও দোয়ার বিজ্ঞাপনমুক্ত ইসলামিক অ্যাপ: https://github.com/mehedishakeel/DeenIslam/releases',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'অ্যাপের লিংক কপি করা হয়েছে! প্রিয়জনদের সাথে শেয়ার করুন।',
                            style: GoogleFonts.hindSiliguri(fontSize: 13),
                          ),
                          backgroundColor: AppColors.emerald,
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
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: Text(
                      'অ্যাপ লিংক কপি ও শেয়ার করুন',
                      style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Authentic Sources
          Text(
            'তথ্যসূত্র ও কৃতজ্ঞতা স্বীকার',
            style: GoogleFonts.hindSiliguri(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 10),
          ...sources.map((s) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
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
                  Text(
                    s['title']!,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 13.8,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s['desc']!,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12.5,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
