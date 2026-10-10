class Ayah {
  final int numberInSurah;
  final int numberInQuran;
  final String textArabic;
  final String textBengali;
  final String? audioUrl;
  final bool isBookmarked;

  const Ayah({
    required this.numberInSurah,
    required this.numberInQuran,
    required this.textArabic,
    required this.textBengali,
    this.audioUrl,
    this.isBookmarked = false,
  });

  Ayah copyWith({bool? isBookmarked}) {
    return Ayah(
      numberInSurah: numberInSurah,
      numberInQuran: numberInQuran,
      textArabic: textArabic,
      textBengali: textBengali,
      audioUrl: audioUrl,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
