import 'package:flutter_test/flutter_test.dart';
import 'package:deen_islam/data/repositories/quiz_data.dart';

void main() {
  group('QuizData Integrity & Parity Tests', () {
    test('Contains all categories and 16 authentic questions', () {
      expect(QuizData.categories.length, equals(4));
      expect(QuizData.questions.length, equals(16));
    });

    test('Every question has valid category, 4 options, in-bounds answer, and explanation', () {
      const validCategories = {'quran', 'seerah', 'fiqh'};
      for (final q in QuizData.questions) {
        expect(validCategories.contains(q.category), isTrue);
        expect(q.question, isNotEmpty);
        expect(q.options.length, equals(4));
        expect(q.answer, inInclusiveRange(0, 3));
        expect(q.explanation, isNotEmpty);
      }
    });

    test('Category filtering returns expected question subsets', () {
      expect(QuizData.filterByCategory('all').length, equals(16));
      final quranCount = QuizData.filterByCategory('quran').length;
      final seerahCount = QuizData.filterByCategory('seerah').length;
      final fiqhCount = QuizData.filterByCategory('fiqh').length;
      expect(quranCount, greaterThanOrEqualTo(5));
      expect(seerahCount, greaterThanOrEqualTo(5));
      expect(fiqhCount, greaterThanOrEqualTo(5));
      expect(quranCount + seerahCount + fiqhCount, equals(16));
    });

    test('Contains 8 complete Masael FAQs', () {
      expect(QuizData.faqs.length, equals(8));
      for (final faq in QuizData.faqs) {
        expect(faq.question, isNotEmpty);
        expect(faq.answer, isNotEmpty);
      }
    });
  });
}
