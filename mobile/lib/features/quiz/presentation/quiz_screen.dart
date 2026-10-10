import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int _highScore = 0;
  int? _selectedOption;
  bool _quizCompleted = false;

  static const List<Map<String, dynamic>> _questions = [
    {
      'q': 'পবিত্র কুরআনের সর্বপ্রথম নাযিলকৃত সূরা কোনটি এবং এর প্রথম শব্দ কী?',
      'options': [
        'সূরা আল-ফাতিহা (আলহামদুলিল্লাহ)',
        'সূরা আল-আলাক (ইকরা - পড়ো)',
        'সূরা আল-মুদ্দাসসির (ইয়া আইয়্যুহাল মুদ্দাসসির)',
        'সূরা আল-বাকারা (আলিফ-লাম-মীম)',
      ],
      'answer': 1,
      'explanation':
          'হেরা গুহায় জিবরাঈল (আ.)-এর মাধ্যমে সর্বপ্রথম সূরা আল-আলাকের প্রথম ৫টি আয়াত নাযিল হয়, যার প্রথম শব্দ "ইকরা" (পড়ো)।',
    },
    {
      'q': 'পবিত্র কুরআনের কোন সূরাকে "কুরআনের হৃদয়" (কলবুল কুরআন) বলা হয়েছে?',
      'options': [
        'সূরা আর-রাহমান',
        'সূরা আল-মুলক',
        'সূরা ইয়াসীন',
        'সূরা আল-কাহফ',
      ],
      'answer': 2,
      'explanation': 'হাদিস শরীফে সূরা ইয়াসীনকে কুরআনের হৃদয় হিসেবে উল্লেখ করা হয়েছে এবং সূরা আল-ফাতিহাকে উম্মুল কুরআন বলা হয়।',
    },
    {
      'q': 'ইসলামের ইতিহাসে সর্বপ্রথম মুয়াজ্জিন কে ছিলেন?',
      'options': [
        'হযরত আবু বকর সিদ্দিক (রা.)',
        'হযরত আম্মার ইবনে ইয়াসির (রা.)',
        'হযরত বিলাল ইবনে রাবাহ (রা.)',
        'হযরত আব্দুল্লাহ ইবনে উম্মে মাকতুম (রা.)',
      ],
      'answer': 2,
      'explanation':
          'রাসূলুল্লাহ (সা.)-এর নির্দেশে হযরত বিলাল ইবনে রাবাহ (রা.) মদিনায় সর্বপ্রথম আজান প্রদান করেন।',
    },
    {
      'q': 'পবিত্র কুরআনের সবচেয়ে মর্যাদাপূর্ণ আয়াত "আয়াতুল কুরসী" কোন সূরায় অবস্থিত?',
      'options': [
        'সূরা আলে ইমরান, আয়াত ১৮',
        'সূরা আল-বাকারা, আয়াত ২৫৫',
        'সূরা আল-বাকারা, আয়াত ২৮৫',
        'সূরা আন-নিসা, আয়াত ৩৬',
      ],
      'answer': 1,
      'explanation':
          'সূরা আল-বাকারার ২৫৫ নম্বর আয়াতটি হলো আয়াতুল কুরসী। সহীহ হাদিসে এটিকে কুরআনের সর্বশ্রেষ্ঠ আয়াত বলা হয়েছে।',
    },
    {
      'q': 'পাঁচ ওয়াক্ত সালাত কোন রাতে উম্মতে মুহাম্মাদীর ওপর ফরজ হয়?',
      'options': [
        'লাইলাতুল কদরের রাতে',
        'হিজরতের রাতে',
        'মিরাজের রাতে (ইসরা ও মিরাজ)',
        'বদর যুদ্ধের আগের রাতে',
      ],
      'answer': 2,
      'explanation':
          'মিরাজের রজনীতে মহান আল্লাহ সরাসরি রাসূলুল্লাহ (সা.)-কে পাঁচ ওয়াক্ত সালাত উপহার দেন, যার সওয়াব পঞ্চাশ ওয়াক্তের সমান।',
    },
    {
      'q': 'স্বর্ণের যাকাতের নিসাব পরিমাণ কত?',
      'options': [
        '৫ ভরি স্বর্ণ',
        '৭.৫ ভরি (সাড়ে সাত তোলা / ৮৭.৪৮ গ্রাম) স্বর্ণ',
        '১০ ভরি স্বর্ণ',
        '৫২.৫ ভরি স্বর্ণ',
      ],
      'answer': 1,
      'explanation':
          'স্বর্ণের নিসাব ৭.৫ ভরি (৮৭.৪৮ গ্রাম) এবং রৌপ্যের নিসাব ৫২.৫ ভরি (৬১২.৩৬ গ্রাম)। এক চান্দ্র বছর পূর্ণ হলে ২.৫% যাকাত ফরজ হয়।',
    },
    {
      'q': 'পবিত্র কুরআনে মোট কতজন নবী ও রাসূলের নাম প্রত্যক্ষভাবে উল্লেখ করা হয়েছে?',
      'options': [
        '১৮ জন',
        '২৫ জন',
        '৪০ জন',
        '৭০ জন',
      ],
      'answer': 1,
      'explanation':
          'পবিত্র কুরআনে ২৫ জন নবী-রাসূলের নাম সরাসরি উল্লেখ রয়েছে, যাঁদের মধ্যে প্রথম আদম (আ.) এবং সর্বশেষ মুহাম্মাদ (সা.)।',
    },
    {
      'q': 'হজ্জের সবচেয়ে প্রধান ফরজ (রুকন) কোনটি?',
      'options': [
        'মদিনা শরীফ যিয়ারত করা',
        '৯ জিলহজ্জ আরাফাতের ময়দানে অবস্থান করা',
        'পাথর নিক্ষেপ করা',
        'মিনায় রাত্রিযাপন করা',
      ],
      'answer': 1,
      'explanation':
          'রাসূলুল্লাহ (সা.) বলেছেন: "আল-হজ্জু আরাফাহ" অর্থাৎ আরাফাতের ময়দানে অবস্থান করাই হলো হজ্জের মূল স্তম্ভ।',
    },
  ];

  static const List<Map<String, String>> _faqs = [
    {
      'q': '১. নামাজে ভুল হলে সাহু সিজদা দেওয়ার নিয়ম কী?',
      'a':
          'নামাজের কোনো ওয়াজিব ভুলবশত ছুটে গেলে বা বিলম্ব হলে শেষ বৈঠকে কেবল তাশাহহুদ (আত্তাহিয়্যাতু) পড়ে ডান দিকে এক সালাম ফিরিয়ে দুটি সিজদা করতে হয়। এরপর পুনরায় তাশাহহুদ, দরুদ শরীফ ও দোয়া মাসুরা পড়ে উভয় দিকে সালাম ফিরিয়ে নামাজ শেষ করতে হয়।',
    },
    {
      'q': '২. ছুটে যাওয়া (কাজা) নামাজ আদায়ের বিধান কী?',
      'a':
          'ঘুম বা ভুলে যাওয়ার কারণে কোনো ফরজ বা ওয়াজিব (বিতর) নামাজ ছুটে গেলে স্মরণ হওয়া মাত্রই বা সুবিধাজনক সময়ে (তিনটি নিষিদ্ধ সময় বাদে) তা কাজা পড়ে নেওয়া ফরজ। সুন্নাত নামাজের সাধারণত কাজা হয় না, তবে ফজরের সুন্নাত ফরজের সাথে ছুটে গেলে সূর্য ওঠার পর দুপুরের আগে পড়ে নেওয়া উত্তম।',
    },
    {
      'q': '৩. মোবাইলে অজু ছাড়া কুরআন শরীফ পড়া যাবে কি?',
      'a':
          'ছাপানো মুসহাফ (কুরআন শরীফ) স্পর্শ করার জন্য অজু থাকা শর্ত। তবে মোবাইল স্ক্রিনে দেখে বা মুখস্থ কুরআন তিলাওয়াত অজু ছাড়াও করা জায়েয আছে; যদিও অজু অবস্থায় তিলাওয়াত করা অধিক আদব ও সওয়াবের কাজ।',
    },
    {
      'q': '৪. চাকরিজীবীদের বেতনের টাকার ওপর কীভাবে যাকাত হিসাব করতে হবে?',
      'a':
          'মাসিক বেতন থেকে সংসারের যাবতীয় খরচ বাদ দিয়ে যা সঞ্চয় থাকে, তা যদি নিসাব পরিমাণ (৫২.৫ ভরি রুপার সমমূল্য) পৌঁছে এবং সেই নিসাবের ওপর পূর্ণ এক চান্দ্র বছর (হিজরি বছর) অতিবাহিত হয়, তবে বছর শেষে মোট জমাকৃত অর্থের ২.৫% যাকাত দিতে হবে।',
    },
    {
      'q': '৫. মৃত পিতা-মাতার জন্য সন্তানের সবচেয়ে উত্তম আমল কী?',
      'a':
          'হাদিস অনুযায়ী মৃত পিতা-মাতার জন্য সন্তানের সেরা আমল হলো: ১. তাঁদের জন্য নিয়মিত মাগফিরাতের দোয়া করা ("রাব্বির হামহুমা কামা রাব্বাইয়ানী সাগীরা"), ২. তাঁদের পক্ষ থেকে সদকায়ে জারিয়া (যেমন নলকূপ, মসজিদ বা কুরআন বিতরণ) করা, এবং ৩. তাঁদের আত্মীয়-স্বজন ও বন্ধুদের সাথে সুসম্পর্ক বজায় রাখা।',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final hs = await StorageService.getQuizHighScore();
    if (!mounted) return;
    setState(() => _highScore = hs);
  }

  Future<void> _selectOption(int index) async {
    if (_selectedOption != null) return;
    HapticFeedback.selectionClick();
    final isCorrect = index == (_questions[_currentIndex]['answer'] as int);
    final nextScore = isCorrect ? _score + 1 : _score;
    setState(() {
      _selectedOption = index;
      _score = nextScore;
    });
    if (nextScore > _highScore) {
      await StorageService.setQuizHighScore(nextScore);
      if (mounted) {
        setState(() => _highScore = nextScore);
      }
    }
  }

  void _nextQuestion() {
    if (_currentIndex + 1 < _questions.length) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedOption = null;
      _quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ইসলামিক কুইজ ও প্রশ্নোত্তর',
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
              Tab(text: 'ইসলামিক কুইজ'),
              Tab(text: 'মাসায়েল ও প্রশ্নোত্তর'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildQuizTab(isDark),
            _buildFaqTab(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizTab(bool isDark) {
    if (_quizCompleted) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events_rounded, color: AppColors.amber, size: 56),
                const SizedBox(height: 12),
                Text(
                  'মাশাআল্লাহ! কুইজ সম্পন্ন হয়েছে',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'আপনার স্কোর: ${BengaliNumerals.convert(_score)} / ${BengaliNumerals.convert(_questions.length)}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emerald,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'সর্বোচ্চ স্কোর: ${BengaliNumerals.convert(_highScore)} / ${BengaliNumerals.convert(_questions.length)}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _restartQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    'আবার অংশগ্রহণ করুন',
                    style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final current = _questions[_currentIndex];
    final options = current['options'] as List<String>;
    final correctAnswer = current['answer'] as int;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Score & Progress Header
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'প্রশ্ন ${BengaliNumerals.convert(_currentIndex + 1)}/${BengaliNumerals.convert(_questions.length)}',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
              Text(
                'স্কোর: ${BengaliNumerals.convert(_score)} • সর্বোচ্চ: ${BengaliNumerals.convert(_highScore)}',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Question Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                current['q'] as String,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.45,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              ...options.asMap().entries.map((entry) {
                final idx = entry.key;
                final text = entry.value;
                final isSelected = _selectedOption == idx;
                final isRightOption = idx == correctAnswer;

                Color borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
                Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

                if (_selectedOption != null) {
                  if (isRightOption) {
                    borderColor = AppColors.emerald;
                    bgColor = AppColors.emeraldSoft;
                  } else if (isSelected) {
                    borderColor = Colors.redAccent;
                    bgColor = Colors.redAccent.withOpacity(0.12);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _selectOption(idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1.4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${BengaliNumerals.convert(idx + 1)}. $text',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13.8,
                                fontWeight: FontWeight.w600,
                                color: (_selectedOption != null && isRightOption)
                                    ? AppColors.emerald
                                    : (isDark ? Colors.white : AppColors.textPrimaryLight),
                              ),
                            ),
                          ),
                          if (_selectedOption != null && isRightOption)
                            const Icon(Icons.check_circle, color: AppColors.emerald, size: 20),
                          if (_selectedOption != null && isSelected && !isRightOption)
                            const Icon(Icons.cancel, color: Colors.redAccent, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              if (_selectedOption != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ব্যাখ্যা: ${current['explanation']}',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.emerald,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentIndex + 1 < _questions.length
                        ? 'পরবর্তী প্রশ্ন →'
                        : 'ফলাফল দেখুন',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFaqTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _faqs.length,
      itemBuilder: (context, index) {
        final item = _faqs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
              Text(
                item['q']!,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['a']!,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
