class Dua {
  final int id;
  final String category;
  final String titleBengali;
  final String arabicText;
  final String pronunciation;
  final String translation;
  final String reference;
  final int targetCount;
  final String? note;
  final bool isFavorite;

  const Dua({
    required this.id,
    required this.category,
    required this.titleBengali,
    required this.arabicText,
    required this.pronunciation,
    required this.translation,
    required this.reference,
    this.targetCount = 1,
    this.note,
    this.isFavorite = false,
  });

  Dua copyWith({bool? isFavorite}) {
    return Dua(
      id: id,
      category: category,
      titleBengali: titleBengali,
      arabicText: arabicText,
      pronunciation: pronunciation,
      translation: translation,
      reference: reference,
      targetCount: targetCount,
      note: note,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
