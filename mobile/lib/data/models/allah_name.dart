class AllahName {
  final int id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String? desc;

  const AllahName({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    this.desc,
  });

  factory AllahName.fromJson(Map<String, dynamic> json) {
    return AllahName(
      id: json['id'] as int,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      meaning: json['meaning'] as String,
      desc: json['desc'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic': arabic,
      'transliteration': transliteration,
      'meaning': meaning,
      if (desc != null) 'desc': desc,
    };
  }
}
