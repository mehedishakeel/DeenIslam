import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/bengali_numerals.dart';
import '../../../data/repositories/quiz_data.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String _selectedCategory = 'all';
  int _currentIndex = 0;
  int _score = 0;
  int _highScore = 0;
  int? _selectedOption;
  bool _quizCompleted = false;

  List<QuizQuestion> get _activeQuestions =>
      QuizData.filterByCategory(_selectedCategory);

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

  void _selectCategory(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _currentIndex = 0;
      _score = 0;
      _selectedOption = null;
      _quizCompleted = false;
    });
  }

  Future<void> _selectOption(int index) async {
    if (_selectedOption != null) return;
    HapticFeedback.selectionClick();
    final isCorrect = index == _activeQuestions[_currentIndex].answer;
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
    if (_currentIndex + 1 < _activeQuestions.length) {
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
    final questions = _activeQuestions;

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
                  'আপনার স্কোর: ${BengaliNumerals.convert(_score)} / ${BengaliNumerals.convert(questions.length)}',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emerald,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'সর্বোচ্চ স্কোর: ${BengaliNumerals.convert(_highScore)}',
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

    final current = questions[_currentIndex];
    final options = current.options;
    final correctAnswer = current.answer;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Category Filter Chips
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: QuizData.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              final cat = QuizData.categories[idx];
              final isSelected = _selectedCategory == cat.id;
              return ChoiceChip(
                label: Text(
                  cat.nameBn,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.grey.shade300 : Colors.black87),
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.emerald,
                backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                side: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                onSelected: (_) => _selectCategory(cat.id),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

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
                'প্রশ্ন ${BengaliNumerals.convert(_currentIndex + 1)}/${BengaliNumerals.convert(questions.length)}',
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
                current.question,
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
                    'ব্যাখ্যা: ${current.explanation}',
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
                    _currentIndex + 1 < questions.length
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
      itemCount: QuizData.faqs.length,
      itemBuilder: (context, index) {
        final item = QuizData.faqs[index];
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
                item.question,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.answer,
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
