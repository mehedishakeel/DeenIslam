import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theme/app_colors.dart';

class ArticlesMediaScreen extends StatefulWidget {
  const ArticlesMediaScreen({super.key});

  @override
  State<ArticlesMediaScreen> createState() => _ArticlesMediaScreenState();
}

class _ArticlesMediaScreenState extends State<ArticlesMediaScreen> {
  String? _playingAudioId;

  static const List<Map<String, String>> _articles = [
    {
      'category': 'আকীদাহ ও তাওহীদ',
      'readTime': '৫ মিনিট পাঠ',
      'title': 'তাওহীদের প্রকৃত অর্থ ও মুমিন জীবনে এর গুরুত্ব',
      'summary':
          'ইসলামের সর্বপ্রথম ও সর্বপ্রধান ভিত্তি হলো তাওহীদ বা আল্লাহর একত্ববাদ। তাওহীদে রুবুবিয়্যাহ, উলুহিয়্যাহ এবং আসমা ওয়াস সিফাতের সংক্ষিপ্ত ও প্রামাণ্য আলোচনা।',
      'quote':
          '“আমি জিন ও মানবজাতিকে কেবল আমার ইবাদতের জন্যই সৃষ্টি করেছি।” — সূরা আয-যারিয়াত: ৫৬',
      'body': '''ইসলামের মূল ভিত্তি হলো ‘তাওহীদ’ বা মহান আল্লাহর একত্ববাদে অবিচল বিশ্বাস। তাওহীদ শব্দের আভিধানিক অর্থ কোনো কিছুকে এক বলে জানা ও ঘোষণা করা। শরীয়তের পরিভাষায়— মহান আল্লাহকে তাঁর সত্তা, রুবুবিয়্যাত (প্রতিপালন), উলুহিয়্যাত (ইবাদত) এবং সুন্দর নাম ও গুণাবলীতে এক ও অদ্বিতীয় হিসেবে বিশ্বাস করার নামই তাওহীদ।

১. তাওহীদে রুবুবিয়্যাহ:
এই বিশ্বাস রাখা যে, মহান আল্লাহই একমাত্র স্রষ্টা, রিযিকদাতা, জীবন ও মৃত্যুদাতা এবং বিশ্বজগতের একমাত্র পরিচালক।

২. তাওহীদে উলুহিয়্যাহ (ইবাদতের তাওহীদ):
সালাত, সিয়াম, দোয়া, তাওয়াক্কুল, ভয় ও আশা—সকল প্রকার ইবাদত একমাত্র আল্লাহর জন্য নিবেদিত করা। আল্লাহ ছাড়া অন্য কারো কাছে বিপদমুক্তির প্রার্থনা বা সিজদা করা শিরক।

৩. তাওহীদে আসমা ওয়াস সিফাত:
কুরআন ও সহীহ হাদিসে মহান আল্লাহর যেসব সুন্দর নাম ও গুণাবলী বর্ণিত হয়েছে, সেগুলোকে কোনো রূপ বিকৃতি বা তুলনা ছাড়াই বিশ্বাস করা।

মুমিন জীবনে তাওহীদের প্রভাব:
বিশুদ্ধ তাওহীদ মানুষকে সৃষ্টিজগতের গোলামী থেকে মুক্ত করে একমাত্র স্রষ্টার গোলামে পরিণত করে। এতে হৃদয়ে প্রশান্তি, সাহসিকতা ও তাকওয়া সৃষ্টি হয় এবং পরকালে জাহান্নাম থেকে মুক্তির গ্যারান্টি মেলে।''',
    },
    {
      'category': 'সীরাতুন্নবী (সা.)',
      'readTime': '৬ মিনিট পাঠ',
      'title': 'রাসূলুল্লাহ (সা.)-এর পবিত্র সীরাত: মানবতার সর্বোত্তম আদর্শ',
      'summary':
          'ব্যক্তি, পরিবার, সমাজ ও রাষ্ট্র—জীবনের প্রতিটি ক্ষেত্রে রাসূলুল্লাহ (সা.)-এর সুন্নাহ ও আদর্শ কেন আমাদের একমাত্র আলোকবর্তিকা।',
      'quote':
          '“নিশ্চয়ই তোমাদের জন্য রাসূলুল্লাহর মধ্যে রয়েছে উত্তম আদর্শ।” — সূরা আল-আহযাব: ২১',
      'body': '''মানব ইতিহাসের সর্বশ্রেষ্ঠ মহামানব হলেন সাইয়্যিদুল মুরসালীন মুহাম্মাদুর রাসূলুল্লাহ (সা.)। মহান আল্লাহ তাঁকে সমগ্র বিশ্বজগতের জন্য রহমতস্বরূপ (‘রাহমাতুল্লিল আলামীন’) প্রেরণ করেছেন।

সত্যবাদিতা ও আমানতদারিতা:
নবুওয়াত লাভের পূর্ব থেকেই মক্কার মানুষ তাঁকে ‘আল-আমীন’ (বিশ্বস্ত) ও ‘আস-সাদিক’ (সত্যবাদী) উপাধিতে ভূষিত করেছিল। চরম শত্রুরাও তাঁর কাছে আমানত গচ্ছিত রাখত।

ক্ষমা ও উদারতা:
মক্কা বিজয়ের দিন দীর্ঘ তেইশ বছরের অত্যাচারী শত্রুদের হাতের মুঠোয় পেয়েও তিনি ঘোষণা করেছিলেন— “আজ তোমাদের বিরুদ্ধে কোনো অভিযোগ নেই, তোমরা সবাই মুক্ত।”

পারিবারিক ও সামাজিক জীবন:
তিনি নিজে ঘরের কাজে সাহায্য করতেন, নিজের জুতা ও কাপড় সেলাই করতেন, এতিম ও অসহায়দের খোঁজ নিতেন এবং ছোটদের আগে সালাম দিতেন। তাঁর সুন্নাহর অনুসরণই আল্লাহর ভালোবাসা অর্জনের একমাত্র পথ (সূরা আলে ইমরান: ৩১)।''',
    },
    {
      'category': 'উলুমুল কুরআন',
      'readTime': '৫ মিনিট পাঠ',
      'title': 'আল-কুরআন অনুধাবন (তাদাব্বুর) ও তিলাওয়াতের আদব',
      'summary':
          'পবিত্র কুরআন কেবল তিলাওয়াতের জন্য নয়, বরং এর অর্থ বোঝা, চিন্তা-ভাবনা করা এবং বাস্তব জীবনে আমল করার নির্দেশিকা।',
      'quote':
          '“তবে কি তারা কুরআন নিয়ে গভীর চিন্তা-ভাবনা করে না?” — সূরা মুহাম্মাদ: ২৪',
      'body': '''আল-কুরআনুল কারীম হলো মানবজাতির হিদায়াতের জন্য নাযিলকৃত মহান আল্লাহর সর্বশেষ কালাম। কুরআনের সাথে একজন মুমিনের সম্পর্ক ৫টি স্তরে হওয়া আবশ্যক:

১. বিশুদ্ধ তিলাওয়াত: তাজবীদসহ ধীরস্থিরভাবে (তারতীলের সাথে) কুরআন তিলাওয়াত করা। প্রতিটি হরফে ১০টি করে নেকি পাওয়া যায়।
২. অর্থ অনুধাবন ও তাদাব্বুর: আল্লাহ কী আদেশ করছেন এবং কী নিষেধ করছেন তা মাতৃভাষায় অনুবাদ ও তাফসীরের মাধ্যমে বোঝা।
৩. আমল বা বাস্তবায়ন: কুরআনের আদেশ মান্য করা এবং নিষিদ্ধ বিষয় বর্জন করা।
৪. মুখস্থ করা: সালাতে পাঠের জন্য নিয়মিত সূরা ও আয়াত হিফয করা।
৫. দাওয়াত ও প্রচার: “তোমাদের মধ্যে সর্বোত্তম ঐ ব্যক্তি যে নিজে কুরআন শেখে এবং অন্যকে শেখায়।” (সহীহ বুখারী: ৫০২৭)''',
    },
    {
      'category': 'আখলাক ও চরিত্র',
      'readTime': '৪ মিনিট পাঠ',
      'title': 'ইসলামে উত্তম চরিত্র (হুসনুল খুলুক) ও সদাচরণের মর্যাদা',
      'summary':
          'কিয়ামতের দিন মুমিনের পাল্লায় উত্তম চরিত্রের চেয়ে ভারী আর কোনো আমল হবে না। প্রতিবেশী, পিতা-মাতা ও মানুষের সাথে আচরণের ইসলামী নীতি।',
      'quote':
          '“কিয়ামতের দিন মুমিনের মিযানে উত্তম চরিত্রের চেয়ে ভারী আর কিছু হবে না।” — সুনান তিরমিযী: ২০০২',
      'body': '''ইসলাম কেবল কিছু আনুষ্ঠানিক ইবাদতের নাম নয়; বরং ইবাদতের মূল লক্ষ্যই হলো মানুষের চরিত্র ও আখলাককে পরিশুদ্ধ করা। রাসূলুল্লাহ (সা.) বলেছেন— “উত্তম চরিত্রের পূর্ণতা দানের জন্যই আমাকে প্রেরণ করা হয়েছে।”

উত্তম চরিত্রের প্রধান দিকসমূহ:
• পিতা-মাতার প্রতি সদাচরণ এবং তাঁদের সামনে ‘উফ’ শব্দটিও না বলা।
• কথায় ও কাজে সত্যবাদিতা বজায় রাখা এবং ওয়াদা পালন করা।
• ক্রোধ সংবরণ করা ও মানুষকে ক্ষমা করা।
• হিংসা, গীবত (পরনিন্দা), অহংকার ও মিথ্যা অপবাদ থেকে জবানকে হেফাজত করা।
• হাসিমুখে কথা বলা—কারণ মুসলিম ভাইয়ের সাথে হাসিমুখে সাক্ষাৎ করাও সদকা।''',
    },
    {
      'category': 'আখিরাত ও আত্মশুদ্ধি',
      'readTime': '৫ মিনিট পাঠ',
      'title': 'আখিরাতের অনন্ত জীবন ও বুদ্ধিমান মুমিনের প্রস্তুতি',
      'summary':
          'দুনিয়ার ক্ষণস্থায়ী জীবন আখিরাতের শস্যক্ষেত্র। মৃত্যু, কবর, হাশর ও মিযানের স্মরণ যেভাবে মানুষকে গুনাহ থেকে বাঁচিয়ে রাখে।',
      'quote':
          '“প্রত্যেক প্রাণীকেই মৃত্যুর স্বাদ গ্রহণ করতে হবে।” — সূরা আলে ইমরান: ১৮৫',
      'body': '''দুনিয়ার জীবন অত্যন্ত সংক্ষিপ্ত এবং পরীক্ষার স্থান। পক্ষান্তরে আখিরাতের জীবন চিরস্থায়ী, যার কোনো শেষ নেই। রাসূলুল্লাহ (সা.) বলেছেন— “দুনিয়াতে এমনভাবে বসবাস করো যেন তুমি একজন মুসাফির কিংবা পথিক।” (সহীহ বুখারী)

আখিরাতের প্রস্তুতির ৪টি পাথেয়:
১. খাঁটি তওবা ও ইস্তিগফার: প্রতিদিন ঘুমানোর পূর্বে নিজের কৃতকর্মের হিসাব নেওয়া (মুহাসাবা) এবং গুনাহের জন্য আল্লাহর কাছে ক্ষমা চাওয়া।
২. ফরজ ইবাদতে যত্নবান হওয়া: বিশেষ করে পাঁচ ওয়াক্ত সালাত, কারণ কিয়ামতের দিন সর্বপ্রথম সালাতের হিসাব নেওয়া হবে।
৩. বান্দার হক আদায় করা: কারো সম্পদ বা সম্মানে আঘাত দিয়ে থাকলে দুনিয়াতেই ক্ষমা চেয়ে নেওয়া।
৪. সদকায়ে জারিয়া: এমন নেক আমল রেখে যাওয়া যার সওয়াব মৃত্যুর পরও কবরে পৌঁছাতে থাকে।''',
    },
    {
      'category': 'ইসলামী অর্থনীতি',
      'readTime': '৫ মিনিট পাঠ',
      'title': 'যাকাত ও সদকা: সম্পদ পবিত্রকরণ ও দারিদ্র্য বিমোচনের হাতিয়ার',
      'summary':
          'যাকাত ধনীর অনুগ্রহ নয়, বরং দরিদ্রের নির্ধারিত অধিকার। যাকাত ও গোপন সদকার মাধ্যমে সম্পদে বরকত ও সমাজে ভারসাম্য প্রতিষ্ঠা।',
      'quote':
          '“তাদের সম্পদে প্রার্থনাকারী ও বঞ্চিতদের নির্ধারিত অধিকার রয়েছে।” — সূরা আয-যারিয়াত: ১৯',
      'body': '''পবিত্র কুরআনে বিরাশি (৮২) স্থানে সালাতের পাশাপাশি যাকাত আদায়ের নির্দেশ দেওয়া হয়েছে। ‘যাকাত’ শব্দের অর্থ পবিত্রতা ও বৃদ্ধি। নিসাব পরিমাণ সম্পদ পূর্ণ এক চান্দ্র বছর স্থায়ী হলে ২.৫% (চল্লিশ ভাগের এক ভাগ) যাকাত প্রদান করা ফরজ।

যাকাত ও সদকার ফযিলত:
• সম্পদ পবিত্র হয় এবং অদৃশ্য বিপদ-আপদ থেকে রক্ষা পায়।
• সমাজে ধনী-দরিদ্রের বৈষম্য দূর হয় এবং ভ্রাতৃত্ব সুদৃঢ় হয়।
• গোপনে সদকা করলে মহান আল্লাহর ক্রোধ প্রশমিত হয় এবং কিয়ামতের দিন আরশের ছায়ায় স্থান পাওয়া যায়।
• রাসূলুল্লাহ (সা.) বলেছেন: “দান-সদকা দ্বারা কখনো সম্পদ কমে না।” (সহীহ মুসলিম: ২৫৮৮)''',
    },
  ];

  static const List<Map<String, String>> _audioTracks = [
    {
      'id': 'fatiha',
      'title': 'সূরা আল-ফাতিহা (পূর্ণ তিলাওয়াত - ১ম আয়াত)',
      'subtitle': 'ক্বারী মিশারি রাশিদ আল-আফাসী • মক্কী সূরা',
      'url': 'https://everyayah.com/data/Alafasy_128kbps/001001.mp3',
    },
    {
      'id': 'kursi',
      'title': 'আয়াতুল কুরসী (সূরা আল-বাকারা: ২৫৫)',
      'subtitle': 'ক্বারী মিশারি রাশিদ আল-আফাসী • সর্বশ্রেষ্ঠ আয়াত',
      'url': 'https://everyayah.com/data/Alafasy_128kbps/002255.mp3',
    },
    {
      'id': 'baqarah_last',
      'title': 'সূরা আল-বাকারার শেষ ২ আয়াত (২৮৫-২৮৬)',
      'subtitle': 'ক্বারী মিশারি রাশিদ আল-আফাসী • রাতের আমল',
      'url': 'https://everyayah.com/data/Alafasy_128kbps/002285.mp3',
    },
    {
      'id': 'ikhlas',
      'title': 'সূরা আল-ইখলাস (কুল হুওয়াল্লাহু আহাদ)',
      'subtitle': 'ক্বারী মিশারি রাশিদ আল-আফাসী • কুরআনের এক-তৃতীয়াংশ',
      'url': 'https://everyayah.com/data/Alafasy_128kbps/112001.mp3',
    },
    {
      'id': 'falaq',
      'title': 'সূরা আল-ফালাক (নিরাপত্তার সূরা)',
      'subtitle': 'ক্বারী মিশারি রাশিদ আল-আফাসী • সকাল-সন্ধ্যার আমল',
      'url': 'https://everyayah.com/data/Alafasy_128kbps/113001.mp3',
    },
    {
      'id': 'nas',
      'title': 'সূরা আন-নাস (কুমন্ত্রণা থেকে আশ্রয়)',
      'subtitle': 'ক্বারী মিশারি রাশিদ আল-আফাসী • সকাল-সন্ধ্যার আমল',
      'url': 'https://everyayah.com/data/Alafasy_128kbps/114001.mp3',
    },
    {
      'id': 'azan_makkah',
      'title': 'মক্কা শরীফের সুমধুর আজান (হারামাইন)',
      'subtitle': 'মসজিদুল হারাম • আজান ধ্বনি',
      'url': 'https://www.islamcan.com/audio/adhan/azan1.mp3',
    },
  ];

  @override
  void dispose() {
    AudioService.instance.stop();
    super.dispose();
  }

  Future<void> _toggleTrack(Map<String, String> track) async {
    final id = track['id']!;
    if (_playingAudioId == id) {
      await AudioService.instance.stop();
      if (!mounted) return;
      setState(() => _playingAudioId = null);
      return;
    }

    setState(() => _playingAudioId = id);
    await AudioService.instance.playUrl(
      track['url']!,
      onCompleted: () {
        if (!mounted) return;
        setState(() => _playingAudioId = null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'প্রবন্ধ ও অডিও মিডিয়া',
            style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: AppColors.emerald,
            unselectedLabelColor:
                isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            indicatorColor: AppColors.emerald,
            labelStyle: GoogleFonts.hindSiliguri(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'ইসলামিক প্রবন্ধ (৬টি)'),
              Tab(text: 'কুরআন ও আজান অডিও'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildArticlesTab(context, isDark),
            _buildAudioTab(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesTab(BuildContext context, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        final article = _articles[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _openArticleReader(context, article, isDark),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article['category']!,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.emerald,
                          ),
                        ),
                      ),
                      Text(
                        article['readTime']!,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 11.5,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article['title']!,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article['summary']!,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12.8,
                      height: 1.45,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'সম্পূর্ণ প্রবন্ধ পড়ুন',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: AppColors.emerald,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openArticleReader(
    BuildContext context,
    Map<String, String> article,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.86,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        article['category']!,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text:
                                    '${article['title']}\n\n${article['quote']}\n\n${article['body']}',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'প্রবন্ধটি কপি করা হয়েছে',
                                  style: GoogleFonts.hindSiliguri(fontSize: 13),
                                ),
                                backgroundColor: AppColors.emerald,
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, size: 18),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  article['title']!,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: const Border(
                      left: BorderSide(color: AppColors.emerald, width: 4),
                    ),
                  ),
                  child: Text(
                    article['quote']!,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  article['body']!,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 14.5,
                    height: 1.65,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAudioTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _audioTracks.length,
      itemBuilder: (context, index) {
        final track = _audioTracks[index];
        final isPlaying = _playingAudioId == track['id'];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPlaying
                  ? AppColors.emerald
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: isPlaying ? 1.6 : 1.0,
            ),
          ),
          child: Row(
            children: [
              IconButton.filled(
                onPressed: () => _toggleTrack(track),
                style: IconButton.styleFrom(
                  backgroundColor: isPlaying ? Colors.redAccent : AppColors.emerald,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track['title']!,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isPlaying ? 'অডিও স্ট্রিম প্লে হচ্ছে...' : track['subtitle']!,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 12,
                        color: isPlaying
                            ? AppColors.emerald
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
