class Surah {
  final int number;
  final String nameArabic;
  final String nameBengali;
  final String nameEnglish;
  final String revelationType; // 'মাক্কী' or 'মাদানী'
  final int numberOfAyahs;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameBengali,
    required this.nameEnglish,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      nameArabic: json['nameArabic'] as String,
      nameBengali: json['nameBengali'] as String,
      nameEnglish: json['nameEnglish'] as String,
      revelationType: json['revelationType'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'nameArabic': nameArabic,
      'nameBengali': nameBengali,
      'nameEnglish': nameEnglish,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
    };
  }
}
