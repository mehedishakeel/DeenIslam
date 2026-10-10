class HadithBook {
  final int index;
  final String slug;
  final String nameBengali;
  final String nameArabic;
  final String compiler;
  final String description;
  final String badge;
  final int totalCount;

  const HadithBook({
    required this.index,
    required this.slug,
    required this.nameBengali,
    required this.nameArabic,
    required this.compiler,
    required this.description,
    required this.badge,
    required this.totalCount,
  });
}

class HadithItem {
  final int hadithNumber;
  final String bookSlug;
  final String bookNameBengali;
  final String chapterTitle;
  final String arabic;
  final String bengali;
  final String narrator;
  final String grade;

  const HadithItem({
    required this.hadithNumber,
    required this.bookSlug,
    required this.bookNameBengali,
    required this.chapterTitle,
    required this.arabic,
    required this.bengali,
    required this.narrator,
    this.grade = 'সহীহ',
  });

  Map<String, dynamic> toJson() => {
        'hadithNumber': hadithNumber,
        'bookSlug': bookSlug,
        'bookNameBengali': bookNameBengali,
        'chapterTitle': chapterTitle,
        'arabic': arabic,
        'bengali': bengali,
        'narrator': narrator,
        'grade': grade,
      };

  factory HadithItem.fromJson(Map<String, dynamic> json) => HadithItem(
        hadithNumber: json['hadithNumber'] as int? ?? 1,
        bookSlug: json['bookSlug'] as String? ?? 'bukhari',
        bookNameBengali: json['bookNameBengali'] as String? ?? 'সহীহ বুখারী',
        chapterTitle: json['chapterTitle'] as String? ?? 'হাদিস শরীফ',
        arabic: json['arabic'] as String? ?? '',
        bengali: json['bengali'] as String? ?? '',
        narrator: json['narrator'] as String? ?? '',
        grade: json['grade'] as String? ?? 'সহীহ',
      );
}
