class Dua {
  final int id;
  final String category;
  final String titleBengali;
  final String arabicText;
  final String pronunciation;
  final String translation;
  final String reference;
  final bool isFavorite;

  const Dua({
    required this.id,
    required this.category,
    required this.titleBengali,
    required this.arabicText,
    required this.pronunciation,
    required this.translation,
    required this.reference,
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
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
