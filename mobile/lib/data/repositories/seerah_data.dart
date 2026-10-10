class SeerahEvent {
  final String id;
  final String yearCe;
  final String yearAh;
  final String era;
  final String eraBn;
  final String titleBn;
  final String titleAr;
  final String placeBn;
  final double lat;
  final double lng;
  final String summaryBn;
  final String sourcesBn;

  const SeerahEvent({
    required this.id,
    required this.yearCe,
    required this.yearAh,
    required this.era,
    required this.eraBn,
    required this.titleBn,
    required this.titleAr,
    required this.placeBn,
    required this.lat,
    required this.lng,
    required this.summaryBn,
    required this.sourcesBn,
  });
}

class GenealogyNode {
  final int gen;
  final String nameBn;
  final String nameAr;
  final bool isProphet;
  final String motherBn;
  final String branchesBn;
  final String noteBn;

  const GenealogyNode({
    required this.gen,
    required this.nameBn,
    required this.nameAr,
    this.isProphet = false,
    this.motherBn = '',
    this.branchesBn = '',
    required this.noteBn,
  });
}

class GenealogyEra {
  final String id;
  final String roman;
  final String titleBn;
  final String subtitleBn;
  final bool agreed;
  final List<GenealogyNode> generations;

  const GenealogyEra({
    required this.id,
    required this.roman,
    required this.titleBn,
    required this.subtitleBn,
    required this.agreed,
    required this.generations,
  });
}

class FamilyMember {
  final String nameBn;
  final String nameAr;
  final String relationBn;
  final String lifeBn;
  final String descBn;

  const FamilyMember({
    required this.nameBn,
    required this.nameAr,
    required this.relationBn,
    required this.lifeBn,
    required this.descBn,
  });
}

class FamilyCategory {
  final String key;
  final String titleBn;
  final String countBn;
  final List<FamilyMember> members;

  const FamilyCategory({
    required this.key,
    required this.titleBn,
    required this.countBn,
    required this.members,
  });
}

class CompanionModel {
  final String id;
  final String nameBn;
  final String nameAr;
  final String laqabBn;
  final String acceptedBn;
  final String lifeBn;
  final List<String> roles;
  final List<String> rolesBn;
  final String bioBn;

  const CompanionModel({
    required this.id,
    required this.nameBn,
    required this.nameAr,
    required this.laqabBn,
    required this.acceptedBn,
    required this.lifeBn,
    required this.roles,
    required this.rolesBn,
    required this.bioBn,
  });
}

class BattleModel {
  final String id;
  final String type; // 'ghazwah' or 'sariyyah'
  final String typeBn;
  final String yearAh;
  final String dateBn;
  final String nameBn;
  final String nameAr;
  final String locationBn;
  final String outcome; // 'victory', 'treaty', 'no_fighting', 'trial'
  final String outcomeBn;
  final int muslimForceNum;
  final int enemyForceNum;
  final String muslimForceBn;
  final String enemyForceBn;
  final String muslimCmdBn;
  final String enemyCmdBn;
  final String lossesBn;
  final String summaryBn;

  const BattleModel({
    required this.id,
    required this.type,
    required this.typeBn,
    required this.yearAh,
    required this.dateBn,
    required this.nameBn,
    required this.nameAr,
    required this.locationBn,
    required this.outcome,
    required this.outcomeBn,
    required this.muslimForceNum,
    required this.enemyForceNum,
    required this.muslimForceBn,
    required this.enemyForceBn,
    required this.muslimCmdBn,
    required this.enemyCmdBn,
    required this.lossesBn,
    required this.summaryBn,
  });
}

class SeerahData {
  // 1. SEERAH MAP & TIMELINE EVENTS
  static const List<SeerahEvent> events = [
    SeerahEvent(
      id: 'year-of-the-elephant',
      yearCe: '৫৭০ খ্রি.',
      yearAh: 'হিজরত পূর্ব ৫৩ বছর',
      era: 'pre_prophethood',
      eraBn: 'নবুওয়াত-পূর্ব যুগ',
      titleBn: 'হস্তী বর্ষ ও রাসূলুল্লাহ (ﷺ)-এর শুভ জন্ম',
      titleAr: 'عام الفيل ومولد النبي ﷺ',
      placeBn: 'মক্কা মুকাররমা (শিয়াবে আবু তালিব)',
      lat: 21.4225,
      lng: 39.8262,
      summaryBn:
          'ইয়েমেনের শাসক আবরাহা কাবা ঘর ধ্বংসের উদ্দেশ্যে হস্তীবাহিনী নিয়ে মক্কায় অভিযান চালায় এবং আল্লাহ আবাবিল পাখির মাধ্যমে তাদের ধ্বংস করেন। এই বছরের রবিউল আউয়াল মাসে রাসূলুল্লাহ (ﷺ) জন্মগ্রহণ করেন।',
      sourcesBn: "সীরাত ইবনে হিশাম, তাবাকাত ইবনে সা'দ, সূরা আল-ফীল",
    ),
    SeerahEvent(
      id: 'halimah-fosterage',
      yearCe: '৫৭০–৫৭৪ খ্রি.',
      yearAh: 'হিজরত পূর্ব ৫৩–৪৯ বছর',
      era: 'pre_prophethood',
      eraBn: 'নবুওয়াত-পূর্ব যুগ',
      titleBn: 'বনু সা’দ গোত্রে দুধমাতা হালিমা সাদিয়ার গৃহে লালন-পালন ও বক্ষ বিদারণ',
      titleAr: 'الرضاعة في بني سعد وشق الصدر',
      placeBn: 'বনু সা’দ অঞ্চল (তায়েফের নিকটবর্তী)',
      lat: 21.1800,
      lng: 40.5500,
      summaryBn:
          'আরবের প্রথা অনুযায়ী বিশুদ্ধ আরবি ভাষা ও মুক্ত আবহাওয়ায় বেড়ে ওঠার জন্য শিশু মুহাম্মাদ (ﷺ)-কে বনু সা’দ গোত্রের হালিমা সাদিয়ার কাছে সোপর্দ করা হয়। এখানেই ফেরেশতা জিবরীল (আ.) কর্তৃক প্রথমবার তাঁর বক্ষ বিদারণের ঘটনা ঘটে।',
      sourcesBn: 'সহীহ মুসলিম, সীরাত ইবনে হিশাম',
    ),
    SeerahEvent(
      id: 'death-of-aminah',
      yearCe: '৫৭৬ খ্রি.',
      yearAh: 'হিজরত পূর্ব ৪৭ বছর',
      era: 'pre_prophethood',
      eraBn: 'নবুওয়াত-পূর্ব যুগ',
      titleBn: 'মাতা আমিনা বিনতে ওয়াহাবের ইন্তেকাল',
      titleAr: 'وفاة آمنة بنت وهب بالأبواء',
      placeBn: 'আল-আবওয়া (মক্কা ও মদিনার মধ্যবর্তী স্থান)',
      lat: 23.1069,
      lng: 39.0928,
      summaryBn:
          'মদিনায় পিতা আবদুল্লাহর কবর ও মামাদের সাথে সাক্ষাৎ শেষে মক্কায় ফেরার পথে আল-আবওয়া নামক স্থানে মাতা আমিনা ইন্তেকাল করেন। উম্মে আইমান (রা.) ৬ বছর বয়সী শিশু মুহাম্মাদ (ﷺ)-কে মক্কায় দাদা আবদুল মুত্তালিবের কাছে নিয়ে আসেন।',
      sourcesBn: "তাবাকাত ইবনে সা'দ, সীরাত ইবনে হিশাম",
    ),
    SeerahEvent(
      id: 'syria-journey-bahira',
      yearCe: '৫৮২ খ্রি.',
      yearAh: 'হিজরত পূর্ব ৪১ বছর',
      era: 'pre_prophethood',
      eraBn: 'নবুওয়াত-পূর্ব যুগ',
      titleBn: 'চাচা আবু তালিবের সাথে শাম (সিরিয়া) সফর ও পাদ্রি বাহিরার সাক্ষাৎ',
      titleAr: 'رحلة الشام الأولى ولقاء الراهب بحيرى',
      placeBn: 'বুসরা (দক্ষিণ সিরিয়া)',
      lat: 32.5197,
      lng: 36.4819,
      summaryBn:
          '১২ বছর বয়সে চাচা আবু তালিবের সাথে বাণিজ্য কাফেলায় সিরিয়ার বুসরা নগরীতে যান। খ্রিস্টান পণ্ডিত বাহিরা তাঁর মধ্যে শেষ নবীর আলামত চিনতে পেরে আবু তালিবকে তাঁকে নিরাপদে মক্কায় ফিরিয়ে নেওয়ার পরামর্শ দেন।',
      sourcesBn: 'জামে তিরমিযী, সীরাত ইবনে হিশাম',
    ),
    SeerahEvent(
      id: 'hilf-al-fudul',
      yearCe: '৫৯০–৬০৫ খ্রি.',
      yearAh: 'হিজরত পূর্ব ৩৩–১৮ বছর',
      era: 'pre_prophethood',
      eraBn: 'নবুওয়াত-পূর্ব যুগ',
      titleBn: 'হিলফুল ফুযূল চুক্তি ও হাজরে আসওয়াদ স্থাপন',
      titleAr: 'حلف الفضول وبناء الكعبة',
      placeBn: 'মক্কা মুকাররমা',
      lat: 21.4235,
      lng: 39.8270,
      summaryBn:
          'মক্কায় মাজলুমের অধিকার রক্ষায় হিলফুল ফুযূল চুক্তিতে অংশগ্রহণ করেন এবং ৩৫ বছর বয়সে কাবা পুনর্নির্মাণের সময় হাজরে আসওয়াদ স্থাপনের বিরোধ প্রজ্ঞার সাথে মীমাংসা করেন।',
      sourcesBn: 'মুসনাদে আহমাদ, সীরাত ইবনে হিশাম',
    ),
    SeerahEvent(
      id: 'marriage-to-khadijah',
      yearCe: '৫৯৫ খ্রি.',
      yearAh: 'হিজরত পূর্ব ২৮ বছর',
      era: 'pre_prophethood',
      eraBn: 'নবুওয়াত-পূর্ব যুগ',
      titleBn: 'খাদিজা বিনতে খুওয়াইলিদ (রা.)-এর সাথে বিবাহ',
      titleAr: 'زواج النبي ﷺ من خديجة بنت خويلد',
      placeBn: 'মক্কা মুকাররমা',
      lat: 21.4250,
      lng: 39.8290,
      summaryBn:
          'আল-আমিন ও আস-সাদিক হিসেবে তাঁর সততা ও আমানতদারিতায় মুগ্ধ হয়ে খাদিজা বিনতে খুওয়াইলিদ (রা.) বিবাহের প্রস্তাব পাঠান এবং ২৫ বছর বয়সে তাঁদের বিবাহ সম্পন্ন হয়।',
      sourcesBn: "তাবাকাত ইবনে সা'দ, সীরাত ইবনে হিশাম",
    ),
    SeerahEvent(
      id: 'first-revelation-hira',
      yearCe: '৬১০ খ্রি. (রমজান)',
      yearAh: 'নবুওয়াত ১ম বর্ষ',
      era: 'makki',
      eraBn: 'মক্কী জীবন',
      titleBn: 'হেরা গুহায় প্রথম ওহী নাযিল ও নবুওয়াত লাভ',
      titleAr: 'بدء الوحي في غار حراء',
      placeBn: 'গারে হেরা (জাবালে নূর, মক্কা)',
      lat: 21.4575,
      lng: 39.8594,
      summaryBn:
          '৪০ বছর বয়সে রমজান মাসে হেরা গুহায় ধ্যানমগ্ন অবস্থায় ফেরেশতা জিবরীল (আ.) সূরা আল-আলাকের প্রথম ৫টি আয়াত নিয়ে আগমন করেন। খাদিজা (রা.), আলী (রা.), যায়েদ (রা.) ও আবু বকর (রা.) সর্বপ্রথম ইসলাম গ্রহণ করেন।',
      sourcesBn: 'সহীহ বুখারী (হাদিস ৩), সহীহ মুসলিম',
    ),
    SeerahEvent(
      id: 'dar-al-arqam',
      yearCe: '৬১০–৬১৩ খ্রি.',
      yearAh: 'নবুওয়াত ১–৩ বর্ষ',
      era: 'makki',
      eraBn: 'মক্কী জীবন',
      titleBn: 'দারুল আরকামে দাওয়াত ও সাফা পর্বতে প্রকাশ্য ঘোষণা',
      titleAr: 'دار الأرقم والجهر بالدعوة على الصفا',
      placeBn: 'সাফা পাহাড়ের পাদদেশ, মক্কা',
      lat: 21.4220,
      lng: 39.8275,
      summaryBn:
          'প্রথম তিন বছর সাহাবী আরকাম (রা.)-এর গৃহে গোপনে কুরআন শিক্ষা চলে। এরপর সাফা পাহাড়ে দাঁড়িয়ে প্রকাশ্যে তাওহীদের দাওয়াত দেন।',
      sourcesBn: "সহীহ বুখারী, তাবাকাত ইবনে সা'দ",
    ),
    SeerahEvent(
      id: 'migration-to-abyssinia',
      yearCe: '৬১৫ খ্রি. (রজব)',
      yearAh: 'নবুওয়াত ৫ম বর্ষ',
      era: 'makki',
      eraBn: 'মক্কী জীবন',
      titleBn: 'হাবশায় (আবিসিনিয়া) সাহাবীদের প্রথম ও দ্বিতীয় হিজরত',
      titleAr: 'الهجرة إلى الحبشة',
      placeBn: 'আকসুম (হাবশা / ইথিওপিয়া)',
      lat: 14.1310,
      lng: 38.7206,
      summaryBn:
          'কুরাইশদের নির্যাতনের মুখে উসমান (রা.), রুকাইয়া (রা.) এবং জাফর ইবনে আবি তালিব (রা.)-এর নেতৃত্বে সাহাবীগণ ন্যায়পরায়ণ বাদশাহ নাজাশীর দেশ হাবশায় হিজরত করেন।',
      sourcesBn: 'মুসনাদে আহমাদ, সীরাত ইবনে হিশাম',
    ),
    SeerahEvent(
      id: 'boycott-and-year-of-sorrow',
      yearCe: '৬১৬–৬১৯ খ্রি.',
      yearAh: 'নবুওয়াত ৭–১০ বর্ষ',
      era: 'makki',
      eraBn: 'মক্কী জীবন',
      titleBn: 'শিয়াবে আবু তালিবে অবরোধ ও আমুল হুযন (শোকের বছর)',
      titleAr: 'حصار شعب أبي طالب وعام الحزن',
      placeBn: 'শিয়াবে আবু তালিব, মক্কা',
      lat: 21.4248,
      lng: 39.8305,
      summaryBn:
          'বনু হাশিমের বিরুদ্ধে ৩ বছরব্যাপী অবরোধের পর ৬১৯ খ্রিস্টাব্দে চাচা আবু তালিব এবং সহধর্মিণী খাদিজা (রা.) ইন্তেকাল করেন।',
      sourcesBn: 'সহীহ বুখারী, আর-রাহীকুল মাখতূম',
    ),
    SeerahEvent(
      id: 'journey-to-taif',
      yearCe: '৬১৯ খ্রি. (শাওয়াল)',
      yearAh: 'নবুওয়াত ১০ম বর্ষ',
      era: 'makki',
      eraBn: 'মক্কী জীবন',
      titleBn: 'তায়েফ গমন ও চরম পরীক্ষার মাঝেও ক্ষমার আদর্শ',
      titleAr: 'رحلة الطائف',
      placeBn: 'তায়েফ নগরী',
      lat: 21.2703,
      lng: 40.4158,
      summaryBn:
          'তায়েফবাসী পাথর ছুড়ে রক্তাক্ত করলেও পাহাড়ের ফেরেশতা আসার পর তিনি বদদোয়া না করে তাঁদের ভবিষ্যৎ প্রজন্মের হেদায়েতের জন্য দোয়া করেন।',
      sourcesBn: 'সহীহ বুখারী (হাদিস ৩২৩১), সহীহ মুসলিম',
    ),
    SeerahEvent(
      id: 'isra-and-miraj',
      yearCe: '৬২০ খ্রি.',
      yearAh: 'নবুওয়াত ১১তম বর্ষ',
      era: 'makki',
      eraBn: 'মক্কী জীবন',
      titleBn: 'ইসরা ও মিরাজ (মসজিদুল আকসা ও সপ্তাকাশ ভ্রমণ)',
      titleAr: 'الإسراء والمعراج',
      placeBn: 'বাইতুল মুকাদ্দাস (জেরুজালেম)',
      lat: 31.7761,
      lng: 35.2358,
      summaryBn:
          'মক্কা থেকে জেরুজালেমের মসজিদুল আকসায় ভ্রমণ, সকল নবীর ইমামতি এবং সপ্তাকাশ অতিক্রম করে পাঁচ ওয়াক্ত ফরজ নামাজের বিধান লাভ করেন।',
      sourcesBn: 'সূরা বনী ইসরাঈল (১৭:১), সহীহ বুখারী',
    ),
    SeerahEvent(
      id: 'cave-of-thawr',
      yearCe: '৬২২ খ্রি.',
      yearAh: '১ হিজরি',
      era: 'hijrah',
      eraBn: 'হিজরত ও মাদানী সূচনা',
      titleBn: 'বাইআতে আকাবা, হিজরত ও সওর গুহায় অবস্থান',
      titleAr: 'الهجرة النبوية وغار ثور',
      placeBn: 'গারে সওর (মক্কার দক্ষিণে)',
      lat: 21.3772,
      lng: 39.8501,
      summaryBn:
          'কুরাইশদের ষড়যন্ত্র নস্যাৎ করে আবু বকর সিদ্দীক (রা.)-কে সাথে নিয়ে মক্কা ত্যাগ করেন এবং সওর গুহায় ৩ রাত অবস্থান শেষে মদিনার পথে যাত্রা করেন।',
      sourcesBn: 'সহীহ বুখারী (হাদিস ৩৬৫৩), সূরা আত-তাওবাহ (৯:৪০)',
    ),
    SeerahEvent(
      id: 'arrival-quba-madinah',
      yearCe: '৬২২ খ্রি. (রবিউল আউয়াল)',
      yearAh: '১ হিজরি',
      era: 'hijrah',
      eraBn: 'হিজরত ও মাদানী সূচনা',
      titleBn: 'কুবায় আগমন, মসজিদে নববী নির্মাণ ও মদিনা সনদ',
      titleAr: 'الوصول إلى قباء والمدينة وبناء المسجد النبوي',
      placeBn: 'মদিনা মুনাওয়ারা',
      lat: 24.4672,
      lng: 39.6111,
      summaryBn:
          'কুবায় প্রথম মসজিদ প্রতিষ্ঠা, মদিনায় মসজিদে নববী নির্মাণ, মুহাজির-আনসার ভ্রাতৃত্ব বন্ধন এবং ঐতিহাসিক মদিনা সনদ প্রণয়ন করেন।',
      sourcesBn: 'সহীহ বুখারী, সীরাত ইবনে হিশাম',
    ),
    SeerahEvent(
      id: 'battle-of-badr-event',
      yearCe: '৬২৪ খ্রি. (১৭ রমজান)',
      yearAh: '২ হিজরি',
      era: 'madani',
      eraBn: 'মাদানী জীবন ও বিজয়সমূহ',
      titleBn: 'ঐতিহাসিক বদর যুদ্ধ (ইয়াওমুল ফুরকান)',
      titleAr: 'غزوة بدر الكبرى',
      placeBn: 'বদর প্রান্তর',
      lat: 23.7800,
      lng: 38.7900,
      summaryBn:
          '১৭ রমজান ২ হিজরিতে মাত্র ৩১৩ জন সাহাবী ১,০০০ কুরাইশ সৈন্যের বিরুদ্ধে ঐতিহাসিক বিজয় লাভ করেন।',
      sourcesBn: 'সূরা আল-আনফাল, সহীহ বুখারী',
    ),
    SeerahEvent(
      id: 'battle-of-uhud-event',
      yearCe: '৬২৫ খ্রি. (৭ শাওয়াল)',
      yearAh: '৩ হিজরি',
      era: 'madani',
      eraBn: 'মাদানী জীবন ও বিজয়সমূহ',
      titleBn: 'উহুদ যুদ্ধ ও হামযাহ (রা.)-এর শাহাদাত',
      titleAr: 'غزوة أحد',
      placeBn: 'উহুদ পর্বত (মদিনার উত্তরে)',
      lat: 24.5033,
      lng: 39.6150,
      summaryBn:
          '৩,০০০ কুরাইশ সৈন্যের বিরুদ্ধে যুদ্ধে হামযাহ (রা.) ও মুসআব ইবনে উমাইর (রা.)-সহ ৭০ জন সাহাবী শাহাদাত বরণ করেন।',
      sourcesBn: 'সূরা আলে ইমরান, সহীহ বুখারী',
    ),
    SeerahEvent(
      id: 'battle-of-khandaq-event',
      yearCe: '৬২৭ খ্রি. (শাওয়াল)',
      yearAh: '৫ হিজরি',
      era: 'madani',
      eraBn: 'মাদানী জীবন ও বিজয়সমূহ',
      titleBn: 'খন্দক বা আহযাবের যুদ্ধ ও পরিখা খনন',
      titleAr: 'غزوة الخندق (الأحزاب)',
      placeBn: 'মদিনা মুনাওয়ারা',
      lat: 24.4795,
      lng: 39.5955,
      summaryBn:
          '১০,০০০ শত্রু সৈন্যের অবরোধ মোকাবিলায় সালমান আল-ফারসী (রা.)-এর পরামর্শে পরিখা খনন করা হয় এবং আল্লাহর সাহায্যে শত্রু জোট ছত্রভঙ্গ হয়ে যায়।',
      sourcesBn: 'সূরা আল-আহযাব, সহীহ বুখারী',
    ),
    SeerahEvent(
      id: 'treaty-of-hudaybiyyah',
      yearCe: '৬২৮ খ্রি.',
      yearAh: '৬–৭ হিজরি',
      era: 'madani',
      eraBn: 'মাদানী জীবন ও বিজয়সমূহ',
      titleBn: 'হুদাইবিয়ার সন্ধি, রাজন্যবর্গের নিকট পত্র ও খায়বার বিজয়',
      titleAr: 'صلح الحديبية وفتح خيبر',
      placeBn: 'হুদাইবিয়া ও খায়বার',
      lat: 21.4411,
      lng: 39.6481,
      summaryBn:
          'বাইআতে রিদওয়ান ও ১০ বছরের হুদাইবিয়ার সন্ধি স্বাক্ষরিত হয়, সম্রাটদের কাছে দাওয়াতি পত্র প্রেরিত হয় এবং ৭ হিজরিতে খায়বার বিজিত হয়।',
      sourcesBn: 'সূরা আল-ফাতহ, সহীহ বুখারী',
    ),
    SeerahEvent(
      id: 'conquest-of-makkah-event',
      yearCe: '৬৩০ খ্রি. (২০ রমজান)',
      yearAh: '৮–৯ হিজরি',
      era: 'madani',
      eraBn: 'মাদানী জীবন ও বিজয়সমূহ',
      titleBn: 'মক্কা বিজয়, হুনাইন ও তাবুক অভিযান',
      titleAr: 'فتح مكة وغزوة حنين وتبوك',
      placeBn: 'মক্কা মুকাররমা ও তাবুক',
      lat: 28.3835,
      lng: 36.5662,
      summaryBn:
          '৮ হিজরিতে ১০,০০০ সাহাবী নিয়ে রক্তপাতহীন মক্কা বিজয় ও সাধারণ ক্ষমা ঘোষণা করেন। এরপর হুনাইন বিজয় এবং ৯ হিজরিতে ৩০,০০০ সাহাবী নিয়ে তাবুক অভিযান পরিচালনা করেন।',
      sourcesBn: 'সূরা আন-নাসর, সূরা আত-তাওবাহ, সহীহ বুখারী',
    ),
    SeerahEvent(
      id: 'farewell-pilgrimage-death',
      yearCe: '৬৩২ খ্রি.',
      yearAh: '১০–১১ হিজরি',
      era: 'madani',
      eraBn: 'মাদানী জীবন ও বিজয়সমূহ',
      titleBn: 'বিদায় হজের ভাষণ ও রফীকে আ’লা-এর ডাকে সাড়া',
      titleAr: 'حجة الوداع ووفاة النبي ﷺ',
      placeBn: 'আরাফাত ও মদিনা মুনাওয়ারা',
      lat: 21.3549,
      lng: 39.9841,
      summaryBn:
          '১০ হিজরিতে লক্ষাধিক সাহাবীর সামনে বিদায় হজের ভাষণ দেন এবং ১১ হিজরির ১২ রবিউল আউয়াল ৬৩ বছর বয়সে মদিনায় ইন্তেকাল করেন।',
      sourcesBn: 'সহীহ বুখারী, সহীহ মুসলিম',
    ),
  ];

  // 2. 50-GENERATION GENEALOGY ACROSS 8 ERAS
  static const List<GenealogyEra> genealogyEras = [
    GenealogyEra(
      id: 'era-1',
      roman: 'I',
      titleBn: '১ম যুগ: আদম (আ.) থেকে মহাপ্লাবন পূর্ব',
      subtitleBn: 'মানবজাতির সূচনা ও প্রথম প্রজন্মসমূহ (ইবনে ইসহাকের বর্ণনা অনুযায়ী)',
      agreed: false,
      generations: [
        GenealogyNode(gen: 49, nameBn: 'আদম (আ.)', nameAr: 'آدم عليه السلام', isProphet: true, branchesBn: 'হাবিল, কাবিল', noteBn: 'প্রথম মানব ও প্রথম নবী (আবুল বাশার)।'),
        GenealogyNode(gen: 48, nameBn: 'শীস (আ.)', nameAr: 'شيث عليه السلام', isProphet: true, motherBn: 'হাওয়া (আ.)', noteBn: 'আদম (আ.)-এর উত্তরাধিকারী ও আল্লাহর নবী।'),
        GenealogyNode(gen: 47, nameBn: 'ইয়ানিশ (আনূশ)', nameAr: 'يانش (أنوش)', noteBn: 'শীস (আ.)-এর পুত্র ও তাওহীদের ধারক।'),
        GenealogyNode(gen: 46, nameBn: 'কাইনান', nameAr: 'قينان', noteBn: 'প্রাচীন বংশধারা রক্ষাকারী।'),
        GenealogyNode(gen: 45, nameBn: 'মাহলাঈল', nameAr: 'مهلائيل', noteBn: 'প্রাচীন জনপদ নির্মাতা হিসেবে ইতিহাসে উল্লিখিত।'),
        GenealogyNode(gen: 44, nameBn: 'ইয়ারদ (ইয়ারিদ)', nameAr: 'يرد', noteBn: 'ইদরীস (আ.)-এর পিতা।'),
        GenealogyNode(gen: 43, nameBn: 'ইদরীস (আ.) (আখনূখ)', nameAr: 'إدريس عليه السلام', isProphet: true, noteBn: 'কুরআনে উল্লিখিত মহান নবী (সূরা মারইয়াম ৫৬-৫৭)।'),
        GenealogyNode(gen: 42, nameBn: 'মাত্তুশালাখ', nameAr: 'متوشلخ', noteBn: 'ইদরীস (আ.)-এর পুত্র।'),
        GenealogyNode(gen: 41, nameBn: 'লামক (লামেক)', nameAr: 'لمك', noteBn: 'নূহ (আ.)-এর পিতা।'),
      ],
    ),
    GenealogyEra(
      id: 'era-2',
      roman: 'II',
      titleBn: '২য় যুগ: মহাপ্লাবন পরবর্তী — নূহ (আ.) থেকে আযর',
      subtitleBn: 'দ্বিতীয় মানব বসতি ও সেমিটিক বংশধারা',
      agreed: false,
      generations: [
        GenealogyNode(gen: 40, nameBn: 'নূহ (আ.)', nameAr: 'نوح عليه السلام', isProphet: true, branchesBn: 'হাম, ইয়াফিস', noteBn: 'উলুল আযম রাসূল ও মহাপ্লাবন পরবর্তী মানবজাতির দ্বিতীয় পিতা।'),
        GenealogyNode(gen: 39, nameBn: 'সাম (Shem)', nameAr: 'سام بن نوح', noteBn: 'নূহ (আ.)-এর পুত্র; আরব ও বনী ইসরাঈলের পূর্বপুরুষ।'),
        GenealogyNode(gen: 38, nameBn: 'আরফাখশাদ', nameAr: 'أرفخشذ', noteBn: 'সামের পুত্র।'),
        GenealogyNode(gen: 37, nameBn: 'শালিখ', nameAr: 'شالخ', noteBn: 'আবিরের পিতা।'),
        GenealogyNode(gen: 36, nameBn: 'আবির', nameAr: 'عابر', branchesBn: 'কাহতান (দক্ষিণ আরবের ইয়েমেনি ও আনসার গোত্রসমূহ)', noteBn: 'তাঁর অপর পুত্র কাহতান থেকে দক্ষিণ আরবের আনসারদের উৎপত্তি।'),
        GenealogyNode(gen: 35, nameBn: 'ফালিখ', nameAr: 'فالخ', noteBn: 'ভূমি ও গোত্র বিভাজনের যুগের পূর্বপুরুষ।'),
        GenealogyNode(gen: 34, nameBn: 'রা’উ', nameAr: 'راعو', noteBn: 'সারূগের পিতা।'),
        GenealogyNode(gen: 33, nameBn: 'সারূগ', nameAr: 'ساروغ', noteBn: 'নাহূরের পিতা।'),
        GenealogyNode(gen: 32, nameBn: 'নাহূর', nameAr: 'ناحور', noteBn: 'ইবরাহীম (আ.)-এর দাদা।'),
        GenealogyNode(gen: 31, nameBn: 'তারিখ / আযর', nameAr: 'تارخ / آزر', noteBn: 'ইবরাহীম (আ.)-এর পিতা।'),
      ],
    ),
    GenealogyEra(
      id: 'era-3',
      roman: 'III',
      titleBn: '৩য় যুগ: খলিলুল্লাহ ইবরাহীম (আ.) ও ইসমাঈল (আ.)',
      subtitleBn: 'কাবা ঘরের নির্মাতা ও মিল্লাতে ইবরাহীমের সূচনা',
      agreed: true,
      generations: [
        GenealogyNode(gen: 30, nameBn: 'ইবরাহীম (আ.)', nameAr: 'إبراهيم الخليل عليه السلام', isProphet: true, branchesBn: 'ইসহাক (আ.) ও বনী ইসরাঈলের নবীগণ', noteBn: 'আবুল আম্বিয়া ও খলিলুল্লাহ; কাবা ঘরের পুনর্নির্মাতা।'),
        GenealogyNode(gen: 29, nameBn: 'ইসমাঈল (আ.)', nameAr: 'إسماعيل الذبيح عليه السلام', isProphet: true, motherBn: 'হাজেরা (আ.)', noteBn: 'যবীহুল্লাহ; শিশুকালে মক্কায় যমযম কূপের সূচনা ও পিতার সাথে কাবা নির্মাণ করেন।'),
      ],
    ),
    GenealogyEra(
      id: 'era-4',
      roman: 'IV',
      titleBn: '৪র্থ যুগ: ইসমাঈল (আ.) থেকে আদনান',
      subtitleBn: 'মক্কায় ইসমাঈলী বংশধারা',
      agreed: false,
      generations: [
        GenealogyNode(gen: 28, nameBn: 'নাবিত (নাবাইওত)', nameAr: 'نابت بن إسماعيل', noteBn: 'ইসমাঈল (আ.)-এর জ্যেষ্ঠ পুত্র ও কাবার তত্ত্বাবধায়ক।'),
        GenealogyNode(gen: 27, nameBn: 'ইয়াসজুব', nameAr: 'يشجب', noteBn: 'মক্কার ইসমাঈলী বংশধর।'),
        GenealogyNode(gen: 26, nameBn: 'ইয়ারুব', nameAr: 'يعرب', noteBn: 'তাইরাহ-এর পিতা।'),
        GenealogyNode(gen: 25, nameBn: 'তাইরাহ', nameAr: 'تيرح', noteBn: 'নাহূরের পিতা।'),
        GenealogyNode(gen: 24, nameBn: 'নাহূর', nameAr: 'ناحور', noteBn: 'মুকাওয়্যামের পিতা।'),
        GenealogyNode(gen: 23, nameBn: 'আল-মুকাওয়্যাম', nameAr: 'المقوم', noteBn: 'উদাদের পিতা।'),
        GenealogyNode(gen: 22, nameBn: 'উদাদ (উদ্দ)', nameAr: 'أدد', noteBn: 'আদনানের পিতা।'),
      ],
    ),
    GenealogyEra(
      id: 'era-5',
      roman: 'V',
      titleBn: '৫ম যুগ: আদনান, মুদার ও কিনানাহ (উত্তর আরব)',
      subtitleBn: 'আদনান থেকে মুহাম্মাদ (ﷺ) পর্যন্ত ২১টি প্রজন্ম সর্বসম্মতভাবে প্রমাণিত (সহীহ বুখারী)',
      agreed: true,
      generations: [
        GenealogyNode(gen: 21, nameBn: 'আদনান', nameAr: 'عدنان', branchesBn: 'উত্তর আরবের আদনানী গোত্রসমূহ', noteBn: 'আদনান থেকে মুহাম্মাদ (ﷺ) পর্যন্ত বংশলতিকা সম্পূর্ণ অকাট্য ও সর্বসম্মত।'),
        GenealogyNode(gen: 20, nameBn: 'মা’আদ ইবনে আদনান', nameAr: 'معد بن عدنان', noteBn: 'আরব গোত্রগুলোর প্রসিদ্ধ পূর্বপুরুষ।'),
        GenealogyNode(gen: 19, nameBn: 'নিযার ইবনে মা’আদ', nameAr: 'نزار بن معد', branchesBn: 'রাবী’আহ শাখা', noteBn: 'নিযার থেকে মুদার ও রাবী’আহ শাখার উৎপত্তি।'),
        GenealogyNode(gen: 18, nameBn: 'মুদার ইবনে নিযার', nameAr: 'مضر بن نزار', branchesBn: 'কায়স আইলান (হালিমা সাদিয়ার গোত্র)', noteBn: 'হিজাযের অন্যতম প্রধান গোত্রপতি।'),
        GenealogyNode(gen: 17, nameBn: 'ইলিয়াস ইবনে মুদার', nameAr: 'إلياس بن مضر', noteBn: 'হজের তালবিয়াহ ও কাবার সম্মান রক্ষাকারী।'),
        GenealogyNode(gen: 16, nameBn: 'মুদরিকাহ ইবনে ইলিয়াস', nameAr: 'مدركة بن إلياس', branchesBn: 'হুযাইল গোত্র (ইবনে মাসউদ রা.)', noteBn: 'প্রকৃত নাম আমির।'),
        GenealogyNode(gen: 15, nameBn: 'খুযাইমাহ ইবনে মুদরিকাহ', nameAr: 'خزيمة بن مدركة', branchesBn: 'বনু আসাদ ইবনে খুযাইমাহ', noteBn: 'কিনানাহর পিতা।'),
        GenealogyNode(gen: 14, nameBn: 'কিনানাহ ইবনে খুযাইমাহ', nameAr: 'كنانة بن خزيمة', branchesBn: 'বনু দামরাহ, বনু মুদলিজ', noteBn: 'মক্কা অঞ্চলের প্রধান গোত্রপতি।'),
      ],
    ),
    GenealogyEra(
      id: 'era-6',
      roman: 'VI',
      titleBn: '৬ষ্ঠ যুগ: কুরাইশ বংশ (আন-নাদর থেকে কিলাব)',
      subtitleBn: 'কুরাইশ গোত্রের নামকরণ ও উপ-গোত্রসমূহের বিস্তার',
      agreed: true,
      generations: [
        GenealogyNode(gen: 13, nameBn: 'আন-নাদর ইবনে কিনানাহ', nameAr: 'النضر بن كنانة', noteBn: 'তাঁর উপাধি ছিল কুরাইশ।'),
        GenealogyNode(gen: 12, nameBn: 'মালিক ইবনে আন-নাদর', nameAr: 'مالك بن النضر', noteBn: 'ফিহরের পিতা।'),
        GenealogyNode(gen: 11, nameBn: 'ফিহর ইবনে মালিক (কুরাইশ)', nameAr: 'فهر بن مالك (قريش)', branchesBn: 'বনু আল-হারিস (আবু উবাইদাহ রা.)', noteBn: 'ফিহরের বংশধরদেরই মূলত কুরাইশ বলা হয়।'),
        GenealogyNode(gen: 10, nameBn: 'গালিব ইবনে ফিহর', nameAr: 'غالب بن فهر', noteBn: 'লুয়াইয়ের পিতা।'),
        GenealogyNode(gen: 9, nameBn: 'লুয়াই ইবনে গালিব', nameAr: 'لؤي بن غالب', branchesBn: 'বনু আমির ইবনে লুয়াই', noteBn: 'কা’বের পিতা।'),
        GenealogyNode(gen: 8, nameBn: 'কা’ব ইবনে লুয়াই', nameAr: 'كعب بن لؤي', branchesBn: 'বনু আদী (উমর ইবনুল খাত্তাব রা.), বনু সাহম, বনু জুমাহ', noteBn: 'উমর (রা.)-এর বংশ তাঁর কাছে এসে রাসূল (ﷺ)-এর বংশের সাথে মিলিত হয়েছে।'),
        GenealogyNode(gen: 7, nameBn: 'মুররাহ ইবনে কা’ব', nameAr: 'مرة بن كعب', branchesBn: 'বনু তাইম (আবু বকর রা.), বনু মাখযুম (খালিদ রা.)', noteBn: 'আবু বকর সিদ্দীক (রা.)-এর বংশ মুররাহ ইবনে কা’বের কাছে মিলিত হয়েছে।'),
        GenealogyNode(gen: 6, nameBn: 'কিলাব ইবনে মুররাহ', nameAr: 'كلاب بن مرة', branchesBn: 'বনু যুহরাহ (মা আমিনা, সা’দ ও আবদুর রহমান ইবনে আউফ রা.)', noteBn: 'রাসূলুল্লাহ (ﷺ)-এর পিতৃ ও মাতৃ উভয় বংশধারা কিলাব ইবনে মুররাহর কাছে একত্রিত হয়েছে।'),
      ],
    ),
    GenealogyEra(
      id: 'era-7',
      roman: 'VII',
      titleBn: '৭ম যুগ: মক্কার নেতৃবৃন্দ (কুসাই থেকে আবদুল্লাহ)',
      subtitleBn: 'কাবা ঘরের তত্ত্বাবধান ও বনু হাশিম',
      agreed: true,
      generations: [
        GenealogyNode(gen: 5, nameBn: 'কুসাই ইবনে কিলাব', nameAr: 'قصي بن كلاب', motherBn: 'ফাতিমা বিনতে সা’দ', branchesBn: 'বনু আবদুদ দার, বনু আসাদ (খাদিজা রা.)', noteBn: 'কুরাইশদের ঐক্যবদ্ধ করে কাবার চাবি ও হজ পরিচালনার দায়িত্ব প্রতিষ্ঠা করেন।'),
        GenealogyNode(gen: 4, nameBn: 'আবদ মানাফ ইবনে কুসাই', nameAr: 'عبد مناف بن قصي', motherBn: 'হুব্বা বিনতে হুলাইল', branchesBn: 'বনু আবদ শামস ও বনু উমাইয়া (উসমান রা.), বনু মুত্তালিব', noteBn: 'মক্কার অত্যন্ত সম্মানিত সরদার।'),
        GenealogyNode(gen: 3, nameBn: 'হাশিম ইবনে আবদ মানাফ', nameAr: 'هاشم بن عبد مناف', motherBn: 'আতিকা বিনতে মুররাহ', branchesBn: 'বনু হাশিম', noteBn: 'হাজীদের মেহমানদারি এবং গ্রীষ্ম ও শীতকালীন বাণিজ্য কাফেলার প্রবর্তক।'),
        GenealogyNode(gen: 2, nameBn: 'আবদুল মুত্তালিব (শাইবাহ)', nameAr: 'عبد المطلب بن هاشم', motherBn: 'সালমা বিনতে আমর', branchesBn: 'হামযাহ (রা.), আব্বাস (রা.), আবু তালিবসহ ১০ পুত্র ও ৬ কন্যা', noteBn: 'যমযম কূপ পুনঃখননকারী ও রাসূল (ﷺ)-এর স্নেহময় দাদা।'),
        GenealogyNode(gen: 1, nameBn: 'আবদুল্লাহ ইবনে আবদুল মুত্তালিব', nameAr: 'عبد الله بن عبد المطلب', motherBn: 'ফাতিমা বিনতে আমর', noteBn: 'রাসূলুল্লাহ (ﷺ)-এর সম্মানিত পিতা; রাসূল (ﷺ)-এর জন্মের পূর্বেই ২৫ বছর বয়সে মদিনায় ইন্তেকাল করেন।'),
      ],
    ),
    GenealogyEra(
      id: 'era-8',
      roman: 'VIII',
      titleBn: '৮ম যুগ: সাইয়্যিদুল মুরসালীন মুহাম্মাদুর রাসূলুল্লাহ (ﷺ)',
      subtitleBn: 'খাতামুন নাবিয়্যীন ও রাহমাতুল্লিল আলামীন',
      agreed: true,
      generations: [
        GenealogyNode(
          gen: 0,
          nameBn: 'মুহাম্মাদ ইবনে আবদুল্লাহ (ﷺ)',
          nameAr: 'مُحَمَّدُ بْنُ عَبْدِ اللَّهِ ﷺ',
          isProphet: true,
          motherBn: 'আমিনা বিনতে ওয়াহাব ইবনে আবদ মানাফ ইবনে যুহরাহ',
          branchesBn: '১১ উম্মাহাতুল মুমিনীন, ৭ সন্তান ও ৭ দৌহিত্র-দৌহিত্রী',
          noteBn: 'আল-আমিন, আস-সাদিক, সাইয়্যিদুল মুরসালীন ও সর্বশেষ নবী ও রাসূল (৫৭০–৬৩২ খ্রি. / ১১ হিজরি)।',
        ),
      ],
    ),
  ];

  // 3. PROPHET'S HOUSEHOLD & FAMILY
  static const List<FamilyCategory> familyCategories = [
    FamilyCategory(
      key: 'wives',
      titleBn: 'উম্মাহাতুল মুমিনীন (১১ জন সহধর্মিণী)',
      countBn: '১১ জন',
      members: [
        FamilyMember(nameBn: 'খাদিজা বিনতে খুওয়াইলিদ (রা.)', nameAr: 'خديجة بنت خويلد رضي الله عنها', relationBn: '১ম সহধর্মিণী', lifeBn: '৫৫৫ – ৬১৯ খ্রি. • মক্কা', descBn: 'সর্বপ্রথম ইসলাম গ্রহণকারী ও ২৫ বছরের জীবনসঙ্গিনী। ইবরাহীম ব্যতীত রাসূল (ﷺ)-এর সকল সন্তানের জননী।'),
        FamilyMember(nameBn: 'সাওদা বিনতে যাম’আহ (রা.)', nameAr: 'سودة بنت زمعة رضي الله عنها', relationBn: '২য় সহধর্মিণী', lifeBn: 'ওফাত: ৫৪ হিজরি • মদিনা', descBn: 'হাবশায় হিজরতকারী প্রবীণ সাহাবিয়া; খাদিজা (রা.)-এর ইন্তেকালের পর রাসূল (ﷺ) তাঁকে বিবাহ করেন।'),
        FamilyMember(nameBn: 'আয়েশা বিনতে আবি বকর (রা.)', nameAr: 'عائشة بنت أبي بكر رضي الله عنها', relationBn: '৩য় সহধর্মিণী', lifeBn: 'ওফাত: ৫৮ হিজরি • মদিনা', descBn: 'আবু বকর সিদ্দীক (রা.)-এর কন্যা এবং উম্মতের শ্রেষ্ঠ নারী ফকিহ ও মুহাদ্দিস (২,২১০টি হাদিস বর্ণনাকারী)।'),
        FamilyMember(nameBn: 'হাফসা বিনতে উমর (রা.)', nameAr: 'حفصة بنت عمر رضي الله عنها', relationBn: '৪র্থ সহধর্মিণী', lifeBn: 'ওফাত: ৪৫ হিজরি • মদিনা', descBn: 'উমর (রা.)-এর কন্যা ও কুরআনের সংকলিত মূল মাসহাফের সংরক্ষক।'),
        FamilyMember(nameBn: 'যয়নব বিনতে খুযাইমা (রা.)', nameAr: 'زينب بنت خزيمة رضي الله عنها', relationBn: '৫ম সহধর্মিণী', lifeBn: 'ওফাত: ৪ হিজরি • মদিনা', descBn: 'দরিদ্রদের প্রতি অসীম দয়ার কারণে উম্মুল মাসাকীন উপাধিতে ভূষিত ছিলেন।'),
        FamilyMember(nameBn: 'উম্মে সালামা (রা.)', nameAr: 'أم سلمة هند بنت أبي أمية رضي الله عنها', relationBn: '৬ষ্ঠ সহধর্মিণী', lifeBn: 'ওফাত: ৬১ হিজরি • মদিনা', descBn: 'প্রাজ্ঞ সাহাবিয়া; হুদাইবিয়ার সন্ধির দিন তাঁর পরামর্শ মুসলিমদের সংকট নিরসন করে।'),
        FamilyMember(nameBn: 'যয়নব বিনতে জাহশ (রা.)', nameAr: 'زينب بنت جحش رضي الله عنها', relationBn: '৭ম সহধর্মিণী', lifeBn: 'ওফাত: ২০ হিজরি • মদিনা', descBn: 'সূরা আহযাবের ৩৭ নং আয়াতের মাধ্যমে স্বয়ং আল্লাহ তাআলা আসমানে তাঁর বিবাহের ফয়সালা করেন।'),
        FamilyMember(nameBn: 'জুওয়াইরিয়া বিনতে আল-হারিস (রা.)', nameAr: 'جويرية بنت الحارث رضي الله عنها', relationBn: '৮ম সহধর্মিণী', lifeBn: 'ওফাত: ৫৬ হিজরি • মদিনা', descBn: 'তাঁর সাথে রাসূল (ﷺ)-এর বিবাহের বরকতে বনু মুস্তালিক গোত্রের সবাই মুক্তি লাভ করে ও ইসলাম গ্রহণ করে।'),
        FamilyMember(nameBn: 'উম্মে হাবিবা বিনতে আবি সুফিয়ান (রা.)', nameAr: 'أم حبيبة رملة بنت أبي سفيان رضي الله عنها', relationBn: '৯ম সহধর্মিণী', lifeBn: 'ওফাত: ৪৪ হিজরি • মদিনা', descBn: 'হাবশায় হিজরতকারী সাহাবিয়া; বাদশাহ নাজাশীর মাধ্যমে ৭ হিজরিতে তাঁর বিবাহ সম্পন্ন হয়।'),
        FamilyMember(nameBn: 'সাফিয়্যা বিনতে হুয়াই (রা.)', nameAr: 'صفية بنت حيي رضي الله عنها', relationBn: '১০ম সহধর্মিণী', lifeBn: 'ওফাত: ৫০ হিজরি • মদিনা', descBn: 'হারুন (আ.)-এর বংশধর; খায়বার বিজয়ের পর ইসলাম গ্রহণ করেন।'),
        FamilyMember(nameBn: 'মাইমুনা বিনতে আল-হারিস (রা.)', nameAr: 'ميمونة بنت الحارث رضي الله عنها', relationBn: '১১তম সহধর্মিণী', lifeBn: 'ওফাত: ৫১ হিজরি • সারিফ', descBn: '৭ হিজরিতে উমরাতুল কাযার পর রাসূলুল্লাহ (ﷺ)-এর সর্বশেষ বিবাহিতা সহধর্মিণী।'),
      ],
    ),
    FamilyCategory(
      key: 'children',
      titleBn: 'সন্তানগণ (৩ পুত্র ও ৪ কন্যা)',
      countBn: '৭ জন',
      members: [
        FamilyMember(nameBn: 'আল-কাসিম ইবনে মুহাম্মাদ', nameAr: 'القاسم بن محمد', relationBn: 'জ্যেষ্ঠ পুত্র (মাতা: খাদিজা রা.)', lifeBn: 'শৈশবে মক্কায় ওফাত', descBn: 'প্রথম সন্তান; তাঁর নামানুসারে রাসূলুল্লাহ (ﷺ)-এর কুনিয়াত ছিল আবুল কাসিম।'),
        FamilyMember(nameBn: 'যয়নব বিনতে মুহাম্মাদ (রা.)', nameAr: 'زينب بنت محمد رضي الله عنها', relationBn: 'জ্যেষ্ঠা কন্যা (মাতা: খাদিজা রা.)', lifeBn: 'ওফাত: ৮ হিজরি • মদিনা', descBn: 'আবুল আস ইবনুর রাবী (রা.)-এর সহধর্মিণী এবং আলী ও উমামা (রা.)-এর মাতা।'),
        FamilyMember(nameBn: 'রুকাইয়া বিনতে মুহাম্মাদ (রা.)', nameAr: 'رقية بنت محمد رضي الله عنها', relationBn: '২য় কন্যা (মাতা: খাদিজা রা.)', lifeBn: 'ওফাত: ২ হিজরি (বদর যুদ্ধের দিন)', descBn: 'উসমান ইবনে আফফান (রা.)-এর সহধর্মিণী; হাবশা ও মদিনায় হিজরতকারী।'),
        FamilyMember(nameBn: 'উম্মে কুলসুম বিনতে মুহাম্মাদ (রা.)', nameAr: 'أم كلثوم بنت محمد رضي الله عنها', relationBn: '৩য় কন্যা (মাতা: খাদিজা রা.)', lifeBn: 'ওফাত: ৯ হিজরি • মদিনা', descBn: 'রুকাইয়া (রা.)-এর ওফাতের পর উসমান (রা.)-এর সাথে তাঁর বিবাহ হয়।'),
        FamilyMember(nameBn: 'ফাতিমা আয-যাহরা (রা.)', nameAr: 'فاطمة الزهراء بنت محمد رضي الله عنها', relationBn: 'কনিষ্ঠা কন্যা (মাতা: খাদিজা রা.)', lifeBn: '৬০৫ – ১১ হিজরি • মদিনা', descBn: 'জান্নাতের নারীদের সরদার, আলী (রা.)-এর সহধর্মিণী এবং হাসান ও হুসাইন (রা.)-এর জননী।'),
        FamilyMember(nameBn: 'আবদুল্লাহ ইবনে মুহাম্মাদ (তাইয়্যিব/তাহির)', nameAr: 'عبد الله بن محمد', relationBn: '২য় পুত্র (মাতা: খাদিজা রা.)', lifeBn: 'শৈশবে মক্কায় ওফাত', descBn: 'তাঁর ওফাতের পর কাফেরদের কটূক্তির জবাবে সূরা আল-কাওসার নাযিল হয়।'),
        FamilyMember(nameBn: 'ইবরাহীম ইবনে মুহাম্মাদ', nameAr: 'إبراهيم بن محمد', relationBn: 'কনিষ্ঠ পুত্র (মাতা: মারিয়া কিবতিয়া রা.)', lifeBn: '৮ – ১০ হিজরি • মদিনা', descBn: 'মদিনায় জন্মগ্রহণ করেন এবং ১৮ মাস বয়সে ইন্তেকাল করেন।'),
      ],
    ),
    FamilyCategory(
      key: 'grandchildren',
      titleBn: 'দৌহিত্র ও দৌহিত্রী (৭ জন)',
      countBn: '৭ জন',
      members: [
        FamilyMember(nameBn: 'আল-হাসান ইবনে আলী (রা.)', nameAr: 'الحسن بن علي رضي الله عنه', relationBn: 'দৌহিত্র (ফাতিমা ও আলী রা.-এর পুত্র)', lifeBn: '৩ – ৫০ হিজরি • মদিনা', descBn: 'জান্নাতের যুবকদের সরদার ও মুসলিম উম্মাহর ঐক্য স্থাপনকারী।'),
        FamilyMember(nameBn: 'আল-হুসাইন ইবনে আলী (রা.)', nameAr: 'الحسين بن علي رضي الله عنه', relationBn: 'দৌহিত্র (ফাতিমা ও আলী রা.-এর পুত্র)', lifeBn: '৪ – ৬১ হিজরি', descBn: 'জান্নাতের যুবকদের সরদার ও কারবালার মহান শহীদ।'),
        FamilyMember(nameBn: 'উমামা বিনতে আবিল আস (রা.)', nameAr: 'أمامة بنت أبي العاص رضي الله عنها', relationBn: 'দৌহিত্রী (যয়নব রা.-এর কন্যা)', lifeBn: 'সাহাবিয়া', descBn: 'রাসূলুল্লাহ (ﷺ)-এর অত্যন্ত স্নেহভাজন নাতনি।'),
        FamilyMember(nameBn: 'আলী ইবনে আবিল আস ও আবদুল্লাহ ইবনে উসমান', nameAr: 'علي بن أبي العاص وعبد الله بن عثمان', relationBn: 'দৌহিত্রদ্বয়', lifeBn: 'শৈশব/কৈশোরে ওফাত', descBn: 'যয়নব (রা.) এবং রুকাইয়া (রা.)-এর পুত্রদ্বয়।'),
        FamilyMember(nameBn: 'যয়নব বিনতে আলী ও উম্মে কুলসুম বিনতে আলী (রা.)', nameAr: 'زينب وأم كلثوم بنتا علي رضي الله عنهما', relationBn: 'দৌহিত্রীদ্বয়', lifeBn: 'ফাতিমা ও আলী (রা.)-এর কন্যাদ্বয়', descBn: 'রাসূলুল্লাহ (ﷺ)-এর জীবদ্দশায় জন্মগ্রহণকারী দৌহিত্রীদ্বয়।'),
      ],
    ),
    FamilyCategory(
      key: 'relatives',
      titleBn: 'পিতা-মাতা, দাদা, চাচা-ফুফু ও দুধ-মাতা পরিজন',
      countBn: '১৫+ জন',
      members: [
        FamilyMember(nameBn: 'আবদুল্লাহ ইবনে আবদুল মুত্তালিব ও আমিনা বিনতে ওয়াহাব', nameAr: 'عبد الله بن عبد المطلب وآمنة بنت وهب', relationBn: 'পিতা ও মাতা', lifeBn: 'মদিনা ও আল-আবওয়া', descBn: 'রাসূলুল্লাহ (ﷺ)-এর সম্মানিত পিতা ও মাতা।'),
        FamilyMember(nameBn: 'আবদুল মুত্তালিব ইবনে হাশিম', nameAr: 'عبد المطلب بن هاشم', relationBn: 'দাদা (পিতামহ)', lifeBn: '৪৯৭ – ৫৭৮ খ্রি. • মক্কা', descBn: 'যমযম কূপ পুনঃখননকারী এবং ৮ বছর বয়স পর্যন্ত রাসূল (ﷺ)-এর অভিভাবক।'),
        FamilyMember(nameBn: 'হামযাহ (রা.), আব্বাস (রা.) ও আবু তালিব', nameAr: 'حمزة والعباس وأبو طالب', relationBn: 'প্রধান চাচাগণ', lifeBn: 'বনু হাশিম', descBn: 'হামযাহ (রা.) শহীদদের সরদার, আব্বাস (রা.) বদর ও হুনাইনের সঙ্গী এবং আবু তালিব ৪২ বছর রাসূল (ﷺ)-এর রক্ষাকারী।'),
        FamilyMember(nameBn: 'সাফিয়্যা (রা.) ও আরওয়া বিনতে আবদুল মুত্তালিব (রা.)', nameAr: 'صفية وأروى بنتا عبد المطلب رضي الله عنهما', relationBn: 'সাহাবিয়া ফুফুদ্বয়', lifeBn: 'মদিনা', descBn: 'ইসলাম গ্রহণকারী বীর ফুফুদ্বয়; সাফিয়্যা (রা.) ছিলেন যুবাইর ইবনুল আওয়াম (রা.)-এর মাতা।'),
        FamilyMember(nameBn: 'হালিমা সাদিয়া, সুওয়াইবা ও উম্মে আইমান (রা.)', nameAr: 'حليمة السعدية وثويبة وأم أيمن رضي الله عنها', relationBn: 'দুধ-মাতা ও ধাত্রী মাতা', lifeBn: 'বনু সা’দ ও মদিনা', descBn: 'শৈশবে দুধপান ও লালন-পালনকারী এবং উম্মে আইমান (রা.)-কে রাসূল (ﷺ) বলতেন—"আমার মায়ের পর আমার মা।"'),
        FamilyMember(nameBn: 'যায়েদ ইবনে হারিসা (রা.) ও উসামা ইবনে যায়েদ (রা.)', nameAr: 'زيد بن حارثة وأسامة بن زيد رضي الله عنهما', relationBn: 'হিব্বু রাসূলিল্লাহ ও তাঁর পুত্র', lifeBn: 'মদিনা', descBn: 'কুরআনে নাম উল্লেখিত একমাত্র সাহাবী যায়েদ (রা.) এবং তাঁর পুত্র তরুণ সেনাপতি উসামা (রা.)।'),
      ],
    ),
  ];

  // 4. COMPANIONS DIRECTORY
  static const List<CompanionModel> companions = [
    CompanionModel(
      id: 'abu-bakr',
      nameBn: 'আবু বকর আস-সিদ্দীক (রা.)',
      nameAr: 'أبو بكر الصديق رضي الله عنه',
      laqabBn: 'আস-সিদ্দীক • সানি ইসনাইন (গুহার সঙ্গী)',
      acceptedBn: '৬১০ খ্রি. (১ম বর্ষ)',
      lifeBn: '৫৭৩ – ১৩ হিজরি / ৬৩৪ খ্রি.',
      roles: ['caliph', 'asharah', 'muhajir', 'badri'],
      rolesBn: ['১ম খলিফা', 'আশারায়ে মুবাশশারাহ', 'মুহাজির', 'বদরী'],
      bioBn: 'প্রাপ্তবয়স্ক পুরুষদের মধ্যে প্রথম ইসলাম গ্রহণকারী, হিজরত ও সওর গুহার সঙ্গী এবং ইসলামের প্রথম খলিফা (১১–১৩ হিজরি)।',
    ),
    CompanionModel(
      id: 'umar',
      nameBn: 'উমর ইবনুল খাত্তাব (রা.)',
      nameAr: 'عمر بن الخطاب رضي الله عنه',
      laqabBn: 'আল-ফারুক • আমীরুল মুমিনীন',
      acceptedBn: '৬১৬ খ্রি. (৬ষ্ঠ বর্ষ)',
      lifeBn: '৫৮৪ – ২৩ হিজরি / ৬৪৪ খ্রি.',
      roles: ['caliph', 'asharah', 'muhajir', 'badri', 'martyr'],
      rolesBn: ['২য় খলিফা', 'আশারায়ে মুবাশশারাহ', 'মুহাজির', 'বদরী', 'শহীদ'],
      bioBn: 'ইসলামের দ্বিতীয় খলিফা (১৩–২৩ হিজরি); যাঁর শাসনামলে বাইতুল মুকাদ্দাস, শাম, ইরাক, পারস্য ও মিসর বিজিত হয় এবং হিজরি ক্যালেন্ডার প্রবর্তিত হয়।',
    ),
    CompanionModel(
      id: 'uthman',
      nameBn: 'উসমান ইবনে আফফান (রা.)',
      nameAr: 'عثمان بن عفان رضي الله عنه',
      laqabBn: 'যুন-নূরাইন (দুই নূরের অধিকারী)',
      acceptedBn: '৬১১ খ্রি.',
      lifeBn: '৫৭৬ – ৩৫ হিজরি / ৬৫৬ খ্রি.',
      roles: ['caliph', 'asharah', 'muhajir', 'martyr'],
      rolesBn: ['৩য় খলিফা', 'আশারায়ে মুবাশশারাহ', 'মুহাজির', 'শহীদ'],
      bioBn: 'রাসূলুল্লাহ (ﷺ)-এর দুই কন্যা রুকাইয়া ও উম্মে কুলসুম (রা.)-এর স্বামী, বীরে রুমার দাতা, তাবুক বাহিনীর পৃষ্ঠপোষক ও তৃতীয় খলিফা।',
    ),
    CompanionModel(
      id: 'ali',
      nameBn: 'আলী ইবনে আবি তালিব (রা.)',
      nameAr: 'علي بن أبي طالب رضي الله عنه',
      laqabBn: 'আসাদুল্লাহ • আবু তুরাব',
      acceptedBn: '৬১০ খ্রি. (১ম বর্ষ)',
      lifeBn: '৬০০ – ৪০ হিজরি / ৬৬১ খ্রি.',
      roles: ['caliph', 'asharah', 'muhajir', 'badri', 'martyr', 'commander'],
      rolesBn: ['৪র্থ খলিফা', 'আশারায়ে মুবাশশারাহ', 'মুহাজির', 'বদরী', 'শহীদ'],
      bioBn: 'কিশোরদের মধ্যে প্রথম মুসলিম, ফাতিমা (রা.)-এর স্বামী, বদর ও খায়বার বিজয়ের বীর এবং ইসলামের চতুর্থ খলিফা।',
    ),
    CompanionModel(
      id: 'talhah',
      nameBn: 'তালহা ইবনে উবাইদুল্লাহ (রা.)',
      nameAr: 'طلحة بن عبيد الله رضي الله عنه',
      laqabBn: 'তালহাতুল খাইর • জীবন্ত শহীদ',
      acceptedBn: '৬১১ খ্রি.',
      lifeBn: '৫৯৪ – ৩৬ হিজরি / ৬৫৬ খ্রি.',
      roles: ['asharah', 'muhajir', 'martyr'],
      rolesBn: ['আশারায়ে মুবাশশারাহ', 'মুহাজির', 'শহীদ'],
      bioBn: 'উহুদ যুদ্ধে নিজ শরীর ও হাত দিয়ে তীর ঠেকিয়ে রাসূলুল্লাহ (ﷺ)-কে রক্ষা করেন এবং পৃথিবীতেই জান্নাতের সুসংবাদ লাভ করেন।',
    ),
    CompanionModel(
      id: 'zubayr',
      nameBn: 'যুবাইর ইবনুল আওয়াম (রা.)',
      nameAr: 'الزبير بن العوام رضي الله عنه',
      laqabBn: 'হাওয়ারিয়্যু রাসূলিল্লাহ (রাসূলের একনিষ্ঠ সাহায্যকারী)',
      acceptedBn: '৬১১ খ্রি.',
      lifeBn: '৫৯৪ – ৩৬ হিজরি / ৬৫৬ খ্রি.',
      roles: ['asharah', 'muhajir', 'badri', 'martyr'],
      rolesBn: ['আশারায়ে মুবাশশারাহ', 'মুহাজির', 'বদরী', 'শহীদ'],
      bioBn: 'রাসূলুল্লাহ (ﷺ)-এর ফুফাতো ভাই এবং আল্লাহর পথে প্রথম তরবারি উত্তোলনকারী সাহাবী।',
    ),
    CompanionModel(
      id: 'abdur-rahman',
      nameBn: 'আবদুর রহমান ইবনে আউফ (রা.)',
      nameAr: 'عبد الرحمن بن عوف رضي الله عنه',
      laqabBn: 'তাজিরুর রহমান (দয়াময়ের ব্যবসায়ী)',
      acceptedBn: '৬১১ খ্রি.',
      lifeBn: '৫৮০ – ৩২ হিজরি / ৬৫২ খ্রি.',
      roles: ['asharah', 'muhajir', 'badri'],
      rolesBn: ['আশারায়ে মুবাশশারাহ', 'মুহাজির', 'বদরী'],
      bioBn: 'আশারায়ে মুবাশশারাহর অন্যতম সদস্য, যিনি মদিনায় শূন্য হাতে হিজরত করে হালাল ব্যবসার মাধ্যমে অর্জিত বিপুল সম্পদ আল্লাহর রাস্তায় দান করেন।',
    ),
    CompanionModel(
      id: 'sad-abi-waqqas',
      nameBn: 'সা’দ ইবনে আবি ওয়াক্কাস (রা.)',
      nameAr: 'سعد بن أبي وقاص رضي الله عنه',
      laqabBn: 'মুস্তাজাবুদ দাওয়াহ • কাদিসিয়ার বিজেতা',
      acceptedBn: '৬১১ খ্রি.',
      lifeBn: '৫৯৫ – ৫৫ হিজরি / ৬৭৪ খ্রি.',
      roles: ['asharah', 'muhajir', 'badri', 'commander'],
      rolesBn: ['আশারায়ে মুবাশশারাহ', 'মুহাজির', 'বদরী', 'সেনাপতি'],
      bioBn: 'ইসলামের পথে প্রথম তীর নিক্ষেপকারী এবং কাদিসিয়া যুদ্ধে পারস্য বিজয়ের প্রধান সেনাপতি।',
    ),
    CompanionModel(
      id: 'said-ibn-zayd',
      nameBn: 'সাঈদ ইবনে যায়েদ (রা.)',
      nameAr: 'سعيد بن زيد رضي الله عنه',
      laqabBn: 'আশারায়ে মুবাশশারাহর সাহাবী',
      acceptedBn: '৬১৪ খ্রি.',
      lifeBn: '৫৯৩ – ৫১ হিজরি / ৬৭১ খ্রি.',
      roles: ['asharah', 'muhajir'],
      rolesBn: ['আশারায়ে মুবাশশারাহ', 'মুহাজির'],
      bioBn: 'জান্নাতের সুসংবাদপ্রাপ্ত দশজন সাহাবীর অন্যতম এবং ফাতিমা বিনতে খাত্তাব (রা.)-এর স্বামী।',
    ),
    CompanionModel(
      id: 'abu-ubaydah',
      nameBn: 'আবু উবাইদাহ ইবনুল জাররাহ (রা.)',
      nameAr: 'أبو عبيدة بن الجراح رضي الله عنه',
      laqabBn: 'আমীনুল উম্মাহ (উম্মতের বিশ্বস্ততম ব্যক্তি)',
      acceptedBn: '৬১১ খ্রি.',
      lifeBn: '৫৮৩ – ১৮ হিজরি / ৬৩৯ খ্রি.',
      roles: ['asharah', 'muhajir', 'badri', 'commander'],
      rolesBn: ['আশারায়ে মুবাশশারাহ', 'মুহাজির', 'বদরী', 'সেনাপতি'],
      bioBn: 'রাসূলুল্লাহ (ﷺ) যাঁকে আমীনুল উম্মাহ উপাধি দিয়েছেন এবং যিনি শাম ও বাইতুল মুকাদ্দাস অভিযানের প্রধান সেনাপতি ছিলেন।',
    ),
    CompanionModel(
      id: 'hamzah',
      nameBn: 'হামযাহ ইবনে আবদুল মুত্তালিব (রা.)',
      nameAr: 'حمزة بن عبد المطلب رضي الله عنه',
      laqabBn: 'আসাদুল্লাহ • সাইয়্যিদুশ শুহাদা',
      acceptedBn: '৬১৫ খ্রি.',
      lifeBn: '৫৬৮ – ৩ হিজরি / ৬২৫ খ্রি. (উহুদ)',
      roles: ['muhajir', 'badri', 'martyr', 'commander'],
      rolesBn: ['মুহাজির', 'বদরী', 'শহীদ', 'সেনাপতি'],
      bioBn: 'রাসূলুল্লাহ (ﷺ)-এর চাচা, বদর যুদ্ধের বীর যোদ্ধা এবং উহুদ প্রান্তরে শাহাদাত বরণকারী শহীদদের সরদার।',
    ),
    CompanionModel(
      id: 'musab',
      nameBn: 'মুসআব ইবনে উমাইর (রা.)',
      nameAr: 'مصعب بن عمير رضي الله عنه',
      laqabBn: 'আস-সাফীরুল আউয়াল (ইসলামের প্রথম দূত)',
      acceptedBn: '৬১৪ খ্রি.',
      lifeBn: '৫৮৫ – ৩ হিজরি / ৬২৫ খ্রি. (উহুদ)',
      roles: ['muhajir', 'badri', 'martyr', 'envoy'],
      rolesBn: ['মুহাজির', 'বদরী', 'শহীদ', 'দূত'],
      bioBn: 'মদিনায় প্রেরিত ইসলামের প্রথম শিক্ষক ও দাঈ এবং বদর ও উহুদ যুদ্ধে মুসলিম বাহিনীর পতাকাবাহী।',
    ),
    CompanionModel(
      id: 'bilal',
      nameBn: 'বিলাল ইবনে রাবাহ (রা.)',
      nameAr: 'بلال بن رباح رضي الله عنه',
      laqabBn: 'মুয়াজ্জিনু রাসূলিল্লাহ (ﷺ)',
      acceptedBn: '৬১০ খ্রি.',
      lifeBn: '৫৮০ – ২০ হিজরি / ৬৪০ খ্রি.',
      roles: ['muhajir', 'badri'],
      rolesBn: ['মুহাজির', 'বদরী', '১ম মুয়াজ্জিন'],
      bioBn: 'মক্কার উত্তপ্ত মরুভূমিতে আহাদ আহাদ ঘোষণাকারী, ইসলামের প্রথম মুয়াজ্জিন ও মক্কা বিজয়ের দিন কাবার ছাদে আজানদাতা।',
    ),
    CompanionModel(
      id: 'khalid',
      nameBn: 'খালিদ ইবনে ওয়ালিদ (রা.)',
      nameAr: 'خالد بن الوليد رضي الله عنه',
      laqabBn: 'সাইফুল্লাহিল মাসলূল (আল্লাহর উন্মুক্ত তরবারি)',
      acceptedBn: '৮ হিজরি / ৬২৯ খ্রি.',
      lifeBn: '৫৯২ – ২১ হিজরি / ৬৪২ খ্রি.',
      roles: ['muhajir', 'commander'],
      rolesBn: ['মুহাজির', 'সেনাপতি'],
      bioBn: 'মু’তা, মক্কা বিজয়, হুনাইন, ইয়ামামা ও ইয়ারমুক যুদ্ধের অপরাজিত সেনাপতি।',
    ),
    CompanionModel(
      id: 'sad-muadh',
      nameBn: 'সা’দ ইবনে মুআয (রা.) ও আবু আইয়ুব আনসারী (রা.)',
      nameAr: 'سعد بن معاذ وأبو أيوب الأنصاري رضي الله عنهما',
      laqabBn: 'আনসারদের প্রধান নেতা ও রাসূল (ﷺ)-এর মেজবান',
      acceptedBn: 'বাইআতে আকাবা ও ১ হিজরি',
      lifeBn: 'মদিনা ও কনস্টান্টিনোপল',
      roles: ['ansar', 'badri', 'martyr'],
      rolesBn: ['আনসার', 'বদরী', 'শহীদ'],
      bioBn: 'সা’দ ইবনে মুআয (রা.)-এর ওফাতে আল্লাহর আরশ কেঁপে উঠেছিল এবং আবু আইয়ুব আনসারী (রা.) হিজরতের পর রাসূল (ﷺ)-কে মেহমানদারি করেন।',
    ),
    CompanionModel(
      id: 'scholars',
      nameBn: 'আবু হুরায়রা, আনাস ইবনে মালিক, মুআয ও ইবনে মাসউদ (রা.)',
      nameAr: 'أبو هريرة وأنس ومعاذ وابن مسعود رضي الله عنهم',
      laqabBn: 'উম্মতের শীর্ষ হাদিস বর্ণনাকারী ও ফকিহ সাহাবীগণ',
      acceptedBn: 'মক্কী ও মাদানী যুগ',
      lifeBn: 'মদিনা, কুফা ও বসরা',
      roles: ['muhajir', 'ansar', 'badri', 'envoy'],
      rolesBn: ['শীর্ষ মুহাদ্দিস', 'ফকিহ', 'দূত'],
      bioBn: 'রাসূলুল্লাহ (ﷺ)-এর কুরআন, ফিকহ ও হাজার হাজার হাদিস উম্মতের কাছে পৌঁছে দেওয়ার প্রধান স্তম্ভ।',
    ),
  ];

  // 5. BATTLES & EXPEDITIONS (GHAZWAT & SARAYA)
  static const List<BattleModel> battles = [
    BattleModel(
      id: 'early-patrols',
      type: 'sariyyah',
      typeBn: 'সারিয়্যাহ (প্রেরিত দল)',
      yearAh: '১ হিজরি',
      dateBn: 'রমজান ১ হিজরি • ৬২৩ খ্রি.',
      nameBn: 'প্রাথমিক টহল অভিযান (সিফুল বাহর ও রাবিগ)',
      nameAr: 'سرايا حمزة وعبيدة وسعد',
      locationBn: 'লোহিত সাগর উপকূল ও রাবিগ',
      outcome: 'no_fighting',
      outcomeBn: 'বিনা যুদ্ধে সমাপ্তি',
      muslimForceNum: 60,
      enemyForceNum: 300,
      muslimForceBn: '৩০–৬০ জন মুহাজির',
      enemyForceBn: '২০০–৩০০ কুরাইশ অশ্বারোহী',
      muslimCmdBn: 'হামযাহ (রা.), উবাইদাহ (রা.), সা’দ ইবনে আবি ওয়াক্কাস (রা.)',
      enemyCmdBn: 'আবু জাহেল ও আবু সুফিয়ান',
      lossesBn: 'কোনো হতাহত হয়নি; সা’দ (রা.) প্রথম তীর নিক্ষেপ করেন',
      summaryBn: 'হিজরতের পর মদিনার নিরাপত্তা নিশ্চিত করতে প্রেরিত প্রথম টহল অভিযানসমূহ।',
    ),
    BattleModel(
      id: 'ghazwah-abwa',
      type: 'ghazwah',
      typeBn: 'গাযওয়া (রাসূল ﷺ নিজে নেতৃত্ব দেন)',
      yearAh: '২ হিজরি',
      dateBn: 'সফর ২ হিজরি • ৬২৩ খ্রি.',
      nameBn: '১ম গাযওয়া: আল-আবওয়া (ওয়াদ্দান), বুওয়াত ও যুল-উশাইরাহ',
      nameAr: 'غزوة الأبواء وبواط وذي العشيرة',
      locationBn: 'আল-আবওয়া, বুওয়াত ও ইয়ানবু অঞ্চল',
      outcome: 'treaty',
      outcomeBn: 'মৈত্রী চুক্তি স্বাক্ষরিত',
      muslimForceNum: 150,
      enemyForceNum: 100,
      muslimForceBn: '৬০–২০০ জন সাহাবী',
      enemyForceBn: 'কুরাইশ কাফেলা (সাক্ষাৎ ঘটেনি)',
      muslimCmdBn: 'মুহাম্মাদুর রাসূলুল্লাহ (ﷺ)',
      enemyCmdBn: 'বনু দামরাহ ও বনু মুদলিজ গোত্রের সাথে চুক্তি',
      lossesBn: 'কোনো যুদ্ধ ছাড়াই শান্তি চুক্তি সম্পাদিত',
      summaryBn: 'রাসূলুল্লাহ (ﷺ) স্বয়ং নেতৃত্ব দেওয়া প্রথম অভিযানসমূহ, যার মাধ্যমে মদিনার চারপাশের গোত্রগুলোর সাথে মৈত্রী চুক্তি স্থাপিত হয়।',
    ),
    BattleModel(
      id: 'battle-of-badr',
      type: 'ghazwah',
      typeBn: 'গাযওয়া (রাসূল ﷺ নিজে নেতৃত্ব দেন)',
      yearAh: '২ হিজরি',
      dateBn: '১৭ রমজান ২ হিজরি • ৬২৪ খ্রি.',
      nameBn: 'গাযওয়ায়ে বদর আল-কুবরা (ঐতিহাসিক বদর যুদ্ধ)',
      nameAr: 'غزوة بدر الكبرى',
      locationBn: 'বদর প্রান্তর',
      outcome: 'victory',
      outcomeBn: 'ঐতিহাসিক মুসলিম বিজয়',
      muslimForceNum: 313,
      enemyForceNum: 1000,
      muslimForceBn: '৩১৩–৩১৭ জন সাহাবী, ২টি ঘোড়া, ৭০টি উট',
      enemyForceBn: '১,০০০ কুরাইশ সৈন্য, ১০০ ঘোড়া, ৭০০ উট',
      muslimCmdBn: 'মুহাম্মাদুর রাসূলুল্লাহ (ﷺ)',
      enemyCmdBn: 'আবু জাহেল, উতবাহ ইবনে রাবী’আহ',
      lossesBn: 'মুসলিম: ১৪ জন শহীদ • কুরাইশ: ৭০ জন নিহত ও ৭০ জন বন্দী',
      summaryBn: 'সত্য ও মিথ্যার পার্থক্যকারী দিন (ইয়াওমুল ফুরকান)। তিনগুণ বড় কুরাইশ বাহিনীর বিরুদ্ধে ৩১৩ জন সাহাবীর চূড়ান্ত বিজয়।',
    ),
    BattleModel(
      id: 'battle-of-uhud',
      type: 'ghazwah',
      typeBn: 'গাযওয়া (রাসূল ﷺ নিজে নেতৃত্ব দেন)',
      yearAh: '৩ হিজরি',
      dateBn: '৭ শাওয়াল ৩ হিজরি • ৬২৫ খ্রি.',
      nameBn: 'গাযওয়ায়ে উহুদ ও হামরাউল আসাদ',
      nameAr: 'غزوة أحد وغزوة حمراء الأسد',
      locationBn: 'উহুদ পর্বত ও হামরাউল আসাদ',
      outcome: 'trial',
      outcomeBn: 'কঠিন পরীক্ষা ও প্রতিরোধ',
      muslimForceNum: 700,
      enemyForceNum: 3000,
      muslimForceBn: '৭০০ জন সাহাবী',
      enemyForceBn: '৩,০০০ সৈন্য ও ২০০ অশ্বারোহী',
      muslimCmdBn: 'মুহাম্মাদুর রাসূলুল্লাহ (ﷺ)',
      enemyCmdBn: 'আবু সুফিয়ান ও খালিদ ইবনে ওয়ালিদ (তৎকালীন)',
      lossesBn: 'মুসলিম: ৭০ জন শহীদ (হামযাহ ও মুসআব রা. সহ) • কুরাইশ: ২২–৩৭ নিহত',
      summaryBn: 'তীরন্দাজদের গিরিপথ ত্যাগের ফলে মুসলিম বাহিনী কঠিন পরীক্ষার সম্মুখীন হয়; তবে পরদিনই হামরাউল আসাদ পর্যন্ত শত্রুদের পশ্চাদ্ধাবন করে কুরাইশদের ভীত করে ফিরিয়ে দেওয়া হয়।',
    ),
    BattleModel(
      id: 'dhat-al-riqa',
      type: 'ghazwah',
      typeBn: 'গাযওয়া (রাসূল ﷺ নিজে নেতৃত্ব দেন)',
      yearAh: '৪ হিজরি',
      dateBn: '৪ হিজরি • ৬২৫ খ্রি.',
      nameBn: 'বনু নাদির ও যাতুর রিকা অভিযান',
      nameAr: 'غزوة بني النضير وذات الرقاع',
      locationBn: 'মদিনা ও নজদ',
      outcome: 'no_fighting',
      outcomeBn: 'বিনা যুদ্ধে বিজয়',
      muslimForceNum: 400,
      enemyForceNum: 1000,
      muslimForceBn: '৪০০–৭০০ জন সাহাবী',
      enemyForceBn: 'বনু নাদির ও গাতাফান গোত্র',
      muslimCmdBn: 'মুহাম্মাদুর রাসূলুল্লাহ (ﷺ)',
      enemyCmdBn: 'গাতাফান গোত্রসমূহ',
      lossesBn: 'কোনো হতাহত হয়নি; সালাতুল খাওফ প্রবর্তিত হয়',
      summaryBn: 'নজদ অঞ্চলে পরিচালিত এই অভিযানে সাহাবীরা পায়ে কাপড়ের পট্টি বেঁধে অগ্রসর হন এবং ভয়কালীন নামাজের (সালাতুল খাওফ) বিধান নাযিল হয়।',
    ),
    BattleModel(
      id: 'battle-of-khandaq',
      type: 'ghazwah',
      typeBn: 'গাযওয়া (রাসূল ﷺ নিজে নেতৃত্ব দেন)',
      yearAh: '৫ হিজরি',
      dateBn: 'শাওয়াল ৫ হিজরি • ৬২৭ খ্রি.',
      nameBn: 'গাযওয়ায়ে খন্দক (আহযাবের যুদ্ধ)',
      nameAr: 'غزوة الخندق (الأحزاب)',
      locationBn: 'মদিনা মুনাওয়ারা',
      outcome: 'victory',
      outcomeBn: 'চূড়ান্ত মুসলিম বিজয়',
      muslimForceNum: 3000,
      enemyForceNum: 10000,
      muslimForceBn: '৩,০০০ সাহাবী',
      enemyForceBn: '১০,০০০ সম্মিলিত জোট বাহিনী',
      muslimCmdBn: 'মুহাম্মাদুর রাসূলুল্লাহ (ﷺ)',
      enemyCmdBn: 'আবু সুফিয়ান ও মিত্র জোট',
      lossesBn: 'মুসলিম: ৬ জন শহীদ • শত্রু জোট ঝড়ে ছত্রভঙ্গ',
      summaryBn: 'সালমান আল-ফারসী (রা.)-এর পরামর্শে খননকৃত পরিখা ও আল্লাহর পাঠানো ঝড়ে ১০,০০০ শত্রু সৈন্য পরাজিত হয়ে পালিয়ে যায়।',
    ),
    BattleModel(
      id: 'hudaybiyyah',
      type: 'ghazwah',
      typeBn: 'গাযওয়া (রাসূল ﷺ নিজে নেতৃত্ব দেন)',
      yearAh: '৬ হিজরি',
      dateBn: 'শাবান ও জিলকদ ৬ হিজরি • ৬২৮ খ্রি.',
      nameBn: 'বনু মুস্তালিক ও হুদাইবিয়ার সন্ধি (বাইআতে রিদওয়ান)',
      nameAr: 'غزوة بني المصطلق وصلح الحديبية',
      locationBn: 'আল-মুরাইসী ও হুদাইবিয়া',
      outcome: 'treaty',
      outcomeBn: 'ঐতিহাসিক ১০ বছরের সন্ধি (ফাতহুম মুবীন)',
      muslimForceNum: 1400,
      enemyForceNum: 1000,
      muslimForceBn: '১,৪০০ সাহাবী',
      enemyForceBn: 'কুরাইশ বাহিনী',
      muslimCmdBn: 'মুহাম্মাদুর রাসূলুল্লাহ (ﷺ)',
      enemyCmdBn: 'সুহাইল ইবনে আমর (কুরাইশ প্রতিনিধি)',
      lossesBn: 'রক্তপাতহীন সন্ধি ও দাওয়াতের প্রসার',
      summaryBn: 'গাছের নিচে বাইআতে রিদওয়ান এবং ১০ বছরের শান্তি চুক্তি স্বাক্ষরিত হয়, যাকে কুরআনে ফাতহুম মুবীন (সুস্পষ্ট বিজয়) বলা হয়েছে।',
    ),
    BattleModel(
      id: 'battle-of-khaybar',
      type: 'ghazwah',
      typeBn: 'গাযওয়া (রাসূল ﷺ নিজে নেতৃত্ব দেন)',
      yearAh: '৭ হিজরি',
      dateBn: 'মুহাররম ৭ হিজরি • ৬২৮ খ্রি.',
      nameBn: 'গাযওয়ায়ে খায়বার বিজয়',
      nameAr: 'غزوة خيبر',
      locationBn: 'খায়বার দুর্গ অঞ্চল',
      outcome: 'victory',
      outcomeBn: 'মুসলিম বিজয়',
      muslimForceNum: 1600,
      enemyForceNum: 10000,
      muslimForceBn: '১,৪০০–১,৬০০ সাহাবী',
      enemyForceBn: 'খায়বারের দুর্গসমূহে ১০,০০০ যোদ্ধা',
      muslimCmdBn: 'মুহাম্মাদুর রাসূলুল্লাহ (ﷺ) ও আলী ইবনে আবি তালিব (রা.)',
      enemyCmdBn: 'মারহাব ও কিনানাহ',
      lossesBn: 'মুসলিম: ১৬ জন শহীদ • খায়বারের সকল দুর্গ বিজিত',
      summaryBn: 'আলী (রা.)-এর বীরত্বে কামুস দুর্গসহ খায়বারের সকল দুর্গের পতন ঘটে।',
    ),
    BattleModel(
      id: 'battle-of-mutah',
      type: 'sariyyah',
      typeBn: 'সারিয়্যাহ (বৃহৎ অভিযান)',
      yearAh: '৮ হিজরি',
      dateBn: 'জমাদিউল আউয়াল ৮ হিজরি • ৬২৯ খ্রি.',
      nameBn: 'মু’তার যুদ্ধ',
      nameAr: 'غزوة مؤتة',
      locationBn: 'মু’তা (জর্ডান)',
      outcome: 'trial',
      outcomeBn: 'কৌশলগত প্রত্যাহার ও বীরত্ব',
      muslimForceNum: 3000,
      enemyForceNum: 100000,
      muslimForceBn: '৩,০০০ সাহাবী',
      enemyForceBn: '১,০০,০০০ রোমান ও মিত্র সৈন্য',
      muslimCmdBn: 'যায়েদ (রা.), জাফর (রা.), ইবনে রাওয়াহা (রা.) ও খালিদ (রা.)',
      enemyCmdBn: 'থিওডোর ও শুরাহবীল আল-গাসসানী',
      lossesBn: 'মুসলিম: মাত্র ১২ জন শহীদ',
      summaryBn: 'তিন সেনাপতির শাহাদাতের পর সাইফুল্লাহ খালিদ ইবনে ওয়ালিদ (রা.) রণকৌশলের মাধ্যমে ৩,০০০ মুসলিম সৈন্যকে ১ লক্ষ রোমান সৈন্যের মোকাবিলা থেকে নিরাপদে ফিরিয়ে আনেন।',
    ),
    BattleModel(
      id: 'conquest-of-makkah',
      type: 'ghazwah',
      typeBn: 'গাযওয়া (রাসূল ﷺ নিজে নেতৃত্ব দেন)',
      yearAh: '৮ হিজরি',
      dateBn: '২০ রমজান ও শাওয়াল ৮ হিজরি • ৬৩০ খ্রি.',
      nameBn: 'মক্কা বিজয় ও হুনাইন যুদ্ধ',
      nameAr: 'فتح مكة وغزوة حنين',
      locationBn: 'মক্কা মুকাররমা ও হুনাইন উপত্যকা',
      outcome: 'victory',
      outcomeBn: 'মহাবিজয় ও সাধারণ ক্ষমা',
      muslimForceNum: 12000,
      enemyForceNum: 20000,
      muslimForceBn: '১০,০০০ (মক্কা বিজয়) ও ১২,০০০ (হুনাইন)',
      enemyForceBn: '২০,০০০ যোদ্ধা (হাওয়াযিন ও সাকীফ)',
      muslimCmdBn: 'মুহাম্মাদুর রাসূলুল্লাহ (ﷺ)',
      enemyCmdBn: 'আবু সুফিয়ান (মক্কা) / মালিক ইবনে আউফ (হুনাইন)',
      lossesBn: 'কাবা ঘর শিরকমুক্তকরণ, সাধারণ ক্ষমা ও হুনাইন বিজয়',
      summaryBn: '১০,০০০ সাহাবী নিয়ে বিনা রক্তপাতে মক্কা বিজয় ও সাধারণ ক্ষমা ঘোষণা করেন এবং পরবর্তীতে হুনাইন যুদ্ধে চূড়ান্ত বিজয় অর্জিত হয়।',
    ),
    BattleModel(
      id: 'expedition-of-tabuk',
      type: 'ghazwah',
      typeBn: 'গাযওয়া (রাসূল ﷺ নিজে নেতৃত্ব দেন)',
      yearAh: '৯ হিজরি',
      dateBn: 'রজব ৯ হিজরি • ৬৩০ খ্রি.',
      nameBn: 'গাযওয়ায়ে তাবুক ও উসামা (রা.)-এর অভিযান (১১ হিজরি)',
      nameAr: 'غزوة تبوك وبعث أسامة بن زيد',
      locationBn: 'তাবুক (সিরিয়া সীমান্ত)',
      outcome: 'no_fighting',
      outcomeBn: 'বিনা যুদ্ধে রোমানদের পশ্চাদপসরণ ও সন্ধি',
      muslimForceNum: 30000,
      enemyForceNum: 40000,
      muslimForceBn: '৩০,০০০ সাহাবী ও ১০,০০০ অশ্বারোহী',
      enemyForceBn: 'রোমান সীমান্ত বাহিনী (যুদ্ধক্ষেত্র ত্যাগ করে)',
      muslimCmdBn: 'মুহাম্মাদুর রাসূলুল্লাহ (ﷺ) / উসামা ইবনে যায়েদ (রা.)',
      enemyCmdBn: 'বাইজেন্টাইন সাম্রাজ্য',
      lossesBn: 'যুদ্ধ ছাড়াই সীমান্ত রাজ্যগুলোর সন্ধি ও আনুগত্য',
      summaryBn: 'রাসূলুল্লাহ (ﷺ) পরিচালিত সর্ববৃহৎ ও সর্বশেষ গাযওয়া, যার মাধ্যমে উত্তর আরব ও শাম সীমান্তে ইসলামী রাষ্ট্রের নিরাপত্তা সুপ্রতিষ্ঠিত হয়।',
    ),
  ];
}
